#!/usr/bin/env bash
# git-perigoso — PreToolUse em Bash. NASCE EM BLOQUEIO.
#
# Barra operacao de versionamento destrutiva e irreversivel durante uma
# execucao autonoma. A F6 roda sem supervisao: um `push --force` ali apaga
# trabalho de outra pessoa sem ninguem ver acontecer.
#
# Hook de SEGURANCA: falha fechada.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./rastro.sh
. "$DIR/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

CMD="$(rastro_tool_input_get "$ENTRADA" command)"
[ -n "$CMD" ] || exit 0

MOTIVO=""
case "$CMD" in
  *"git push"*"--force"*|*"git push"*" -f "*|*"git push --force-with-lease"*)
    MOTIVO="push forcado reescreve o historico remoto" ;;
  *"git reset --hard"*)
    MOTIVO="reset --hard descarta alteracoes nao commitadas, sem desfazer" ;;
  *"git clean -"*[fdx]*)
    MOTIVO="git clean apaga arquivos nao rastreados definitivamente" ;;
  *"git checkout ."*|*"git restore ."*)
    MOTIVO="descarta todas as alteracoes locais de uma vez" ;;
  *"git branch -D"*)
    MOTIVO="apaga branch sem verificar merge" ;;
  *"git rebase"*|*"git filter-branch"*|*"git reflog expire"*)
    MOTIVO="reescreve historico" ;;
esac

[ -n "$MOTIVO" ] || exit 0

rastro_grava "$RAIZ" acao_bloqueada hook bloqueado "git perigoso: $MOTIVO" '[]'
rastro_bloqueia "sprintx/git-perigoso: comando barrado — $MOTIVO. Durante a execucao autonoma nenhuma operacao de versionamento irreversivel roda sem decisao humana. Se isso e mesmo necessario, pare, registre em 00-BLOQUEIOS.md e deixe para o usuario decidir."
