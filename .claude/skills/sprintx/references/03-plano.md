# F3 — PLANO

Você está na F3. Seu objetivo é gerar a árvore de sprints/fases/tasks. Nesta fase você não escreve código de implementação.

## Pré-requisitos verificáveis

- `docs/sprintx/features/<slug>/00-DECISOES.md` existe.
- **Nenhum PENDENTE bloqueante** em `00-DECISOES.md`. Se houver, PARE: liste os PENDENTEs, diga o que cada um trava e pergunte só o necessário para resolvê-los (isso é resolução de pendência da F2, não uma nova entrevista). Só gere o plano com todos os bloqueantes resolvidos.
- Se `00-DECISOES.md` não existe, a F2 não aconteceu: diga "Falta a F2 (descoberta). Vou executá-la primeiro." e execute `references/02-descoberta.md`.

Se este é um retorno da F5 (auditoria com achado ALTA), leia `00-AUDITORIA.md` antes de regerar: cada achado ALTA e MÉDIA deve ser endereçado na nova versão do plano.

## Passo 0 — Consultar o histórico dos arquivos (quando houver `memox`)

Antes de escrever o plano, se o `memox` estiver instalado no projeto, consulte-o sobre os
arquivos que o plano pretende tocar. Ele responde "quem já mexeu neste arquivo e por quê" a
partir dos artefatos de trabalhos anteriores — features fechadas pela sprintx e ocorrências
fechadas pela runx.

Como a lista de arquivos ainda não existe (é o Passo 2 que a produz), consulte pelos
**candidatos**: os arquivos e áreas que a base (`base/`) identificou como tocados pela
feature. Um segundo passe, depois de escrever as tasks, é útil mas não obrigatório.

O que o `memox` devolver **entra na base como contexto histórico**, num arquivo próprio de
`base/` no formato do Passo 4 da F1, com a **proveniência preservada**: cada afirmação diz de
qual trabalho veio (`trabalho_id`) e de qual artefato. Isso não é opinião da skill nem
conhecimento novo — é o que outro trabalho registrou, e o leitor precisa poder voltar à fonte.

Use-o para o que ele é bom: descobrir que um arquivo que você ia tratar como simples já foi
palco de uma ocorrência, que um módulo tem risco residual registrado, ou que uma decisão que
você ia tomar já foi tomada (e por quê). Um achado desses vira risco na sprint ou decisão
`D-NN` — nunca uma alteração silenciosa no plano.

**A ausência do `memox` nunca bloqueia.** Não está instalado, não responde, não conhece os
arquivos: siga para o Passo 1 sem registrar nada e sem avisar. O plano nunca depende dele —
o histórico é contexto que melhora o plano, não pré-requisito dele.

## Passo 1 — Desenhar a árvore

Com a base (`base/`) e as decisões (`00-DECISOES.md`) na mão, desenhe Sprints → Fases → Tasks.

**Regra estrutural obrigatória:** a sprint-01 entrega a capacidade de testar — configuração, client/conexões, harness de teste, fixtures — e NÃO funcionalidade de negócio. Sem isso, o TDD das sprints seguintes não é executável.

**Regra de granularidade:** se `teste_integracao` e `teste_funcional` de uma task não cabem em uma frase cada, a task está grande demais — quebre em duas ou mais.

**Paralelismo declarado:** para CADA task, declare `paralelizavel` e `depende_de`; para CADA fase, declare com qual outra fase pode rodar em paralelo (ou "nenhuma"). A execução nunca decidirá isso — se você não declarar, é sequencial.

**Sem decisão humana em execução:** se ao planejar você encontrar algo que exigiria decisão humana durante a execução, transforme em decisão AGORA: pergunte ao usuário na hora, registre a resposta como nova linha D-NN em `00-DECISOES.md` e só então continue o plano. Esta é a única pergunta permitida na F3.

## Passo 2 — Escrever os arquivos

Para cada sprint N, crie `docs/sprintx/features/<slug>/sprint-NN/` com três arquivos, usando os templates (caminhos relativos à raiz da skill):

- `sprint.md` — de `assets/TEMPLATE-sprint.md`: objetivo, fases, critério de saída, riscos conhecidos.
- `fases.md` — de `assets/TEMPLATE-fases.md`: por fase, objetivo, tasks que a compõem, critério de saída, com qual outra fase pode rodar em paralelo.
- `tasks.md` — de `assets/TEMPLATE-tasks.md`: um bloco por task com TODOS os campos do contrato (`id`, `titulo`, `objetivo`, `arquivos`, `teste_integracao`, `teste_funcional`, `criterio_aceite`, `depende_de`, `paralelizavel`, `status`).

**Frontmatter (obrigatório).** Os três arquivos são arquivos de estado e são gravados com
o frontmatter do contrato expx-schema v1 — `kind: sprint`, `kind: fases` e `kind: tasks`,
respectivamente. Leia `references/00-schema.md` antes de gravar e siga-o para os campos e
os enums. Pontos que a F3 costuma errar:

- Em `kind: tasks`, a lista `tasks:` do frontmatter espelha os blocos da prosa: um item por
  task, com os mesmos campos do contrato acima, mais `fase` (a fase à qual a task pertence),
  `concluida_em: null` e `suite: nao_executada` — a F3 nunca executou nada ainda.
- `teste_integracao` e `teste_funcional` são obrigatórios e não vazios já aqui, na F3.
  Task gravada sem eles é violação do método, não rascunho.
- Em `kind: fases`, "roda em paralelo com: nenhuma" na prosa vira `paralela_com: []` com
  `paralelizavel: false` no YAML.
- Em `kind: sprint`, `criterio_saida` é o mesmo critério da prosa, resumido em uma linha, e
  `riscos` é a lista dos riscos conhecidos (`[]` se nenhum).

Convenções:

- `id` no formato `T-NN.MM` (NN = sprint, MM = sequencial dentro da sprint).
- `status` inicial de toda task: `pendente`.
- `criterio_aceite` é verificável, binário e sem adjetivo. "Endpoint responde 200 com o campo `total`" serve; "endpoint funciona bem" não serve.
- `arquivos` lista caminhos relativos à raiz do repositório, separados em "cria:" e "altera:".
- Nada no plano pode contradizer a base sem uma decisão D-NN que justifique.

**O diagrama do grafo de tasks (ao gravar `fases.md`).** Com as tasks da sprint escritas, gere
o bloco Mermaid do grafo de tasks e grave-o dentro do próprio `fases.md`, abaixo do
frontmatter e acima da prosa das fases. O formato exato, as regras de derivação, o limite de
25 tasks e os exemplos estão em `references/09-diagrama.md` — leia-o antes de gerar.

O diagrama é **derivado**: ele sai exclusivamente de `id`, `titulo`, `fase`, `depende_de` e
`status` das tasks, e não acrescenta informação nenhuma ao plano. Se dois desses campos se
contradisserem (o caso típico: `paralelizavel: true` com `depende_de` não vazio), o diagrama
**não é gerado** e a contradição é reportada como erro de plano — que aqui, na F3, é para
corrigir agora, antes de encerrar a fase. Fora isso, a ausência do diagrama é inofensiva e
nunca impede a F3 de ser concluída.

## Passo 2.1 — Derivar o `modulo_afetado` e as `palavras_chave`

Com as tasks escritas, os arquivos que a feature vai tocar estão declarados: eles são a união
dos campos `arquivos` (`cria` + `altera`) de todas as tasks. A partir deles, derive os módulos
afetados e registre-os no `ORQUESTRADOR.md` — no campo `modulo_afetado` do frontmatter
(`kind: orquestrador`, contrato em `references/00-schema.md`).

**Como derivar o módulo de um arquivo, nesta ordem:**

1. **Com `CONVENCOES.md` no projeto** (procure, nesta ordem, em `CONVENCOES.md`,
   `docs/stackx/CONVENCOES.md` e `.expx/CONVENCOES.md`, na raiz do repositório): use as
   **camadas que ele declara**. O módulo é o nome da camada à qual o arquivo pertence segundo
   as convenções do projeto — é a resposta certa porque é a que o projeto já usa para se
   descrever.
2. **Sem `CONVENCOES.md`**: use a **estrutura de pastas**, sem chutar. Tome o primeiro
   segmento significativo do caminho depois da raiz de código, ignorando os invólucros que não
   são módulo (`src/`, `app/`, `lib/`, `packages/<nome>/src/`, `internal/`, `pkg/`).
   `src/relatorios/exportador.ts` → `relatorios`; `app/api/rotas/pedidos.ts` → `api`;
   `packages/core/src/faturamento/calculo.ts` → `faturamento`. Se o caminho não tiver segmento
   além do arquivo (`main.ts` na raiz), o módulo é `raiz`.

A ausência do `CONVENCOES.md` **nunca é erro e nunca bloqueia**: a estrutura de pastas é uma
fonte legítima, e é a que todo projeto tem. Este é o mesmo critério do hook `tdd-teste-antes`,
com uma diferença deliberada: lá, sem convenções, o hook fica inativo, porque adivinhar onde o
teste mora produz falso positivo que desinstala o hook; aqui a derivação continua, porque a
pasta de um arquivo é um fato observável, não um palpite.

**Normalize sempre:** minúscula, sem acento, sem plural inventado. `Relatórios` → `relatorios`.
Módulo repetido entra uma vez só.

**As `palavras_chave`** saem do trabalho em si — o que a feature faz, o domínio que ela toca, a
tecnologia central. Até 8 termos, minúscula, sem acento. Mais que 8 deixa de discriminar.

`arquivos_alterados` **fica `[]` aqui**: na F3 nenhuma task foi concluída, e o campo agrega
tasks concluídas. Quem o preenche é a F6, ao fechar a última task. A chave existe já na F3, com
lista vazia — nunca ausente (regra 6 do contrato).

Se a F4 ainda não rodou (o `ORQUESTRADOR.md` não existe), leve estes valores prontos para ela:
a F4 os grava ao criar o arquivo. Se o orquestrador já existe (retorno da F5, replanejamento),
reescreva os campos e o `atualizado_em`.

## Passo 2.2 — Gravar o total de tasks no estado da barra

Com as tasks escritas, o plano tem um número que a barra de status precisa e que só existe a
partir de agora: **quantas tasks o trabalho tem no total**. Conte todas as tasks de todas as
sprints e grave `tasks_total` em `.expx/estado.json`, seguindo `references/09-estado.md`.

Grave também `fase: f3`, se a fase ainda não estiver registrada lá. `tasks_concluidas` fica
como está (`0`, nesta altura) — nenhuma task foi executada.

Se o plano for regerado (retorno da F5), reescreva `tasks_total` com a nova contagem: um plano
que ganhou ou perdeu tasks muda o denominador que a barra mostra.

Se `.expx/` não existir, siga sem gravar, sem erro e sem aviso — a ausência do diretório
significa que o CLI não instalou o ecossistema neste projeto, e nada do plano depende disso.

## Passo 3 — Verificação própria antes de encerrar

Antes de declarar a F3 concluída, confira você mesmo:

- [ ] Toda task tem os 10 campos do contrato preenchidos.
- [ ] Os três arquivos de cada sprint têm frontmatter válido conforme `references/00-schema.md`, e a lista `tasks:` do YAML bate task a task com os blocos da prosa.
- [ ] Nenhum `depende_de` aponta para id inexistente; não há ciclo de dependência.
- [ ] Toda task com `paralelizavel: true` não escreve nos mesmos arquivos de outra task paralela da mesma janela.
- [ ] A sprint-01 é de capacidade de testar, não de negócio.
- [ ] Nenhuma task depende de decisão humana em execução.
- [ ] Cada teste de cada task cabe em uma frase.
- [ ] Nenhuma task tem pior caso plausível maior que quatro vezes o melhor caso plausível (senão, quebre-a agora — a F3.5 se recusaria a estimá-la).
- [ ] `modulo_afetado` e `palavras_chave` estão derivados (Passo 2.1), em minúscula e sem acento, prontos para o `ORQUESTRADOR.md` — ou já gravados nele, se ele existir.
- [ ] `tasks_total` foi gravado em `.expx/estado.json` com o número de tasks do plano (Passo 2.2), ou `.expx/` não existe no projeto.
- [ ] Cada `fases.md` tem o bloco Mermaid do grafo de tasks conforme `references/09-diagrama.md` — ou a contradição que impediu a geração foi corrigida no plano. Este item não bloqueia a fase: o diagrama é derivado.

## Critério de saída da fase

- [ ] `sprint-01/` (e demais sprints) existem com `sprint.md`, `fases.md` e `tasks.md` completos.
- [ ] Checklist do Passo 3 toda atendida.

## Quando o critério não é atendido

Corrija o plano você mesmo, nesta fase, antes de encerrar — a F3 é o lugar de mexer no plano. Não deixe para a F5 achar o que você já sabe que está errado.

## O plano é o insumo da F3.5 (estimativa)

O plano pronto — tasks granulares, com `depende_de` e `paralelizavel` declarados — é exatamente o insumo de que a estimativa precisa. É por isso que a F3.5 (`references/07-estimativa.md`) só roda depois desta fase: estimar antes de existir task é chute com aparência de método.

A F3.5 é **opcional** e não é pré-requisito da F4. Você não a executa aqui, e a ausência de estimativa não impede nada. Duas obrigações práticas recaem sobre a F3:

**Portão de compreensão — antecipe-o aqui.** Ao desenhar cada task, pergunte-se qual seria o esforço no caso bom plausível (`o`) e no caso ruim plausível (`p`). **Se `p` superar quatro vezes `o`, a task está mal compreendida e deve ser quebrada AINDA NA F3**, antes de encerrar a fase. Uma faixa em que o pior caso é mais de quatro vezes o melhor não é incerteza sobre esforço: é falta de entendimento sobre o que a task é — e a F3.5 se recusa a estimar uma task assim, devolvendo-a para cá. Quebrar agora custa minutos; descobrir na estimativa custa um retorno de fase.

Esse teste é irmão da regra de granularidade (se os dois testes não cabem em uma frase cada, quebre) e não a substitui: aplique os dois.

**Não estime aqui.** Não escreva horas, faixas, prazos nem datas em `sprint.md`, `fases.md` ou `tasks.md`. Nenhum campo do contrato da task carrega esforço, e o plano não é o lugar de número de esforço. A estimativa vive exclusivamente em `docs/sprintx/features/<slug>/00-ESTIMATIVA.md`, gravado pela F3.5.

## Ao terminar

Anuncie: "F3 concluída. Plano em `docs/sprintx/features/<slug>/sprint-*/` (N sprints, M tasks)." Siga para a F4 lendo `references/04-orquestrador.md`.

Grave a fase de destino em `.expx/estado.json` (`references/09-estado.md`): `fase: f4` ao seguir direto para a F4, ou `fase: f3.5` se o usuário pediu estimativa e a F3.5 vai rodar antes.

Se o usuário pediu estimativa (ou acionou `/sprintx-estimar`), rode antes a F3.5 lendo `references/07-estimativa.md` e só então siga para a F4. Sem esse pedido, vá direto para a F4 — a F3.5 nunca é executada por conta própria e nunca bloqueia a passagem.
