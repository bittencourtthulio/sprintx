#!/usr/bin/env bash
# rastro-subagente — SubagentStop. Grava `agente_concluido`.
#
# E o que permite ao painel responder "quem fez o que": filtro por agente,
# com o que cada um tocou e que veredito emitiu.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./rastro.sh
. "$DIR/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

AGENTE="$(rastro_json_get "$ENTRADA" agent_type)"
case "$AGENTE" in
  auditor-plano|revisor-testes|qa|investigador|cartografo) ;;
  *) AGENTE="principal" ;;
esac

RASTRO_AGENTE="$AGENTE"
rastro_grava "$RAIZ" agente_concluido hook ok "subagente $AGENTE encerrou" '[]'
exit 0
