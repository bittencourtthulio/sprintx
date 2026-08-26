# sprint^x

**sprint^x** (lê-se "sprint elevado a x", escreve-se `sprintx` em código e nomes de arquivo) é uma skill para [Claude Code](https://claude.com/claude-code) que implementa um método de planejamento e execução de features onde **todo o esforço vai para o planejamento** — a execução é autônoma porque a ambiguidade já foi eliminada antes de escrever a primeira linha de código.

> Uma pergunta feita durante a execução é sempre uma falha da fase de planejamento.

Criada pela [Expx (Exponencial)](https://github.com/bittencourtthulio) e aberta para qualquer pessoa usar em qualquer projeto.

## Por que existir

A maioria dos fluxos "planeje e depois implemente" para agentes de IA falha da mesma forma: o plano é vago o suficiente para o agente ter que decidir coisas sozinho no meio da implementação, ou parar e perguntar — o que quebra a autonomia que você queria ter comprado. O sprint^x resolve isso tratando o planejamento como o produto principal:

- **Hierarquia clara** — Sprint contém Fases, Fase contém Tasks, cada nível em seu próprio arquivo.
- **Contrato obrigatório por task** — toda task declara objetivo, arquivos tocados, teste de integração, teste funcional, critério de aceite verificável, dependências e se pode rodar em paralelo.
- **TDD como regra, não como sugestão** — o teste é escrito antes da implementação; task só é concluída quando os dois testes passam.
- **Portões de aceite em toda transição** — task → task, task → fase, fase → sprint. Critério não atendido, não avança.
- **Paralelismo declarado no plano**, nunca decidido pelo agente em tempo de execução.
- **Execução que nunca para** — dúvida nova durante a execução vira bloqueio registrado, não uma pergunta. O agente pula para a próxima task paralelizável e segue.

## As seis fases

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

### Opção 1 — copiar a skill para o seu projeto

Copie as pastas `.claude/skills/sprintx/` e `.claude/commands/` deste repositório para a raiz do seu projeto:

```bash
git clone https://github.com/bittencourtthulio/sprintx.git /tmp/sprintx
cp -r /tmp/sprintx/.claude/skills/sprintx /caminho/do/seu/projeto/.claude/skills/
cp /tmp/sprintx/.claude/commands/sprintx*.md /caminho/do/seu/projeto/.claude/commands/
```

Se o seu projeto ainda não tem `.claude/skills/` ou `.claude/commands/`, crie as pastas antes de copiar.

### Opção 2 — copiar só a skill (sem os comandos de atalho)

Se você prefere sempre invocar por descrição em vez de comando, basta a pasta da skill:

```bash
cp -r /tmp/sprintx/.claude/skills/sprintx /caminho/do/seu/projeto/.claude/skills/
```

O Claude Code já reconhece e dispara a skill automaticamente quando você descreve algo que quer construir, integrar ou mudar no sistema — não precisa digitar `sprintx` no pedido.

### Opção 3 — instalação global (todos os seus projetos)

Copie para o diretório de skills do usuário em vez do projeto:

```bash
cp -r /tmp/sprintx/.claude/skills/sprintx ~/.claude/skills/
cp /tmp/sprintx/.claude/commands/sprintx*.md ~/.claude/commands/
```

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
.claude/
  skills/sprintx/
    SKILL.md                    a skill em si — princípio, contratos, regras, máquina de estados
    DECISOES-DA-SKILL.md        decisões de design tomadas ao construir esta skill
    references/                 roteiro operacional detalhado de cada uma das 6 fases
    assets/                     templates preenchíveis usados pelas fases
  commands/
    sprintx*.md                 atalhos de comando para cada fase
```

## Empacotamento futuro

Esta skill não usa nenhum caminho absoluto e não depende de nenhum prefixo de plugin — a pasta inteira pode ser movida ou empacotada como plugin sem quebrar nada.

## Licença

MIT — use, copie e adapte livremente.
