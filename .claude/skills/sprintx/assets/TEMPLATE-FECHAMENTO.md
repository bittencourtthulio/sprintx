---
expx_schema: 1
expx_tool: sprintx
kind: fechamento
trabalho_id: {{slug-da-feature}}
titulo: {{titulo sem acento, uma linha}}
tipo_trabalho: feature
fechado_em: {{AAAA-MM-DD}}
modulo_afetado: [{{modulos, minusculo, sem acento}}]
arquivos_alterados: [{{uniao sem repeticao dos arquivos das tasks concluidas}}]
palavras_chave: [{{ate 8 termos, minusculo, sem acento}}]
resumo: {{uma linha sobre o que a feature entregou}}
decisao_principal: {{a decisao de maior impacto, uma linha}}
risco_residual: {{o que ficou por observar, uma linha}}
testes_adicionados: {{numero}}
---

# Fechamento — {{slug-da-feature}}

> Registro do que este trabalho entregou, em que módulo e em que arquivos. É o que torna a
> feature encontrável depois: por arquivo, por módulo e por palavra-chave.
> Os três campos de indexação são cópia fiel do `ORQUESTRADOR.md` no momento do fechamento.

## O que foi entregue

{{O resumo do frontmatter em prosa: o que o sistema faz agora que não fazia antes. Uma ou duas
frases, não um relatório.}}

## Decisão principal

{{A decisão de maior impacto e por quê. Normalmente uma das linhas D-NN de `00-DECISOES.md` —
quando for, use a mesma redação, com o id.}}

## Risco residual

{{O que ficou por observar: limite não testado, bloqueio aberto, caminho que a suíte não cobre.
Se nada ficou, escreva isso — não deixe a seção vazia.}}

## Onde isto mexeu

- **Módulos:** {{os mesmos de `modulo_afetado`}}
- **Arquivos:** {{os mesmos de `arquivos_alterados`, sem repetição}}
- **Testes adicionados:** {{o mesmo número de `testes_adicionados`}}
