#!/usr/bin/env bash
# sem-placeholder-no-plano — PostToolUse em escrita nos arquivos do plano.
#
# Procura marcador de exemplo nao substituido vindo dos templates ({{assim}},
# padrao DS-13). Barato, e pega o plano gerado pela metade.
#
# Modo: nasce em `aviso`.
#
# ATENCAO (DS-31): no PostToolUse o exit 2 NAO bloqueia e o stderr NAO volta
# ao modelo. O unico canal e o JSON no stdout. Por isso este hook so avisa —
# e, mesmo promovido a "bloqueio", o maximo que consegue e avisar mais forte.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../comum/rastro.sh
. "$DIR/../comum/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
[ -n "$ALVO" ] || exit 0

# So os arquivos do plano.
case "$ALVO" in
  */docs/sprintx/features/*) ;;
  *) exit 0 ;;
esac
[ -f "$ALVO" ] || exit 0

# O marcador dos templates. Ignora o proprio template (que DEVE ter marcador).
case "$ALVO" in
  */assets/TEMPLATE-*) exit 0 ;;
esac

ACHADOS="$(grep -o '{{[^}]*}}' "$ALVO" 2>/dev/null | sort -u | head -5 | tr '\n' ' ')"
[ -n "$ACHADOS" ] || exit 0

REL="${ALVO#"$RAIZ"/}"
MSG="sprintx/sem-placeholder-no-plano: $REL ainda tem marcador de template nao substituido: $ACHADOS. Um arquivo do plano com {{marcador}} esta gerado pela metade — substitua tudo antes de seguir para a proxima fase."

rastro_grava "$RAIZ" regra_violada hook aviso "placeholder nao substituido em $REL" "[\"$(rastro_json_escape "$REL")\"]"
rastro_aviso_ao_modelo PostToolUse "$MSG"
