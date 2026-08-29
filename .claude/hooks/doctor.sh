#!/usr/bin/env bash
# doctor — mostra em que modo cada hook está e o que o rastro acumulou.
#
# É a ferramenta do passo 5 da ordem de implementação: a promoção a bloqueio
# é guiada pelas violações que o painel acumulou, e este é o painel mínimo,
# de linha de comando, enquanto o painel de verdade não existe.
#
#   .claude/hooks/doctor.sh              relatório
#   .claude/hooks/doctor.sh promover <hook>   muda o modo para bloqueio
#   .claude/hooks/doctor.sh rebaixar <hook>   volta para aviso
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/comum/rastro.sh"

RAIZ="$(rastro_raiz "$PWD")"
CFG="$RAIZ/.expx/hooks.json"

HOOKS="segredo git-perigoso escopo-da-task task-so-fecha-verde sem-placeholder-no-plano tdd-teste-antes"

# ------------------------------------------------------------- subcomandos
if [ "${1:-}" = "promover" ] || [ "${1:-}" = "rebaixar" ]; then
  ALVO="${2:-}"
  [ -n "$ALVO" ] || { echo "uso: doctor.sh $1 <hook>" >&2; exit 1; }
  case " $HOOKS " in *" $ALVO "*) ;; *) echo "hook desconhecido: $ALVO" >&2; exit 1 ;; esac
  command -v jq >/dev/null 2>&1 || { echo "erro: precisa do jq para mudar o modo" >&2; exit 1; }
  [ -f "$CFG" ] || { echo "erro: $CFG nao existe" >&2; exit 1; }

  NOVO="bloqueio"; [ "$1" = "rebaixar" ] && NOVO="aviso"

  if [ "$1" = "promover" ]; then
    N="$(grep -c "\"regra_violada\"" "$RAIZ"/docs/eventos/*.jsonl 2>/dev/null | awk -F: '{s+=$NF} END {print s+0}')"
    echo "Atencao: $ALVO passa a BARRAR a acao, nao so avisar."
    echo "O rastro acumulou $N violacao(oes) ate agora. Promova so depois de"
    echo "conferir que nenhuma delas era falso positivo."
    echo
  fi

  tmp="$(mktemp)"
  jq --arg h "$ALVO" --arg m "$NOVO" '.hooks[$h].modo = $m' "$CFG" > "$tmp" && mv "$tmp" "$CFG"
  echo "$ALVO -> $NOVO"
  exit 0
fi

# ---------------------------------------------------------------- relatorio
echo
echo "sprintx doctor — $RAIZ"
echo

printf '%-26s %-10s %s\n' "HOOK" "MODO" "INSTALADO"
printf '%-26s %-10s %s\n' "--------------------------" "----------" "---------"
for h in $HOOKS; do
  modo="$(rastro_modo "$RAIZ" "$h")"
  arq=""
  [ -f "$RAIZ/.claude/hooks/comum/$h.sh" ]   && arq="comum/$h.sh"
  [ -f "$RAIZ/.claude/hooks/sprintx/$h.sh" ] && arq="sprintx/$h.sh"
  [ -n "$arq" ] || arq="AUSENTE"
  printf '%-26s %-10s %s\n' "$h" "$modo" "$arq"
done

echo
echo "AGENTES"
for a in auditor-plano revisor-testes investigador; do
  cc=" "; oc=" "
  [ -f "$RAIZ/.claude/agents/$a.md" ]   && cc="x"
  [ -f "$RAIZ/.opencode/agent/$a.md" ] && oc="x"
  printf '  [%s] claude   [%s] opencode   %s\n' "$cc" "$oc" "$a"
done

echo
echo "RASTRO"
if ls "$RAIZ"/docs/eventos/*.jsonl >/dev/null 2>&1; then
  total=$(cat "$RAIZ"/docs/eventos/*.jsonl 2>/dev/null | wc -l | tr -d ' ')
  echo "  $total evento(s) em docs/eventos/"
  if command -v jq >/dev/null 2>&1; then
    echo
    echo "  por evento:"
    cat "$RAIZ"/docs/eventos/*.jsonl 2>/dev/null \
      | jq -r '.evento' 2>/dev/null | sort | uniq -c | sort -rn \
      | while read -r n e; do printf '    %5s  %s\n' "$n" "$e"; done
    echo
    echo "  violacoes por hook (o que decide a promocao a bloqueio):"
    viol=$(cat "$RAIZ"/docs/eventos/*.jsonl 2>/dev/null \
      | jq -r 'select(.evento=="regra_violada") | .detalhe' 2>/dev/null \
      | sed 's/ T-[0-9.]*$//' | sort | uniq -c | sort -rn)
    if [ -n "$viol" ]; then
      printf '%s\n' "$viol" | while read -r n d; do printf '    %5s  %s\n' "$n" "$d"; done
    else
      echo "    nenhuma"
    fi
  fi
else
  echo "  nenhum evento ainda"
fi

echo
echo "Para promover um hook a bloqueio:  .claude/hooks/doctor.sh promover <hook>"
echo
