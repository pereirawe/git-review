# Claude Provider - git-review

## Variáveis de ambiente

- `CLAUDE_API_KEY`: chave Anthropic (obrigatório)
- `CLAUDE_MODEL`: Modelo Claude (padrão: `claude-3.1`)
- `API_PROVIDER`: deve ser `claude`

## Exemplo de config

O arquivo de configuração fica em `~/.local/share/git-review/git-review.conf`
(ignorado pelo git, não vai para o repositório):

```sh
API_PROVIDER=claude
CLAUDE_API_KEY="YOUR_CLAUDE_KEY"
CLAUDE_MODEL="claude-3.1"
```

## Observações

- O script usa o endpoint `https://api.anthropic.com/v1/complete`.
- O prompt é formatado com as seções `System`, `User` e `Assistant`.
- Não há cálculo de custo estimado; use o painel da Anthropic para métricas de faturamento.
