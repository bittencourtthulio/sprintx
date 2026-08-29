# F4 — ORQUESTRADOR

Você está na F4. Seu objetivo é gerar `docs/sprintx/features/<slug>/ORQUESTRADOR.md` — o arquivo-mapa, a porta de entrada da execução. Escreva-o para quem abriu o repositório agora e não sabe nada: nem do projeto, nem do método, nem desta conversa.

## Pré-requisitos verificáveis

- `docs/sprintx/features/<slug>/sprint-01/` existe com `sprint.md`, `fases.md` e `tasks.md`.
- Se não existe, a F3 não aconteceu: diga "Falta a F3 (plano). Vou executá-la primeiro." e execute `references/03-plano.md`.

## Passo único — Gerar ORQUESTRADOR.md

Use `assets/TEMPLATE-ORQUESTRADOR.md` (caminho relativo à raiz da skill). O arquivo tem exatamente estas seções, nesta ordem:

1. **Objetivo** — o que esta feature entrega, em NO MÁXIMO 5 linhas.
2. **Mapa e ordem de leitura** — todos os arquivos de `docs/sprintx/features/<slug>/` e em que ordem um executor deve lê-los (este arquivo primeiro; depois `00-DECISOES.md`; depois `base/00-INDICE.md`; depois cada `sprint-NN/` na ordem).
3. **Rota de execução** — a sequência de sprints e fases, marcando explicitamente: o que roda em paralelo com o quê, e qual é o caminho crítico (a cadeia de dependências que define a duração total). Derive tudo de `fases.md` e dos `depende_de` das tasks — não invente paralelismo que o plano não declarou.
4. **Ferramentas** — MCPs e SDKs necessários; comandos exatos de teste, lint e typecheck do projeto; onde ficam os segredos (nome da variável e local — NUNCA o valor).
5. **Agentes** — os três papéis: *implementador* (escreve teste e código da task), *revisor de testes* (confere que o teste falharia com implementação errada), *auditor de aceite* (confere o critério de aceite antes de marcar concluída). Explique como um agente único assume os três papéis em sequência dentro de cada task quando não há múltiplos agentes disponíveis.
6. **Regras de autonomia** — copie as regras de execução: não perguntar, não pedir autorização; teste antes do código; dúvida nova → `00-BLOQUEIOS.md`, pular, seguir para a próxima paralelizável; critério de aceite não atendido = não avança; status atualizado em `tasks.md` a cada task.
7. **Definição de pronto global** — o que precisa ser verdade para a feature inteira estar entregue (derive da definição de pronto do usuário em `00-DECISOES.md` + critérios de saída das sprints).
8. **Como retomar uma sessão interrompida** — instrução literal: ler este arquivo, ler os `status` em cada `tasks.md`, ler `00-BLOQUEIOS.md`, e continuar da primeira task `pendente` ou `em_andamento` cujas dependências estão `concluida`.

Regras de escrita:

- Só caminhos relativos à raiz do repositório.
- Nenhum valor de segredo, token ou credencial — só o nome e onde encontrar.
- Não duplique o conteúdo das tasks aqui; aponte para os arquivos.

**Frontmatter (obrigatório).** `ORQUESTRADOR.md` é arquivo de estado: grave-o com o
frontmatter `kind: orquestrador` do contrato expx-schema v1, descrito em
`references/00-schema.md` — leia-o antes de gravar. Ao preencher:

- `estagio` é a fase da máquina de estados em que o trabalho está ao gravar (na F4, `f4`).
- `sprints` lista as pastas de sprint na ordem (`[sprint-01, sprint-02]`).
- `caminho_critico` repete, em lista, a mesma cadeia declarada na seção 3 — sem inventar
  paralelismo nem cadeia que o plano não declarou.
- `concluido_em` é `null` até a feature inteira estar entregue.

## Critério de saída da fase

- [ ] `ORQUESTRADOR.md` existe em `docs/sprintx/features/<slug>/` com as 8 seções, na ordem, todas preenchidas.
- [ ] A seção Objetivo tem no máximo 5 linhas.
- [ ] A rota de execução cobre todas as sprints e fases do plano e marca o caminho crítico.
- [ ] Nenhum segredo com valor; nenhum caminho absoluto.
- [ ] `ORQUESTRADOR.md` tem frontmatter `kind: orquestrador` válido conforme `references/00-schema.md`, com `caminho_critico` igual ao da seção 3.

## Quando o critério não é atendido

Complete a seção faltante antes de encerrar. Se uma informação de Ferramentas não existe no repositório (ex.: não há comando de lint), escreva "NÃO EXISTE NO PROJETO" na linha — não invente comando.

## Ao terminar

Anuncie: "F4 concluída. `docs/sprintx/features/<slug>/ORQUESTRADOR.md` gerado. Próxima fase: F5 AUDITORIA." Siga para a F5 lendo `references/05-auditoria.md`.
