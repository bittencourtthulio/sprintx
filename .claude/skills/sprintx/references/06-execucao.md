# F6 — EXECUÇÃO

Você está na F6. A partir de agora você implementa até o fim, sob as regras de autonomia. Você NÃO pergunta nada, NÃO pede autorização para nada e NÃO para no meio. Toda a ambiguidade já foi eliminada nas fases anteriores; se você sentir falta de uma decisão, isso é um bloqueio a registrar, nunca uma pergunta a fazer.

## Pré-requisitos verificáveis

- `docs/sprintx/features/<slug>/00-AUDITORIA.md` existe e contém `VEREDITO: SIM`.
- Se contém `VEREDITO: NÃO`, volte para a F3. Se não existe, falta a F5: diga qual fase falta e execute-a primeiro.

## Passo 1 — Carregar o mapa

Leia `docs/sprintx/features/<slug>/ORQUESTRADOR.md` inteiro e siga a ordem de leitura que ele define. Ele é a fonte da rota, do paralelismo, do caminho crítico, das ferramentas e da definição de pronto. Em caso de conflito entre a sua memória da conversa e o ORQUESTRADOR, vale o ORQUESTRADOR.

Se está retomando uma sessão interrompida, siga a seção "Como retomar" do ORQUESTRADOR: status em cada `tasks.md` + `00-BLOQUEIOS.md` dizem onde você parou.

## Passo 2 — Executar task a task

Ordem: sprints em ordem numérica; dentro da sprint, a rota do ORQUESTRADOR. Só execute em paralelo o que o plano declarou paralelizável. Uma task só começa quando todas em `depende_de` estão `concluida`.

Para CADA task, nesta ordem:

1. Marque `status: em_andamento` em `tasks.md` e grave `task_iniciada` no rastro (`references/08-rastro.md`).
2. **Escreva o teste de integração e o teste funcional ANTES de qualquer código de implementação**, exatamente como a task os descreve. Rode-os e confirme que falham (vermelho).
3. Implemente até os dois testes passarem (verde). Rode a suíte relevante inteira, não só os testes novos.
4. Assuma os três papéis do ORQUESTRADOR, em sequência: implementador (passos 2–3), revisor de testes, auditor de aceite (o `criterio_aceite` é verdade agora? verifique de fato, não presuma).

   **O papel de revisor de testes é do agente `revisor-testes`, quando ele existir neste harness.** Acione-o sobre a task que está fechando: ele lê os testes e responde `solido` ou `fraco`, com o motivo em uma linha. Um `fraco` significa que o teste passaria com a implementação errada — e teste fraco é pior que teste ausente, porque produz suíte verde e falsa confiança. Task com teste `fraco` NÃO fecha: corrija o teste até ele discriminar, e só então siga. Sem o agente disponível, faça você mesma a pergunta, com o mesmo rigor.
5. Só então marque `status: concluida` em `tasks.md` e grave `task_concluida` no rastro, acrescentando na linha da task: data (obtenha com `date +%Y-%m-%d` do sistema) e resultado da suíte (ex.: `2026-08-26 · suíte: 42 passed, 0 failed`).
6. **Registre o esforço real da task**, em horas de trabalho focado, na mesma linha (ex.: `2026-08-26 · suíte: 42 passed, 0 failed · real: 3,5 h`). O real cobre o que a task de fato custou — escrever os dois testes, implementar, rodar a suíte e verificar o critério de aceite — e NÃO inclui reunião, revisão de código, deploy nem ida e volta com o cliente. Isso alimenta a calibração das estimativas futuras (ver "Passo 4"); anote no momento de concluir, não reconstrua de memória no fim do trabalho.
7. Critério de aceite não atendido ou teste não passando: a task NÃO é concluída. Não existe "concluído com ressalva".

**Frontmatter (obrigatório) — o YAML e a prosa andam juntos.** Cada arquivo de estado que
você tocar na F6 é gravado com o frontmatter do contrato expx-schema v1
(`references/00-schema.md`, leitura obrigatória antes da primeira gravação). Ao atualizar o
status de uma task, atualize TANTO o frontmatter QUANTO a prosa do bloco — nunca só um dos
dois. A cada gravação de `tasks.md`:

- `status` da task na lista `tasks:` do frontmatter recebe o mesmo valor que a prosa
  (`pendente` → `em_andamento` → `concluida`, ou `bloqueada`).
- `atualizado_em` do arquivo é reescrito com a data do sistema (`date +%Y-%m-%d`).
- `concluida_em` recebe a data quando a task passa a `concluida`; permanece `null` em
  qualquer outro status.
- `suite` recebe `verde` quando a suíte relevante terminou com 0 failed, `vermelha` quando
  houve falha, e permanece `nao_executada` enquanto a suíte não rodou para aquela task.

Deixar o frontmatter desatualizado em relação à prosa equivale a não ter gravado a task: o
painel de operação lê o YAML, não a prosa.

## Regra de bloqueio — nunca parar

Surgiu dúvida nova, decisão não coberta pelo plano, pré-requisito faltando (segredo inexistente, serviço fora do ar, dependência quebrada):

1. Registre em `docs/sprintx/features/<slug>/00-BLOQUEIOS.md`: `B-NN | task | descrição do bloqueio | o que destravaria`.
2. Marque a task como `status: bloqueada` em `tasks.md` e grave `task_bloqueada` no rastro.
   Ao registrar o bloqueio, grave também o frontmatter `kind: bloqueios` de `00-BLOQUEIOS.md` (novo item em `bloqueios:` com `id`, `task`, `aberto_em` com a data do sistema, `resolvido_em: null` e `descricao` em uma linha) e reescreva `atualizado_em`. Formato em `references/00-schema.md`. A task muda para `bloqueada` no frontmatter e na prosa de `tasks.md`.
3. Pule para a próxima task paralelizável cujas dependências estão satisfeitas.
4. NUNCA pare para esperar resposta humana. Se não resta nenhuma task executável, encerre com o relatório final — os bloqueios são a pauta do usuário, não uma conversa sua.

## Portões de fase e de sprint

- Fase só é dada como concluída quando seu critério de saída em `fases.md` é verdade.
- Sprint só é dada como concluída quando seu critério de saída em `sprint.md` é verdade.
- Critério não atendido = não avança para a próxima fase/sprint; trate como bloqueio se não houver task que o resolva.

## Passo 3 — Atualizar o histórico de esforço

Ao fim do trabalho (tudo concluído, ou nada mais executável), atualize `docs/sprintx/estimativas/HISTORICO.md` a partir de `assets/TEMPLATE-HISTORICO.md` (`kind: estimativa_historico`, contrato em `references/00-schema.md`). Este é o único arquivo da skill que é **apendado**, nunca sobrescrito: entrada de trabalho anterior não se apaga nem se reescreve. Se o arquivo não existir, crie-o a partir do template.

Uma entrada por task **concluída**, com: `trabalho_id`, `task_id`, `tipo_task`, `area`, `sinais`, `estimado_min`, `estimado_max`, `estimado_media`, `real` e `desvio`. Task `bloqueada` não entra — ela não tem real completo a registrar.

**O desvio.** Se `docs/sprintx/features/<slug>/00-ESTIMATIVA.md` existe, cada entrada traz o estimado daquela task e o desvio entre estimado e real:

```
desvio_task = real / estimado_media          # estimado_media = (o + 4m + p) / 6
```

`1,0` é o alvo; `1,4` significa que levou 40% a mais que o previsto.

**A duração observada, vinda do rastro.** O rastro registra o instante de `task_iniciada` e de `task_concluida`, o que dá a duração de cada task **sem ninguém anotar nada** (`references/08-rastro.md`). Use-a para conferir o `real` que você anotou no Passo 2 — mas **não a confunda com esforço**:

> Tempo de parede não é esforço. Uma task "aberta" por seis horas pode ter tido vinte minutos de trabalho e um almoço no meio.

Por isso a duração vinda do rastro entra no `HISTORICO.md` como `duracao_observada`, um campo distinto de `real`, e **nunca a substitui**. Quando as duas divergirem muito, vale o `real` — e a divergência é, ela própria, um sinal de que a task teve interrupção.

Pela mesma razão, a calibração usa **mediana**, não média: um único intervalo com pausa no meio distorce uma média e quase não move uma mediana.

Se a F3.5 não rodou (não existe `00-ESTIMATIVA.md`), registre o real mesmo assim, com `estimado_min`, `estimado_max`, `estimado_media` e `desvio` em `null`: o real continua alimentando a comparabilidade por tipo e área nas estimativas futuras.

**Recalcule a tabela de calibração por tipo** ao acrescentar as entradas: para cada `tipo_task`, `desvio_medio` é a média dos `desvio_task` de todas as entradas encerradas daquele tipo, e `fator_ativo` é `true` a partir de 3 entradas. Esse desvio é o que vira fator de correção nas estimativas seguintes — e ele é sempre declarado na saída da estimativa, nunca embutido em silêncio (`references/07-estimativa.md`).

Se houve estimativa, inclua no relatório final (Passo 4) uma linha por sprint com estimado × real e o desvio, para que a divergência fique visível junto com as demais.

## Passo 4 — Relatório final

Ao terminar (tudo concluído, ou nada mais executável), entregue ao usuário um relatório com exatamente estas seções:

1. **Concluído por sprint** — por sprint: tasks concluídas / total, e o que ficou funcionando.
2. **Bloqueios** — o conteúdo de `00-BLOQUEIOS.md` (ou "nenhum").
3. **Saída da suíte** — o resultado da última execução completa da suíte de testes, colado, não resumido de memória.
4. **Divergências entre o plano e a realidade** — tudo que foi diferente do planejado (arquivo a mais, teste ajustado, limite da base que se comportou diferente), uma linha por divergência.

## Critério de saída da fase

- [ ] Toda task está `concluida` ou `bloqueada` (nenhuma `pendente`/`em_andamento` executável restante).
- [ ] `tasks.md` atualizado com data e resultado de suíte em cada task concluída.
- [ ] Em todo arquivo de estado tocado, o frontmatter está válido e coerente com a prosa: `status`, `concluida_em`, `suite` e `atualizado_em` refletem o estado real (`references/00-schema.md`).
- [ ] Se o trabalho inteiro foi entregue, `ORQUESTRADOR.md` teve `estagio`, `status`, `concluido_em` e `atualizado_em` reescritos; sprints e fases concluídas tiveram `status` atualizado em `sprint.md` e `fases.md`.
- [ ] Toda task concluída tem o esforço real registrado em `tasks.md`.
- [ ] `docs/sprintx/estimativas/HISTORICO.md` recebeu uma entrada por task concluída, com o desvio calculado (ou `null` quando não houve estimativa), e a tabela de calibração por tipo foi recalculada.
- [ ] Relatório final entregue com as 4 seções.
