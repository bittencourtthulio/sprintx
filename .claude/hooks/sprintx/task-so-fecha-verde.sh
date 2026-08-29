#!/usr/bin/env bash
# task-so-fecha-verde — PreToolUse em escrita no tasks.md.
#
# A regra central do metodo: task so fecha verde. Hoje ela depende do modelo
# lembrar dela na hora de editar o proprio arquivo de estado.
#
# Barra a mudanca de status para `concluida` quando:
#   - `suite` nao for `verde`, ou
#   - `teste_integracao` ou `teste_funcional` estiverem vazios.
#
# Modo: nasce em `aviso`.
#
# Mecanica: le o conteudo QUE VAI SER GRAVADO (tool_input.content para Write,
# new_string para Edit), nao o arquivo em disco — o objetivo e barrar ANTES.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../comum/rastro.sh
. "$DIR/../comum/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
case "$ALVO" in
  */tasks.md) ;;
  *) exit 0 ;;
esac

# O texto que esta sendo escrito. Write traz `content`; Edit traz `new_string`.
NOVO="$(rastro_tool_input_get "$ENTRADA" content)"
[ -n "$NOVO" ] || NOVO="$(rastro_tool_input_get "$ENTRADA" new_string)"
[ -n "$NOVO" ] || exit 0

# Nada virando `concluida` nesta gravacao => nada a verificar.
printf '%s' "$NOVO" | grep -q 'status: concluida' || exit 0

# ------------------------------------------------------ achar as violacoes
# Percorre os blocos de task do texto novo; para cada um que esta `concluida`,
# confere suite verde e os dois testes preenchidos.
PROBLEMAS="$(printf '%s' "$NOVO" | awk '
  function fecha(  msg) {
    if (id != "" && concluida) {
      msg = ""
      if (suite != "verde")   msg = msg " suite=" (suite == "" ? "ausente" : suite)
      if (ti == 0)            msg = msg " teste_integracao vazio"
      if (tf == 0)            msg = msg " teste_funcional vazio"
      if (msg != "") print id ":" msg
    }
    id=""; concluida=0; suite=""; ti=0; tf=0
  }
  /^[ \t]*-[ \t]*id:/ { fecha(); id=$3; sub(/^[ \t]+/,"",id) }
  /status:[ \t]*concluida/      { concluida=1 }
  /suite:/                      { s=$0; sub(/.*suite:[ \t]*/,"",s); sub(/[ \t]+$/,"",s); suite=s }
  /teste_integracao:/           { v=$0; sub(/.*teste_integracao:[ \t]*/,"",v); gsub(/[ \t"'"'"']/,"",v); if (v != "" && v != "null") ti=1 }
  /teste_funcional:/            { v=$0; sub(/.*teste_funcional:[ \t]*/,"",v);  gsub(/[ \t"'"'"']/,"",v); if (v != "" && v != "null") tf=1 }
  END { fecha() }
')"

[ -n "$PROBLEMAS" ] || exit 0

RESUMO="$(printf '%s' "$PROBLEMAS" | tr '\n' ';')"
MSG="sprintx/task-so-fecha-verde: task nao pode ir para concluida assim -> $RESUMO. A regra do metodo e: task so e concluida quando o teste de integracao E o teste funcional passam. Nao existe concluido com ressalva. Rode a suite ate verde, ou marque a task como bloqueada e registre em 00-BLOQUEIOS.md."

MODO="$(rastro_modo "$RAIZ" task-so-fecha-verde)"
REL="${ALVO#"$RAIZ"/}"

if [ "$MODO" = "bloqueio" ]; then
  rastro_grava "$RAIZ" acao_bloqueada hook bloqueado "fechamento invalido: $RESUMO" "[\"$(rastro_json_escape "$REL")\"]"
  rastro_bloqueia "$MSG"
fi

rastro_grava "$RAIZ" regra_violada hook aviso "fechamento invalido: $RESUMO" "[\"$(rastro_json_escape "$REL")\"]"
rastro_aviso_ao_modelo PreToolUse "$MSG"
