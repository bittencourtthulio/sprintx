---
description: sprintx F3.5 — estima o esforço do plano em faixa, com premissas, invalidadores e confiança
argument-hint: [nome-da-feature]
---

Invoque a skill `sprintx` e execute a F3.5 ESTIMATIVA seguindo `references/07-estimativa.md`.

Feature: $ARGUMENTS (se vazio, use a feature em andamento).

A F3.5 é a fase opcional do método e roda **sobre um plano já existente**. Antes de executar, confirme no disco que `docs/sprintx/features/<slug>/sprint-01/` existe com `sprint.md`, `fases.md` e `tasks.md`. Se não existir, o plano não existe: diga "Falta a F3 (plano). Não dá para estimar antes de existir task." e execute `references/03-plano.md` primeiro — estimar antes de existir task é chute com aparência de método. Se faltar fase anterior a essa, aponte qual falta e execute a pendente, conforme a máquina de estados do SKILL.md.

Rodar esta fase não altera o plano, não é pré-requisito de nada e não bloqueia a F4: um plano sem `00-ESTIMATIVA.md` segue para a F4 normalmente. Ela pode ser rodada sobre um plano já auditado sem invalidar a auditoria.

Duas regras invioláveis governam a saída (regras 18 e 19 do SKILL.md):

- **Faixa, nunca número único** — toda estimativa sai como `min–max`, com premissas, invalidadores e nível de confiança declarados.
- **Esforço, nunca prazo** — a unidade é a hora de trabalho focado; a conversão em data de calendário é decisão humana e a skill não a faz.

Ao final, grave `docs/sprintx/features/<slug>/00-ESTIMATIVA.md` (frontmatter `kind: estimativa`, contrato em `references/00-schema.md`) e apresente na conversa: esforço total e caminho crítico como faixas distintas com a diferença explicada, premissas, invalidadores observáveis, o que não está incluído, a confiança com o motivo e o fator de correção aplicado, se houver.
