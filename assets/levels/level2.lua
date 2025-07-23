-- assets/levels/level2.lua

return {
  -- Mapa drugiego poziomu - bardziej skomplikowana
  map_data = {
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 8, 0, 0, 0, 7, 8, 0, 3 },
    { 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 3, 1, 1, 1, 3, 3, 1, 3 },
  },

  -- Gracz zaczyna po lewej stronie
  player_start_x = 64,
  player_start_y = 150,

  portals = {
    {
      -- Portal 1: prowadzi do level2
      x = 26 * 32,          -- pozycja x portalu
      y = 6 * 32,           -- pozycja y portalu
      width = 32,           -- szerokość portalu (opcjonalne)
      height = 32,          -- wysokość portalu (opcjonalne)
      target_level = "level1", -- nazwa docelowego poziomu
      target_x = 64,        -- gdzie ma się pojawić gracz na poziomie docelowym
      target_y = 160,       -- gdzie ma się pojawić gracz na poziomie docelowym
    },
  },

  -- Inne tło dla drugiego poziomu (opcjonalne)
  background = "assets/graphics/backgrounds/level2.png",
  tileset = "assets/graphics/tilesets/level2.png",
}
