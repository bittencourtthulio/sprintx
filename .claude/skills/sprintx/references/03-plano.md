# F3 — PLANO

Você está na F3. Seu objetivo é gerar a árvore de sprints/fases/tasks. Nesta fase você não escreve código de implementação.

## Pré-requisitos verificáveis

- `docs/<slug>/00-DECISOES.md` existe.
- **Nenhum PENDENTE bloqueante** em `00-DECISOES.md`. Se houver, PARE: liste os PENDENTEs, diga o que cada um trava e pergunte só o necessário para resolvê-los (isso é resolução de pendência da F2, não uma nova entrevista). Só gere o plano com todos os bloqueantes resolvidos.
- Se `00-DECISOES.md` não existe, a F2 não aconteceu: diga "Falta a F2 (descoberta). Vou executá-la primeiro." e execute `references/02-descoberta.md`.

Se este é um retorno da F5 (auditoria com achado ALTA), leia `00-AUDITORIA.md` antes de regerar: cada achado ALTA e MÉDIA deve ser endereçado na nova versão do plano.

## Passo 1 — Desenhar a árvore

Com a base (`base/`) e as decisões (`00-DECISOES.md`) na mão, desenhe Sprints → Fases → Tasks.

**Regra estrutural obrigatória:** a sprint-01 entrega a capacidade de testar — configuração, client/conexões, harness de teste, fixtures — e NÃO funcionalidade de negócio. Sem isso, o TDD das sprints seguintes não é executável.

**Regra de granularidade:** se `teste_integracao` e `teste_funcional` de uma task não cabem em uma frase cada, a task está grande demais — quebre em duas ou mais.

**Paralelismo declarado:** para CADA task, declare `paralelizavel` e `depende_de`; para CADA fase, declare com qual outra fase pode rodar em paralelo (ou "nenhuma"). A execução nunca decidirá isso — se você não declarar, é sequencial.

**Sem decisão humana em execução:** se ao planejar você encontrar algo que exigiria decisão humana durante a execução, transforme em decisão AGORA: pergunte ao usuário na hora, registre a resposta como nova linha D-NN em `00-DECISOES.md` e só então continue o plano. Esta é a única pergunta permitida na F3.

## Passo 2 — Escrever os arquivos

Para cada sprint N, crie `docs/<slug>/sprint-NN/` com três arquivos, usando os templates (caminhos relativos à raiz da skill):

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

**Não estime aqui.** Não escreva horas, faixas, prazos nem datas em `sprint.md`, `fases.md` ou `tasks.md`. Nenhum campo do contrato da task carrega esforço, e o plano não é o lugar de número de esforço. A estimativa vive exclusivamente em `docs/<slug>/00-ESTIMATIVA.md`, gravado pela F3.5.

## Ao terminar

Anuncie: "F3 concluída. Plano em `docs/<slug>/sprint-*/` (N sprints, M tasks)." Siga para a F4 lendo `references/04-orquestrador.md`.

Se o usuário pediu estimativa (ou acionou `/sprintx-estimar`), rode antes a F3.5 lendo `references/07-estimativa.md` e só então siga para a F4. Sem esse pedido, vá direto para a F4 — a F3.5 nunca é executada por conta própria e nunca bloqueia a passagem.
