---
name: sprintx
description: Use para planejar e implementar qualquer feature, integração, refatoração, migração ou mudança no sistema — sempre que o usuário descrever algo que quer construir, adicionar, integrar, corrigir de forma estruturada ou alterar no código, mesmo sem pedir plano, sprint ou sprintx por nome. Cobre ingestão de contexto, descoberta de requisitos, plano de sprints/fases/tasks com TDD, orquestração, auditoria e execução autônoma de ponta a ponta.
---

# sprint^x

sprint^x ("sprint elevado a x") é o método de planejamento e execução de features da Expx (Exponencial).

## Princípio central

Todo o esforço vai para o planejamento. A execução é autônoma porque a ambiguidade já foi eliminada no planejamento. Uma pergunta feita durante a execução é sempre uma falha da fase de planejamento.

## Máquina de estados

As seis fases são estritamente sequenciais e a skill nunca pula fase:

F1 INGESTÃO → F2 DESCOBERTA → F3 PLANO → *(F3.5 ESTIMATIVA — opcional)* → F4 ORQUESTRADOR → F5 AUDITORIA → F6 EXECUÇÃO

A **F3.5 ESTIMATIVA é a única fase opcional** do método e é a única exceção à sequencialidade estrita: ela roda entre a F3 e a F4, sobre o plano pronto, **apenas quando o usuário pede estimativa**. Não é pré-requisito de nada: a ausência de `00-ESTIMATIVA.md` NUNCA impede a passagem para a F4, e a F5 não a audita nem a exige. Se o usuário não pediu estimativa, siga da F3 direto para a F4. A F3.5 nunca bloqueia o fluxo, nunca altera o plano e pode ser rodada depois, sobre um plano já auditado, sem invalidar nada.

Toda transição desta máquina — entrar numa fase, abrir ou fechar uma task, registrar ou resolver bloqueio, concluir o trabalho — atualiza também `.expx/estado.json`, o arquivo de exibição que a barra de status lê (`references/09-estado.md`). Ele é **derivado e descartável**: a fase continua sendo detectada pelo disco, como na tabela abaixo, e nunca por ele. Se `.expx/` não existir no projeto, a skill segue sem gravar, sem erro e sem aviso.

Antes de agir, descubra em que fase está inspecionando o disco em `docs/sprintx/features/<slug-da-feature>/`:

| Estado do disco | Fase atual |
|---|---|
| `docs/sprintx/features/<slug>/base/` não existe | F1 |
| `base/` existe, `00-DECISOES.md` não | F2 |
| `00-DECISOES.md` existe, `sprint-01/` não | F3 |
| `sprint-01/` existe, `ORQUESTRADOR.md` não | F4 |
| `ORQUESTRADOR.md` existe, sem auditoria aprovada | F5 |
| Auditoria aprovada: `00-AUDITORIA.md` existe e contém `VEREDITO: SIM` | F6 |

A F3.5 não aparece na tabela porque não é um estado da máquina: ela é um desvio opcional a partir da F3, disparado por pedido do usuário (ou pelo comando `/sprintx-estimar`), e o disco continua indicando F4 com ou sem `00-ESTIMATIVA.md`.

Se o usuário pedir uma fase adiantada, explique o que falta e execute a fase pendente em vez de obedecer fora de ordem. Ao entrar em uma fase, leia o arquivo dela em `references/` (tabela abaixo) antes de qualquer ação — e somente o da fase atual.

## Contratos

### Contrato da Task — toda task declara, obrigatoriamente

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

### Contrato da Fase

Objetivo, tasks que a compõem, critério de saída, com qual outra fase pode rodar em paralelo.

### Contrato da Sprint

Objetivo, fases, critério de saída, riscos conhecidos.

## Regras invioláveis

1. Todo o esforço vai para o planejamento; pergunta feita durante a execução é sempre falha da fase de planejamento.
2. As fases são estritamente sequenciais; nunca pule fase nem execute fora de ordem.
3. TDD é obrigatório: o teste é escrito antes da implementação.
4. Task só é marcada como concluída quando o teste de integração E o teste funcional passam; não existe "concluído com ressalva".
5. Toda transição (task → task, task → fase, fase → sprint) tem critério de aceite verificável, binário e sem adjetivo; critério não atendido = não avança.
6. O paralelismo é declarado no plano para cada task e cada fase; a IA em execução nunca decide isso sozinha.
7. Nenhuma task pode depender de decisão humana em tempo de execução.
8. Dúvida nova durante a execução: registrar em `00-BLOQUEIOS.md`, pular a task e seguir para a próxima paralelizável; nunca parar e esperar.
9. Na F1 nada de invenção: se a fonte não afirma, escreva "NÃO DOCUMENTADO"; todo número vem com a referência que o afirma.
10. A F2 é a fase de entrevista: nela a IA é obrigada a perguntar, em blocos de no máximo 5 perguntas, esperando resposta entre os blocos, cobrindo os eixos mínimos. Fora da F2, a única pergunta permitida no método inteiro é a exceção prevista na regra 11 (decisão nova detectada na F3); em qualquer outro momento, dúvida não é pergunta — é bloqueio (regra 8).
11. A F3 bloqueia se houver PENDENTE bloqueante em `00-DECISOES.md`. Se, ao planejar, a F3 encontrar algo que exigiria decisão humana em execução, essa é a única pergunta permitida fora da F2: pergunta na hora e registra a resposta como nova decisão D-NN.
12. Granularidade: se os dois testes da task não cabem em uma frase cada, a task está grande demais — quebre.
13. A primeira sprint entrega a capacidade de testar (config, client, harness, fixtures), não funcionalidade de negócio.
14. Na F5 a IA é auditora: só aponta, nunca corrige; achado de severidade ALTA manda voltar para a F3 — nunca corrigir à mão o arquivo gerado.
15. Proibido escrever código de implementação em qualquer fase antes da F6.
16. Use sempre caminhos relativos; nunca escreva caminhos absolutos em nenhum artefato.
17. Todo arquivo de estado é gravado com o frontmatter do contrato expx-schema v1, descrito em `references/00-schema.md`. Arquivo de estado sem frontmatter válido é considerado não entregue. Ao abrir uma pasta de trabalho que já existe e cujos arquivos não têm frontmatter, acrescente o frontmatter na próxima vez que gravar aquele arquivo, inferindo os valores da prosa existente; nunca reescreva em massa nem migre pastas que não vai tocar.
18. Estimativa sai sempre como faixa, com premissas, invalidadores e nível de confiança. Número único é proibido.
19. Estimativa é esforço, nunca prazo de calendário. A conversão em data é decisão humana.
20. Todo trabalho fecha com `FECHAMENTO.md`, declarando módulo afetado, arquivos alterados e palavras-chave.

## Fases → arquivos da skill

| Fase | Roteiro operacional | Templates usados |
|---|---|---|
| Todas as que gravam arquivo | `references/00-schema.md` — **leitura obrigatória** em qualquer fase que grave arquivo de estado (F1, F2, F3, F3.5, F4, F6) | — |
| Todas as que gravam transição | `references/08-rastro.md` — formato do rastro de eventos, lido pelo painel | — |
| Todas as que gravam transição | `references/09-estado.md` — contrato `expx-estado` v1: o `.expx/estado.json` que a barra de status lê | — |
| F3 e F6 (ao gravar `fases.md` e ao fechar task) | `references/09-diagrama.md` — o bloco Mermaid do grafo de tasks dentro de `fases.md`. Derivado: sua ausência é inofensiva e nunca bloqueia | `assets/TEMPLATE-fases.md` |
| F1 INGESTÃO | `references/01-ingestao.md` | `assets/TEMPLATE-base-recurso.md`, `assets/TEMPLATE-base-indice.md`, `assets/TEMPLATE-BLOQUEIOS.md` |
| F2 DESCOBERTA | `references/02-descoberta.md` | `assets/TEMPLATE-DECISOES.md` |
| F3 PLANO | `references/03-plano.md` | `assets/TEMPLATE-sprint.md`, `assets/TEMPLATE-fases.md`, `assets/TEMPLATE-tasks.md` |
| F3.5 ESTIMATIVA (opcional) | `references/07-estimativa.md` | `assets/TEMPLATE-ESTIMATIVA.md`, `assets/TEMPLATE-HISTORICO.md` |
| F4 ORQUESTRADOR | `references/04-orquestrador.md` | `assets/TEMPLATE-ORQUESTRADOR.md` |
| F5 AUDITORIA | `references/05-auditoria.md` | — |
| F6 EXECUÇÃO | `references/06-execucao.md` | `assets/TEMPLATE-FECHAMENTO.md`, `assets/TEMPLATE-HISTORICO.md` |

Os caminhos acima são relativos à raiz desta skill. O detalhe operacional de cada fase mora exclusivamente no reference correspondente; leia-o apenas quando a fase chegar.

## Hooks e agentes

Toda regra inviolável desta skill é, sozinha, uma instrução que o modelo pode esquecer numa execução longa. Hook é script determinístico: roda sempre, porque quem executa é o harness, não o modelo. Agente roda em contexto próprio e com ferramentas restritas.

**Hooks e agentes não criam regra nova.** Eles garantem regras que já existem acima. Nada do método muda por causa deles.

### Os hooks

Todo hook de método **nasce em modo `aviso`** e só é promovido a `bloqueio` depois de rodar sem falso positivo — guiado pela lista de `regra_violada` que o painel acumulou. A razão é prática: hook que dá falso positivo é desinstalado, e junto com ele vão os que funcionavam. Os hooks de segurança são a exceção e nascem em `bloqueio`.

O modo de cada hook vive em `.expx/hooks.json`, e é lá que se promove.

| Hook | Evento | Modo inicial | O que faz |
|---|---|---|---|
| `escopo-da-task` | `PreToolUse` (escrita) | `aviso` | Compara o arquivo editado com o campo `arquivos` da task em andamento. Fora da lista, avisa |
| `task-so-fecha-verde` | `PreToolUse` (`tasks.md`) | `aviso` | Barra `status: concluida` quando `suite` não é `verde` ou falta `teste_integracao`/`teste_funcional` |
| `sem-placeholder-no-plano` | `PostToolUse` (plano) | `aviso` | Acha marcador `{{...}}` de template não substituído |
| `tdd-teste-antes` | `PostToolUse` (escrita) | `aviso` | Avisa quando a implementação nasce antes do teste. **Inativo sem `CONVENCOES.md`** — não chuta onde o teste deveria estar |
| `segredo` | `PreToolUse` (escrita) | `bloqueio` | Barra segredo com forma reconhecível indo para arquivo versionado |
| `git-perigoso` | `PreToolUse` (Bash) | `bloqueio` | Barra operação de versionamento irreversível durante a execução autônoma |

Hook de método falha **aberta**: se ele quebra, o trabalho segue. Hook de segurança falha **fechada**.

### Os agentes

Os agentes de veredito têm **acesso somente de leitura**. É isso que transforma "aponta, não corrige" de instrução em impossibilidade técnica.

| Agente | Fase | Ferramentas | Papel |
|---|---|---|---|
| `auditor-plano` | F5 | leitura | Fura o plano antes de virar código, sem ter visto o raciocínio que o gerou |
| `revisor-testes` | F5 e F6 | leitura | Responde a uma pergunta só: esse teste passaria com a implementação errada? |
| `investigador` | F1 (opcional) | leitura | Monta a base em contexto próprio, para não consumir o contexto principal |

Quando o agente não existe no harness em uso, a fase roda como sempre rodou — a skill nunca fica bloqueada por falta de agente.

### O rastro

Hooks e skill gravam os eventos em `docs/eventos/<trabalho_id>.jsonl`, formato em `references/08-rastro.md`. É o que dá ao painel a linha do tempo do trabalho, quem fez o quê, e a duração real por task — esta última alimentando a calibração da F3.5, sem ninguém anotar nada.

## Onde fica `docs/sprintx/features/<slug>/`

Todo artefato desta skill vive sob `docs/sprintx/`, nunca solto em `docs/`. A estrutura é fixa:

```
docs/sprintx/
  features/<slug-da-feature>/    um diretório por feature, com a estrutura completa
    FECHAMENTO.md                gravado ao fim da F6: o que a feature entregou, e onde
  estimativas/HISTORICO.md       esforço real do projeto inteiro (atravessa features)
```

O `FECHAMENTO.md` é o que torna a feature encontrável depois — por arquivo, por módulo e por
palavra-chave (regra inviolável 20). É o equivalente, do lado Build, ao relatório técnico da
runx; sem ele, um índice dos artefatos do projeto conheceria apenas a manutenção, e metade da
história do sistema ficaria invisível.

`docs/sprintx/` é sempre ancorado na raiz do repositório Git mais próxima do diretório de trabalho atual (o diretório que contém `.git/`). Em um monorepo sem `.git` visível no diretório de trabalho, suba diretórios até encontrar a raiz do repositório; se não houver `.git` em nenhum ancestral, use a raiz do diretório de trabalho atual. Nunca crie `docs/sprintx/` dentro de um pacote/workspace individual sem antes checar se já existe um `docs/` na raiz do repositório — se existir, crie `sprintx/` dentro dele.

O prefixo `docs/sprintx/` mantém a documentação da skill agrupada e separada da documentação normal do projeto, que continua em `docs/`. `features/` isola as features umas das outras; `estimativas/` fica fora de `features/` porque o histórico é do projeto, não de uma feature.

**Pastas em formato antigo.** Se você encontrar uma feature em `docs/<slug>/` (formato anterior, sem o prefixo), trabalhe nela onde está: a máquina de estados detecta a fase pelo conteúdo, não pelo caminho. Não mova pastas por conta própria — mover é decisão do usuário, e uma migração silenciosa quebraria links e histórico do repositório dele. Features novas sempre nascem em `docs/sprintx/features/<slug>/`.

## Como derivar o `<slug-da-feature>`

A partir do que o usuário disse, gere o slug assim:

1. Pegue o nome essencial da feature (substantivos que a identificam, sem verbos de pedido como "quero", "adicionar por favor").
2. Converta para minúsculas e remova acentos (ç → c, ã → a, é → e, ...).
3. Substitua espaços e separadores por hífen; remova qualquer caractere fora de `a-z`, `0-9` e `-`; colapse hifens repetidos.
4. Se já existir `docs/sprintx/features/<slug>/` compatível com o pedido, reutilize esse slug — é a mesma feature em andamento.
5. Se o pedido for ambíguo, proponha um slug em uma linha ("Vou usar o slug `x-y-z`.") e siga em frente sem esperar confirmação.

Exemplo: "adicionar exportação de relatório em CSV" → `exportacao-relatorio-csv`.
