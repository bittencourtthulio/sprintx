# F6 — EXECUÇÃO

Você está na F6. A partir de agora você implementa até o fim, sob as regras de autonomia. Você NÃO pergunta nada, NÃO pede autorização para nada e NÃO para no meio. Toda a ambiguidade já foi eliminada nas fases anteriores; se você sentir falta de uma decisão, isso é um bloqueio a registrar, nunca uma pergunta a fazer.

## Pré-requisitos verificáveis

- `docs/<slug>/00-AUDITORIA.md` existe e contém `VEREDITO: SIM`.
- Se contém `VEREDITO: NÃO`, volte para a F3. Se não existe, falta a F5: diga qual fase falta e execute-a primeiro.

## Passo 1 — Carregar o mapa

Leia `docs/<slug>/ORQUESTRADOR.md` inteiro e siga a ordem de leitura que ele define. Ele é a fonte da rota, do paralelismo, do caminho crítico, das ferramentas e da definição de pronto. Em caso de conflito entre a sua memória da conversa e o ORQUESTRADOR, vale o ORQUESTRADOR.

Se está retomando uma sessão interrompida, siga a seção "Como retomar" do ORQUESTRADOR: status em cada `tasks.md` + `00-BLOQUEIOS.md` dizem onde você parou.

## Passo 2 — Executar task a task

Ordem: sprints em ordem numérica; dentro da sprint, a rota do ORQUESTRADOR. Só execute em paralelo o que o plano declarou paralelizável. Uma task só começa quando todas em `depende_de` estão `concluida`.

Para CADA task, nesta ordem:

1. Marque `status: em_andamento` em `tasks.md`.
2. **Escreva o teste de integração e o teste funcional ANTES de qualquer código de implementação**, exatamente como a task os descreve. Rode-os e confirme que falham (vermelho).
3. Implemente até os dois testes passarem (verde). Rode a suíte relevante inteira, não só os testes novos.
4. Assuma os três papéis do ORQUESTRADOR, em sequência: implementador (passos 2–3), revisor de testes (o teste falharia com implementação errada?), auditor de aceite (o `criterio_aceite` é verdade agora? verifique de fato, não presuma).
5. Só então marque `status: concluida` em `tasks.md`, acrescentando na linha da task: data (obtenha com `date +%Y-%m-%d` do sistema) e resultado da suíte (ex.: `2026-08-26 · suíte: 42 passed, 0 failed`).
6. Critério de aceite não atendido ou teste não passando: a task NÃO é concluída. Não existe "concluído com ressalva".

## Regra de bloqueio — nunca parar

Surgiu dúvida nova, decisão não coberta pelo plano, pré-requisito faltando (segredo inexistente, serviço fora do ar, dependência quebrada):

1. Registre em `docs/<slug>/00-BLOQUEIOS.md`: `B-NN | task | descrição do bloqueio | o que destravaria`.
2. Marque a task como `status: bloqueada` em `tasks.md`.
3. Pule para a próxima task paralelizável cujas dependências estão satisfeitas.
4. NUNCA pare para esperar resposta humana. Se não resta nenhuma task executável, encerre com o relatório final — os bloqueios são a pauta do usuário, não uma conversa sua.

## Portões de fase e de sprint

- Fase só é dada como concluída quando seu critério de saída em `fases.md` é verdade.
- Sprint só é dada como concluída quando seu critério de saída em `sprint.md` é verdade.
- Critério não atendido = não avança para a próxima fase/sprint; trate como bloqueio se não houver task que o resolva.

## Passo 3 — Relatório final

Ao terminar (tudo concluído, ou nada mais executável), entregue ao usuário um relatório com exatamente estas seções:

1. **Concluído por sprint** — por sprint: tasks concluídas / total, e o que ficou funcionando.
2. **Bloqueios** — o conteúdo de `00-BLOQUEIOS.md` (ou "nenhum").
3. **Saída da suíte** — o resultado da última execução completa da suíte de testes, colado, não resumido de memória.
4. **Divergências entre o plano e a realidade** — tudo que foi diferente do planejado (arquivo a mais, teste ajustado, limite da base que se comportou diferente), uma linha por divergência.

## Critério de saída da fase

- [ ] Toda task está `concluida` ou `bloqueada` (nenhuma `pendente`/`em_andamento` executável restante).
- [ ] `tasks.md` atualizado com data e resultado de suíte em cada task concluída.
- [ ] Relatório final entregue com as 4 seções.
