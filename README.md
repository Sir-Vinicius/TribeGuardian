# Tribe Guardian (Love2D Prototype)

Protótipo roguelike top-down com foco em estrutura simples e separação de responsabilidades.

## Estrutura sugerida

```text
.
├── conf.lua
├── main.lua
└── src
    ├── entities
    │   └── player.lua
    └── systems
        ├── combat_system.lua
        └── enemy_system.lua
```

## Mecânicas implementadas

- Movimento do jogador (`WASD` ou setas).
- Ataque curto em direção do movimento (`ESPAÇO`) com cooldown.
- Spawn contínuo de inimigos nas bordas da tela.
- IA simples: inimigos perseguem o jogador.
- Dano por contato com invulnerabilidade curta.
- Contagem de abates e reinício da partida (`R`).

## Como integrar ao projeto existente

1. Copie os arquivos `main.lua`, `conf.lua` e pasta `src/` para o projeto Love2D.
2. Se já existir um `main.lua`, mantenha o ciclo principal (`love.load`, `love.update`, `love.draw`) e integre os módulos de `player`, `enemy_system` e `combat_system`.
3. Ajuste números de balanceamento direto nos módulos:
   - `src/entities/player.lua`: velocidade, vida, cooldown e alcance.
   - `src/systems/enemy_system.lua`: frequência e velocidade dos inimigos.
4. Rode com `love .`.
