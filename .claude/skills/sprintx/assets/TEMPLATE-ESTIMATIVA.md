---
expx_schema: 1
expx_tool: sprintx
kind: estimativa
trabalho_id: {{slug-da-feature}}
gerada_em: {{AAAA-MM-DD}}
atualizado_em: {{AAAA-MM-DD}}
unidade: h
esforco_total_min: {{numero}}
esforco_total_max: {{numero}}
caminho_critico_min: {{numero}}
caminho_critico_max: {{numero}}
confianca: {{alta | media | baixa}}
confianca_motivo: {{motivo derivado dos sinais, uma linha}}
fator_correcao_aplicado: {{numero ou null}}
metodo_agregacao: pert_quadratura
tasks_estimadas: {{numero}}
premissas: [{{premissa verificavel em uma linha}}]
invalidadores: [{{fato observavel que obriga a refazer a estimativa}}]
nao_incluido: [{{o que a faixa deliberadamente nao cobre}}]
tasks_a_quebrar: [{{T-NN.MM}}]
---

> Substitua TODOS os marcadores `{{...}}`. Roteiro operacional em `references/07-estimativa.md`.
> Frontmatter sem acento em chave nem em valor de enum; datas em `AAAA-MM-DD` obtidas com `date +%Y-%m-%d`.
> `min` e `max` são sempre diferentes: número único é proibido pelo método.

# Estimativa — {{título da feature}}

{{Se a confiança for BAIXA, esta é a PRIMEIRA linha do documento, antes de qualquer número:}}
{{**Confiança BAIXA. Para subir: <ação específica, verificável, curta, nomeando o artefato>.**}}

{{Se não existir `docs/sprintx/estimativas/HISTORICO.md`, esta linha vem em seguida:}}
{{**Não há base de calibração neste projeto:** `docs/sprintx/estimativas/HISTORICO.md` não existe. As faixas vêm de julgamento sobre o plano, sem desvio histórico para corrigi-las. Por isso a confiança não passa de MÉDIA.}}

## Faixa

| | Faixa | O que é |
|---|---|---|
| **Esforço total** | **{{min}}–{{max}} h** | todo o trabalho a ser feito, paralelo ou não — é o que se cobra |
| **Caminho crítico** | **{{min}}–{{max}} h** | a cadeia de dependências mais longa — é o que limita o calendário |

**Por que os dois números são diferentes:** {{uma frase nomeando o que roda em paralelo. Ex.: "T-02.03, T-02.04, T-03.01 e T-03.02 são paralelizáveis e somam no esforço total sem alongar a cadeia F-01.1 → F-02.1 → F-03.2, que é o caminho crítico."}}

> **Esforço não é prazo.** A conversão em data depende da disponibilidade do time, de feriado, férias, revisão e ida e volta com o cliente — variáveis que esta estimativa não conhece. A conversão é decisão de quem conhece a agenda.

Unidade: hora de trabalho focado. Método de agregação: PERT com variâncias somadas em quadratura (fórmulas na seção "Como a conta foi feita").

## Por sprint e fase

| Sprint / Fase | Tasks | Faixa | Sinais predominantes |
|---|---|---|---|
| sprint-{{NN}} | {{n}} | {{min}}–{{max}} h | {{sinais}} |
| — F-{{NN}}.{{M}} {{título}} | {{n}} | {{min}}–{{max}} h | {{sinais}} |
| — F-{{NN}}.{{M}} {{título}} | {{n}} | {{min}}–{{max}} h | {{sinais}} |

## Por task

| Task | Tipo | o | m | p | Média | Faixa | Sinais aplicados | Comparável no histórico |
|---|---|---|---|---|---|---|---|---|
| T-{{NN}}.{{MM}} | {{tipo_task}} | {{o}} | {{m}} | {{p}} | {{media}} | {{min}}–{{max}} h | {{sinal, sinal}} | {{trabalho/task ou "nenhum"}} |

## Tasks a quebrar — não estimadas

{{Toda task cuja faixa pessimista supera quatro vezes a otimista entra aqui e NÃO entra nos totais.}}

| Task | o | p | p/o | O que precisa ser esclarecido para quebrá-la |
|---|---|---|---|---|
| T-{{NN}}.{{MM}} | {{o}} | {{p}} | {{razao}}× | {{uma frase específica}} |

{{ou "Nenhuma: todas as tasks passaram no portão de compreensão (p ≤ 4 × o)."}}

Estas tasks não estão no esforço total nem no caminho crítico. A correção é na F3: quebrar a task, e reestimar depois.

## Itens fora das tasks

{{Só existe se algo da lista "Não incluído" for deliberadamente incluído. Cada item tem faixa própria e nunca é diluído dentro das tasks.}}

| Item | Faixa | Por que está incluído |
|---|---|---|
| {{ex.: homologação assistida com o cliente}} | {{min}}–{{max}} h | {{motivo}} |

{{ou "Nenhum: a faixa cobre apenas o trabalho descrito nas tasks."}}

## Premissas

O que foi assumido como verdadeiro. Se uma delas for falsa, a faixa muda.

- {{premissa verificável hoje, nomeando o artefato que a sustenta}}
- {{premissa verificável hoje, nomeando o artefato que a sustenta}}

## Invalidadores

O que, se acontecer, torna esta estimativa sem valor e obriga a refazê-la. Cada um é um fato **observável**.

- {{fato observável específico deste trabalho, nomeando o que ele contradiz — uma decisão D-NN, um arquivo da base, uma task}}
- {{fato observável específico deste trabalho}}

> Teste antes de gravar: se o invalidador puder ser colado em outro projeto sem trocar uma palavra, ele é genérico. Reescreva. "Mudança de escopo" não é invalidador; "o cliente pedir suporte a mais de um formato de arquivo" é.

## Não incluído

O que esta faixa deliberadamente não cobre:

- reunião, alinhamento e cerimônia
- revisão de código e ida e volta do pull request
- ida e volta com o cliente (dúvida, aprovação, homologação)
- deploy e acompanhamento de subida
- correção pós-entrega e garantia
- treinamento, documentação de usuário e passagem de conhecimento
- gestão do projeto
- {{acrescente o que mais for específico deste trabalho}}

## Confiança

**{{ALTA | MÉDIA | BAIXA}}** — {{motivo derivado dos sinais, citando quais}}.

{{Se BAIXA, repita aqui a ação para subir o nível e diga quanto ela custa aproximadamente. Quase sempre é uma investigação curta que vale mais que uma estimativa apressada.}}

## Calibração

- Histórico consultado: {{`docs/sprintx/estimativas/HISTORICO.md` (N entradas) | "não existe neste projeto"}}
- Fator de correção aplicado: {{ex.: "1,25× nas tasks de tipo `integracao_externa`, vindo de um desvio médio de 1,25 em 4 entradas encerradas" | "nenhum"}}

O fator de correção é sempre visível. Fator embutido em silêncio é indistinguível de número inventado.

## Como a conta foi feita

Método: **PERT com variâncias somadas em quadratura**. Reproduzível à mão.

Por task estimada:

```
media_task  = (o + 4m + p) / 6
desvio_task = (p - o) / 6
```

Por conjunto (fase, sprint, trabalho, caminho crítico):

```
media_conjunto  = soma das media_task
desvio_conjunto = raiz_quadrada( soma dos (desvio_task)^2 )
min = media_conjunto - desvio_conjunto      (piso: soma dos o)
max = media_conjunto + desvio_conjunto
```

Somar variâncias em quadratura faz o intervalo crescer menos que a soma linear: os desvios se compensam entre tasks, e supor que tudo dá errado ao mesmo tempo superestimaria grosseiramente. Por construção, a faixa agregada é sempre mais estreita que `[soma dos o, soma dos p]`.

O **caminho crítico** usa as mesmas fórmulas, mas apenas sobre as tasks da cadeia de dependências mais longa: {{lista dos ids da cadeia}}. Tasks paralelizáveis somam no esforço total e não somam aqui.
