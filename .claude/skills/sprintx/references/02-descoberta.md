# F2 — DESCOBERTA

Você está na F2 — a ÚNICA fase de todo o método em que você pergunta ao usuário, e nela você é OBRIGADO a perguntar. Nesta fase você não escreve plano e não escreve código.

## Pré-requisitos verificáveis

- `docs/<slug>/base/` existe e tem pelo menos `00-INDICE.md`.
- `docs/<slug>/00-DECISOES.md` não existe (ou existe com PENDENTEs a resolver — reexecução para resolvê-los).

Se `base/` não existe, a F1 não aconteceu: diga "Falta a F1 (ingestão). Vou executá-la primeiro." e execute `references/01-ingestao.md`.

## Passo 1 — Preparar a entrevista

Releia `base/00-INDICE.md` e `base/00-LACUNAS.md`. Toda lacuna da F1 vira pergunta obrigatória.

Monte perguntas cobrindo, no mínimo, estes sete eixos:

1. **Escopo de negócio** — o que entra nesta entrega e o que explicitamente fica de fora; quem usa; qual problema resolve.
2. **Arquitetura** — onde a feature vive (módulo, serviço, camada); o que reutiliza; o que cria.
3. **Contrato de dados** — entidades, campos, formatos, migrações; o que persiste e onde.
4. **Estado e observabilidade** — o que precisa de log, métrica, auditoria; como saber que está funcionando em produção.
5. **Resiliência e política de erro** — o que fazer em falha parcial, timeout, retry; o que é erro fatal vs. degradação.
6. **Ambiente e segredos** — em que ambientes roda; quais variáveis/segredos existem e ONDE ficam (nunca o valor).
7. **Definição de pronto do usuário** — o que o usuário precisa ver funcionando para considerar entregue.

## Passo 2 — Entrevistar em blocos

- Blocos de NO MÁXIMO 5 perguntas. Envie um bloco, ESPERE a resposta, só então envie o próximo.
- Numere as perguntas (P-01, P-02, ...) para o usuário poder responder por número.
- Prefira perguntas com opções concretas ("A, B ou outro?") a perguntas abertas, quando a base permitir.
- **Se uma resposta contradiz a base, avise na hora e cite o arquivo**: "Atenção: isso contradiz `base/<arquivo>.md`, que afirma X (fonte: Y). Confirma mesmo assim?"
- Continue em novos blocos até os sete eixos estarem cobertos e as lacunas da F1 tratadas.

## Passo 3 — Registrar as decisões

Crie `docs/<slug>/00-DECISOES.md` usando `assets/TEMPLATE-DECISOES.md`. Uma linha por decisão:

```
D-01 | decisão | alternativa descartada | motivo
```

- Toda resposta do usuário que fecha uma escolha vira uma linha D-NN.
- O que o usuário não soube ou não quis decidir entra como PENDENTE, com o que cada pendência trava:

```
PENDENTE-01 | pergunta em aberto | trava: <o que não pode ser planejado sem isso>
```

- Todo PENDENTE é bloqueante por padrão. Só marque `(NÃO BLOQUEANTE)` se o usuário disser explicitamente que o plano pode seguir sem essa resposta, e registre o que acontece se a resposta vier diferente do assumido.

## Proibições desta fase

- Não escreva plano, sprint, fase ou task.
- Não escreva código.
- Não decida no lugar do usuário: o que ele não respondeu é PENDENTE, não é palpite seu.

## Critério de saída da fase

- [ ] Os sete eixos foram perguntados e respondidos (ou registrados como PENDENTE).
- [ ] Toda lacuna da F1 foi perguntada.
- [ ] `00-DECISOES.md` existe, com pelo menos uma decisão D-NN, no formato exato.
- [ ] Contradições com a base foram apontadas ao usuário no momento em que surgiram.

## Quando o critério não é atendido

Se o usuário parou de responder no meio, registre o que já foi decidido, marque o restante como PENDENTE e informe: a F3 vai bloquear enquanto houver PENDENTE bloqueante.

## Ao terminar

Anuncie: "F2 concluída. N decisões e M pendências em `docs/<slug>/00-DECISOES.md`." Se houver PENDENTE bloqueante, diga quais e avise que a F3 está travada por eles. Caso contrário, siga para a F3 lendo `references/03-plano.md`.
