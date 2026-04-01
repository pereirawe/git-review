# AI-powered code review no terminal

`git-review` leva seu `git diff` diretamente para APIs de IA (OpenAI, Gemini ou Claude) e retorna uma revisão estruturada feita por um Tech Lead sênior.

## Como funciona

O script compara sua branch atual com a branch base (`main` ou `master`), gera o diff e envia para a API configurada.
O modelo analisa as mudanças e devolve:

- **Resumo** do que foi alterado
- **Comentários** de melhoria com sugestão de código, arquivo/linha e justificativa
- **Pontos fortes** e **pontos de atenção** da MR

## Pré-requisitos

| Dependência | Descrição                       |
| ----------- | ------------------------------- |
| `git`       | Repositório Git inicializado    |
| `curl`      | Para chamadas à API             |
| `jq`        | Para processar JSON             |
| `bc`        | Para calcular o custo estimado  |

> O `install.sh` instala automaticamente `curl`, `jq` e `bc` usando o gerenciador de pacotes do sistema (`apt`, `dnf`, `yum`, `brew` ou `apk`).

## Instalação

```sh
curl -fsSL "https://raw.githubusercontent.com/pereirawe/git-review/refs/heads/main/install.sh" | sh
```

O instalador faz um `git clone` do repositório em `~/.local/share/git-review/`, cria um symlink em `~/.local/bin/git-review` e atualiza o `PATH` se necessário.

### Estrutura instalada

```
~/.local/
├── bin/
│   └── git-review          ← symlink para o script principal
└── share/
    └── git-review/         ← repositório clonado (clone do GitHub)
        ├── git-review
        ├── git-review-update
        ├── git-review-uninstall
        ├── install.sh
        ├── system_prompt.txt
        ├── git-review.conf         ← sua config (ignorada pelo git)
        ├── git-review.conf.example ← modelo de configuração
        ├── DESCRIPTION.md
        └── README.md
```

## Configuração

Copie o arquivo de exemplo e edite com suas chaves:

```sh
cp ~/.local/share/git-review/git-review.conf.example \
   ~/.local/share/git-review/git-review.conf

# edite com seu editor preferido:
nano ~/.local/share/git-review/git-review.conf
```

Ou exporte variáveis de ambiente no seu shell:

```sh
export API_PROVIDER=openai
export OPENAI_API_KEY="sk-..."
```

### Variáveis de ambiente

| Variável           | Padrão       | Descrição                              |
| ------------------ | ------------ | -------------------------------------- |
| `API_PROVIDER`     | `openai`     | Provedor de IA: `openai`, `gemini`, `claude` |
| `OPENAI_MODEL`     | `gpt-4.1`    | Modelo OpenAI                          |
| `GEMINI_MODEL`     | `gemini-1.5` | Modelo Gemini                          |
| `CLAUDE_MODEL`     | `claude-3.1` | Modelo Claude                          |
| `MAX_DIFF_LINES`   | `2000`       | Limite de linhas do diff               |
| `DESCRIPTION_FILE` | `DESCRIPTION.md` | Arquivo de descrição do projeto    |
| `GIT_REVIEW_CONFIG`| (automático) | Caminho alternativo para o config      |

## Uso

```sh
# Na branch de feature, detecta main/master automaticamente:
git-review

# Especificando a branch base manualmente:
git-review develop

# Ver a versão instalada:
git-review --version

# Ver ajuda:
git-review --help
```

## Exemplo de saída

```text
[review] Branch base:  main
[review] Branch atual: feat/minha-feature
[review] Modelo:       gpt-4.1
[review] Gerando diff a partir do merge-base...
[review] Diff gerado: 142 linhas
[review] Enviando para a API de IA...

════════════════════════════════════════════════════════
  Code Review: feat/minha-feature → main
════════════════════════════════════════════════════════

## 1. Resumo da Revisão
...

[review] Tokens — entrada: 1200 | saída: 450 | total: 1650
[review] Custo estimado: $0.00045 USD
[review] Revisão concluída.
```

## Atualização

```sh
git-review-update
```

Faz `git pull` no repositório instalado e exibe as versões anterior e atual.

## Desinstalação

```sh
git-review-uninstall
```

Remove `~/.local/share/git-review/` e o symlink em `~/.local/bin/git-review`.

## Versionamento

Usa Git tags no formato `vMAJOR.MINOR.PATCH` (Semantic Versioning).

## Licença

MIT © [pereirawe](https://github.com/pereirawe)
