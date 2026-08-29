---
expx_schema: 1
expx_tool: sprintx
kind: decisoes
trabalho_id: {{slug-da-feature}}
atualizado_em: {{AAAA-MM-DD}}
decisoes:
  - id: D-{{NN}}
    decisao: {{decisao tomada, sem acento, uma linha}}
    alternativa_descartada: {{alternativa descartada, uma linha}}
    motivo: {{motivo, uma linha}}
    status: fechada
    bloqueante: false
  - id: PENDENTE-{{NN}}
    decisao: {{pergunta em aberto, uma linha}}
    alternativa_descartada: null
    motivo: null
    status: pendente
    bloqueante: true
---

# Decisões — {{slug-da-feature}}

> Uma linha por decisão tomada no planejamento (F2 e, excepcionalmente, F3). Formato fixo. Não apague decisões: uma decisão revertida ganha nova linha que cita a anterior.

## Decisões

```
D-01 | {{decisão tomada}} | {{alternativa descartada}} | {{motivo}}
D-02 | {{decisão tomada}} | {{alternativa descartada}} | {{motivo}}
```

## Pendências

> Todo PENDENTE é bloqueante por padrão e trava a F3. Só marque `(NÃO BLOQUEANTE)` com autorização explícita do usuário, registrando a premissa assumida.

```
PENDENTE-01 | {{pergunta em aberto}} | trava: {{o que não pode ser planejado sem isso}}
```

Se não houver pendências, escreva: `Nenhuma pendência.`
