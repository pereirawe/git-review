# OpenAI Provider - git-review

## Variáveis de ambiente

- OPENAI_API_KEY: chave da API OpenAI (obrigatório)
- OPENAI_MODEL: Modelo OpenAI (padrão: gpt-4.1)

## Exemplo ~/.git-review/config

OPENAI_API_KEY="sk-..."
OPENAI_MODEL="gpt-4.1"
API_PROVIDER=openai

## Observações

- O script usa `https://api.openai.com/v1/chat/completions`.
- O custo é estimado localmente com tokens retornados no response.
- Para ativar outras providers, defina `API_PROVIDER` e as chaves adequadas (gemini, claude).
