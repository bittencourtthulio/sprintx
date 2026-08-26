---
description: sprintx F5 — audita o plano e dá o veredito de prontidão para execução autônoma
argument-hint: [nome-da-feature]
---

Invoque a skill `sprintx` e execute a F5 AUDITORIA seguindo `references/05-auditoria.md`.

Feature: $ARGUMENTS (se vazio, use a feature em andamento).

Antes de executar, confirme pela máquina de estados do SKILL.md que a fase atual é a F5. Fora de ordem, recuse: aponte qual fase falta (F1 sem `base/`, F2 sem `00-DECISOES.md`, F3 sem `sprint-01/`, F4 sem `ORQUESTRADOR.md`) e execute a fase pendente em vez desta. Reauditar um plano já auditado é permitido: sobrescreva `00-AUDITORIA.md` com o novo relatório.
