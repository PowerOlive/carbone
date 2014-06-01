dofile(minetest.get_modpath("mobs").."/api.lua")

mobs:register_mob("mobs:dirt_monster", {
	type = "monster",
	hp_max = 25,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	textures = {"mobs_dirt_monster.png"},
	visual_size = {x=3, y=2.6},
	makes_footstep_sound = true,
	view_range = 12,
	walk_velocity = 1,
	run_velocity = 3,
	on_rightclick = nil,
	damage = 4,
	drops = {
		name = "default:dirt",
		chance = 1,
		min = 4,
		max = 4,
		{name = "maptools:silver_coin",
		chance = 1,
		min = 2,
		max = 2,},
	},
	armor = 100,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 1,
	attack_type = "dogfight",
	animation = {
		speed_normal = 17,
		speed_run = 60,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
})

mobs:register_mob("mobs:stone_monster", {
	type = "monster",
	hp_max = 30,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	textures = {"mobs_stone_monster.png"},
	visual_size = {x=3, y=2.6},
	makes_footstep_sound = true,
	view_range = 16,
	walk_velocity = 0.25,
	run_velocity = 2,
	damage = 6,
	drops = {
		{name = "default:stone",
		chance = 1,
		min = 4,
		max = 4,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 3,
		max = 3,},
	},
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 1,
	attack_type = "dogfight",
	animation = {
		speed_normal = 7,
		speed_run = 45,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})

mobs:register_mob("mobs:sand_monster", {
	type = "monster",
	hp_max = 15,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_sand_monster.x",
	textures = {"mobs_sand_monster.png"},
	visual_size = {x=8,y=8},
	makes_footstep_sound = true,
	view_range = 20,
	walk_velocity = 2.125,
	run_velocity = 4,
	damage = 2,
	drops = {
		{name = "default:sand",
		chance = 1,
		min = 4,
		max = 4,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 3,
		max = 3,},
	},
	armor = 100,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 1,
	attack_type = "dogfight",
	animation = {
		speed_normal = 35,
		speed_run = 50,
		stand_start = 0,
		stand_end = 39,
		walk_start = 41,
		walk_end = 72,
		run_start = 74,
		run_end = 105,
		punch_start = 74,
		punch_end = 105,
	},
})

mobs:register_mob("mobs:sheep", {
	type = "animal",
	hp_max = 15,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_sheep.png"},
	visual = "mesh",
	mesh = "mobs_sheep.x",
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1,
		min = 2,
		max = 2,},
		{name = "maptools:copper_coin",
		chance = 1,
		min = 5,
		max = 5,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 0,
	animation = {
		speed_normal = 17,
		stand_start = 0,
		stand_end = 80,
		walk_start = 81,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 6,
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "farming:wheat" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.tamed = true
			elseif self.naked then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.food = (self.food or 0) + 1
				if self.food >= 8 then
					self.food = 0
					self.naked = false
					self.object:set_properties({
						textures = {"mobs_sheep.png"},
						mesh = "mobs_sheep.x",
					})
				end
			end
			return
		end
		if clicker:get_inventory() and not self.naked then
			self.naked = true
			if minetest.registered_items["wool:white"] then
				clicker:get_inventory():add_item("main", ItemStack("wool:white 2"))
			end
			self.object:set_properties({
				textures = {"mobs_sheep_shaved.png"},
				mesh = "mobs_sheep_shaved.x",
			})
		end
	end,
})

minetest.register_craftitem("mobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
})

minetest.register_craftitem("mobs:meat", {
	description = "Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(7),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 25,
})

mobs:register_mob("mobs:rat", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.25, -0.01, -0.25, 0.25, 0.35, 0.25},
	visual = "mesh",
	mesh = "mobs_rat.x",
	textures = {"mobs_rat.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "mobs:rat",
		chance = 1,
		min = 1,
		max = 1,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 0,
	follow = "default:scorched_stuff",
	view_range = 4,
})

minetest.register_craftitem("mobs:rat", {
	description = "Rat",
	inventory_image = "mobs_rat_inventory.png",
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.add_entity(pointed_thing.above, "mobs:rat")
			itemstack:take_item()
		end
		return itemstack
	end,
})
	
minetest.register_craftitem("mobs:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_cooked_rat.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:rat_cooked",
	recipe = "mobs:rat",
	cooktime = 15,
})

minetest.register_craft({
	type = "cooking",
	output = "default:scorched_stuff",
	recipe = "mobs:rat",
	cooktime = 15,
})

mobs:register_mob("mobs:oerkki", {
	type = "monster",
	hp_max = 45,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_oerkki.x",
	textures = {"mobs_oerkki.png"},
	visual_size = {x=5, y=5},
	makes_footstep_sound = false,
	view_range = 16,
	walk_velocity = 0.5,
	run_velocity = 3.25,
	damage = 5,
	drops = {
		{name = "default:obsidian",
		chance = 1,
		min = 4,
		max = 4,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 5,
		max = 5,},
	},
	armor = 100,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 1,
	attack_type = "dogfight",
	animation = {
		stand_start = 0,
		stand_end = 23,
		walk_start = 24,
		walk_end = 36,
		run_start = 37,
		run_end = 49,
		punch_start = 37,
		punch_end = 49,
		speed_normal = 10,
		speed_run = 20,
	},
})

mobs:register_mob("mobs:tree_monster", {
	type = "monster",
	hp_max = 60,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_tree_monster.x",
	textures = {"mobs_tree_monster.png"},
	visual_size = {x=4.5,y=4.5},
	makes_footstep_sound = true,
	view_range = 32,
	walk_velocity = 0,
	run_velocity = 1.6,
	damage = 6,
	drops = {
		{name = "default:sapling",
		chance = 1,
		min = 4,
		max = 4,},
		{name = "default:junglesapling",
		chance = 1,
		min = 4,
		max = 4,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 6,
		max = 6,},
	},
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 8,
	light_damage = 1,
	disable_fall_damage = true,
	attack_type = "dogfight",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 24,
		walk_start = 25,
		walk_end = 47,
		run_start = 48,
		run_end = 62,
		punch_start = 48,
		punch_end = 62,
	},
})

mobs:register_mob("mobs:dungeon_master", {
	type = "monster",
	hp_max = 55,
	collisionbox = {-0.7, -0.01, -0.7, 0.7, 2.6, 0.7},
	visual = "mesh",
	mesh = "mobs_dungeon_master.x",
	textures = {"mobs_dungeon_master.png"},
	visual_size = {x=8, y=8},
	makes_footstep_sound = true,
	view_range = 12,
	walk_velocity = 0.15,
	run_velocity = 2,
	damage = 4,
	drops = {
		{name = "default:mese_crystal",
		chance = 1,
		min = 1,
		max = 1,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 8,
		max = 8,},
	},
	armor = 60,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 200,
	on_rightclick = nil,
	attack_type = "shoot",
	arrow = "mobs:fireball",
	shoot_interval = 2.5,
	sounds = {
		attack = "mobs_fireball",
	},
	animation = {
		stand_start = 0,
		stand_end = 19,
		walk_start = 20,
		walk_end = 35,
		punch_start = 36,
		punch_end = 48,
		speed_normal = 5,
		speed_run = 5,
	},
})

mobs:register_arrow("mobs:fireball", {
	visual = "sprite",
	visual_size = {x=1, y=1},
	--textures = {{name="mobs_fireball.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}}, FIXME
	textures = {"mobs_fireball.png"},
	velocity = 10,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=12},
		}, vec)
		local pos = self.object:getpos()
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.get_node(pos).name
					if n ~= "bedrock:bedrock" and n ~= "default:chest_locked" and n ~= "bones:bones" and n ~= "default:chest" and n ~= "default:furnace" then
						minetest.dig_node(p)
					end
						minetest.sound_play("mobs_fireball_explode", {pos = s, gain = 0.1, max_hear_distance = 48})
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.get_node(pos).name
					if n ~= "bedrock:bedrock" and n ~= "default:chest_locked" and n ~= "bones:bones" and n ~= "default:chest" and n ~= "default:furnace" then
						minetest.dig_node(p)
					end
						minetest.sound_play("mobs_fireball_explode", {pos = p, gain = 0.1, max_hear_distance = 48})
				end
			end
		end
	end
})

mobs:register_mob("mobs:rhino", {
	type = "monster",
	hp_max = 25,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_sand_monster.x",
	textures = {"mobs_rhino.png"},
	visual_size = {x=8, y=8},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 1,
	run_velocity = 2.5,
	damage = 4,
	drops = {
		{name = "default:steel_ingot",
		chance = 1,
		min = 10,
		max = 10,},
		{name = "maptools:silver_coin",
		chance = 1,
		min = 12,
		max = 12,},
	},
	armor = 60,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 8,
	light_damage = 1,
	on_rightclick = nil,
	attack_type = "shoot",
	arrow = "mobs:bullet",
	shoot_interval = 0.5,
	sounds = {
		attack = "mobs_bullet",
	},
	animation = {
		speed_normal = 20,
		speed_run = 45,
		stand_start = 0,
		stand_end = 39,
		walk_start = 41,
		walk_end = 72,
		run_start = 74,
		run_end = 105,
		punch_start = 74,
		punch_end = 105,
	},
})

mobs:register_arrow("mobs:bullet", {
	visual = "sprite",
	visual_size = {x=0.75, y=0.75},
	textures = {"mobs_bullet.png"},
	velocity = 30,
	hit_player = function(self, player)
		local s = self.object:getpos()
		local p = player:getpos()
		local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
		player:punch(self.object, 1.0,  {
			full_punch_interval=1.0,
			damage_groups = {fleshy=3},
		}, vec)
		local pos = self.object:getpos()
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.get_node(pos).name
				end
			end
		end
	end,
	hit_node = function(self, pos, node)
		for dx=-1,1 do
			for dy=-2,1 do
				for dz=-1,1 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.get_node(pos).name
				end
			end
		end
	end
})

if not minetest.setting_getbool("creative_mode") then
	if minetest.setting_getbool("friendly_mobs") ~= false then -- “If not defined or set to true then”
		mobs:register_spawn("mobs:rat", {"default:stone", "default:leaves", "default:jungleleaves", "default:cactus"}, 20, -1, 18000, 4, 31000)
		mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass"},                  20, 8, 140000, 2, 31000)
	end
	if minetest.setting_getbool("hostile_mobs") ~= false then -- “If not defined or set to true then”
		mobs:register_spawn("mobs:dirt_monster", {"default:dirt", "default:stone"}, 1, -1, 130000, 2, -15)
		mobs:register_spawn("mobs:stone_monster", {"default:stone"},                1, -1, 140000, 2, -15)
		mobs:register_spawn("mobs:sand_monster", {"default:stone"},                 1, -1, 150000, 1, -15)
		mobs:register_spawn("mobs:oerkki", {"default:stone"},                       1, -1, 140000, 2, -30)
		mobs:register_spawn("mobs:tree_monster", {"default:stone"},                 1, -1, 160000, 1, -30)
		mobs:register_spawn("mobs:dungeon_master", {"default:stone"},               1, -1, 150000, 1, -60)
		mobs:register_spawn("mobs:rhino", {"default:stone"},                        1, -1, 170000, 1, -60)
	end
end

if minetest.setting_get("log_mods") then
	minetest.log("action", "[mobs] loaded.")
end
