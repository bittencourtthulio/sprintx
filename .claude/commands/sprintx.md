---
description: sprintx — detecta a fase atual do planejamento da feature e continua de onde parou
argument-hint: [nome-da-feature]
---

Invoque a skill `sprintx` e siga-a integralmente.

Feature: $ARGUMENTS (se vazio, use a feature em andamento — o único `docs/<slug>/` com ciclo sprint^x aberto; se houver mais de um ou nenhum, pergunte qual feature antes de começar).

Aplique a máquina de estados do SKILL.md: inspecione `docs/<slug>/` no disco, anuncie a fase detectada em uma linha e execute essa fase seguindo o reference correspondente. Não pule fase.
