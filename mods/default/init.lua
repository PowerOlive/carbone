-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

default = {} -- Definitions made by this mod are usable by all mods.

-- The API documentation in here was moved into doc/lua_api.txt.

WATER_ALPHA = 160
WATER_VISC = 1
LAVA_VISC = 7     -- Slower movement in lava.
LIGHT_MAX = 14    -- 15 is reserved for sunlight.

-- GUI related stuff:

gui_slots = "listcolors[#606060AA;#808080;#101010;#202020;#FFF]"

function default.get_hotbar_bg(x,y)
	local out = ""
	for i= 0, 7, 1 do
		out = out .."image[" .. x + i .. "," .. y .. ";1,1;gui_hb_bg.png]"
	end
	return out
end

gui_suvival_form = "size[8,8.5]"..
			gui_slots ..
			"list[current_player;main;         0,    4.25; 8, 1;  ]" ..
			"list[current_player;main;         0,    5.5;  8, 3; 8]" ..
			"list[current_player;craft;        1.75, 0.5;  3, 3;  ]" ..
			"list[current_player;craftpreview; 5.75, 1.5;  1, 1;  ]" ..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]" ..
			default.get_hotbar_bg(0, 4.25)

-- Load files:

dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/commands.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/trees.lua")
dofile(minetest.get_modpath("default").."/aliases.lua")

-- Code below by Casimir.

local function count_items()
	local i = 0
	local number = 0
	for name, item in pairs(minetest.registered_items) do
		if (name and name ~= "") then
			number = number + 1
		end
		i = i + 1
	end
	print("There are " .. number .. " registered nodes, items and tools.")
end

local function player_join_sounds()
	minetest.register_on_joinplayer(function()
		minetest.sound_play("player_join", {gain = 0.75})
	end)
end

local function player_leave_sounds()
	minetest.register_on_leaveplayer(function()
		minetest.sound_play("player_leave", {gain = 1})
	end)
end

minetest.after(1, count_items)
minetest.after(5, player_join_sounds)
minetest.after(5, player_leave_sounds)

minetest.register_on_joinplayer(function(player)
	player:set_physics_override({
    sneak_glitch = false, -- Climable blocks are quite fast in Carbone.
  })
end)

minetest.register_on_respawnplayer(function(player)
	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	local pos = player:getpos()
	minetest.sound_play("player_join", {pos = pos, gain = 5})
end)
