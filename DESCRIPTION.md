# AI-powered code review no terminal

`git-review` leva seu `git diff` diretamente para APIs de IA (OpenAI, Gemini ou Claude) e retorna uma revisão estruturada feita por um Tech Lead sênior.

## Como funciona

O script compara sua branch atual com a branch base (`main` ou `master`), gera o diff e envia para a API configurada.
O modelo analisa as mudanças e devolve:

- **Resumo** do que foi alterado
- **Comentários** de melhoria com sugestão de código, arquivo/linha e justificativa
- **Pontos fortes** e **pontos de atenção** da MR

## Pré-requisitos

| Dependência | Descrição                             |
| ----------- | ------------------------------------- |
| `git`       | Repositório Git inicializado          |
| `curl`      | Para chamadas à API e downloads       |
| `jq`        | Para processar JSON                   |
| `bc`        | Para calcular o custo estimado        |
| `gh`        | CLI do GitHub para comentários em PRs |
| `glab`      | CLI do GitLab para comentários em MRs |

> O `install.sh` instala automaticamente `curl`, `jq`, `bc`, `gh` e `glab` usando o gerenciador de pacotes do sistema (`apt`, `dnf`, `yum`, `brew` ou `apk`).

## Instalação

```sh
curl -fsSL "https://gitlab.com/-/snippets/5965695/raw/main/install.sh?$(date +%s)" | sh
```

O script instala dependências, baixa os comandos em `~/.local/bin`, define permissão executável e atualiza o `PATH` se necessário.

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
[review] Modelo:       gpt-4o-mini
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

## Configuração

Edite `~/.git-review/config` ou defina variáveis de ambiente:

```sh
export API_PROVIDER=openai
export OPENAI_API_KEY="sk-..."
# ou para Gemini
export GEMINI_API_KEY="..."
# ou para Claude
export CLAUDE_API_KEY="..."
```

### Variáveis de ambiente opcionais

| Variável           | Padrão           | Descrição                        |
| ------------------ | ---------------- | -------------------------------- | ------ | ------ |
| `API_PROVIDER`     | `openai`         | Provedor de IA: openai           | gemini | claude |
| `OPENAI_MODEL`     | `gpt-4.1`        | Modelo OpenAI                    |
| `GEMINI_MODEL`     | `gemini-1.5`     | Modelo Gemini                    |
| `CLAUDE_MODEL`     | `claude-3.1`     | Modelo Claude                    |
| `MAX_DIFF_LINES`   | `2000`           | Limite de linhas do diff         |
| `DESCRIPTION_FILE` | `DESCRIPTION.md` | Arquivo de descrição versionável |

## Atualização

```sh
git-review --update
```

Atualiza os scripts localmente apenas se houver versão mais recente.

## Desinstalação

```sh
git-review --uninstall
```

Remove instalações de `~/.local/bin`.

## Versionamento

Usa Semantic Versioning (`MAJOR.MINOR.PATCH`).

## Estrutura do projeto

```
review/
├── git-review
├── git-review-update
├── git-review-uninstall
├── install.sh
├── system_prompt.txt
├── git-review.conf.example
├── DESCRIPTION.md
└── README.md
```

## Licença

MIT © [williampereira](https://gitlab.com/williampereira)
