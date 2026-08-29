---
description: sprintx F3 — gera o plano de sprints, fases e tasks
---

Invoque a skill `sprintx` e execute a F3 PLANO seguindo `references/03-plano.md`.

Feature: $ARGUMENTS (se vazio, use a feature em andamento).

Antes de executar, confirme pela máquina de estados do SKILL.md que a fase atual é a F3. Fora de ordem, recuse: se `docs/sprintx/features/<slug>/base/` não existe, falta a F1; se `00-DECISOES.md` não existe, falta a F2 — diga qual fase falta e execute-a em vez desta. Se `00-DECISOES.md` tem PENDENTE bloqueante, a F3 fica travada: resolva as pendências primeiro, conforme o reference.
