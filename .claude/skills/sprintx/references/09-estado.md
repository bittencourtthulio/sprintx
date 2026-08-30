# O estado da barra — contrato `expx-estado` v1

Leitura obrigatória quando a skill vai gravar uma transição que muda o que a barra de status
mostra: início de trabalho, troca de fase, abertura e fechamento de task, total de tasks,
bloqueio e conclusão do trabalho.

O contrato canônico está copiado neste repositório em
`docs/contrato/CONTRATO-expx-estado.md` (caminho relativo à raiz do repositório). Este
reference é a voz operacional dele para a sprintx: o que gravar, quando, e como.

## Por que este arquivo existe

A barra de status roda a cada mensagem do assistente, com debounce de 300 ms, e **se um
gatilho novo dispara enquanto o script ainda executa, o Claude Code mata a execução em vez de
enfileirar**. Script lento não atrasa: ele simplesmente não aparece.

Por isso a barra **nunca** lê `tasks.md`, frontmatter, plano ou rastro. Ela lê um arquivo só,
pequeno, já mastigado. Quem mantém esse arquivo são as skills e os hooks, que já estão
escrevendo em disco de qualquer forma.

## Local

```
.expx/estado.json
```

Ignorado pelo versionador. É estado da máquina de quem está trabalhando, não do projeto.

## Formato

```json
{
  "expx_estado": 1,
  "atualizado_em": "2026-08-29T14:32:10Z",
  "trabalho": "exportacao-csv",
  "ferramenta": "sprintx",
  "titulo_curto": "exportacao de relatorios",
  "fase": "f3",
  "task": "T-01.02",
  "tasks_concluidas": 4,
  "tasks_total": 9,
  "raio": null,
  "orcamento_arquivos": null,
  "orcamento_linhas": null,
  "branch": null,
  "pr_estado": null,
  "bloqueios": 0
}
```

## Regras do contrato

1. **Somente exibição.** Nenhuma decisão desta skill lê este arquivo. Ele é derivado e
   descartável; apagá-lo não pode quebrar nada. A máquina de estados continua detectando a
   fase pelo disco em `docs/sprintx/features/<slug>/`, como sempre — nunca por aqui.
2. **Chave nunca omitida.** O que não se aplica vai `null`.
3. **Escrita atômica.** Grave em arquivo temporário e renomeie. A barra pode estar lendo no
   exato momento da gravação, e JSON pela metade quebra o parse.
4. **Pequeno.** Abaixo de 1 KB. Nada de listas, nada de caminhos longos.
5. **`titulo_curto` cabe em 30 caracteres.** Corte, não quebre linha.
6. **Sem trabalho aberto:** `trabalho`, `fase` e `task` viram `null`. O arquivo continua
   existindo.
7. **Enums iguais aos do `expx-schema`:** minúsculo, sem acento. `f3`, não `F3`.

## Quem escreve o quê

| Campo | Dono |
|---|---|
| `trabalho`, `ferramenta`, `titulo_curto`, `fase` | sprintx e runx, nas transições |
| `task`, `tasks_concluidas`, `tasks_total` | sprintx e runx, ao abrir e fechar task |
| `raio`, `orcamento_arquivos`, `orcamento_linhas` | legadox |
| `branch`, `pr_estado` | mergex |
| `bloqueios` | quem registrar bloqueio |

**A sprintx mantém apenas estes oito campos:** `trabalho`, `ferramenta`, `titulo_curto`,
`fase`, `task`, `tasks_concluidas`, `tasks_total` e `bloqueios`.

**Nunca sobrescreva o arquivo inteiro com um objeto novo.** Leia o que está lá, altere só o
que é seu, grave o resultado. `raio` e o orçamento pertencem ao legadox; `branch` e
`pr_estado`, ao mergex. Um `estado.json` que chega com `raio: "alto"` e
`orcamento_arquivos: "2/3"` tem de sair da gravação da sprintx com esses mesmos valores.

## Quando gravar

| Momento | Campos que a sprintx grava |
|---|---|
| Ao iniciar um trabalho (F1, Passo 1) | `trabalho`, `ferramenta: sprintx`, `titulo_curto`, `fase: f1`, `task: null`, `tasks_concluidas: 0`, `tasks_total: 0`, `bloqueios: 0` |
| A cada transição de fase (F1→F2→F3→[F3.5]→F4→F5→F6) | `fase` |
| Ao gerar o plano na F3 | `tasks_total` |
| Ao abrir uma task (F6) | `task` |
| Ao fechar uma task (F6) | `tasks_concluidas`, e `task` passa para a próxima ou `null` se não houver |
| Ao registrar ou resolver bloqueio | `bloqueios` (contagem de bloqueios **abertos**) |
| Ao concluir o trabalho (fim da F6) | `trabalho: null`, `fase: null`, `task: null` |

`ferramenta` é sempre `sprintx`. `fase` usa os enums da máquina de estados em minúscula:
`f1`, `f2`, `f3`, `f3.5`, `f4`, `f5`, `f6`.

`trabalho` é o `<slug-da-feature>` — o mesmo da pasta `docs/sprintx/features/<slug>/`, do
frontmatter e do `trabalho_id` do rastro.

`titulo_curto` é a feature em linguagem de gente, minúscula e sem acento, cortada em 30
caracteres: `exportacao de relatorios csv` serve; o slug cru também serve quando não houver
nada melhor.

`bloqueios` é quantos bloqueios estão **abertos** em `00-BLOQUEIOS.md` (`resolvido_em: null`),
não quantos já existiram. Resolver um bloqueio diminui a contagem.

Ao concluir o trabalho, apenas `trabalho`, `fase` e `task` viram `null`. `tasks_concluidas` e
`tasks_total` ficam como estão — são o placar do que foi entregue, e zerá-los apagaria a única
informação útil que sobra na barra logo depois do fim.

## Como gravar

Sempre nesta ordem: **existe `.expx/`? → leia → altere o que é seu → grave atômico.**

```bash
# 1. Se .expx/ não existir, NÃO crie. Pule a gravação inteira, sem erro e sem aviso.
[ -d .expx ] || exit 0

# 2. Leia o que está lá (ou parta do objeto completo, se o arquivo ainda não existe),
#    altere SÓ os campos da sprintx, grave em temporário e renomeie.
python3 - <<'PY'
import json, os, tempfile, datetime

ALVO = ".expx/estado.json"
if not os.path.isdir(".expx"):
    raise SystemExit(0)

base = {
    "expx_estado": 1, "atualizado_em": None, "trabalho": None, "ferramenta": None,
    "titulo_curto": None, "fase": None, "task": None, "tasks_concluidas": None,
    "tasks_total": None, "raio": None, "orcamento_arquivos": None,
    "orcamento_linhas": None, "branch": None, "pr_estado": None, "bloqueios": None,
}
try:
    with open(ALVO) as f:
        base.update(json.load(f))      # preserva raio, orcamento, branch, pr_estado
except (FileNotFoundError, ValueError):
    pass                                # ausente ou corrompido: parte do objeto completo

# ---- só as chaves da sprintx, só as que este momento muda ----
base["ferramenta"] = "sprintx"
base["fase"] = "f3"
# ------------------------------------------------------------

base["expx_estado"] = 1
base["atualizado_em"] = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
if base["titulo_curto"]:
    base["titulo_curto"] = base["titulo_curto"][:30]

tmp = tempfile.NamedTemporaryFile("w", dir=".expx", prefix=".estado-", suffix=".tmp", delete=False)
try:
    json.dump(base, tmp, ensure_ascii=False)
    tmp.flush()
    os.fsync(tmp.fileno())
    tmp.close()
    os.replace(tmp.name, ALVO)          # renomeação atômica
except BaseException:
    os.unlink(tmp.name)
    raise
PY
```

O que torna a gravação atômica é o par **temporário + `os.replace`**: o temporário nasce no
mesmo diretório do alvo (renomeação entre sistemas de arquivos diferentes não é atômica), e a
renomeação substitui o arquivo em um passo só. Quem estiver lendo vê o conteúdo velho inteiro
ou o novo inteiro — nunca metade. **Nunca grave direto no `.expx/estado.json`**, com `>`, com
ferramenta de edição, nem em duas etapas.

`atualizado_em` é o instante UTC da gravação, obtido do sistema — nunca de memória.

## Tolerância a falha

Este arquivo é cosmético. As três situações abaixo **não são erro** e nenhuma delas interrompe
o trabalho:

1. **`.expx/` não existe.** Significa que o CLI não instalou o ecossistema neste projeto.
   Siga sem gravar, **sem criar o diretório**, sem erro e sem aviso ao usuário. Não registre
   nem no rastro: não houve falha, houve ausência de ecossistema.
2. **A gravação falhou** (disco cheio, permissão, `.expx/` somente leitura). Registre no
   rastro um evento com `resultado: aviso` e `detalhe` de uma linha, e siga. O trabalho não
   para por causa da barra de status.
3. **O `estado.json` está corrompido ou com formato desconhecido.** Parta do objeto completo
   acima, preenchendo com `null` o que não souber, e grave por cima. Um arquivo derivado que
   não parseia não tem nada a preservar.

Por essa mesma razão, **nada aqui é regra inviolável do método**. Um `estado.json` ausente,
velho ou errado não invalida plano, task, auditoria nem fechamento. Elevar um arquivo de
exibição a regra criaria bloqueio por algo puramente cosmético.

## Versionamento

`.expx/estado.json` é **ignorado pelo versionador**: é estado da máquina de quem está
trabalhando, não do projeto, e reescrito a cada transição — versioná-lo produz conflito de
merge em arquivo que ninguém lê a mão. A F1 garante a linha no `.gitignore` do projeto, do
mesmo jeito que já garante `docs/eventos/`.

## Ressalva

A barra de status é mecanismo do Claude Code. O OpenCode tem o seu, com formato possivelmente
diferente. Trate como lacuna a verificar, não como paridade garantida. Sem barra, o
`estado.json` continua correto e inofensivo.
