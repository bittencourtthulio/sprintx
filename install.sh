#!/usr/bin/env bash
# sprintx — instalador para Claude Code e OpenCode
#
#   ./install.sh              instala nos dois harnesses, no projeto atual
#   ./install.sh --global     instala nos dois harnesses, para todos os projetos
#   ./install.sh --claude     só Claude Code
#   ./install.sh --opencode   só OpenCode
#   ./install.sh --dry-run    mostra o que faria, sem escrever nada
#
# Idempotente: rodar de novo atualiza os arquivos no lugar.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SRC/.claude/skills/sprintx"
CMD_SRC="$SRC/.claude/commands"

SCOPE="project"; DO_CLAUDE=1; DO_OPENCODE=1; DRY=0; DEST=""
while [ $# -gt 0 ]; do
  case "$1" in
    --global)   SCOPE="global" ;;
    --project)  SCOPE="project" ;;
    --claude)   DO_OPENCODE=0 ;;
    --opencode) DO_CLAUDE=0 ;;
    --dry-run)  DRY=1 ;;
    -h|--help)  sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)          DEST="$1" ;;
  esac
  shift
done

[ -d "$SKILL_SRC" ] || { echo "erro: skill nao encontrada em .claude/skills/sprintx" >&2; exit 1; }

say()  { printf '  %s\n' "$*"; }
run()  { if [ "$DRY" = 1 ]; then printf '  [dry-run] %s\n' "$*"; else eval "$@"; fi; }

# Copia a skill (SKILL.md + references/ + assets/) para <destino>/sprintx
copy_skill() {
  local dst="$1"
  run "mkdir -p '$dst'"
  run "rm -rf '$dst/sprintx'"
  run "cp -R '$SKILL_SRC' '$dst/sprintx'"
  say "skill    -> $dst/sprintx/"
}

# Copia os 7 commands. $2 = 1 remove 'argument-hint:' (OpenCode nao suporta o campo)
copy_commands() {
  local dst="$1" strip="${2:-0}" f base
  run "mkdir -p '$dst'"
  for f in "$CMD_SRC"/sprintx*.md; do
    base="$(basename "$f")"
    if [ "$strip" = 1 ]; then
      run "grep -v '^argument-hint:' '$f' > '$dst/$base'"
    else
      run "cp '$f' '$dst/$base'"
    fi
  done
  say "commands -> $dst/ (7 arquivos)"
}

echo
echo "sprintx — instalando (escopo: $SCOPE)"
echo

if [ "$SCOPE" = "global" ]; then
  # Global: o OpenCode AUTO-CARREGA skills de ~/.claude/skills/, entao a skill
  # e instalada uma unica vez e serve aos dois harnesses. So os commands sao espelhados.
  if [ "$DO_CLAUDE" = 1 ] || [ "$DO_OPENCODE" = 1 ]; then
    echo "Claude Code (~/.claude) — tambem lido pelo OpenCode como 'external skill'"
    copy_skill "$HOME/.claude/skills"
    [ "$DO_CLAUDE" = 1 ] && copy_commands "$HOME/.claude/commands" 0
    echo
  fi
  if [ "$DO_OPENCODE" = 1 ]; then
    echo "OpenCode (~/.config/opencode)"
    copy_commands "$HOME/.config/opencode/command" 1
    say "skill    -> auto-carregada de ~/.claude/skills/sprintx (nao duplicada)"
    echo
  fi
else
  ROOT="${DEST:-$PWD}"
  [ -d "$ROOT" ] || { echo "erro: destino nao existe: $ROOT" >&2; exit 1; }
  if [ "$DO_CLAUDE" = 1 ]; then
    echo "Claude Code ($ROOT/.claude)"
    copy_skill "$ROOT/.claude/skills"
    copy_commands "$ROOT/.claude/commands" 0
    echo
  fi
  if [ "$DO_OPENCODE" = 1 ]; then
    # Projeto: nao ha ponte .claude -> .opencode, entao a skill e copiada de fato.
    echo "OpenCode ($ROOT/.opencode)"
    copy_skill "$ROOT/.opencode/skills"
    copy_commands "$ROOT/.opencode/command" 1
    echo
  fi
fi

echo "Pronto. Descreva o que quer construir, ou use /sprintx <feature>."
echo
