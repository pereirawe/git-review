# Claude Provider - git-review

## Variáveis de ambiente

- CLAUDE_API_KEY: chave Anthropic (obrigatório)
- CLAUDE_MODEL: Modelo Claude (padrão: claude-3.1)
- API_PROVIDER=claude

## Exemplo ~/.git-review/config

CLAUDE_API_KEY="YOUR_CLAUDE_KEY"
CLAUDE_MODEL="claude-3.1"
API_PROVIDER=claude

## Observações

- O script usa endpoint `https://api.anthropic.com/v1/complete`.
- A variável `prompt` é formatada com `System`, `User`, `Assistant`.
- Não há cálculo de custo estimado no script; use métricas do Anthropic para faturamento.
