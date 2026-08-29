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
TASKS_MD=""
for f in "$RAIZ"/docs/sprintx/features/*/sprint-*/tasks.md; do
  [ -f "$f" ] || continue
  if grep -q 'status: em_andamento' "$f" 2>/dev/null; then TASKS_MD="$f"; break; fi
done

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

# Coleta os caminhos declarados em `arquivos:` (cria + altera) da task aberta.
DECLARADOS="$(awk -v alvo="$TASK_ID" '
  $0 ~ /^  - id:/ { atual = $3; sub(/^[ \t]+/, "", atual) }
  atual == alvo && /cria:|altera:/ {
    linha = $0
    gsub(/.*\[/, "", linha); gsub(/\].*/, "", linha)
    n = split(linha, p, ",")
    for (i = 1; i <= n; i++) { gsub(/^[ \t]+|[ \t]+$/, "", p[i]); if (p[i] != "") print p[i] }
  }
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
MODO="$(rastro_modo "$RAIZ" escopo-da-task)"

if [ "$MODO" = "bloqueio" ]; then
  rastro_grava "$RAIZ" acao_bloqueada hook bloqueado "fora do escopo da task $TASK_ID" "[\"$(rastro_json_escape "$REL")\"]"
  rastro_bloqueia "$MSG"
fi

rastro_grava "$RAIZ" regra_violada hook aviso "fora do escopo da task $TASK_ID" "[\"$(rastro_json_escape "$REL")\"]"
rastro_aviso_ao_modelo PreToolUse "$MSG"
