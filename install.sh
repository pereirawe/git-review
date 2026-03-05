#!/bin/sh
set -e

# ─────────────────────────────────────────────
#  review — installer
# ─────────────────────────────────────────────

REVIEW_URL="https://raw.githubusercontent.com/williampereira/review/main/review"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/review"

# ── helpers ───────────────────────────────────

info()    { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
success() { printf '\033[1;32m[OK]\033[0m    %s\n' "$*"; }
error()   { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

# ── detect package manager ────────────────────

install_deps() {
  if command -v apt-get > /dev/null 2>&1; then
    info "Instalando dependências via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y curl jq bc
  elif command -v dnf > /dev/null 2>&1; then
    info "Instalando dependências via dnf..."
    sudo dnf install -y curl jq bc
  elif command -v yum > /dev/null 2>&1; then
    info "Instalando dependências via yum..."
    sudo yum install -y curl jq bc
  elif command -v brew > /dev/null 2>&1; then
    info "Instalando dependências via brew..."
    brew install curl jq bc
  elif command -v apk > /dev/null 2>&1; then
    info "Instalando dependências via apk..."
    sudo apk add --no-cache curl jq bc
  else
    error "Nenhum gerenciador de pacotes suportado encontrado (apt, dnf, yum, brew, apk)."
  fi
}

# ── main ──────────────────────────────────────

info "Iniciando instalação do review..."

# 1. Instalar dependências
install_deps
success "Dependências instaladas: curl, jq, bc"

# 2. Garantir que o diretório de destino existe
mkdir -p "$INSTALL_DIR"

# 3. Fazer download do binário/script
info "Baixando review de $REVIEW_URL..."
curl -fsSL "$REVIEW_URL" -o "$INSTALL_PATH" \
  || error "Falha ao fazer download. Verifique a URL: $REVIEW_URL"
success "Download concluído"

# 4. Dar permissão de execução
chmod +x "$INSTALL_PATH"
success "Permissões configuradas (chmod +x)"

# 5. Verificar PATH
case ":$PATH:" in
  *":$INSTALL_DIR:"*)
    # já está no PATH
    ;;
  *)
    info "Adicionando $INSTALL_DIR ao PATH..."
    SHELL_RC=""
    if [ -f "$HOME/.bashrc" ];  then SHELL_RC="$HOME/.bashrc"; fi
    if [ -f "$HOME/.zshrc" ];   then SHELL_RC="$HOME/.zshrc";  fi
    if [ -n "$SHELL_RC" ]; then
      printf '\n# review — adicionado pelo instalador\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_RC"
      info "Adicionado ao $SHELL_RC. Rode: source $SHELL_RC"
    else
      info "Adicione manualmente ao seu shell rc: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    ;;
esac

# ── feito ─────────────────────────────────────
echo ""
success "review instalado em $INSTALL_PATH"
info    "Execute: review --help"