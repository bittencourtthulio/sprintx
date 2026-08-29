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

## Fases → arquivos da skill

| Fase | Roteiro operacional | Templates usados |
|---|---|---|
| Todas as que gravam arquivo | `references/00-schema.md` — **leitura obrigatória** em qualquer fase que grave arquivo de estado (F1, F2, F3, F3.5, F4, F6) | — |
| F1 INGESTÃO | `references/01-ingestao.md` | `assets/TEMPLATE-base-recurso.md`, `assets/TEMPLATE-base-indice.md`, `assets/TEMPLATE-BLOQUEIOS.md` |
| F2 DESCOBERTA | `references/02-descoberta.md` | `assets/TEMPLATE-DECISOES.md` |
| F3 PLANO | `references/03-plano.md` | `assets/TEMPLATE-sprint.md`, `assets/TEMPLATE-fases.md`, `assets/TEMPLATE-tasks.md` |
| F3.5 ESTIMATIVA (opcional) | `references/07-estimativa.md` | `assets/TEMPLATE-ESTIMATIVA.md`, `assets/TEMPLATE-HISTORICO.md` |
| F4 ORQUESTRADOR | `references/04-orquestrador.md` | `assets/TEMPLATE-ORQUESTRADOR.md` |
| F5 AUDITORIA | `references/05-auditoria.md` | — |
| F6 EXECUÇÃO | `references/06-execucao.md` | — |

Os caminhos acima são relativos à raiz desta skill. O detalhe operacional de cada fase mora exclusivamente no reference correspondente; leia-o apenas quando a fase chegar.

## Onde fica `docs/sprintx/features/<slug>/`

Todo artefato desta skill vive sob `docs/sprintx/`, nunca solto em `docs/`. A estrutura é fixa:

```
docs/sprintx/
  features/<slug-da-feature>/    um diretório por feature, com a estrutura completa
  estimativas/HISTORICO.md       esforço real do projeto inteiro (atravessa features)
```

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
