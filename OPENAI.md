# OpenAI Provider - git-review

## Variáveis de ambiente

- `OPENAI_API_KEY`: chave da API OpenAI (obrigatório)
- `OPENAI_MODEL`: Modelo OpenAI (padrão: `gpt-4.1`)
- `API_PROVIDER`: deve ser `openai`

## Exemplo de config

O arquivo de configuração fica em `~/.local/share/git-review/git-review.conf`
(ignorado pelo git, não vai para o repositório):

```sh
API_PROVIDER=openai
OPENAI_API_KEY="sk-..."
OPENAI_MODEL="gpt-4.1"
```

## Observações

- O script usa `https://api.openai.com/v1/chat/completions`.
- O custo é estimado localmente com base nos tokens retornados no response.
- Para alternar para outro provedor, basta mudar `API_PROVIDER` e definir a chave correspondente.
