# Contrato expx-schema v1 — frontmatter dos arquivos de estado

Leitura OBRIGATÓRIA em qualquer fase que grave arquivo de estado (F1, F2, F3, F4, F6).

Um painel de operação lê os arquivos gerados por esta skill para mostrar o andamento
dos trabalhos. Prosa não é contrato: a mesma informação pode ser escrita de dez formas
corretas para um humano e todas quebram um parser. O frontmatter resolve isso sem
prejudicar a leitura humana — a máquina lê o YAML, a pessoa lê a prosa abaixo dele.

O painel apenas LÊ. Esta skill continua sendo a única a escrever.

## Contrato irmão — a runx

O `expx-schema v1` é compartilhado com a [`runx`](https://github.com/bittencourtthulio/runx), a metade Run do
método Expx (ocorrências em produção, estágios E1–E5). Os kinds `orquestrador`, `sprint`, `fases`,
`tasks`, `bloqueios` e `base_indice` existem nas duas skills com os mesmos campos e os mesmos enums;
`expx_tool` (`sprintx` | `runx`) diz qual das duas gravou o arquivo, e é por isso que o enum tem os
dois valores. A runx acrescenta na task o campo `teste_regressao` (prova o comportamento errado antes
do fix) e tem kinds próprios do ciclo dela (`ocorrencia`, `causa_raiz`, `qa`, `relatorio_tecnico`,
`relatorio_uso`, `relatorios_indice`); a sprintx tem o `decisoes`.

**Ao mudar qualquer kind compartilhado, a mudança vale para as duas skills** — um painel que lê as
duas não pode encontrar o mesmo `kind` com formatos diferentes. Kind exclusivo de uma delas pode
evoluir sozinho.

## Regras universais

Valem para todo arquivo que leva frontmatter:

1. O bloco YAML é a primeira coisa do arquivo, delimitado por `---` antes e depois.
2. Toda chave em `snake_case`, minúscula, sem acento.
3. Todo valor de enum em minúscula e sem acento: `concluida`, nunca `Concluída`.
4. Datas em ISO: `AAAA-MM-DD`. Obtenha a data com `date +%Y-%m-%d` do sistema, nunca de memória.
5. Booleanos: `true` / `false` (sem aspas).
6. Lista vazia é `[]`. Valor ausente é `null`. **NUNCA omita a chave** — o painel
   diferencia "não se aplica" de "esqueceram de escrever".
7. O frontmatter é a única fonte para o painel. A prosa abaixo dele é para humano e
   continua exatamente como esta skill já a produz.
8. Campos de texto no YAML são de UMA linha. Nada de duplicar prosa longa no YAML.
9. `atualizado_em` é reescrito a cada gravação do arquivo.

## Enums

| Enum | Valores |
|---|---|
| `expx_tool` | `sprintx` \| `runx` |
| `tipo_trabalho` | `feature` \| `ocorrencia` |
| `estagio` | `f1` `f2` `f3` `f4` `f5` `f6` |
| `status` (trabalho, sprint, fase) | `nao_iniciado` \| `em_andamento` \| `bloqueado` \| `concluido` |
| `status` (task) | `pendente` \| `em_andamento` \| `concluida` \| `bloqueada` |
| `suite` | `verde` \| `vermelha` \| `nao_executada` |
| `severidade` | `alta` \| `media` \| `baixa` |

Atenção a duas distinções que o painel trata como coisas diferentes:

- `estagio` (`f1`..`f6`) é a fase da MÁQUINA DE ESTADOS do método — em minúscula, no frontmatter.
  Não confunda com o id de uma FASE do plano, que é `F-NN.M` (ex.: `F-01.1`) e vive nos
  campos `fases:`, `fase:` e `caminho_critico:`. São namespaces distintos.
- `status` de task usa o vocabulário feminino (`concluida`, `bloqueada`); `status` de
  trabalho, sprint e fase usa o masculino (`concluido`, `bloqueado`). Não troque um pelo outro.

## Cabeçalho comum

Todo arquivo com frontmatter começa com estas quatro chaves, nesta ordem:

```yaml
expx_schema: 1
expx_tool: sprintx
kind: <o kind do arquivo>
trabalho_id: <slug da feature>
```

`trabalho_id` é sempre o `<slug-da-feature>` — o mesmo nome da pasta `docs/<slug>/`.

## Os kinds que a sprintx produz

### `ORQUESTRADOR.md` → `kind: orquestrador`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: orquestrador
trabalho_id: exportacao-csv-relatorios
titulo: Exportacao de relatorios em CSV
tipo_trabalho: feature
tipo_ocorrencia: null
estagio: f3
status: em_andamento
criado_em: 2026-08-20
atualizado_em: 2026-08-29
concluido_em: null
sprints: [sprint-01, sprint-02]
caminho_critico: [F-01.1, F-01.3]
---
```

- `tipo_ocorrencia` é `null` quando `tipo_trabalho: feature`.
- `caminho_critico` lista ids de fase (`F-NN.M`) e/ou de task (`T-NN.MM`), na ordem da
  cadeia, exatamente como a seção 3 do ORQUESTRADOR os declara.
- `concluido_em` permanece `null` até o trabalho inteiro estar entregue.

### `sprint-NN/sprint.md` → `kind: sprint`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: sprint
trabalho_id: exportacao-csv-relatorios
sprint_id: sprint-01
titulo: Fundacao
status: em_andamento
criterio_saida: Suite verde e client cobrindo os quatro endpoints
fases: [F-01.1, F-01.2]
riscos: [Rate limit nao documentado na fonte]
atualizado_em: 2026-08-29
---
```

`riscos` é uma lista de strings de uma linha; sem riscos registrados, `[]`.

### `sprint-NN/fases.md` → `kind: fases`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: fases
trabalho_id: exportacao-csv-relatorios
sprint_id: sprint-01
atualizado_em: 2026-08-29
fases:
  - id: F-01.1
    titulo: Config e segredos
    status: concluido
    criterio_saida: Variaveis carregadas e validadas na subida
    paralelizavel: false
    paralela_com: []
    tasks: [T-01.01, T-01.02]
---
```

`paralela_com` lista os ids das fases que rodam em paralelo com esta; "nenhuma" na prosa
corresponde a `[]` no YAML, com `paralelizavel: false`.

### `sprint-NN/tasks.md` → `kind: tasks`

O arquivo mais importante. Cada task do plano vira um item da lista `tasks:`, com
EXATAMENTE os mesmos campos do Contrato da Task do `SKILL.md` — nenhum a mais, nenhum a
menos — acrescidos apenas dos três campos de execução (`concluida_em`, `suite`) e do
vínculo com a fase (`fase`).

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: tasks
trabalho_id: exportacao-csv-relatorios
sprint_id: sprint-01
atualizado_em: 2026-08-29
tasks:
  - id: T-01.01
    titulo: Carregar configuracao de ambiente
    fase: F-01.1
    status: concluida
    objetivo: Ler e validar as variaveis obrigatorias na subida
    arquivos:
      cria: [src/config/env.ts, src/config/env.test.ts]
      altera: []
    teste_integracao: Sobe a app sem variavel obrigatoria e espera falha
    teste_funcional: Dado env valido, retorna objeto tipado com defaults
    criterio_aceite: App nao sobe sem as quatro variaveis obrigatorias
    depende_de: []
    paralelizavel: true
    concluida_em: 2026-08-29
    suite: verde
---
```

Regras duras deste kind:

- `teste_integracao` e `teste_funcional` são strings OBRIGATÓRIAS e NÃO VAZIAS. O painel
  usa a ausência delas como violação do método. A skill jamais gera uma task sem elas
  preenchidas — inclusive na F3, quando a task ainda está `pendente`.
- `arquivos` mantém a forma do contrato do `SKILL.md`: um mapa com `cria` e `altera`,
  cada um uma lista de caminhos relativos à raiz do repositório (`[]` quando vazio).
- `concluida_em` é `null` enquanto a task não estiver `concluida`.
- `suite` é `nao_executada` até a suíte rodar para aquela task; depois `verde` ou `vermelha`.
- Os campos do YAML são a mesma verdade da prosa do bloco correspondente. Os dois andam juntos.

### `00-BLOQUEIOS.md` → `kind: bloqueios`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: bloqueios
trabalho_id: exportacao-csv-relatorios
atualizado_em: 2026-08-29
bloqueios:
  - id: B-01
    task: T-01.03
    aberto_em: 2026-08-29
    resolvido_em: null
    descricao: Falta credencial de sandbox para validar o webhook
---
```

Sem bloqueios registrados, `bloqueios: []`.

### `00-DECISOES.md` → `kind: decisoes`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: decisoes
trabalho_id: exportacao-csv-relatorios
atualizado_em: 2026-08-29
decisoes:
  - id: D-01
    decisao: Envio assincrono via fila existente
    alternativa_descartada: Envio sincrono na request
    motivo: Nao segurar a resposta do usuario
    status: fechada
    bloqueante: false
---
```

- `status` de decisão usa seu próprio vocabulário: `fechada` \| `pendente`.
- Uma linha `PENDENTE-NN` da prosa entra na lista com `status: pendente`,
  `alternativa_descartada: null` e `motivo: null` enquanto não estiver resolvida.
- `bloqueante` reflete a regra da skill: todo PENDENTE é `true` por padrão; só é `false`
  com autorização explícita do usuário. Decisão já `fechada` é `bloqueante: false`.

### `base/00-INDICE.md` → `kind: base_indice`

```yaml
---
expx_schema: 1
expx_tool: sprintx
kind: base_indice
trabalho_id: exportacao-csv-relatorios
atualizado_em: 2026-08-29
areas:
  - arquivo: send-email.md
    titulo: Send Email
    lacunas: 2
---
```

- `arquivo` é o nome do arquivo dentro de `base/`, sem diretório.
- `lacunas` é o número de lacunas daquela área registradas em `base/00-LACUNAS.md` (`0` se nenhuma).

### Arquivos SEM frontmatter

Não recebem frontmatter, porque o painel não os lê individualmente:

- os arquivos de recurso da base (um por recurso/área, de `TEMPLATE-base-recurso.md`);
- `base/00-LACUNAS.md`;
- `00-AUDITORIA.md`.

Não acrescente frontmatter a eles: um `kind` fora deste contrato é uma violação, não uma extensão.

## Regra de migração — pastas que já existem

Ao abrir uma pasta de trabalho que já existe e cujos arquivos NÃO têm frontmatter:

1. A skill acrescenta o frontmatter na PRÓXIMA VEZ que gravar aquele arquivo, inferindo
   os valores a partir da prosa existente.
2. A skill NUNCA reescreve em massa nem sai migrando pastas ou arquivos que não vai tocar.
3. Se um valor não puder ser inferido da prosa com segurança, use `null` (ou `[]` para
   lista) e siga — nunca invente, nunca pergunte, nunca pare. A chave sempre existe.
4. Migrar o frontmatter NÃO autoriza reescrever a prosa: a prosa existente é preservada
   como está.

## Verificação antes de gravar

Antes de dar por gravado qualquer arquivo de estado:

- [ ] O bloco `---` é a primeira coisa do arquivo e está fechado.
- [ ] O cabeçalho comum (`expx_schema`, `expx_tool`, `kind`, `trabalho_id`) está presente.
- [ ] Nenhuma chave do kind foi omitida — ausente é `null`/`[]`, nunca chave faltando.
- [ ] Nenhum acento em chave ou em valor de enum.
- [ ] Datas em `AAAA-MM-DD`; `atualizado_em` reescrito nesta gravação.
- [ ] Em `kind: tasks`, toda task tem `teste_integracao` e `teste_funcional` não vazios.
- [ ] Nenhum caminho absoluto em nenhum valor.
