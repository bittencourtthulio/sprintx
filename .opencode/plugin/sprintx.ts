/**
 * sprintx — plugin do OpenCode.
 *
 * Paridade com os hooks do Claude Code, no mecanismo que o OpenCode oferece.
 * Os hooks sao os MESMOS scripts em .claude/hooks/ — este arquivo e so a ponte.
 * Duplicar a logica criaria duas fontes divergindo com o tempo, que e o pior
 * defeito possivel para uma skill cujo contrato e o produto.
 *
 * DIFERENCAS DE MECANISMO (verificadas no binario v1.18.23, nao presumidas):
 *
 *  - Bloqueio: no Claude Code e `exit 2`; aqui e LANCAR uma excecao em
 *    tool.execute.before. Testado: a escrita nao acontece e o modelo le a
 *    mensagem do erro.
 *
 *  - Aviso: o Claude Code tem canal proprio (hookSpecificOutput.additional-
 *    Context). O OpenCode NAO tem "permite mas avisa" no before — so passar
 *    em silencio ou lancar. Por isso o aviso e anexado ao resultado da
 *    ferramenta em tool.execute.after, que e o unico caminho ate o modelo.
 *    Ver DS-33.
 *
 *  - Nomes de ferramenta sao minusculos no OpenCode (write/edit/bash).
 */

import { spawnSync } from "node:child_process"
import { existsSync } from "node:fs"
import { join, dirname } from "node:path"

type Payload = {
  cwd: string
  tool_name: string
  tool_input: Record<string, unknown>
  tool_response?: unknown
  agent_type?: string
}

/** Sobe ate achar .git — mesma regra do rastro.sh e do SKILL.md. */
function raizDoRepo(inicio: string): string {
  let d = inicio
  while (d !== "/" && d !== "") {
    if (existsSync(join(d, ".git"))) return d
    const pai = dirname(d)
    if (pai === d) break
    d = pai
  }
  return inicio
}

/**
 * Roda um hook e devolve o que ele decidiu.
 * exit 2  => bloqueia (mensagem no stderr)
 * stdout com additionalContext => aviso
 */
function rodaHook(
  raiz: string,
  caminhoRelativo: string,
  payload: Payload,
): { bloqueia?: string; avisa?: string } {
  const hook = join(raiz, ".claude", "hooks", caminhoRelativo)
  if (!existsSync(hook)) return {}

  const r = spawnSync("bash", [hook], {
    input: JSON.stringify(payload),
    encoding: "utf8",
    timeout: 10_000,
  })

  if (r.status === 2) {
    return { bloqueia: (r.stderr || "").trim() || "bloqueado pelo hook sprintx" }
  }

  const saida = (r.stdout || "").trim()
  if (saida.startsWith("{")) {
    try {
      const j = JSON.parse(saida)
      const ctx = j?.hookSpecificOutput?.additionalContext
      if (typeof ctx === "string" && ctx) return { avisa: ctx }
    } catch {
      /* falha aberta: hook que nao produziu JSON valido nao trava nada */
    }
  }
  return {}
}

/** Traduz o nome da ferramenta do OpenCode para o do Claude Code. */
function nomeCanonico(tool: string): string {
  switch (tool) {
    case "write": return "Write"
    case "edit":  return "Edit"
    case "patch": return "MultiEdit"
    case "bash":  return "Bash"
    default:      return tool
  }
}

export default async ({ directory }: { directory?: string }) => {
  const raiz = raizDoRepo(directory || process.cwd())

  /** Avisos represados no before, para anexar ao resultado no after. */
  const avisosPendentes = new Map<string, string[]>()

  /**
   * Normaliza os argumentos do OpenCode para o formato que os hooks esperam.
   * Verificado no binario: as ferramentas write/edit usam `filePath`
   * (camelCase), enquanto o payload do Claude Code usa `file_path`. Sem esta
   * traducao o hook recebe caminho vazio e a mensagem sai sem o arquivo.
   */
  const monta = (input: any, output: any): Payload => {
    // Verificado no binario: em tool.execute.BEFORE os argumentos vem em
    // `output.args` (mutaveis); em tool.execute.AFTER vem em `input.args`.
    // Ler so um dos dois deixa metade dos hooks com caminho vazio.
    const args = { ...((output?.args ?? input?.args ?? {}) as Record<string, unknown>) }
    if (args.filePath && !args.file_path) args.file_path = args.filePath
    if (args.newString && !args.new_string) args.new_string = args.newString
    return {
      cwd: raiz,
      tool_name: nomeCanonico(input.tool),
      tool_input: args,
    }
  }

  return {
    "tool.execute.before": async (input: any, output: any) => {
      const tool = input.tool
      const payload = monta(input, output)
      const avisos: string[] = []

      const hooks: string[] = []
      if (tool === "write" || tool === "edit" || tool === "patch") {
        hooks.push(
          "comum/segredo.sh",
          "sprintx/escopo-da-task.sh",
          "sprintx/task-so-fecha-verde.sh",
        )
      } else if (tool === "bash") {
        hooks.push("comum/git-perigoso.sh")
      }

      for (const h of hooks) {
        const r = rodaHook(raiz, h, payload)
        // Bloqueio: lancar e o unico jeito de barrar no OpenCode.
        if (r.bloqueia) throw new Error(r.bloqueia)
        if (r.avisa) avisos.push(r.avisa)
      }

      if (avisos.length) avisosPendentes.set(input.callID, avisos)
    },

    "tool.execute.after": async (input: any, output: any) => {
      const payload: Payload = {
        ...monta(input, output),
        tool_response: output?.output,
      }

      const avisos = avisosPendentes.get(input.callID) ?? []
      avisosPendentes.delete(input.callID)

      const hooks: string[] = ["comum/rastro-post.sh"]
      if (input.tool === "write" || input.tool === "edit" || input.tool === "patch") {
        hooks.push("sprintx/sem-placeholder-no-plano.sh", "sprintx/tdd-teste-antes.sh")
      }

      for (const h of hooks) {
        const r = rodaHook(raiz, h, payload)
        if (r.avisa) avisos.push(r.avisa)
      }

      // Unico canal ate o modelo no OpenCode: anexar ao resultado.
      // O prefixo deixa explicito que e o hook falando, nao a ferramenta —
      // sem isso o modelo pode ler o aviso como saida do comando.
      if (avisos.length && typeof output?.output === "string") {
        output.output += "\n\n[sprintx/hooks — aviso, a acao NAO foi bloqueada]\n" +
          avisos.map((a) => `- ${a}`).join("\n")
      }
    },
  }
}
