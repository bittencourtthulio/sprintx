# F1 — INGESTÃO

Você está na F1. Seu único objetivo é construir a base de conhecimento antes de qualquer plano. Nesta fase você não pergunta nada ao usuário, não planeja nada e não escreve nenhum código de implementação.

## Pré-requisitos verificáveis

- O slug da feature está definido (derive-o pelas regras do SKILL.md; se ambíguo, proponha e siga).
- `docs/sprintx/features/<slug>/base/` não existe, ou existe incompleta (reexecução para complementar).

Se `docs/sprintx/features/<slug>/base/` já existe completa e `00-DECISOES.md` também existe, a F1 já passou: anuncie a fase real detectada pela máquina de estados e execute-a em vez desta.

## Passo 1 — Scaffold

Crie, se ainda não existirem (os diretórios intermediários `docs/sprintx/` e `docs/sprintx/features/` fazem parte da criação e nascem junto):

```
docs/sprintx/features/<slug>/
  00-BLOQUEIOS.md      apenas o título "# Bloqueios" e a linha "Nenhum bloqueio registrado." — será preenchido na execução
  base/
    00-INDICE.md       título + lista (vazia por enquanto) dos arquivos da base
    00-LACUNAS.md      título + "Nenhuma lacuna registrada."
```

**Frontmatter (obrigatório).** `00-BLOQUEIOS.md` (`kind: bloqueios`, com `bloqueios: []`) e
`base/00-INDICE.md` (`kind: base_indice`) são arquivos de estado: grave-os já com o
frontmatter do contrato expx-schema v1. O formato exato de cada um está em
`references/00-schema.md` — leia-o antes de gravar. `base/00-LACUNAS.md` e os arquivos de
recurso da base NÃO levam frontmatter.
Use `assets/TEMPLATE-BLOQUEIOS.md` e `assets/TEMPLATE-base-indice.md` (caminhos relativos à
raiz da skill) como ponto de partida desses dois arquivos.

**O rastro no `.gitignore`.** Garanta a linha `docs/eventos/` no `.gitignore` da raiz do
repositório — acrescente-a se não existir, e não faça nada se já existir. O rastro de
eventos (`references/08-rastro.md`) é local da máquina de quem executou, cresce rápido e o
painel roda local; versioná-lo por acidente traz conflito de merge em arquivo append-only,
que é chato de resolver. Quem quiser rastro compartilhado troca isso conscientemente.

Na mesma passada, garanta também a linha `.expx/estado.json` no `.gitignore` — o arquivo que a
barra de status lê (`references/09-estado.md`), pela mesma razão: é estado da máquina de quem
está trabalhando, reescrito a cada transição. Se `.expx/` não existe no projeto, não crie nada
e não acrescente a linha: não há o que ignorar.

**O estado da barra — abertura do trabalho.** Com o scaffold no disco, grave `.expx/estado.json`
com `trabalho: <slug>`, `ferramenta: sprintx`, `titulo_curto` (a feature em até 30 caracteres),
`fase: f1`, `task: null`, `tasks_concluidas: 0`, `tasks_total: 0` e `bloqueios: 0`, seguindo
`references/09-estado.md` — leitura e gravação atômica, preservando os campos dos outros donos.
Se `.expx/` não existir, siga sem gravar, sem erro e sem aviso.

## Passo 2 — Detectar o modo

Decida pelo que o usuário descreveu:

- **Modo EXTERNO** — a feature integra ferramenta, API, SDK ou serviço de terceiro (o usuário nomeou um produto externo, ou a feature é inviável sem um). Ingerir a documentação oficial dessa ferramenta.
- **Modo INTERNO** — a feature é do próprio sistema. Ingerir o código existente.

Se genuinamente ambíguo, trate como os dois: ingira a documentação externa E as áreas internas tocadas. No modo EXTERNO, ingira também o mínimo interno necessário (os pontos do sistema que a integração vai tocar) — uma integração nunca é só o lado de fora.

## Passo 3 — Ingerir

**Modo EXTERNO:**
1. Localize a documentação oficial da ferramenta. Verifique primeiro se ela publica um índice para LLMs (`llms.txt` ou `llms-full.txt` na raiz do domínio de docs) ou versões `.md` das páginas (muitos docs servem `.md` ao trocar a extensão da URL). Se publicar, use isso como fonte primária.
2. Leia as páginas relevantes para a feature: autenticação, recursos/endpoints usados, limites, erros, webhooks/eventos se aplicável.
3. Um arquivo por recurso/área estudada em `base/`, no formato do Passo 4.

**Modo INTERNO:**
1. Mapeie as áreas do código que a feature vai tocar: módulos, contratos entre camadas, schema de banco, padrões de teste existentes (framework, comandos, onde ficam as fixtures), configuração e variáveis de ambiente.
2. Leia esses arquivos de verdade — não descreva de memória.
3. Um arquivo por recurso/área estudada em `base/`, no formato do Passo 4.

## Passo 3.1 — Consultar o `memox` (quando instalado)

Se o `memox` estiver instalado no projeto, consulte-o sobre os arquivos e as áreas que a
ingestão identificou como tocados pela feature. Ele responde "quem já mexeu neste arquivo e por
quê" a partir dos artefatos de trabalhos anteriores — features fechadas pela sprintx
(`FECHAMENTO.md`) e ocorrências fechadas pela runx (relatório técnico).

O que ele devolver **entra na base como contexto histórico**, em arquivo próprio de `base/`, no
formato do Passo 4, com a **proveniência preservada**: cada afirmação diz de qual trabalho veio
(`trabalho_id`) e de qual artefato, e a seção "Fonte" aponta para o artefato, não para o
`memox`. Isso vale como fonte documentada para a regra de "nada de invenção": é registro de
outro trabalho, não memória sua.

Um risco residual registrado por um trabalho anterior sobre um arquivo que esta feature vai
tocar é exatamente o tipo de coisa que a base existe para trazer à tona antes do plano.

**A ausência do `memox` nunca bloqueia.** Não instalado, sem resposta, ou sem nada sobre estes
arquivos: siga para o Passo 4 sem registrar nada. A F1 nunca falha por falta dele, e a falta
dele não é lacuna — não vai para `00-LACUNAS.md`, porque lacuna é o que a skill procurou na
fonte e não achou, não uma ferramenta opcional que o projeto não instalou.

## Passo 4 — Formato de cada arquivo da base

Use `assets/TEMPLATE-base-recurso.md` (caminho relativo à raiz da skill). Todo arquivo tem exatamente estas seções:

1. **Contrato de entrada** — o que o recurso recebe (parâmetros, payloads, tipos, obrigatoriedade).
2. **Contrato de saída** — o que devolve (formato, campos, códigos).
3. **Limites e cotas** — rate limits, tamanhos máximos, timeouts, paginação.
4. **Erros conhecidos e tratamento** — códigos de erro, causas, o que a fonte manda fazer.
5. **Riscos para a nossa implementação** — o que daqui pode quebrar o nosso caso de uso.
6. **Fonte** — URL ou caminho de arquivo + data de acesso.

## Regras duras desta fase

- **Nada de invenção.** Se a fonte não afirma, escreva literalmente `NÃO DOCUMENTADO` no campo.
- **Todo número vem com a referência que o afirma** (URL ou arquivo:linha ao lado do número).
- **Proibido escrever código de implementação.** Trechos citados da fonte ou do código existente são permitidos; código novo, não.
- O que você procurou e não encontrou vai para `base/00-LACUNAS.md`, uma linha por lacuna, com onde procurou.
- Cada arquivo criado entra em `base/00-INDICE.md` com uma linha de resumo.
- Ao atualizar `base/00-INDICE.md`, reescreva também a lista `areas:` do frontmatter (uma entrada por arquivo da base, com `lacunas` contando as lacunas daquela área) e o campo `atualizado_em`. Formato em `references/00-schema.md`.

## Critério de saída da fase

- [ ] Todos os recursos/áreas que a feature toca têm arquivo em `base/` no template fixo.
- [ ] `00-INDICE.md` lista todos os arquivos da base.
- [ ] `00-LACUNAS.md` registra tudo que não foi encontrado (ou declara que não há lacunas).
- [ ] Nenhum campo inventado; todo número referenciado.
- [ ] `00-BLOQUEIOS.md` e `base/00-INDICE.md` têm frontmatter válido conforme `references/00-schema.md`.

## Quando o critério não é atendido

Continue ingerindo até atender. Se uma fonte externa está inacessível (docs fora do ar, paywall), registre em `00-LACUNAS.md` com a URL tentada e siga — a lacuna vira pergunta obrigatória na F2.

## Ao terminar

Anuncie: "F1 concluída. Base de conhecimento em `docs/sprintx/features/<slug>/base/` (N arquivos, M lacunas). Próxima fase: F2 DESCOBERTA — vou te entrevistar em blocos de até 5 perguntas." Grave `fase: f2` em `.expx/estado.json` (`references/09-estado.md`). Em seguida, se a sessão continuar, entre na F2 lendo `references/02-descoberta.md`.
