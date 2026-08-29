---
description: sprintx F6 — executa o plano auditado de forma autônoma até o fim
argument-hint: [nome-da-feature]
---

Invoque a skill `sprintx` e execute a F6 EXECUÇÃO seguindo `references/06-execucao.md`.

Feature: $ARGUMENTS (se vazio, use a feature em andamento).

Antes de executar, confirme pela máquina de estados do SKILL.md que a fase atual é a F6: `docs/sprintx/features/<slug>/00-AUDITORIA.md` precisa existir com `VEREDITO: SIM`. Fora de ordem, recuse: aponte qual fase falta (ou que o veredito é NÃO, o que manda voltar à F3) e execute a fase pendente em vez desta. Se a execução já começou antes, retome pela seção "Como retomar uma sessão interrompida" do `ORQUESTRADOR.md`.
