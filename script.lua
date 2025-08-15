local player = require("player")
local tilemap = require("tilemap")
local camera = require("camera")

local mapdata = require("levels.level1")

local background_paths = {
  "./assets/graphics/backgrounds/menu_background.png",
  "./assets/graphics/backgrounds/level1.png",
  "./assets/graphics/backgrounds/level2.png",
}

local backgrounds = {
  image.load(background_paths[1]),
  image.load(background_paths[2]),
  image.load(background_paths[3]),
}

local idle_paths = {
  "./assets/graphics/menu/start_idle.png",
  "./assets/graphics/menu/continue_idle.png",
  "./assets/graphics/menu/options_idle.png",
}

local active_paths = {
  "./assets/graphics/menu/start_active.png",
  "./assets/graphics/menu/continue_active.png",
  "./assets/graphics/menu/options_active.png"
}

local idles = {
  image.load(idle_paths[1]),
  image.load(idle_paths[2]),
  image.load(idle_paths[3]),
}

local actives = {
  image.load(active_paths[1]),
  image.load(active_paths[2]),
  image.load(active_paths[3]),
}

player.init()
tilemap.init("./assets/graphics/tilesets/level1.png", mapdata)

local state = "MENU"
local activable = {
  "START",
  "CONTINUE",
  "OPTIONS",
}
local active = 1

local function clamp_actives()
  if active > #activable then
    active = 1
  elseif active < 1 then
    active = #activable
  end
end

local function update_menu()
   if buttons.released.down then
      active = active + 1
      clamp_actives()
   end

   if buttons.released.up then
      active = active - 1
      clamp_actives()
   end

   if buttons.released.cross and (active == 1 or active == 2) then
    state = "GAME"
   end
end

local ui_x = 200

local function render_menu()
  if active == 1 then
    actives[1]:blit(ui_x, 100)
    idles[2]:blit(ui_x, 150)
    idles[3]:blit(ui_x, 200)
  elseif active == 2 then
    idles[1]:blit(ui_x, 100)
    actives[2]:blit(ui_x, 150)
    idles[3]:blit(ui_x, 200)
  elseif active == 3 then
    idles[1]:blit(ui_x, 100)
    idles[2]:blit(ui_x, 150)
    actives[3]:blit(ui_x, 200)
  end
end

local function update()
  buttons.read()

  update_menu()

  if state == "MENU" then
     if buttons.released.r then
        state = "GAME"
     end
  elseif state == "GAME" then
    player.update()
    camera.update(player, tilemap)
  end
end

local function render()
  if state == "MENU" then
    image.blit(backgrounds[1], 0, 0)

    render_menu()
  elseif state == "GAME" then
    image.blit(backgrounds[2], 0, 0)

    tilemap.render()
    player.render()
  end

  screen.flip()
end

while true do
  update()
  render()
end
