#!/usr/bin/env bash
# tdd-teste-antes — PostToolUse em ferramentas de escrita.
#
# Se um arquivo de implementacao da task for criado ANTES do arquivo de teste
# correspondente, avisa.
#
# Usa as convencoes do `stackx` (CONVENCOES.md) para saber onde o teste
# deveria estar. SEM CONVENCOES.md, FICA INATIVO EM VEZ DE CHUTAR — essa e a
# regra, e ela e deliberada: a heuristica de "arquivo de teste correspondente"
# erra com facilidade.
#
# Modo: so faz sentido em `aviso` por bastante tempo. Nao promova sem
# evidencia acumulada no painel.
#
# ATENCAO (DS-31): PostToolUse nao bloqueia. Este hook so avisa, por desenho.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../comum/rastro.sh
. "$DIR/../comum/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

# ---------------------------------------------------- porta: exige stackx
# Sem CONVENCOES.md nao ha como saber onde o teste mora neste projeto.
# Inativo e a resposta certa; chutar produziria falso positivo, e falso
# positivo desinstala o hook (e leva junto os que funcionavam).
CONV=""
for c in "$RAIZ/CONVENCOES.md" "$RAIZ/docs/stackx/CONVENCOES.md" "$RAIZ/.expx/CONVENCOES.md"; do
  [ -f "$c" ] && { CONV="$c"; break; }
done
[ -n "$CONV" ] || exit 0

ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
[ -n "$ALVO" ] || exit 0
[ -f "$ALVO" ] || exit 0
REL="${ALVO#"$RAIZ"/}"

# Artefatos da skill e o proprio teste nao entram.
case "$REL" in
  docs/*|.expx/*) exit 0 ;;
esac

# O sufixo de teste do projeto sai do CONVENCOES.md, nao de palpite.
# Aceita as formas usuais declaradas la (.test.ts, _test.go, .spec.ts, ...).
SUFIXOS="$(grep -oE '\.(test|spec)\.[a-z]+|_test\.[a-z]+' "$CONV" 2>/dev/null | sort -u)"
[ -n "$SUFIXOS" ] || exit 0

# O arquivo escrito JA e um teste? Entao TDD esta sendo respeitado.
for s in $SUFIXOS; do
  case "$REL" in *"$s") exit 0 ;; esac
done

# E um arquivo de implementacao. Existe o teste correspondente?
BASE="${REL%.*}"
EXT="${REL##*.}"
for s in $SUFIXOS; do
  # so considera sufixos da mesma linguagem
  case "$s" in *".$EXT") ;; *) continue ;; esac
  [ -f "$RAIZ/$BASE$s" ] && exit 0
  # convencao de pasta espelhada: src/x.ts -> test/x.test.ts
  ESPELHO="${BASE#src/}"
  for d in test tests __tests__ spec; do
    [ -f "$RAIZ/$d/$ESPELHO$s" ] && exit 0
  done
done

MSG="sprintx/tdd-teste-antes: $REL parece implementacao e nenhum teste correspondente foi encontrado (convencoes lidas de ${CONV#"$RAIZ"/}). O metodo exige o teste ANTES da implementacao: escreva o teste, veja-o falhar (vermelho), e so entao implemente."

rastro_grava "$RAIZ" regra_violada hook aviso "implementacao sem teste correspondente: $REL" "[\"$(rastro_json_escape "$REL")\"]"
rastro_aviso_ao_modelo PostToolUse "$MSG"
