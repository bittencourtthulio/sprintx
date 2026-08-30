<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/banner-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/banner-light.svg">
  <img alt="sprintx — a metade Build do metodo Expx" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/banner-light.svg" width="100%">
</picture>

<p>
  <img alt="harness: Claude Code" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-claude.svg">
  <img alt="harness: OpenCode" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-opencode.svg">
  <img alt="fases F1 a F6" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-fases.svg">
  <img alt="TDD obrigatorio" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-tdd.svg">
  <img alt="schema expx v1" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-schema.svg">
  <img alt="docs pt-BR" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-lang.svg">
  <img alt="licenca MIT" src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/assets/badge-license.svg">
</p>

<p>
  <a href="https://bittencourtthulio.github.io/expxdev/#sprintx"><strong>📘 Documentação do método</strong></a>
  &nbsp;·&nbsp;
  <a href="https://bittencourtthulio.github.io/expxdev/#sprintx">Fases F1–F6</a>
  &nbsp;·&nbsp;
  <a href="https://bittencourtthulio.github.io/expxdev/#ecossistema">O ecossistema</a>
  &nbsp;·&nbsp;
  <a href="https://bittencourtthulio.github.io/expxdev/#schema">Contratos</a>
</p>

<strong>A metade Build do método Expx</strong> — a skill de planejamento e execução<br>
de features novas para <a href="https://claude.com/claude-code">Claude Code</a> e <a href="https://opencode.ai">OpenCode</a>.

</div>

`sprintx` (lê-se "sprint elevado a x") pega uma ideia e a leva até a feature entregue, passando por seis fases obrigatórias: ingestão da base de conhecimento, descoberta com entrevista, plano em sprints/fases/tasks, orquestrador, auditoria do próprio plano e execução autônoma.

> **Todo o esforço vai para o planejamento; a execução é autônoma porque a ambiguidade já foi eliminada.**
> Uma pergunta feita durante a execução é sempre uma falha da fase de planejamento.

---

## O ecossistema Expx

O método Expx é um conjunto de skills que se compõem, instaladas e mantidas pelo CLI [`expxdev`](https://github.com/bittencourtthulio/expxdev).

| Peça | Papel | Relação com a `sprintx` |
|---|---|---|
| **[expxdev](https://github.com/bittencourtthulio/expxdev)** | o CLI: instala, atualiza e diagnostica o ecossistema, e sobe o painel de operação | é quem instala esta skill (`npx expxdev init`) |
| **sprintx** *(este repositório)* | **Build** — feature nova, F1…F6 | — |
| **[runx](https://github.com/bittencourtthulio/runx)** | **Run** — ocorrência em produção, E1…E5 | skill irmã; mesmos contratos, gatilho diferente |
| **[legadox](https://github.com/bittencourtthulio/legadox)** | **camada** de segurança para código legado | endurece as fases da `sprintx` quando existe `PERFIL.md` |
| **[stackx](https://github.com/bittencourtthulio/stackx)** | **camada** de convenções do repositório | a `sprintx` lê o `CONVENCOES.md` antes de planejar e de escrever código |
| **[mergex](https://github.com/bittencourtthulio/mergex)** | entrega: branch, commit por task, PR e pacote de QA | abre a branch no início da F6 e entrega ao fim dela |
| **[memox](https://github.com/bittencourtthulio/MemoX)** | **camada** de memória do projeto | consultada na F1 e na F3, sobre os arquivos que o plano pretende tocar |
| **[prodx](https://github.com/bittencourtthulio/prodx)** | **camada** de produto: decide **se** há trabalho | roda antes da F1 e entrega o `BRIEFING.md` assinado como entrada dela |

**Camadas** (`legadox`, `stackx`, `memox`, `prodx`) sozinhas não fazem nada — elas modificam o comportamento da `sprintx` e da `runx`. A `prodx` é a única que roda **antes** de tudo: ela decide *se* há trabalho, e só depois a `sprintx` decide *como* fazê-lo. A ausência de qualquer irmã nunca quebra o fluxo desta skill: insumo que não existe vira aviso do que falta, nunca invenção.

Detalhes do ecossistema inteiro no [README do expxdev](https://github.com/bittencourtthulio/expxdev).

---

## Build e Run

O método Expx tem duas metades, irmãs e com a mesma disciplina de engenharia:

| | **sprintx** (Build) | **[runx](https://github.com/bittencourtthulio/runx)** (Run) |
|---|---|---|
| **Gatilho** | feature nova, planejada do zero | ocorrência num sistema em produção |
| **Entrada** | uma ideia, um requisito | um chamado, ticket ou relato de cliente |
| **Estágios** | F1…F6 (ingestão → execução) | E1…E5 (investigação → relatório) |
| **Saída** | a feature entregue | a ocorrência encerrada, com dois relatórios |

As duas compartilham **exatamente** os mesmos contratos: base de conhecimento antes de qualquer plano, hierarquia sprint → fase → task, TDD obrigatório com no mínimo dois testes por task, critério de aceite verificável em toda transição, paralelismo declarado no plano e execução autônoma guiada por um arquivo orquestrador.

**Muda o gatilho e o tamanho. Nunca o rigor.**

> Precisa sustentar o que já está em produção — bug, ajuste, chamado de cliente? Essa é a outra metade: **[runx](https://github.com/bittencourtthulio/runx)**.

---

## Por que existir

A maioria dos fluxos "planeje e depois implemente" para agentes de IA falha da mesma forma: o plano é vago o suficiente para o agente ter que decidir coisas sozinho no meio da implementação, ou parar e perguntar — o que quebra a autonomia que você queria ter comprado. A `sprintx` resolve isso tratando o planejamento como o produto principal:

- **Hierarquia clara** — sprint contém fases, fase contém tasks, cada nível em seu próprio arquivo.
- **Contrato obrigatório por task** — toda task declara objetivo, arquivos tocados, teste de integração, teste funcional, critério de aceite verificável, dependências e se pode rodar em paralelo.
- **TDD como regra, não como sugestão** — o teste é escrito antes da implementação; task só é concluída quando os dois testes passam.
- **Portões de aceite em toda transição** — task → task, task → fase, fase → sprint. Critério não atendido, não avança.
- **Paralelismo declarado no plano**, nunca decidido pelo agente em tempo de execução.
- **Execução que nunca para** — dúvida nova durante a execução vira bloqueio registrado, não uma pergunta. O agente pula para a próxima task paralelizável e segue.
- **Estimativa honesta, quando você pede** — o mesmo plano granular vira faixa de esforço com premissas e invalidadores explícitos. Nunca número único, nunca prazo de calendário.

---

## Compatibilidade

`sprintx` funciona em **Claude Code** e em **OpenCode**, a partir da mesma fonte. Os arquivos da skill são idênticos nos dois — o que muda é apenas onde eles ficam:

| | Claude Code | OpenCode |
|---|---|---|
| Skill (projeto) | `.claude/skills/sprintx/` | `.opencode/skills/sprintx/` |
| Comandos (projeto) | `.claude/commands/` | `.opencode/command/` |
| Skill (global) | `~/.claude/skills/sprintx/` | a mesma pasta, auto-carregada |
| Comandos (global) | `~/.claude/commands/` | `~/.config/opencode/command/` |
| Agentes (projeto) | `.claude/agents/` | `.opencode/agent/` |
| Restrição de ferramentas do agente | `tools:` | `permission: { edit: deny }` |
| Hooks | `.claude/settings.json` | `.opencode/plugin/*.ts` |
| Hook bloquear a ação | `exit 2` | lançar exceção |
| Hook avisar sem bloquear | JSON no stdout | anexado ao resultado da ferramenta |

No escopo global o OpenCode carrega automaticamente as skills de `~/.claude/skills/` (ele as chama de *external skills*), então a skill é instalada **uma única vez** e serve aos dois. No escopo de projeto essa ponte não existe, e a skill é copiada para os dois lugares.

Os dois harnesses descobrem a skill do mesmo jeito — pelo `name` e pela `description` do frontmatter, carregando o corpo sob demanda — e os dois aceitam `$ARGUMENTS` nos comandos. Por isso um único conjunto de arquivos atende aos dois sem fork e sem condicional. Verificado no OpenCode v1.18.23 — inclusive os hooks, testados de ponta a ponta nos dois harnesses.

Já os **hooks** divergem de mecanismo, e é a única parte com fork. A lógica mora **uma vez só**, em `.claude/hooks/*.sh`; o plugin do OpenCode é uma ponte que a invoca e traduz a saída. O modo `aviso` é a lacuna real de paridade: o `tool.execute.before` do OpenCode só sabe passar em silêncio ou bloquear, então o aviso é anexado ao resultado da ferramenta, sempre prefixado para o modelo não confundi-lo com a saída do comando.

---

## Hooks e agentes

Toda regra do método é, sozinha, uma instrução que o modelo pode esquecer na task 14 de uma execução autônoma. **Hook é script determinístico: quem executa é o harness, não o modelo.** Agente roda em contexto próprio, com ferramentas restritas.

Hooks e agentes **não criam regra nova** — eles garantem regras que já existem.

| Hook | Quando | Modo inicial | O que garante |
|---|---|---|---|
| `escopo-da-task` | antes de escrever | aviso | Não tocar no que não está na task |
| `task-so-fecha-verde` | antes de fechar task | aviso | Task só fecha com suíte verde e os dois testes |
| `sem-placeholder-no-plano` | após escrever o plano | aviso | Nenhum `{{marcador}}` de template sobrando |
| `tdd-teste-antes` | após escrever código | aviso | Teste antes da implementação |
| `segredo` | antes de escrever | **bloqueio** | Segredo não vai para arquivo versionado |
| `git-perigoso` | antes de rodar Bash | **bloqueio** | Nada irreversível durante a execução autônoma |

**Todo hook de método nasce em `aviso`.** Hook que dá falso positivo é desinstalado, e junto com ele vão os que funcionavam — então a promoção a `bloqueio` só acontece depois de evidência de uso real:

```bash
.claude/hooks/doctor.sh                            # modo de cada hook + violações acumuladas
.claude/hooks/doctor.sh promover escopo-da-task    # só depois de conferir os falsos positivos
```

Os agentes de veredito têm **somente leitura**, o que transforma "aponta, não corrige" de promessa em impossibilidade técnica:

| Agente | Fase | Papel |
|---|---|---|
| `auditor-plano` | F5 | Fura o plano sem ter visto o raciocínio que o gerou |
| `revisor-testes` | F5 e F6 | Esse teste passaria com a implementação errada? |
| `investigador` | F1 (opcional) | Monta a base em contexto próprio |

Hooks e skill gravam um rastro append-only em `docs/eventos/<slug>.jsonl` (ignorado pelo versionador). Dele sai a linha do tempo do trabalho, quem fez o quê — e a **duração real por task sem ninguém anotar nada**, que alimenta a calibração da estimativa. Com um cuidado: tempo de parede não é esforço, então o valor entra como `duracao_observada`, nunca como `real`, e a calibração usa mediana.

---

## Instalação

### Pelo CLI do método (recomendado)

```bash
npx expxdev init
```

O `init` busca a `sprintx` na versão publicada, empacota como plugin local e configura o harness. Os comandos ficam com namespace no Claude Code (`/expx:sprintx-sprints`) e sem namespace no OpenCode (`/sprintx-sprints`).

### Pelo instalador do repositório

Monta a estrutura **dos dois harnesses de uma vez**:

```bash
git clone https://github.com/bittencourtthulio/sprintx.git
cd sprintx
./install.sh
```

Isso cria `.claude/` **e** `.opencode/` no projeto atual. Para deixar disponível em todos os seus projetos:

```bash
./install.sh --global
```

| Flag | Efeito |
|---|---|
| *(nenhuma)* | instala nos dois harnesses, no projeto atual |
| `--global` | instala no diretório global do usuário, não no projeto |
| `--claude` | só Claude Code |
| `--opencode` | só OpenCode |
| `--dry-run` | mostra o que faria, sem escrever nada |

As flags combinam: `./install.sh --global --opencode` instala só o OpenCode, só no global. Rodar de novo atualiza no lugar — o instalador é idempotente.

### Instalação manual

A skill é a mesma pasta nos dois harnesses — só o destino muda:

```bash
# Claude Code + OpenCode (global)
cp -R .claude/skills/sprintx  ~/.claude/skills/

# OpenCode (projeto)
cp -R .claude/skills/sprintx  meu-projeto/.opencode/skills/
```

Os comandos do OpenCode são os mesmos do Claude Code sem a linha `argument-hint:`, que o OpenCode não usa. Reinicie a sessão do seu harness para a skill ser carregada.

---

## Uso

### O jeito mais simples

Descreva o que quer construir. **Não é preciso dizer `sprintx`, "plano" nem "sprint"** — a skill dispara sozinha ao reconhecer a descrição de algo a ser construído:

```
Quero adicionar exportação de relatório em CSV nessa tela.
```

### Comandos

| Comando | O que faz |
|---|---|
| `/sprintx <feature>` | detecta a fase atual e continua de onde parou |
| `/sprintx-base <feature>` | **F1** — ingestão, constrói a base de conhecimento |
| `/sprintx-descoberta <feature>` | **F2** — entrevista de descoberta |
| `/sprintx-sprints <feature>` | **F3** — gera o plano de sprints, fases e tasks |
| `/sprintx-estimar <feature>` | **F3.5** — estima o esforço do plano em faixa *(opcional)* |
| `/sprintx-orquestrador <feature>` | **F4** — gera o mapa de execução |
| `/sprintx-auditoria <feature>` | **F5** — audita o plano gerado |
| `/sprintx-executar <feature>` | **F6** — executa o plano até o fim |

Os comandos de fase **recusam execução fora de ordem**: peça o plano sem a ingestão feita e a skill diz o que falta e executa a fase pendente.

---

## As seis fases

```
F1 INGESTÃO → F2 DESCOBERTA → F3 PLANO → [F3.5 ESTIMATIVA] → F4 ORQUESTRADOR → F5 AUDITORIA → F6 EXECUÇÃO
```

Estritamente sequenciais. A skill descobre onde está **inspecionando o disco**, não perguntando — você nunca precisa dizer "estou na fase X".

A elas se soma uma única fase **opcional**, a F3.5 (estimativa), que roda entre a F3 e a F4 apenas quando você pede — e cuja ausência nunca impede nada.

| Fase | Nome | O que faz |
|---|---|---|
| **F1** | Ingestão | Constrói a base de conhecimento antes de qualquer plano — documentação oficial de ferramentas de terceiro (modo externo) ou o código e contratos existentes (modo interno). Nada de invenção: o que a fonte não afirma vira `NÃO DOCUMENTADO`. |
| **F2** | Descoberta | A única fase em que a IA pergunta — e nela é obrigada a perguntar, em blocos de até 5 perguntas, esperando resposta entre eles. Cobre escopo, arquitetura, dados, observabilidade, erros, segredos e definição de pronto. Sai um `00-DECISOES.md` com cada decisão rastreável. |
| **F3** | Plano | Gera a árvore de sprints, fases e tasks com todos os contratos preenchidos. Bloqueia se sobrar pendência não resolvida. A primeira sprint sempre entrega a capacidade de testar (config, client, harness, fixtures) antes de qualquer funcionalidade de negócio. |
| **F3.5** | Estimativa *(opcional)* | Converte o plano pronto em **faixa de esforço** — nunca número único, nunca prazo de calendário. Só roda a pedido, e nunca bloqueia a F4. |
| **F4** | Orquestrador | Gera o `ORQUESTRADOR.md` — o mapa de execução, escrito para quem abre o repositório sem saber nada: rota de execução, paralelismo, caminho crítico, ferramentas, agentes, regras de autonomia e como retomar uma sessão interrompida. |
| **F5** | Auditoria | A IA vira auditora do próprio plano e não corrige nada — só aponta. Verifica tasks sem teste, testes fracos, critérios subjetivos, dependências circulares, paralelismo falso e mais. Veredito único: pronto para execução autônoma, SIM ou NÃO. |
| **F6** | Execução | Lê o orquestrador e implementa até o fim, sob as regras de autonomia. Escreve o teste antes do código, atualiza o status de cada task, e entrega um relatório final com o que foi concluído, os bloqueios e a saída da suíte. |

---

## Orçar sem chutar

Uma software house vive de orçar, e a maior parte das estimativas erra por não ter insumo: sem tasks granulares, com dependências e paralelismo declarados, estimar é chute com aparência de método. O plano da `sprintx` já é esse insumo — a **F3.5** é a camada opcional que o converte em faixa de esforço.

Rode `/sprintx-estimar <feature>` sobre um plano pronto. Sai um `00-ESTIMATIVA.md` assim:

```
Confiança BAIXA. Para subir: ler a documentação de webhooks do gateway
e registrar base/gateway-webhooks.md, fechando a lacuna L-02.

Esforço total    58–66 h    todo o trabalho a fazer — é o que se cobra
Caminho crítico  35–42 h    a cadeia mais longa — é o que limita o calendário
```

Dois números diferentes, e a diferença explicada: as tasks paralelizáveis somam no total sem alongar a cadeia crítica. Nenhuma quantidade de gente entrega abaixo de 35 h, mas alguém precisa fazer as 58–66 h.

O que essa camada faz de diferente:

- **Faixa, nunca número único.** Número único vira compromisso, e compromisso construído sobre incerteza é dívida. Toda estimativa sai com premissas, invalidadores e nível de confiança.
- **Esforço, nunca prazo.** A unidade é a hora de trabalho focado. Converter em data depende de agenda, feriado, férias e ida e volta com o cliente — variáveis que a skill não conhece e não finge conhecer. A conversão é decisão humana.
- **Agregação que não superestima.** Três pontos por task (otimista, provável, pessimista), agregados por PERT com variâncias somadas em quadratura. Somar os pessimistas supõe que tudo dá errado ao mesmo tempo; a quadratura faz o intervalo crescer menos que a soma linear. O método está documentado e é reproduzível à mão.
- **Task que não se entende não se estima.** Se o pessimista passa de quatro vezes o otimista, a task não é incerta — é mal compreendida. A skill manda quebrá-la e a deixa fora dos totais.
- **Invalidadores observáveis.** "Mudança de escopo" não é invalidador. "O cliente pedir suporte a mais de um formato de arquivo além de CSV" é: alguém consegue olhar e dizer se aconteceu.
- **O que não está incluído vem escrito.** Reunião, revisão de código, ida e volta com o cliente, deploy, correção pós-entrega, treinamento. Se for para incluir, entra como item próprio — nunca diluído nas tasks.
- **Aprende com o que aconteceu.** Ao concluir cada task, a F6 registra o esforço real em `docs/sprintx/estimativas/HISTORICO.md`. O desvio entre estimado e real por tipo de task vira fator de correção nas estimativas seguintes — sempre visível na saída, nunca embutido em silêncio.

A F3.5 é a única fase opcional do método e não altera o plano. Sem `HISTORICO.md`, a confiança nunca passa de MÉDIA e a saída diz que não há base de calibração no projeto.

---

## Os contratos

### Task

Toda task declara, obrigatoriamente:

| Campo | Conteúdo |
|---|---|
| `id` | T-NN.MM |
| `titulo` | título curto |
| `objetivo` | uma frase |
| `arquivos` | criados e alterados |
| `teste_integracao` | o que valida, contra o quê |
| `teste_funcional` | o que valida, com qual entrada e saída |
| `criterio_aceite` | verificável, binário, sem adjetivo |
| `depende_de` | [ids] ou [] |
| `paralelizavel` | true \| false |
| `status` | pendente \| em_andamento \| concluida \| bloqueada |

**Fase:** objetivo, tasks que a compõem, critério de saída, com qual outra fase pode rodar em paralelo.
**Sprint:** objetivo, fases, critério de saída, riscos conhecidos.

**Granularidade:** se os dois testes de uma task não cabem em uma frase cada, a task está grande demais — quebrar.

---

## Estrutura em disco

Tudo da skill fica sob `docs/sprintx/`, separado da documentação normal do projeto. As features ficam isoladas em `features/`; o histórico de esforço fica fora delas, porque atravessa o projeto inteiro.

```
docs/sprintx/
  features/
    <slug-da-feature>/
      ORQUESTRADOR.md      mapa e porta de entrada da execução
      00-DECISOES.md       uma linha por decisão tomada no planejamento
      00-BLOQUEIOS.md      bloqueios registrados durante a execução
      00-AUDITORIA.md      relatório e veredito da F5
      00-ESTIMATIVA.md     faixa de esforço, premissas e invalidadores (só se a F3.5 rodar)
      base/
        00-INDICE.md
        00-LACUNAS.md
        <um arquivo por recurso/área estudada>.md
      sprint-01/
        sprint.md
        fases.md
        tasks.md
      sprint-02/ ...
    <outra-feature>/ ...   cada feature isolada na sua pasta
  estimativas/
    HISTORICO.md           esforço real do projeto inteiro, que calibra as estimativas seguintes
```

---

## expx-schema v1

Todo arquivo de estado carrega um **frontmatter YAML legível por máquina**, para que um painel de operação leia o andamento das features sem depender de prosa.

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: tasks
trabalho_id: exportacao-csv
sprint_id: sprint-01
atualizado_em: 2026-08-29
tasks:
  - id: T-01.01
    titulo: Client de exportacao com fixture de dados
    fase: F-01.1
    status: concluida
    objetivo: Ter a capacidade de testar antes de qualquer regra de negocio
    arquivos:
      cria: [src/export/client.ts, src/export/client.test.ts]
      altera: []
    teste_integracao: A tela chama o client e recebe o arquivo montado
    teste_funcional: exportarCsv([]) retorna cabecalho e nenhuma linha
    criterio_aceite: Os dois testes passam e a suite inteira fica verde
    depende_de: []
    paralelizavel: false
    concluida_em: 2026-08-29
    suite: verde
---
```

O painel apenas **lê**; a skill continua sendo a única a escrever. A máquina lê o YAML, a pessoa lê a prosa abaixo dele.

Os kinds `orquestrador`, `sprint`, `fases`, `tasks`, `bloqueios` e `base_indice` são **idênticos campo por campo** aos da [`runx`](https://github.com/bittencourtthulio/runx) — o campo `expx_tool` (`sprintx` | `runx`) diz qual das duas escreveu. A única diferença é na task: a `runx` acrescenta `teste_regressao`, que só faz sentido quando existe um comportamento errado a provar. A `sprintx` tem ainda dois kinds próprios da camada de estimativa: `estimativa` e `estimativa_historico`. Contrato completo em [`references/00-schema.md`](.claude/skills/sprintx/references/00-schema.md).

---

## Estrutura do repositório

```
.claude/
  skills/sprintx/
    SKILL.md                    a skill em si — princípio, contratos, regras, máquina de estados
    DECISOES-DA-SKILL.md        decisões de design tomadas ao construir esta skill
    references/
      00-schema.md              contrato expx-schema v1 do frontmatter dos arquivos de estado
      08-rastro.md              contrato expx-eventos v1 do rastro append-only
      <uma por fase>            roteiro operacional detalhado (as 6 + a F3.5 opcional)
    assets/
      TEMPLATE-*.md             templates preenchíveis usados pelas fases
  commands/
    sprintx*.md                 atalhos de comando para cada fase
  hooks/
    doctor.sh                   modo de cada hook e violações acumuladas
    comum/                      rastro, segredo, git — não específicos da sprintx
    sprintx/                    escopo-da-task, task-so-fecha-verde, tdd, placeholder
  agents/
    auditor-plano.md            F5 em contexto separado, somente leitura
    revisor-testes.md           o teste passaria com a implementação errada?
    investigador.md             auxiliar opcional da F1
  settings.json                 registra os hooks no Claude Code
.expx/
  hooks.json                    o modo (aviso/bloqueio) de cada hook
.opencode/
  command/sprintx*.md           os mesmos comandos, no formato do OpenCode
  agent/                        os mesmos agentes, no formato do OpenCode
  plugin/sprintx.ts             ponte que invoca os mesmos scripts de .claude/hooks/
.github/assets/                 banner e badges do README
install.sh                      instalador para Claude Code e OpenCode
```

A pasta `.claude/skills/sprintx/` é a **fonte única** da skill: ela não cita `.claude` em lugar nenhum e usa só caminhos relativos à própria raiz, por isso o mesmo conteúdo funciona sem alteração nos dois harnesses. O `.opencode/command/` é gerado a partir de `.claude/commands/`.

O `SKILL.md` é a porta de entrada e fica enxuto. O detalhe operacional de cada fase mora no `reference` correspondente, lido **só quando a fase chega** — mantendo o contexto pequeno.

---

## Licença

MIT — use, copie e adapte livremente.

---

<div align="center">
<sub>Parte do método <strong>Expx</strong> ·
<a href="https://github.com/bittencourtthulio/expxdev">expxdev</a> ·
sprintx ·
<a href="https://github.com/bittencourtthulio/runx">runx</a> ·
<a href="https://github.com/bittencourtthulio/legadox">legadox</a> ·
<a href="https://github.com/bittencourtthulio/stackx">stackx</a> ·
<a href="https://github.com/bittencourtthulio/mergex">mergex</a></sub>
</div>
