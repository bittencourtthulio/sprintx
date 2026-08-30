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

<!-- SUBSTITUA O BLOCO ABAIXO INTEIRO pelo grafo de tasks derivado de tasks.md.
     Regras, formato exato e exemplos: references/09-diagrama.md.
     Acima de 25 tasks na sprint: um diagrama por fase mais um de visão geral, nesta mesma posição.
     Contradição entre campos (ex.: paralelizavel: true com depende_de não vazio): NÃO gere o
     diagrama, remova este bloco e reporte a contradição como erro de plano.
     O diagrama é derivado — a ausência dele é inofensiva e nunca bloqueia nada. -->

```mermaid
%% Grafo de tasks — sprint-{{NN}} — gerado pela sprintx a partir de tasks.md
flowchart LR
  subgraph fase_{{NN}}_{{M}}["F-{{NN}}.{{M}} — {{titulo da fase}}"]
    T_{{NN}}_{{MM}}["T-{{NN}}.{{MM}}<br/>{{titulo curto, cortado em 28}}"]
  end

  {{T_NN_MM --> T_NN_MM, uma linha por dependencia, fora dos subgraphs}}

  classDef concluida fill:#d4f4dd,stroke:#2e7d32,color:#1b3d20
  classDef andamento fill:#fff3cd,stroke:#b8860b,color:#4a3800
  classDef bloqueada fill:#f8d7da,stroke:#c62828,color:#4a1d1f
  classDef pendente  fill:#eceff1,stroke:#78909c,color:#263238
  classDef critico   stroke-width:3px

  class T_{{NN}}_{{MM}} pendente
  class {{T_NN_MM, T_NN_MM: os nos do caminho critico}} critico
```

<!-- FIM DO BLOCO A SUBSTITUIR -->

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
