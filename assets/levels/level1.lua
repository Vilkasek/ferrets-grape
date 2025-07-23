-- assets/levels/level1.lua

return {
  -- Mapa poziomu (0 = puste, 1-8 = różne kafelki, 9 = portal)
  map_data = {
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3 },
    { 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2 },
    { 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3 },
  },

  -- Pozycja startowa gracza na tym poziomie
  player_start_x = 100,
  player_start_y = 100,

  -- Portale w poziomie
  portals = {
    {
      -- Portal 1: prowadzi do level2
      x = 27 * 32,          -- pozycja x portalu
      y = 7 * 32,           -- pozycja y portalu
      width = 32,           -- szerokość portalu (opcjonalne)
      height = 32,          -- wysokość portalu (opcjonalne)
      target_level = "level2", -- nazwa docelowego poziomu
      target_x = 64,        -- gdzie ma się pojawić gracz na poziomie docelowym
      target_y = 160,       -- gdzie ma się pojawić gracz na poziomie docelowym
    },
  },

  background = "assets/graphics/backgrounds/level1.png",
  tileset = "assets/graphics/tilesets/level1.png",
}
