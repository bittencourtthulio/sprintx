# Tasks — Sprint {{NN}}

> Um bloco por task. Repita o bloco abaixo para cada task da sprint, preenchendo TODOS os campos — nenhum é opcional. Na execução (F6), a linha `status` é atualizada em cada transição; ao concluir, acrescente data e resultado da suíte.

---

```yaml
id: T-{{NN}}.{{MM}}
titulo: {{título curto da task}}
objetivo: {{uma frase}}
arquivos:
  cria: [{{caminho/relativo/novo.ext}}]
  altera: [{{caminho/relativo/existente.ext}}]
teste_integracao: {{o que valida, contra o quê — em uma frase}}
teste_funcional: {{o que valida, com qual entrada e qual saída — em uma frase}}
criterio_aceite: {{condição verificável, binária, sem adjetivo}}
depende_de: [{{T-NN.MM, ...}}]   # ou []
paralelizavel: {{true | false}}
status: pendente
```

---

```yaml
id: T-{{NN}}.{{MM}}
titulo: {{título curto da task}}
objetivo: {{uma frase}}
arquivos:
  cria: []
  altera: []
teste_integracao: {{o que valida, contra o quê}}
teste_funcional: {{o que valida, com qual entrada e qual saída}}
criterio_aceite: {{condição verificável, binária, sem adjetivo}}
depende_de: []
paralelizavel: {{true | false}}
status: pendente
```
