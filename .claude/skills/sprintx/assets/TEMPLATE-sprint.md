---
expx_schema: 1
expx_tool: sprintx
kind: sprint
trabalho_id: {{slug-da-feature}}
sprint_id: sprint-{{NN}}
titulo: {{titulo da sprint, sem acento, uma linha}}
status: {{nao_iniciado | em_andamento | bloqueado | concluido}}
criterio_saida: {{criterio de saida em uma linha}}
fases: [{{F-NN.1, F-NN.2}}]
riscos: [{{risco em uma linha}}]
atualizado_em: {{AAAA-MM-DD}}
---

# Sprint {{NN}} — {{título da sprint}}

## Objetivo

{{O que esta sprint entrega, em uma ou duas frases. Lembrete: a sprint-01 entrega a capacidade de testar — config, client, harness, fixtures — não funcionalidade de negócio.}}

## Fases

| Fase | Título | Roda em paralelo com |
|---|---|---|
| F-{{NN}}.1 | {{título}} | {{F-NN.M ou "nenhuma"}} |
| F-{{NN}}.2 | {{título}} | {{F-NN.M ou "nenhuma"}} |

Detalhe de cada fase em `fases.md`; tasks em `tasks.md`.

## Critério de saída

{{Condição verificável, binária, sem adjetivo, que precisa ser verdade para esta sprint estar concluída. Ex.: "a suíte roda com `<comando>` e termina com 0 failed".}}

## Riscos conhecidos

- {{risco vindo da base ou das decisões, com referência ao arquivo que o registra}}
- {{ou "Nenhum risco registrado."}}
