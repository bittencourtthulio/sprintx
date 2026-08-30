# Contrato `expx-estado` v1

Arquivo minúsculo que a barra de status lê. Compartilhado por todas as skills.

---

## A regra que justifica tudo

A barra de status roda a cada mensagem do assistente, com debounce de 300 ms, e **se um gatilho novo dispara enquanto o script ainda executa, o Claude Code mata a execução em vez de enfileirar**. Script lento não atrasa: ele simplesmente não aparece.

Por isso a barra **nunca** lê `tasks.md`, frontmatter, plano ou rastro. Ela lê um arquivo só, pequeno, já mastigado. Quem mantém esse arquivo são as skills e os hooks, que já estão escrevendo em disco de qualquer forma.

## Local

```
.expx/estado.json
```

Ignorado pelo versionador. É estado da máquina de quem está trabalhando, não do projeto.

## Formato

```json
{
  "expx_estado": 1,
  "atualizado_em": "2026-08-29T14:32:10Z",
  "trabalho": "OC-2026-0142",
  "ferramenta": "runx",
  "titulo_curto": "frete acima de 50kg",
  "fase": "e3",
  "task": "T-01.02",
  "tasks_concluidas": 4,
  "tasks_total": 9,
  "raio": "alto",
  "orcamento_arquivos": "2/3",
  "orcamento_linhas": "31/40",
  "branch": "fix/OC-2026-0142-calculo-frete",
  "pr_estado": null,
  "bloqueios": 0
}
```

## Regras

1. **Somente exibição.** Nenhuma skill toma decisão lendo este arquivo. Ele é derivado e descartável; apagá-lo não pode quebrar nada.
2. **Chave nunca omitida.** O que não se aplica vai `null`. `raio` é `null` fora do modo legado; `pr_estado` é `null` antes do push.
3. **Escrita atômica.** Escreva em arquivo temporário e renomeie. A barra pode estar lendo no exato momento da gravação, e JSON pela metade quebra o parse.
4. **Pequeno.** Abaixo de 1 KB. Nada de listas, nada de caminhos longos.
5. **`titulo_curto` cabe em 30 caracteres.** Corte, não quebre linha.
6. **Sem trabalho aberto:** `trabalho`, `fase` e `task` viram `null`. O arquivo continua existindo.
7. **Enums iguais aos do `expx-schema`:** minúsculo, sem acento. `e3`, não `E3`. `alto`, não `ALTO`.

## Quem escreve o quê

| Campo | Dono |
|---|---|
| `trabalho`, `ferramenta`, `titulo_curto`, `fase` | sprintx e runx, nas transições |
| `task`, `tasks_concluidas`, `tasks_total` | sprintx e runx, ao abrir e fechar task |
| `raio`, `orcamento_arquivos`, `orcamento_linhas` | legadox |
| `branch`, `pr_estado` | mergex |
| `bloqueios` | quem registrar bloqueio |

Cada dono atualiza **apenas os seus campos**, preservando os demais. Ler, alterar o que é seu, gravar. Nunca sobrescrever o arquivo inteiro com um objeto novo.

## Quem instala a barra

O CLI. As skills só mantêm o arquivo — nem precisam saber que a barra existe.

## Ressalva

A barra de status é mecanismo do Claude Code. O OpenCode tem o seu, com formato possivelmente diferente. Trate como lacuna a verificar, não como paridade garantida. Sem barra, o `estado.json` continua correto e inofensivo.