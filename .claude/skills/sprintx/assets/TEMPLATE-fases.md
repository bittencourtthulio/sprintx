---
expx_schema: 1
expx_tool: sprintx
kind: fases
trabalho_id: {{slug-da-feature}}
sprint_id: sprint-{{NN}}
atualizado_em: {{AAAA-MM-DD}}
fases:
  - id: F-{{NN}}.{{M}}
    titulo: {{titulo da fase, sem acento, uma linha}}
    status: {{nao_iniciado | em_andamento | bloqueado | concluido}}
    criterio_saida: {{condicao verificavel, binaria, sem adjetivo}}
    paralelizavel: {{true | false}}
    paralela_com: [{{F-NN.M}}]
    tasks: [{{T-NN.MM, T-NN.MM}}]
  - id: F-{{NN}}.{{M}}
    titulo: {{titulo da fase, sem acento, uma linha}}
    status: {{nao_iniciado | em_andamento | bloqueado | concluido}}
    criterio_saida: {{condicao verificavel, binaria, sem adjetivo}}
    paralelizavel: false
    paralela_com: []
    tasks: [{{T-NN.MM}}]
---

# Fases — Sprint {{NN}}

> Um bloco por fase. Repita o bloco quantas vezes forem necessárias. O paralelismo declarado aqui é definitivo: a execução nunca decide paralelismo sozinha.

---

## F-{{NN}}.{{M}} — {{título da fase}}

**Objetivo:** {{uma frase}}

**Tasks que a compõem:** {{T-NN.MM, T-NN.MM, ...}}

**Critério de saída:** {{condição verificável, binária, sem adjetivo}}

**Roda em paralelo com:** {{F-NN.M | nenhuma}}

---

## F-{{NN}}.{{M}} — {{título da fase}}

**Objetivo:** {{uma frase}}

**Tasks que a compõem:** {{T-NN.MM, ...}}

**Critério de saída:** {{condição verificável, binária, sem adjetivo}}

**Roda em paralelo com:** {{F-NN.M | nenhuma}}
