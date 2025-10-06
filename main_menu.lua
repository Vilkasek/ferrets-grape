local state_machine = require("state_machine")
local level_manager = require("level_manager")
local player = require("player")
local tilemap = require("tilemap")
local decorations = require("decorations")
local camera = require("camera")

local main_menu = {
  background = "./assets/graphics/backgrounds/menu_background.png",
  idle_paths = {
    "./assets/graphics/menu/start_idle.png",
    "./assets/graphics/menu/continue_idle.png",
    "./assets/graphics/menu/options_idle.png",
  },
  active_paths = {
    "./assets/graphics/menu/start_active.png",
    "./assets/graphics/menu/continue_active.png",
    "./assets/graphics/menu/options_active.png",
  },

  idles = {},
  actives = {},

  activable = { "START", "CONTINUE", "OPTIONS" },
  active = 1,

  logos_paths = {
    "./assets/graphics/menu/shadow_logo.png",
    "./assets/graphics/menu/shadowless_logo.png",
  },
  logos = {},

  active_logo = 1,

  menusound = nil,
}

local function clamp_actives()
  if main_menu.active > #main_menu.activable then
    main_menu.active = 1
  elseif main_menu.active < 1 then
    main_menu.active = #main_menu.activable
  end
end

function main_menu.init(mn)
  main_menu.idles = {
    image.load(main_menu.idle_paths[1]),
    image.load(main_menu.idle_paths[2]),
    image.load(main_menu.idle_paths[3]),
  }

  main_menu.actives = {
    image.load(main_menu.active_paths[1]),
    image.load(main_menu.active_paths[2]),
    image.load(main_menu.active_paths[3]),
  }

  main_menu.logos = {
    image.load(main_menu.logos_paths[1]),
    image.load(main_menu.logos_paths[2]),
  }

  main_menu.menusound = mn
end

function main_menu.update()
  if buttons.released.down then
    main_menu.menusound:play(3)
    main_menu.active = main_menu.active + 1
    clamp_actives()
  end
  if buttons.released.up then
    main_menu.menusound:play(2)
    main_menu.active = main_menu.active - 1
    clamp_actives()
  end

  if buttons.released.cross and main_menu.active == 1 then
    main_menu.menusound:play(2)

    level_manager.load_level(0, player, tilemap, decorations, camera)
    level_manager.finished_levels = 0
    state_machine.change_state("ANIMATION")
  end

  if buttons.released.cross and main_menu.active == 2 then
    main_menu.menusound:play(2)
    level_manager.load_level(10, player, tilemap, decorations, camera)
    state_machine.change_state("GAME")
  end

  if buttons.released.cross and main_menu.active == 3 then
    main_menu.menusound:play(2)
    state_machine.change_state("OPTIONS")
  end

  if buttons.released.r then
    main_menu.active_logo = 1
  end

  if buttons.released.l then
    main_menu.active_logo = 2
  end
end

function main_menu.render()
  local ui_x = 480 / 2 - 48
  local logo_x = 480 / 2 - 120

  if main_menu.active == 1 then
    main_menu.actives[1]:blit(ui_x, 120)
    main_menu.idles[2]:blit(ui_x, 160)
    main_menu.idles[3]:blit(ui_x, 200)
  elseif main_menu.active == 2 then
    main_menu.idles[1]:blit(ui_x, 120)
    main_menu.actives[2]:blit(ui_x, 160)
    main_menu.idles[3]:blit(ui_x, 200)
  elseif main_menu.active == 3 then
    main_menu.idles[1]:blit(ui_x, 120)
    main_menu.idles[2]:blit(ui_x, 160)
    main_menu.actives[3]:blit(ui_x, 200)
  end

  main_menu.logos[main_menu.active_logo]:blit(logo_x, 0)
end

return main_menu
