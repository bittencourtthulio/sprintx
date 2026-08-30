#!/usr/bin/env bash
# segredo — PreToolUse em ferramentas de escrita. NASCE EM BLOQUEIO.
#
# "Segredo commitado nao tem volta, e o falso positivo ali e raro."
#
# Este e um hook de SEGURANCA: falha FECHADA. Se ele nao consegue decidir,
# ele barra. E o oposto dos hooks de metodo.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./rastro.sh
. "$DIR/rastro.sh"

ENTRADA="$(cat)"
CWD="$(rastro_json_get "$ENTRADA" cwd)"
[ -n "$CWD" ] || CWD="$PWD"
RAIZ="$(rastro_raiz "$CWD")"

ALVO="$(rastro_tool_input_get "$ENTRADA" file_path)"
CONTEUDO="$(rastro_tool_input_get "$ENTRADA" content)"
[ -n "$CONTEUDO" ] || CONTEUDO="$(rastro_tool_input_get "$ENTRADA" new_string)"
[ -n "$CONTEUDO" ] || exit 0

REL="${ALVO#"$RAIZ"/}"

# Arquivos que EXISTEM para guardar segredo local nao entram — mas so quando
# ja estao ignorados pelo versionador.
case "$REL" in
  .env|.env.*|*/.env|*/.env.*)
    if [ -f "$RAIZ/.gitignore" ] && grep -qE '^\.env' "$RAIZ/.gitignore" 2>/dev/null; then
      exit 0
    fi
    ;;
esac

# Padroes de segredo com forma reconheciveis. Deliberadamente conservador:
# prefixos de provedor e chave privada, que quase nao dao falso positivo.
ACHADO=""
while IFS='|' read -r nome padrao; do
  [ -n "$padrao" ] || continue
  # -e e obrigatorio: padroes que comecam com "-" (PEM) viram flag sem ele.
  if printf '%s' "$CONTEUDO" | grep -qE -e "$padrao"; then ACHADO="$nome"; break; fi
done <<'PADROES'
chave privada PEM|-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----
token da AWS|AKIA[0-9A-Z]{16}
chave da OpenAI|sk-[A-Za-z0-9]{20,}
chave da Anthropic|sk-ant-[A-Za-z0-9_-]{20,}
token do GitHub|gh[pousr]_[A-Za-z0-9]{30,}
token do Slack|xox[baprs]-[A-Za-z0-9-]{10,}
chave do Google|AIza[0-9A-Za-z_-]{35}
credencial em URL|://[A-Za-z0-9_.-]+:[^@/[:space:]]{8,}@
PADROES

[ -n "$ACHADO" ] || exit 0

# Hook de seguranca: o padrao e bloqueio e ausencia de configuracao NAO rebaixa.
# So um "desligado" explicito desliga.
[ "$(rastro_modo "$RAIZ" segredo seguranca)" = "desligado" ] && exit 0

rastro_grava "$RAIZ" acao_bloqueada hook bloqueado "segredo detectado ($ACHADO) em $REL" "[\"$(rastro_json_escape "$REL")\"]"
rastro_bloqueia "sprintx/segredo: isso parece $ACHADO sendo gravado em $REL. Segredo em arquivo versionado nao tem volta. Use variavel de ambiente e referencie por nome, ou grave em um .env ja ignorado pelo versionador. Se for um exemplo/fixture, use um valor claramente falso que nao case com o formato real."
