local hud = {
  pos_x = 0,
  pos_y = 10,

  health_full_path = "./assets/graphics/hud/health_full.png",
  empty_path = "./assets/graphics/hud/empty.png",

  health_full = nil,
  empty = nil,
}

function hud.init()
  hud.health_full = image.load(hud.health_full_path)
  hud.empty = image.load(hud.empty_path)
end

function hud.render(player)
  for i = 1, 3 do
    if player.lives >= i then
      hud.health_full:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
    else
      hud.empty:blit(i * 32 + hud.pos_x - 22, hud.pos_y)
    end
  end
end

return hud
