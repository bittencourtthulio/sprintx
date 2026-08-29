# sprint^x

<p align="center">
  <img src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/img/hero.svg" alt="sprint^x — todo o esforço vai para o planejamento; a execução é autônoma" width="760">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Claude%20Code-compat%C3%ADvel-2da44e?style=flat-square" alt="Compatível com Claude Code">
  <img src="https://img.shields.io/badge/OpenCode-compat%C3%ADvel-2da44e?style=flat-square" alt="Compatível com OpenCode">
  <img src="https://img.shields.io/badge/expx--schema-v1-8b949e?style=flat-square" alt="Contrato expx-schema v1">
  <img src="https://img.shields.io/badge/licen%C3%A7a-MIT-8b949e?style=flat-square" alt="Licença MIT">
</p>

**sprint^x** (lê-se "sprint elevado a x", escreve-se `sprintx` em código e nomes de arquivo) é uma skill para [Claude Code](https://claude.com/claude-code) e [OpenCode](https://opencode.ai) que implementa um método de planejamento e execução de features onde **todo o esforço vai para o planejamento** — a execução é autônoma porque a ambiguidade já foi eliminada antes de escrever a primeira linha de código.

> Uma pergunta feita durante a execução é sempre uma falha da fase de planejamento.

Criada pela [Expx (Exponencial)](https://github.com/bittencourtthulio) e aberta para qualquer pessoa usar em qualquer projeto.

## Build e Run

O método Expx tem duas metades, irmãs e com a mesma disciplina de engenharia:

<p align="center">
  <img src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/img/buildrun.svg" alt="sprintx (Build) vai de F1 a F6, disparado por uma feature nova; runx (Run) vai de E1 a E5, disparado por uma ocorrência em produção; as duas compartilham os mesmos contratos" width="900">
</p>

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

A maioria dos fluxos "planeje e depois implemente" para agentes de IA falha da mesma forma: o plano é vago o suficiente para o agente ter que decidir coisas sozinho no meio da implementação, ou parar e perguntar — o que quebra a autonomia que você queria ter comprado. O sprint^x resolve isso tratando o planejamento como o produto principal:

- **Hierarquia clara** — Sprint contém Fases, Fase contém Tasks, cada nível em seu próprio arquivo.
- **Contrato obrigatório por task** — toda task declara objetivo, arquivos tocados, teste de integração, teste funcional, critério de aceite verificável, dependências e se pode rodar em paralelo.
- **TDD como regra, não como sugestão** — o teste é escrito antes da implementação; task só é concluída quando os dois testes passam.
- **Portões de aceite em toda transição** — task → task, task → fase, fase → sprint. Critério não atendido, não avança.
- **Paralelismo declarado no plano**, nunca decidido pelo agente em tempo de execução.
- **Execução que nunca para** — dúvida nova durante a execução vira bloqueio registrado, não uma pergunta. O agente pula para a próxima task paralelizável e segue.

<p align="center">
  <img src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/img/task.svg" alt="Anatomia de uma task: os dez campos obrigatórios do contrato, e o ciclo TDD em que o teste vem antes do código" width="900">
</p>

## As seis fases

<p align="center">
  <img src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/img/fases.svg" alt="Máquina de estados: F1 a F5 formam o planejamento; a F5 libera a F6 com VEREDITO SIM, e um achado ALTA devolve o fluxo para a F3" width="900">
</p>

O método é uma máquina de estados estritamente sequencial. A skill sempre sabe em que fase está inspecionando o que já existe em disco — você nunca precisa dizer "estou na fase X".

| Fase | Nome | O que faz |
|---|---|---|
| **F1** | Ingestão | Constrói a base de conhecimento antes de qualquer plano — documentação oficial de ferramentas de terceiro (modo externo) ou o código/contratos existentes (modo interno). Nada de invenção: o que a fonte não afirma vira `NÃO DOCUMENTADO`. |
| **F2** | Descoberta | A única fase em que a IA pergunta — e nela é obrigada a perguntar, em blocos de até 5 perguntas, esperando resposta entre eles. Cobre escopo, arquitetura, dados, observabilidade, erros, segredos e definição de pronto. Sai um `00-DECISOES.md` com cada decisão rastreável. |
| **F3** | Plano | Gera a árvore de sprints, fases e tasks com todos os contratos preenchidos. Bloqueia se sobrar pendência não resolvida. A primeira sprint sempre entrega a capacidade de testar (config, client, harness, fixtures) antes de qualquer funcionalidade de negócio. |
| **F4** | Orquestrador | Gera o `ORQUESTRADOR.md` — o mapa de execução, escrito para quem abre o repositório sem saber nada: rota de execução, paralelismo, caminho crítico, ferramentas, agentes, regras de autonomia e como retomar uma sessão interrompida. |
| **F5** | Auditoria | A IA vira auditora do próprio plano e não corrige nada — só aponta. Verifica tasks sem teste, testes fracos, critérios subjetivos, dependências circulares, paralelismo falso e mais. Dá um veredito único: pronto para execução autônoma, SIM ou NÃO. |
| **F6** | Execução | Lê o orquestrador e implementa até o fim, sob as regras de autonomia. Escreve o teste antes do código, atualiza o status de cada task, e entrega um relatório final com o que foi concluído, os bloqueios e a saída da suíte de testes. |

## Instalação

Um instalador só, que configura **os dois harnesses de uma vez** — Claude Code e OpenCode:

```bash
git clone https://github.com/bittencourtthulio/sprintx.git
cd sprintx
./install.sh --global      # todos os seus projetos
```

Ou instalar apenas no projeto atual:

```bash
./install.sh               # instala no diretório atual
./install.sh /caminho/do/projeto
```

| Flag | Efeito |
|---|---|
| `--global` | Instala para todos os projetos (em vez do projeto atual) |
| `--claude` | Só Claude Code |
| `--opencode` | Só OpenCode |
| `--dry-run` | Mostra o que faria, sem escrever nada |

Rodar de novo atualiza no lugar — o instalador é idempotente.

### O que vai para onde

<p align="center">
  <img src="https://raw.githubusercontent.com/bittencourtthulio/sprintx/main/.github/img/instalacao.svg" alt="No escopo global a skill fica só em ~/.claude/skills e o OpenCode a auto-carrega; no escopo de projeto ela é copiada para .claude e .opencode" width="900">
</p>

**Instalação global.** O OpenCode carrega automaticamente as skills de `~/.claude/skills/` (ele as chama de *external skills*), então a skill é instalada **uma única vez** e serve aos dois — sem cópia duplicada para sair do ar:

```
~/.claude/skills/sprintx/          a skill (lida pelo Claude Code E pelo OpenCode)
~/.claude/commands/sprintx*.md     comandos do Claude Code
~/.config/opencode/command/sprintx*.md   comandos do OpenCode
```

**Instalação de projeto.** Aqui não existe essa ponte entre os dois, então a skill é copiada para os dois lugares:

```
.claude/skills/sprintx/     +  .claude/commands/sprintx*.md
.opencode/skills/sprintx/   +  .opencode/command/sprintx*.md
```

### Instalação manual

Se preferir copiar à mão, a skill é a mesma pasta nos dois harnesses — só o destino muda:

```bash
cp -R .claude/skills/sprintx  ~/.claude/skills/           # Claude Code + OpenCode (global)
cp -R .claude/skills/sprintx  meu-projeto/.opencode/skills/   # OpenCode (projeto)
```

Os comandos do OpenCode são os mesmos do Claude Code sem a linha `argument-hint:`, que o OpenCode não usa.

## Como usar

A forma mais simples é descrever o que você quer construir normalmente — a skill dispara sozinha:

> "Quero adicionar exportação de relatório em CSV nessa tela"

Ou usar os comandos de atalho para pilotar fase a fase:

| Comando | Faz o quê |
|---|---|
| `/sprintx <feature>` | Detecta a fase atual e continua de onde parou |
| `/sprintx-base <feature>` | Roda a F1 — ingestão |
| `/sprintx-descoberta <feature>` | Roda a F2 — entrevista de descoberta |
| `/sprintx-sprints <feature>` | Roda a F3 — gera o plano |
| `/sprintx-orquestrador <feature>` | Roda a F4 — gera o mapa de execução |
| `/sprintx-auditoria <feature>` | Roda a F5 — audita o plano gerado |
| `/sprintx-executar <feature>` | Roda a F6 — executa o plano até o fim |

Cada comando recusa rodar fora de ordem: se você pedir `/sprintx-sprints` sem ter feito a ingestão, ele te diz o que falta e executa a fase pendente primeiro.

Todo o trabalho de cada feature fica em `docs/<slug-da-feature>/` na raiz do seu repositório — plano, decisões, bloqueios e o histórico de tudo o que foi decidido e por quê.

## O que fica em disco

Todo arquivo de estado carrega frontmatter YAML legível por máquina (**expx-schema v1**), para que um painel de operação leia o andamento sem depender da prosa. Os kinds `orquestrador`, `sprint`, `fases`, `tasks`, `bloqueios` e `base_indice` são os mesmos da [runx](https://github.com/bittencourtthulio/runx), com os mesmos campos e enums — o campo `expx_tool` (`sprintx` | `runx`) diz qual das duas escreveu. A única diferença é na task: a runx acrescenta `teste_regressao`, que só faz sentido quando existe um comportamento errado a provar. Contrato completo em [`references/00-schema.md`](.claude/skills/sprintx/references/00-schema.md).

```
docs/<slug-da-feature>/
  ORQUESTRADOR.md      mapa e porta de entrada da execução
  00-DECISOES.md        uma linha por decisão tomada no planejamento
  00-BLOQUEIOS.md        bloqueios registrados durante a execução
  00-AUDITORIA.md        relatório e veredito da F5
  base/
    00-INDICE.md
    00-LACUNAS.md
    <um arquivo por recurso/área estudada>.md
  sprint-01/
    sprint.md
    fases.md
    tasks.md
  sprint-02/ ...
```

## Estrutura deste repositório

```
install.sh                      instalador para Claude Code e OpenCode
.github/img/                    diagramas SVG do README
.claude/
  skills/sprintx/
    SKILL.md                    a skill em si — princípio, contratos, regras, máquina de estados
    DECISOES-DA-SKILL.md        decisões de design tomadas ao construir esta skill
    references/                 roteiro operacional detalhado de cada uma das 6 fases
      00-schema.md              contrato expx-schema v1 do frontmatter dos arquivos de estado
    assets/                     templates preenchíveis usados pelas fases
  commands/
    sprintx*.md                 atalhos de comando para cada fase
.opencode/
  command/sprintx*.md           os mesmos comandos, no formato do OpenCode
```

A pasta `.claude/skills/sprintx/` é a **fonte única** da skill: ela não cita `.claude` em lugar nenhum e usa só caminhos relativos à própria raiz, por isso o mesmo conteúdo funciona sem alteração nos dois harnesses. O `.opencode/command/` é gerado a partir de `.claude/commands/`.

## Compatibilidade

Esta skill não usa nenhum caminho absoluto, não cita `.claude` no corpo e não depende de nenhum prefixo de plugin — a pasta inteira pode ser movida, empacotada como plugin ou instalada em qualquer um dos dois harnesses sem quebrar nada.

| | Claude Code | OpenCode |
|---|---|---|
| Skill (global) | `~/.claude/skills/sprintx/` | a mesma pasta, auto-carregada |
| Skill (projeto) | `.claude/skills/sprintx/` | `.opencode/skills/sprintx/` |
| Comandos (global) | `~/.claude/commands/` | `~/.config/opencode/command/` |
| Comandos (projeto) | `.claude/commands/` | `.opencode/command/` |
| Disparo automático por descrição | sim | sim |
| `$ARGUMENTS` nos comandos | sim | sim |

Verificado no OpenCode v1.18.23.

## Licença

MIT — use, copie e adapte livremente.

---

<sub>sprintx é a metade Build do método Expx (Exponencial). A metade Run é a skill <a href="https://github.com/bittencourtthulio/runx">runx</a>.</sub>
