#!/bin/sh
set -e

# ─────────────────────────────────────────────
#  git-review — installer
# ─────────────────────────────────────────────

BASE_URL="https://gitlab.com/-/snippets/5965695/raw/main"
INSTALL_DIR="$HOME/.local/bin"

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

# ── download helper ───────────────────────────

download() {
  local name="$1"
  local dest="$INSTALL_DIR/$name"
  info "Baixando $name..."
  curl -fsSL "$BASE_URL/$name" -o "$dest" \
    || error "Falha ao baixar $name. Verifique: $BASE_URL/$name"
  chmod +x "$dest"
  success "$name instalado em $dest"
}

# ── main ──────────────────────────────────────

info "Iniciando instalação do git-review..."

# 1. Instalar dependências
install_deps
success "Dependências instaladas: curl, jq, bc"

# 2. Garantir que o diretório de destino existe
mkdir -p "$INSTALL_DIR"

# 3. Baixar os scripts
download "git-review"
download "git-review-update"
download "git-review-uninstall"

# 4. Verificar PATH
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
      printf '\n# git-review — adicionado pelo instalador\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$SHELL_RC"
      info "Adicionado ao $SHELL_RC. Rode: source $SHELL_RC"
    else
      info "Adicione manualmente ao seu shell rc: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    ;;
esac

# ── feito ─────────────────────────────────────
echo ""
success "git-review instalado com sucesso!"
info    "Comandos disponíveis:"
info    "  git-review              → executa a revisão de código"
info    "  git-review-update       → atualiza para a versão mais recente"
info    "  git-review-uninstall    → remove a instalação"