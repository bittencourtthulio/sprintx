---
description: sprintx F1 — ingestão, constrói a base de conhecimento da feature
---

Invoque a skill `sprintx` e execute a F1 INGESTÃO seguindo `references/01-ingestao.md`.

Feature: $ARGUMENTS (se vazio, use a feature em andamento; se não houver, derive o slug do que o usuário descreveu).

Antes de executar, confirme pela máquina de estados do SKILL.md que a fase atual é de fato a F1. Se `docs/<slug>/base/` já existe completa, a F1 já passou: diga isso e execute a fase realmente pendente (uma reexecução da F1 só para complementar a base é permitida se o usuário pedir explicitamente, avisando que o plano existente pode ficar desatualizado).
