local levels = require("levels.levels")
local portal = require("portal")
local enemy = require("enemy")

local level_manager = {
  background_paths = {
    "./assets/graphics/backgrounds/menu_background.png",
    "./assets/graphics/backgrounds/level1.png",
    "./assets/graphics/backgrounds/level2.png",
    "./assets/graphics/backgrounds/level3.png",
    "./assets/graphics/backgrounds/level4.png",
    "./assets/graphics/backgrounds/level5.png",
    "./assets/graphics/backgrounds/level6.png",
    "./assets/graphics/backgrounds/level7.png",
    "./assets/graphics/backgrounds/level8.png",
    "./assets/graphics/backgrounds/level9.png",
    "./assets/graphics/backgrounds/level10.png",
    "./assets/graphics/backgrounds/level11.png",
    "./assets/graphics/backgrounds/level0.png",
  },
  backgrounds = nil,
  current_background = nil,
  current_level_index = 1,
  finished_levels = 0,
  music = nil,
}

function level_manager.init(m)
  level_manager.backgrounds = {
    image.load(level_manager.background_paths[1]),
    image.load(level_manager.background_paths[2]),
    image.load(level_manager.background_paths[3]),
    image.load(level_manager.background_paths[4]),
    image.load(level_manager.background_paths[5]),
    image.load(level_manager.background_paths[6]),
    image.load(level_manager.background_paths[7]),
    image.load(level_manager.background_paths[8]),
    image.load(level_manager.background_paths[9]),
    image.load(level_manager.background_paths[10]),
    image.load(level_manager.background_paths[11]),
    image.load(level_manager.background_paths[12]),
    image.load(level_manager.background_paths[13]),
  }
  level_manager.music = m
end

function level_manager.load_level(level_index, player, tilemap, decorations, camera)
  enemy.clear()

  local level_config = levels[level_index]
  if not level_config then
    portal.despawn()
    return
  end

  package.loaded[level_config.map_data_path] = nil
  package.loaded[level_config.deco_data_path] = nil

  local mapdata = require(level_config.map_data_path)
  local decodata = require(level_config.deco_data_path)

  tilemap.init(level_config.tileset_path, mapdata)
  decorations.init(level_config.deco_tileset_path, decodata)

  level_manager.current_background = level_manager.backgrounds[level_config.background_index]

  player.pos_x = level_config.start_pos.x
  player.pos_y = level_config.start_pos.y
  player.vel_x = 0
  player.vel_y = 0

  camera.x = 0
  camera.y = 0
  camera.update(player, tilemap)

  level_manager.current_level_index = level_index

  if level_config.portal_pos then
    portal.spawn(level_config.portal_pos.x, level_config.portal_pos.y)
  else
    portal.despawn()
  end

  if level_config.enemy_data_path then
    package.loaded[level_config.enemy_data_path] = nil
    local enemy_data = require(level_config.enemy_data_path)

    if enemy_data then
      for row = 1, #enemy_data do
        for col = 1, #enemy_data[row] do
          local enemy_type = enemy_data[row][col]

          if enemy_type == 0 then
            local x = (col - 1) * 32
            local y = (row - 1) * 32
            enemy.spawn(x, y, math.random(2), math.random(32, 128))
          elseif enemy_type > 0 then
            local x = (col - 1) * 32
            local y = (row - 1) * 32
            enemy.spawn(x, y, math.random(2), math.random(128))
          end
        end
      end
    end
  end
end

function level_manager.check_level_transition(player, tilemap, decorations, camera, state_machine, animation_module)
  if not portal.is_active then
    return
  end

  local player_rect = { x = player.pos_x, y = player.pos_y, w = player.width, h = player.height }
  local portal_rect = { x = portal.pos_x, y = portal.pos_y, w = portal.width, h = portal.height }

  if
      player_rect.x < portal_rect.x + portal_rect.w
      and player_rect.x + player_rect.w > portal_rect.x
      and player_rect.y < portal_rect.y + portal_rect.h
      and player_rect.y + player_rect.h > portal_rect.y
  then
    level_manager.finished_levels = level_manager.finished_levels + 1

    if level_manager.current_level_index == 6 then
      animation_module.cleanup()
      animation_module.init("second", level_manager.music)
      state_machine.change_state("ANIMATION")
      return
    end

    local next_level = level_manager.current_level_index + 1
    if levels[next_level] then
      level_manager.load_level(next_level, player, tilemap, decorations, camera)
    else
      level_manager.finished_levels = 1
      state_machine.change_state("MENU")
    end
  end
end

function level_manager.get_current_background()
  return level_manager.current_background
end

return level_manager
