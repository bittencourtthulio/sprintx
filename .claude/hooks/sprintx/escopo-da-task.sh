#!/usr/bin/env bash
# escopo-da-task — PreToolUse em ferramentas de escrita.
#
# "Nao toque no que nao esta na task" — a regra que se dissolve na task 14 de
# uma execucao autonoma. Aqui ela vira mecanica.
#
# Le o tasks.md da task em andamento e compara o arquivo sendo editado com o
# campo `arquivos`. Fora da lista -> aviso (e, depois de promovido, bloqueio).
#
# Modo: nasce em `aviso`. Promova em .expx/hooks.json so depois de semanas
# sem falso positivo.
#
# Contrato: falha aberta. Qualquer duvida sobre o estado do plano => permite.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../comum/rastro.sh
. "$DIR/../comum/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
# Sem caminho no payload nao ha o que verificar (ex.: ferramenta sem file_path).
[ -n "$ALVO" ] || exit 0

# Caminho relativo a raiz do repo — e assim que o plano declara `arquivos`.
REL="${ALVO#"$RAIZ"/}"

# ------------------------------------------------------------------ isencoes
# Os proprios artefatos da skill nunca sao "fora de escopo": a F6 escreve em
# tasks.md e 00-BLOQUEIOS.md o tempo todo, por desenho.
case "$REL" in
  docs/sprintx/*|docs/eventos/*|.expx/*) exit 0 ;;
esac

# ------------------------------------------------ achar a task em andamento
# Sem estado proprio: a task em andamento e a que tem status em_andamento no
# frontmatter de algum sprint-NN/tasks.md.
# Os dois layouts sao varridos: o novo (docs/sprintx/features/<slug>/) e o
# antigo (docs/<slug>/), que a SKILL.md declara continuar suportando. Um glob
# so pelo layout novo faz o hook nao disparar em projeto antigo — silencio que
# parece "tudo em escopo".
# `find` em vez de glob: no zsh um padrao sem match aborta o script (nomatch),
# e o hook morreria em projeto que ainda nao tem plano.
TASKS_MD=""
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if grep -q 'status: em_andamento' "$f" 2>/dev/null; then TASKS_MD="$f"; break; fi
done <<EOF
$(find "$RAIZ/docs" -maxdepth 5 -name tasks.md -type f 2>/dev/null)
EOF

# Nenhuma task aberta => a skill nao esta em execucao. Nao e papel deste hook
# opinar sobre edicao fora do metodo.
[ -n "$TASKS_MD" ] || exit 0

# Extrai o bloco da task em andamento e os arquivos que ela declarou.
# Faixa: da linha "- id:" que precede o em_andamento ate o proximo "- id:".
LIDO="$(awk '
  /^  - id:/ { bloco=""; dentro=1 }
  dentro     { bloco = bloco $0 "\n" }
  /^  - id:/ { id=$3 }
  /status: em_andamento/ { if (dentro) { print id; printf "%s", bloco; achou=1 } }
  achou && /^  - id:/ && !primeiro { primeiro=1 }
' "$TASKS_MD" 2>/dev/null)"

TASK_ID="$(printf '%s' "$LIDO" | head -1 | tr -d ' ')"
[ -n "$TASK_ID" ] || exit 0

# Coleta os caminhos declarados em `arquivos:` da task aberta.
#
# O campo tem DUAS formas em uso: o mapa {cria, altera}, que as skills gravam,
# e a lista plana `arquivos: [a.ts, b.ts]`, que e a forma do contrato. Ler so
# o mapa faz DECLARADOS ficar vazio diante da lista plana, e o hook sai
# permitindo tudo — falha ABERTA num hook cujo proposito e barrar. As duas
# formas sao lidas.
DECLARADOS="$(awk -v alvo="$TASK_ID" '
  # Emite todo caminho dentro de colchetes na linha. Percorre grupo a grupo:
  # `{cria: [a], altera: [b]}` tem DOIS grupos, e um gsub guloso de `.*\[`
  # descartaria o primeiro em silencio.
  function emitir(linha,   ini, fim, corpo, p, n, i) {
    while (match(linha, /\[[^]]*\]/)) {
      ini = RSTART; fim = RLENGTH
      corpo = substr(linha, ini + 1, fim - 2)
      n = split(corpo, p, ",")
      for (i = 1; i <= n; i++) {
        gsub(/^[ \t]+|[ \t]+$/, "", p[i])
        gsub(/^["'\'']|["'\'']$/, "", p[i])
        if (p[i] != "") print p[i]
      }
      linha = substr(linha, ini + fim)
    }
  }
  $0 ~ /^  - id:/ { atual = $3; sub(/^[ \t]+/, "", atual); emlista = 0 }
  atual != alvo { next }
  # mapa: arquivos: {cria: [...], altera: [...]}, em uma linha ou em duas
  /cria:|altera:/ { emitir($0); next }
  # lista plana na mesma linha: arquivos: [a.ts, b.ts]
  /^[ \t]*arquivos:[ \t]*\[/ { emitir($0); emlista = 0; next }
  # lista plana em bloco: arquivos: seguido de "- caminho"
  /^[ \t]*arquivos:[ \t]*$/ { emlista = 1; next }
  emlista && /^[ \t]*-[ \t]+/ {
    linha = $0
    sub(/^[ \t]*-[ \t]+/, "", linha)
    gsub(/^[ \t]+|[ \t]+$/, "", linha)
    gsub(/^["'\'']|["'\'']$/, "", linha)
    if (linha != "") print linha
    next
  }
  emlista { emlista = 0 }
' "$TASKS_MD" 2>/dev/null)"

# Task sem `arquivos` legivel => nao da para julgar. Permite.
[ -n "$DECLARADOS" ] || exit 0

# O arquivo esta na lista?
if printf '%s\n' "$DECLARADOS" | grep -qxF "$REL"; then
  exit 0
fi

# --------------------------------------------------------------- violacao
LISTA="$(printf '%s' "$DECLARADOS" | tr '\n' ' ')"
MSG="sprintx/escopo-da-task: a task $TASK_ID esta em andamento e declarou estes arquivos: $LISTA. O arquivo $REL nao esta na lista. O caminho certo e ampliar a task no plano (tasks.md), nao editar fora dela."

RASTRO_TASK="\"$TASK_ID\""
MODO="$(rastro_modo "$RAIZ" escopo-da-task metodo)"

# Desligado nao roda e nao registra: quem desligou nao quer nem o aviso.
[ "$MODO" = "desligado" ] && exit 0

if [ "$MODO" = "bloqueio" ]; then
  rastro_grava "$RAIZ" acao_bloqueada hook bloqueado "fora do escopo da task $TASK_ID" "[\"$(rastro_json_escape "$REL")\"]"
  rastro_bloqueia "$MSG"
fi

rastro_grava "$RAIZ" regra_violada hook aviso "fora do escopo da task $TASK_ID" "[\"$(rastro_json_escape "$REL")\"]"
rastro_aviso_ao_modelo PreToolUse "$MSG"
