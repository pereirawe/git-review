# Gemini Provider - git-review

## Variáveis de ambiente

- GEMINI_API_KEY: token de acesso Gemini (obrigatório)
- GEMINI_MODEL: Modelo Gemini (padrão: gemini-1.5)
- API_PROVIDER=gemini

## Exemplo ~/.git-review/config

GEMINI_API_KEY="YOUR_GEMINI_KEY"
GEMINI_MODEL="gemini-1.5"
API_PROVIDER=gemini

## Observações

- O script usa endpoint `https://gemini.googleapis.com/v1/models/${GEMINI_MODEL}:generateText`.
- O nome do parâmetro `prompt` é o texto concatenado de sistema + usuário.
- Não há cálculo de custo estimado no script, ajustável para métricas do provedor.
