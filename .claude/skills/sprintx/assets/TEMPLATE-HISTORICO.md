---
expx_schema: 1
expx_tool: sprintx
kind: estimativa_historico
trabalho_id: null
atualizado_em: {{AAAA-MM-DD}}
unidade: h
entradas:
  - trabalho_id: {{slug-do-trabalho}}
    task_id: T-{{NN}}.{{MM}}
    tipo_task: {{config | client | dominio | persistencia | api | ui | integracao_externa | teste | infra | refatoracao}}
    area: {{area ou modulo tocado, uma linha}}
    sinais: [{{sem_cobertura, integracao_externa}}]
    estimado_min: {{numero ou null}}
    estimado_max: {{numero ou null}}
    estimado_media: {{numero ou null}}
    real: {{numero}}
    desvio: {{numero ou null}}
    registrado_em: {{AAAA-MM-DD}}
calibracao:
  - tipo_task: {{tipo}}
    entradas: {{numero}}
    desvio_medio: {{numero}}
    fator_ativo: {{true | false}}
---

> Substitua TODOS os marcadores `{{...}}`. Roteiro operacional em `references/07-estimativa.md`.
> Este arquivo é do PROJETO, não de um trabalho: vive em `docs/sprintx/estimativas/HISTORICO.md` e acumula entradas de todos os trabalhos. Por isso `trabalho_id` no cabeçalho é `null` — o `trabalho_id` de cada linha vive dentro de `entradas:`.
> Este é o único arquivo da skill que é APENDADO, nunca sobrescrito. Trabalho novo acrescenta entradas; entrada antiga não se apaga nem se reescreve.

# Histórico de esforço — calibração das estimativas

Uma linha por task concluída, com o esforço real medido. É a única base de calibração real do projeto: sem ele, toda estimativa fica com confiança no máximo MÉDIA.

Unidade: hora de trabalho focado. O real é o esforço efetivamente gasto na task — escrever os dois testes, implementar, rodar a suíte e verificar o critério de aceite. Não inclui reunião, revisão, deploy nem ida e volta com o cliente: esses são "não incluído" na estimativa e precisam continuar fora aqui, senão a calibração fica corrompida.

## Entradas

| Trabalho | Task | Tipo | Área | Sinais | Estimado (min–max) | Média est. | Real | Desvio |
|---|---|---|---|---|---|---|---|---|
| {{slug}} | T-{{NN}}.{{MM}} | {{tipo_task}} | {{area}} | {{sinais}} | {{min}}–{{max}} h | {{media}} h | {{real}} h | {{desvio}} |

{{Trabalho que rodou sem a F3.5 entra assim: estimado_min, estimado_max, estimado_media e desvio em `null`, com o real preenchido. O real ainda alimenta a comparabilidade por tipo e área.}}

## Calibração por tipo de task

`desvio_medio` é a média dos desvios das entradas encerradas daquele tipo. `1,0` é o alvo; `1,4` significa que aquele tipo de task leva, em média, 40% a mais que o estimado.

| Tipo de task | Entradas | Desvio médio | Fator ativo? |
|---|---|---|---|
| {{tipo_task}} | {{n}} | {{desvio}} | {{sim, aplicado como fator ×{{desvio}} | não — menos de 3 entradas}} |

**Regra do fator.** O desvio de um tipo só vira fator de correção nas estimativas seguintes a partir de **3 entradas encerradas** daquele tipo — abaixo disso é ruído. Quando aplicado, o fator é **sempre declarado na saída da estimativa**, nunca embutido em silêncio.

## Como se calcula o desvio

```
desvio_task = real / media_task_estimada          # media_task = (o + 4m + p) / 6
desvio_medio_do_tipo = media dos desvio_task daquele tipo
```

## Como esta tabela é alimentada

Ao concluir cada task na F6, o esforço real daquela task é anotado. Ao fim do trabalho, a F6 acrescenta as entradas aqui e recalcula a tabela de calibração por tipo. Detalhe em `references/06-execucao.md`; o uso na estimativa, em `references/07-estimativa.md`.
