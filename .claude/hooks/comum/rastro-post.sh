#!/usr/bin/env bash
# rastro-post — PostToolUse. Grava `arquivo_alterado` e `suite_executada`.
#
# Contrato, regra 7: "Sempre grava no rastro, inclusive quando permite."
# Este e o hook que cumpre isso para as duas acoes que o painel precisa ver.
#
# O par (arquivo_alterado, suite_executada) e o que da ao painel a linha do
# tempo do trabalho — e, junto com task_iniciada/task_concluida gravados pela
# skill, a duracao observada que alimenta a calibracao de estimativa.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./rastro.sh
. "$DIR/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

FERRAMENTA="$(rastro_json_get "$ENTRADA" tool_name)"

case "$FERRAMENTA" in
  Write|Edit|MultiEdit|NotebookEdit)
    ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
    [ -n "$ALVO" ] || exit 0
    REL="${ALVO#"$RAIZ"/}"
    rastro_grava "$RAIZ" arquivo_alterado hook ok "$FERRAMENTA" "[\"$(rastro_json_escape "$REL")\"]"
    ;;
  Bash)
    CMD="$(rastro_tool_input_get "$ENTRADA" command)"
    [ -n "$CMD" ] || exit 0
    # So comandos que sao mesmo execucao de suite.
    case "$CMD" in
      *"npm test"*|*"npm run test"*|*"yarn test"*|*"pnpm test"*|\
      *pytest*|*"go test"*|*"cargo test"*|*jest*|*vitest*|*rspec*|*phpunit*|*"dotnet test"*|*"mvn test"*)
        # resultado da suite: o painel quer saber se passou.
        SAIDA="$(rastro_json_get "$ENTRADA" tool_response)"
        RES="ok"
        # Cuidado com "0 failed", que e o caso VERDE e aparece em quase toda
        # saida de suite: o [1-9] no inicio do numero e o que separa os dois.
        if printf '%s' "$SAIDA" | grep -qE '(^|[^0-9])[1-9][0-9]* (failed|failing|error)'; then
          RES="falha"
        elif printf '%s' "$SAIDA" | grep -qE '(^|[[:space:]])(FAILED|FAIL)([[:space:]]|$)'; then
          RES="falha"
        fi
        rastro_grava "$RAIZ" suite_executada hook "$RES" "$(printf '%s' "$CMD" | cut -c1-120)" '[]'
        ;;
    esac
    ;;
esac

exit 0
