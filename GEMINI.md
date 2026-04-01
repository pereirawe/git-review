# Gemini Provider - git-review

## Variáveis de ambiente

- `GEMINI_API_KEY`: token de acesso Gemini (obrigatório)
- `GEMINI_MODEL`: Modelo Gemini (padrão: `gemini-1.5`)
- `API_PROVIDER`: deve ser `gemini`

## Exemplo de config

O arquivo de configuração fica em `~/.local/share/git-review/git-review.conf`
(ignorado pelo git, não vai para o repositório):

```sh
API_PROVIDER=gemini
GEMINI_API_KEY="YOUR_GEMINI_KEY"
GEMINI_MODEL="gemini-1.5"
```

## Observações

- O script usa o endpoint `https://gemini.googleapis.com/v1/models/${GEMINI_MODEL}:generateText`.
- O parâmetro de envio é `prompt`, concatenando o prompt de sistema + mensagem do usuário.
- Não há cálculo de custo estimado; use o painel do Google AI para métricas de uso.
