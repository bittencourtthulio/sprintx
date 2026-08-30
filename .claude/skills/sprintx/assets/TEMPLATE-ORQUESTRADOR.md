---
expx_schema: 1
expx_tool: sprintx
kind: orquestrador
trabalho_id: {{slug-da-feature}}
titulo: {{titulo sem acento, uma linha}}
tipo_trabalho: {{feature | ocorrencia}}
tipo_ocorrencia: null
estagio: {{f1 | f2 | f3 | f4 | f5 | f6}}
status: {{nao_iniciado | em_andamento | bloqueado | concluido}}
criado_em: {{AAAA-MM-DD}}
atualizado_em: {{AAAA-MM-DD}}
concluido_em: null
sprints: [{{sprint-01, sprint-02}}]
caminho_critico: [{{F-01.1, F-01.3}}]
modulo_afetado: [{{modulos, minusculo, sem acento}}]
arquivos_alterados: []
palavras_chave: [{{ate 8 termos, minusculo, sem acento}}]
---

# Orquestrador — {{slug-da-feature}}

> Porta de entrada da execução. Escrito para quem abriu o repositório agora e não sabe nada. Só caminhos relativos; nunca o valor de um segredo.

## 1. Objetivo

{{O que esta feature entrega. NO MÁXIMO 5 linhas.}}

## 2. Mapa e ordem de leitura

1. Este arquivo (`ORQUESTRADOR.md`)
2. `00-DECISOES.md` — decisões que governam o plano
3. `base/00-INDICE.md` — e os arquivos da base que ele lista
4. `sprint-01/sprint.md` → `fases.md` → `tasks.md`
5. {{`sprint-02/` em diante, na ordem}}
6. `00-BLOQUEIOS.md` — bloqueios registrados durante a execução
7. `00-AUDITORIA.md` — achados MÉDIA/BAIXA que permanecem válidos

## 3. Rota de execução

{{Sequência de sprints e fases. Marque explicitamente o que roda em paralelo com o quê, derivado de fases.md e dos depende_de. Ex.:}}

- Sprint 01: F-01.1 → F-01.2
- Sprint 02: F-02.1 ∥ F-02.2 (paralelas) → F-02.3

**Caminho crítico:** {{a cadeia de tasks/fases que define a duração total. Ex.: T-01.01 → T-01.03 → T-02.02 → T-02.05}}

## 4. Ferramentas

- **MCPs / SDKs:** {{quais e para quê, ou "nenhum além do padrão"}}
- **Testes:** `{{comando exato}}`
- **Lint:** `{{comando exato, ou "NÃO EXISTE NO PROJETO"}}`
- **Typecheck:** `{{comando exato, ou "NÃO EXISTE NO PROJETO"}}`
- **Segredos:** {{NOME_DA_VARIAVEL}} — fica em {{onde: .env local, secret manager, CI}}. NUNCA escreva o valor.

## 5. Agentes

- **Implementador** — escreve primeiro os dois testes da task, vê ambos falharem, implementa até passarem.
- **Revisor de testes** — antes de aceitar o verde, responde: este teste falharia com uma implementação errada? Se não, o teste volta.
- **Auditor de aceite** — verifica de fato o `criterio_aceite` da task antes de permitir `status: concluida`.

**Agente único:** assume os três papéis em sequência dentro de cada task, nesta ordem, tratando cada papel como um portão — não avança ao papel seguinte sem fechar o anterior.

## 6. Regras de autonomia

1. Não pergunte nada; não peça autorização para nada.
2. O teste vem antes do código, sempre.
3. Task só é `concluida` com teste de integração E funcional passando e `criterio_aceite` verificado. Não existe "concluído com ressalva".
4. Dúvida nova ou pré-requisito faltando: registrar em `00-BLOQUEIOS.md` (`B-NN | task | bloqueio | o que destravaria`), marcar a task `bloqueada`, pular para a próxima paralelizável. Nunca parar e esperar.
5. Só rode em paralelo o que o plano declarou paralelizável; a execução nunca decide paralelismo.
6. Atualize `status` em `tasks.md` a cada transição; ao concluir, acrescente data e resultado da suíte.
7. Critério de saída de fase/sprint não atendido = não avança.

## 7. Definição de pronto global

{{Lista verificável do que precisa ser verdade para a feature inteira estar entregue — derivada da definição de pronto do usuário em 00-DECISOES.md + critérios de saída das sprints.}}

## 8. Como retomar uma sessão interrompida

1. Leia este arquivo inteiro.
2. Leia o `status` de cada task em cada `sprint-NN/tasks.md`.
3. Leia `00-BLOQUEIOS.md`.
4. Continue da primeira task `pendente` ou `em_andamento` cujas dependências (`depende_de`) estão todas `concluida`. Ignore as `bloqueada` até que o bloqueio registrado seja resolvido.
