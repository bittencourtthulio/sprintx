# F5 — AUDITORIA

Você está na F5. Você agora é AUDITORA do plano, não autora. Você NÃO corrige nada nesta fase — só aponta. Nem um caractere dos arquivos do plano é alterado aqui.

## Pré-requisitos verificáveis

- `docs/sprintx/features/<slug>/ORQUESTRADOR.md` existe.
- Se não existe, a F4 não aconteceu: diga "Falta a F4 (orquestrador). Vou executá-la primeiro." e execute `references/04-orquestrador.md`.

## Passo 1 — Delegar ao agente `auditor-plano`

**Se o agente `auditor-plano` estiver disponível, a auditoria é dele.** Você gerou o plano (ou está no mesmo contexto de quem gerou), e autor e auditor no mesmo contexto tendem a concordar consigo mesmos. O agente não viu o raciocínio da F3: ele lê só os arquivos.

O `auditor-plano` tem **somente ferramentas de leitura**. É isso que torna "aponta, não corrige" impossível de violar — não uma promessa, uma impossibilidade técnica.

Passe a ele o caminho da feature e peça a tabela de achados e o veredito, no formato do Passo 4. Acione também o agente `revisor-testes` sobre as tasks: ele responde à pergunta que mais escapa — *esse teste passaria mesmo com a implementação errada?* — e devolve `solido` ou `fraco` por task. Todo `fraco` vira um achado da tabela (item 2 da lista do Passo 3); a severidade é sua.

Grave no rastro o `veredito_emitido` com `agente: auditor-plano` (formato em `references/08-rastro.md`).

Se o agente não estiver disponível neste harness, faça a auditoria você mesma, seguindo os Passos 3 e 4 — e sabendo que a regra "só aponta, nunca corrige" volta a depender da sua disciplina.

## Passo 2 — Reler tudo com olhos de auditora

Leia, nesta ordem: `ORQUESTRADOR.md`, `00-DECISOES.md`, `base/00-INDICE.md` (e os arquivos da base que ele lista), cada `sprint-NN/sprint.md`, `fases.md` e `tasks.md`.

## Passo 3 — Verificar cada item desta lista

Para cada task, fase e sprint, procure:

1. **Task sem teste** — `teste_integracao` ou `teste_funcional` vazio, genérico ou ausente.
2. **Teste que passaria com implementação errada** — teste que não discrimina (ex.: só verifica que "não deu erro", ou que valida a fixture em vez do comportamento).
3. **Critério de aceite subjetivo** — qualquer adjetivo ou juízo ("rápido", "correto", "bem estruturado") em vez de condição binária verificável.
4. **Dependência circular** — ciclo em `depende_de`, direto ou transitivo.
5. **Paralelismo falso** — tasks marcadas `paralelizavel: true` que escrevem nos mesmos arquivos ou dependem uma da outra.
6. **Sequencialidade desnecessária no caminho crítico** — tasks no caminho crítico marcadas sequenciais sem dependência real entre elas.
7. **Task que exigiria decisão humana** — qualquer "confirmar com o usuário", "decidir depois", "a definir" dentro de uma task.
8. **Pré-requisito externo não declarado** — segredo, conta, permissão, serviço ou dado que a execução vai precisar e que nenhum arquivo declara.
9. **Base ignorada** — qualquer limite, cota, erro conhecido ou risco registrado em `base/` que o plano não trata; qualquer contradição entre o plano e a base sem decisão D-NN que a justifique.

## Passo 4 — Escrever o relatório

Crie (ou sobrescreva, se é uma reauditoria) `docs/sprintx/features/<slug>/00-AUDITORIA.md` com:

1. Cabeçalho: `# Auditoria — <slug>` e a data.
2. A tabela de achados, exatamente neste formato:

```
| severidade | arquivo | problema | correção sugerida |
|---|---|---|---|
| ALTA | sprint-02/tasks.md | ... | ... |
```

Severidades: **ALTA** (invalida a execução autônoma), **MÉDIA** (risco real, execução ainda possível), **BAIXA** (melhoria).
Se não houver achados, escreva "Nenhum achado." no lugar da tabela.

3. O veredito, em uma linha, literalmente em um destes dois formatos:

```
VEREDITO: SIM — o plano está pronto para execução autônoma.
VEREDITO: NÃO — o plano não está pronto para execução autônoma.
```

Regra do veredito: existe achado ALTA → `VEREDITO: NÃO`. Nenhum achado ALTA → `VEREDITO: SIM` (MÉDIA e BAIXA ficam registrados, não bloqueiam).

## Regra dura desta fase

Achado ALTA manda voltar para a F3 — o plano é REGERADO por quem o gerou, endereçando cada achado. NUNCA corrija à mão o arquivo gerado durante a auditoria, nem "só esse detalhe". Auditora não edita plano.

## Critério de saída da fase

- [ ] `00-AUDITORIA.md` existe com tabela (ou "Nenhum achado.") e a linha `VEREDITO:` no formato exato.
- [ ] Nenhum arquivo do plano foi alterado nesta fase.
- [ ] O `veredito_emitido` foi gravado no rastro, com o `agente` que o emitiu.

## Quando o veredito é NÃO

Anuncie os achados ALTA, volte para a F3 (`references/03-plano.md`) levando `00-AUDITORIA.md` como entrada, regere o plano, refaça a F4 se o ORQUESTRADOR for afetado, e reaudite. Repita o ciclo até `VEREDITO: SIM`.

Grave `fase: f3` em `.expx/estado.json` ao voltar (`references/09-estado.md`): a barra mostra onde o trabalho está agora, e ele voltou para o plano.

## Ao terminar com VEREDITO: SIM

Anuncie: "F5 concluída. VEREDITO: SIM — plano pronto para execução autônoma. N achados MÉDIA/BAIXA registrados em `00-AUDITORIA.md`." Siga para a F6 lendo `references/06-execucao.md` (ou pare aqui se o usuário pediu só o planejamento).

Grave `fase: f6` em `.expx/estado.json` (`references/09-estado.md`) ao entrar na execução. Se o usuário pediu só o planejamento e o trabalho para aqui, mantenha `fase: f5` — o trabalho continua aberto na auditoria, e só a conclusão da F6 zera `trabalho`, `fase` e `task`.
