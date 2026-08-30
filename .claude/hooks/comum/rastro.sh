#!/usr/bin/env bash
# rastro.sh — biblioteca compartilhada dos hooks da sprintx.
#
# Implementa o contrato expx-eventos v1:
#   /Users/.../Expx/docs/contrato/CONTRATO-expx-eventos.md
#
# Nao e executavel por si so: os hooks fazem `source` deste arquivo.
#
# Regras do contrato que este arquivo materializa:
#   1. Rapido      — sem subshell desnecessario, sem rede, sem parser externo pesado.
#   3. Falha aberta — toda funcao aqui retorna 0 mesmo quando nao consegue gravar.
#   6. Sem estado proprio — tudo sai de arquivo que ja existe.
#   7. Sempre grava no rastro, inclusive quando permite.

# ---------------------------------------------------------------- util basica

# Raiz do repositorio: sobe ate achar .git. Sem .git em nenhum ancestral,
# usa o cwd. Mesma regra do SKILL.md ("Onde fica docs/sprintx/features/<slug>/").
rastro_raiz() {
  local d="${1:-$PWD}"
  while [ "$d" != "/" ]; do
    [ -d "$d/.git" ] && { printf '%s' "$d"; return 0; }
    d="$(dirname "$d")"
  done
  printf '%s' "${1:-$PWD}"
}

# Escapa uma string para caber dentro de um JSON string literal.
# Ordem importa: a barra invertida primeiro, senao escapamos o que ja escapamos.
rastro_json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//	/\\t}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\n'/\\n}"
  printf '%s' "$s"
}

# Le uma chave de topo de um JSON simples vindo do stdin do hook.
# Usa jq quando existe (correto); sem jq, cai para um grep tolerante.
# Nunca falha: chave ausente devolve string vazia.
rastro_json_get() {
  local json="$1" chave="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$json" | jq -r --arg k "$chave" '.[$k] // empty' 2>/dev/null
    return 0
  fi
  printf '%s' "$json" \
    | grep -o "\"$chave\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 | sed 's/.*:[[:space:]]*"//; s/"$//'
}

# Le uma chave aninhada em tool_input (ex.: file_path).
rastro_tool_input_get() {
  local json="$1" chave="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$json" | jq -r --arg k "$chave" '.tool_input[$k] // empty' 2>/dev/null
    return 0
  fi
  printf '%s' "$json" \
    | grep -o "\"$chave\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1 | sed 's/.*:[[:space:]]*"//; s/"$//'
}

# ------------------------------------------------------------ trabalho_id

# Descobre o trabalho_id (= slug da feature) sem manter estado proprio:
# e a feature com o ORQUESTRADOR.md modificado mais recentemente.
# Sem nenhuma feature em disco, devolve "sem-trabalho".
rastro_trabalho_id() {
  local raiz="$1" f mais_novo=""
  local base="$raiz/docs/sprintx/features"
  [ -d "$base" ] || { printf 'sem-trabalho'; return 0; }
  for f in "$base"/*/ORQUESTRADOR.md; do
    [ -f "$f" ] || continue
    if [ -z "$mais_novo" ] || [ "$f" -nt "$mais_novo" ]; then mais_novo="$f"; fi
  done
  if [ -z "$mais_novo" ]; then
    # Fase anterior a F4: ainda nao ha ORQUESTRADOR. Usa a pasta mais recente.
    for f in "$base"/*/; do
      [ -d "$f" ] || continue
      if [ -z "$mais_novo" ] || [ "$f" -nt "$mais_novo" ]; then mais_novo="$f"; fi
    done
    [ -n "$mais_novo" ] && { basename "${mais_novo%/}"; return 0; }
    printf 'sem-trabalho'; return 0
  fi
  basename "$(dirname "$mais_novo")"
}

# ------------------------------------------------------------------ modo

# Le o modo de um hook em .expx/hooks.json — "aviso", "bloqueio" ou "desligado".
# Contrato expx-eventos: "O modo vive em .expx/hooks.json, por hook".
#
# Os TRES modos sao obrigatorios. Reconhecer so dois e cair no padrao diante do
# terceiro faz o hook continuar rodando depois de alguem pedir para desliga-lo.
#
# O padrao, quando o arquivo falta ou nao tem a entrada, sai do `tipo`:
# hook de seguranca nasce em bloqueio e NUNCA e rebaixado por ausencia de
# configuracao; hook de metodo nasce em aviso. So um "desligado" explicito
# desliga um hook de seguranca.
#
# Uso: rastro_modo <raiz> <hook> [tipo]   — tipo: metodo (padrao) | seguranca
rastro_modo() {
  local raiz="$1" hook="$2" tipo="${3:-metodo}" cfg="$1/.expx/hooks.json"
  local padrao='aviso'
  [ "$tipo" = "seguranca" ] && padrao='bloqueio'

  [ -f "$cfg" ] || { printf '%s' "$padrao"; return 0; }
  local m=""
  if command -v jq >/dev/null 2>&1; then
    m="$(jq -r --arg h "$hook" '.hooks[$h].modo // empty' "$cfg" 2>/dev/null)"
  else
    m="$(grep -o "\"$hook\"[[:space:]]*:[[:space:]]*{[^}]*}" "$cfg" 2>/dev/null \
        | grep -o '"modo"[[:space:]]*:[[:space:]]*"[^"]*"' \
        | head -1 | sed 's/.*:[[:space:]]*"//; s/"$//')"
  fi
  case "$m" in
    bloqueio|aviso|desligado) printf '%s' "$m" ;;
    *)                       printf '%s' "$padrao" ;;
  esac
}

# ---------------------------------------------------------------- gravacao

# rastro_grava <raiz> <evento> <origem> <resultado> <detalhe> [arquivos_json] [extras_json]
#
# Grava UMA linha JSON em docs/eventos/<trabalho_id>.jsonl, no formato exato
# do contrato. As chaves saem sempre todas, na ordem do contrato, e chave
# ausente vai como null — nunca omitida.
#
# Falha aberta: qualquer erro aqui e engolido. Um hook nunca trava o trabalho
# por nao conseguir escrever o proprio rastro.
rastro_grava() {
  local raiz="$1" evento="$2" origem="$3" resultado="$4" detalhe="$5"
  local arquivos="${6:-[]}" extras="${7:-}"

  {
    local dir="$raiz/docs/eventos"
    mkdir -p "$dir" 2>/dev/null || return 0

    local tid; tid="$(rastro_trabalho_id "$raiz")"
    local arq="$dir/$tid.jsonl"

    # Rotacao: acima de 5 MB o arquivo vira <trabalho_id>.1.jsonl (contrato).
    if [ -f "$arq" ]; then
      local tam
      tam=$(wc -c < "$arq" 2>/dev/null | tr -d ' ')
      if [ -n "$tam" ] && [ "$tam" -gt 5242880 ] 2>/dev/null; then
        mv -f "$arq" "$dir/$tid.1.jsonl" 2>/dev/null || true
      fi
    fi

    local ts; ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    local linha
    linha="{\"ts\":\"$ts\""
    linha="$linha,\"expx_eventos\":1"
    linha="$linha,\"trabalho_id\":\"$(rastro_json_escape "$tid")\""
    linha="$linha,\"ferramenta\":\"sprintx\""
    linha="$linha,\"origem\":\"$origem\""
    linha="$linha,\"evento\":\"$evento\""
    linha="$linha,\"fase\":${RASTRO_FASE:-null}"
    linha="$linha,\"task\":${RASTRO_TASK:-null}"
    linha="$linha,\"agente\":\"${RASTRO_AGENTE:-principal}\""
    linha="$linha,\"resultado\":\"$resultado\""
    linha="$linha,\"detalhe\":\"$(rastro_json_escape "$detalhe")\""
    linha="$linha,\"arquivos\":$arquivos"
    [ -n "$extras" ] && linha="$linha,$extras"
    linha="$linha}"

    printf '%s\n' "$linha" >> "$arq" 2>/dev/null || true
  } 2>/dev/null || true
  return 0
}

# ------------------------------------------------------------------ saida

# Fala com o modelo SEM bloquear (modo aviso).
#
# ATENCAO — mecanica verificada na documentacao oficial, divergente do
# contrato v1: no PostToolUse o `exit 2` NAO bloqueia e o stderr NAO volta
# ao modelo. O unico canal que chega ao modelo e o JSON no stdout, via
# hookSpecificOutput.additionalContext. Ver DS-31 em DECISOES-DA-SKILL.md.
rastro_aviso_ao_modelo() {
  local evento_hook="$1" msg="$2"
  printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"%s"}}\n' \
    "$evento_hook" "$(rastro_json_escape "$msg")"
  exit 0
}

# Barra a chamada (modo bloqueio). So vale em PreToolUse.
# exit 2 + stderr e o caminho documentado para bloquear.
rastro_bloqueia() {
  printf '%s\n' "$1" >&2
  exit 2
}
