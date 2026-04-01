#!/bin/sh
set -e

# ─────────────────────────────────────────────
#  git-review — installer
# ─────────────────────────────────────────────

REPO_URL="https://github.com/pereirawe/git-review.git"
INSTALL_DIR="$HOME/.local/share/git-review"
BIN_DIR="$HOME/.local/bin"
BIN_LINK="$BIN_DIR/git-review"

# ── helpers ───────────────────────────────────

info()    { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
success() { printf '\033[1;32m[OK]\033[0m    %s\n' "$*"; }
error()   { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

# ── detect package manager ────────────────────

install_deps() {
  if command -v apt-get > /dev/null 2>&1; then
    info "Instalando dependências via apt..."
    sudo apt-get update -qq
    sudo apt-get install -y curl jq bc gh
    # Instalar glab
    curl -s https://gitlab.com/gitlab-org/cli/-/raw/main/scripts/install.sh | sh
  elif command -v dnf > /dev/null 2>&1; then
    info "Instalando dependências via dnf..."
    sudo dnf install -y curl jq bc
    # gh e glab podem precisar de repos adicionais
    info "Instale gh e glab manualmente se necessário."
  elif command -v yum > /dev/null 2>&1; then
    info "Instalando dependências via yum..."
    sudo yum install -y curl jq bc
    info "Instale gh e glab manualmente se necessário."
  elif command -v brew > /dev/null 2>&1; then
    info "Instalando dependências via brew..."
    brew install curl jq bc gh glab
  elif command -v apk > /dev/null 2>&1; then
    info "Instalando dependências via apk..."
    sudo apk add --no-cache curl jq bc
    info "Instale gh e glab manualmente se necessário."
  else
    error "Nenhum gerenciador de pacotes suportado encontrado (apt, dnf, yum, brew, apk)."
  fi
}

# ── main ──────────────────────────────────────

info "Iniciando instalação do git-review..."

# 1. Verificar que git está disponível
command -v git > /dev/null 2>&1 || error "git não encontrado. Instale o git antes de continuar."

# 2. Instalar dependências
install_deps
success "Dependências instaladas: curl, jq, bc, gh, glab"

# 3. Clonar ou atualizar o repositório
if [ -d "$INSTALL_DIR/.git" ]; then
  info "Repositório já existe. Atualizando..."
  git -C "$INSTALL_DIR" pull --ff-only
  success "Repositório atualizado."
else
  info "Clonando repositório em $INSTALL_DIR..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
  success "Repositório clonado."
fi

# 4. Garantir permissões executáveis
chmod +x "$INSTALL_DIR/git-review"
chmod +x "$INSTALL_DIR/git-review-update"
chmod +x "$INSTALL_DIR/git-review-uninstall"

# 5. Criar symlink em ~/.local/bin
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/git-review" "$BIN_LINK"
success "Symlink criado: $BIN_LINK → $INSTALL_DIR/git-review"

# 6. Copiar arquivo de configuração de exemplo (se ainda não existe)
CONF_FILE="$INSTALL_DIR/git-review.conf"
if [ ! -f "$CONF_FILE" ]; then
  cp "$INSTALL_DIR/git-review.conf.example" "$CONF_FILE"
  info "Arquivo de configuração criado: $CONF_FILE"
  info "Edite-o com suas chaves de API antes de usar."
fi

# 7. Verificar PATH
case ":$PATH:" in
  *":$BIN_DIR:"*)
    # já está no PATH
    ;;
  *)
    info "Adicionando $BIN_DIR ao PATH..."
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
info    "Arquivos em:      $INSTALL_DIR"
info    "Config em:        $CONF_FILE"
info    "Comando no PATH:  $BIN_LINK"
echo ""
info    "Próximo passo: edite $CONF_FILE com sua chave de API."
info    "Depois rode:      git-review"