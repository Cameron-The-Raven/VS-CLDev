/// Away Missions
#ifdef AWAY_MISSION_TEST
#include "../expedition_vr/beach/beach.dmm"
#include "../expedition_vr/beach/cave.dmm"
#include "../expedition_vr/alienship/alienship.dmm"
#include "../expedition_vr/aerostat/aerostat.dmm"
#include "../expedition_vr/aerostat/surface.dmm"
#include "../expedition_vr/space/debrisfield.dmm"
#include "../expedition_vr/space/fueldepot.dmm"
#endif

#include "../expedition_vr/beach/_beach.dm"
/datum/map_template/common_lateload/away_beach
	name = Z_NAME_BEACH
	desc = "The beach away mission."
	mappath = "maps/expedition_vr/beach/beach.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_beach

/datum/map_z_level/common_lateload/away_beach
	name = "Away Mission - Desert Beach"
	//z = Z_NAME_BEACH
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/common_lateload/away_beach_cave
	name = Z_NAME_BEACH_CAVE
	desc = "The beach away mission's cave."
	mappath = "maps/expedition_vr/beach/cave.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_beach_cave

/datum/map_template/common_lateload/away_beach_cave/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 120, /area/tether_away/cave/unexplored/normal, /datum/map_template/surface/mountains/normal)
	//seed_submaps(list(z), 70, /area/tether_away/cave/unexplored/normal, /datum/map_template/surface/mountains/deep)

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, z, 64, 64)

/datum/map_z_level/common_lateload/away_beach_cave
	name = "Away Mission - Desert Cave"
	//z = Z_NAME_BEACH_CAVE
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z


#include "../expedition_vr/alienship/_alienship.dm"
/datum/map_template/common_lateload/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	mappath = "maps/expedition_vr/alienship/alienship.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_alienship

/datum/map_z_level/common_lateload/away_alienship
	name = "Away Mission - Alien Ship"

/datum/map_z_level/common_lateload/away_aerostat
	name = "Away Mission - Aerostat"
	//z = Z_NAME_AEROSTAT
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky

/datum/map_template/common_lateload/away_aerostat_surface
	name = Z_NAME_AEROSTAT_SURFACE
	desc = "The surface from the Virgo 2 Aerostat."
	mappath = "maps/expedition_vr/aerostat/surface.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_aerostat_surface

/datum/map_template/virgo2
	name = "Surface Content - Virgo 2"
	desc = "For seeding submaps on Virgo 2"
	allow_duplicates = FALSE

/datum/random_map/noise/ore/virgo2
	descriptor = "virgo 2 ore distribution map"
	deep_val = 0.2
	rare_val = 0.1

/datum/map_template/common_lateload/away_aerostat_surface/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 120, /area/offmap/aerostat/surface/unexplored, /datum/map_template/virgo2)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/virgo2(null, 1, 1, z, 64, 64)

/datum/map_z_level/common_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"
	//z = Z_NAME_AEROSTAT_SURFACE
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2


#include "../expedition_vr/space/_debrisfield.dm"
#include "../expedition_vr/space/_fueldepot.dm"
#include "../submaps/pois_vr/debris_field/_templates.dm"
#include "../submaps/pois_vr/debris_field/debrisfield_things.dm"
/datum/map_template/common_lateload/away_debrisfield
	name = Z_NAME_DEBRISFIELD
	desc = "The Virgo 3 Debris Field away mission."
	mappath = "maps/expedition_vr/space/debrisfield.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_debrisfield

/datum/map_template/common_lateload/away_debrisfield/on_map_loaded(z)
	. = ..()
	//Commented out until we actually get POIs
	seed_submaps(list(z), 400, /area/space, /datum/map_template/debrisfield)

/datum/map_z_level/common_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	//z = Z_NAME_DEBRISFIELD

/datum/map_template/common_lateload/away_fueldepot
	name = Z_NAME_FUELDEPOT
	desc = "An unmanned fuel depot floating in space."
	mappath = "maps/expedition_vr/space/fueldepot.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/away_fueldepot

/datum/map_z_level/common_lateload/away_fueldepot
	name = "Away Mission - Fuel Depot"
	//z = Z_NAME_FUELDEPOT

//////////////////////////////////////////////////////////////////////////////////////
// Gateway submaps go here

/obj/effect/overmap/visitable/sector/common_gateway
	name = "Unknown"
	desc = "Approach and perform a scan to obtain further information."
	icon_state = "object" //or "globe" for planetary stuff
	known = FALSE

/datum/map_template/common_lateload/gateway
	name = "Gateway Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = /datum/map_z_level/common_lateload/gateway_destination
	name_alias = Z_NAME_ALIAS_GATEWAY

/datum/map_z_level/common_lateload/gateway_destination
	name = "Gateway Destination"
	//z = Z_NAME_ALIAS_GATEWAY
/*			// Removed due to heavy merc presence
#include "../gateway_vr/snow_outpost.dm"
/datum/map_template/common_lateload/gateway/snow_outpost
	name = "Snow Outpost"
	desc = "Big snowy area with various outposts."
	mappath = "maps/gateway_vr/snow_outpost.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/gateway_destination
*/
#include "../gateway_vr/zoo.dm"
/datum/map_template/common_lateload/gateway/zoo
	name = "Gateway - Zoo"
	desc = "Gigantic space zoo"
	mappath = "maps/gateway_vr/zoo_b.dmm"

#include "../gateway_vr/carpfarm.dm"
/datum/map_template/common_lateload/gateway/carpfarm
	name = Z_NAME_GATEWAY_CARP_FARM
	desc = "Asteroid base surrounded by carp"
	mappath = "maps/gateway_vr/carpfarm.dmm"

#include "../gateway_vr/snowfield.dm"
/datum/map_template/common_lateload/gateway/snowfield
	name = Z_NAME_GATEWAY_SNOW_FIELD
	desc = "An old base in middle of snowy wasteland"
	mappath = "maps/gateway_vr/snowfield.dmm"

#include "../gateway_vr/listeningpost.dm"
/datum/map_template/common_lateload/gateway/listeningpost
	name = Z_NAME_GATEWAY_LISTENING_POST
	desc = "Asteroid-bound mercenary listening post"
	mappath = "maps/gateway_vr/listeningpost.dmm"

#include "../gateway_vr/variable/honlethhighlands.dm"
/datum/map_template/common_lateload/gateway/honlethhighlands_a
	name = Z_NAME_GATEWAY_HONLETH_A
	desc = "The cold surface of some planet."
	mappath = "maps/gateway_vr/variable/honlethhighlands_a.dmm"

/datum/map_template/common_lateload/gateway/honlethhighlands_b
	name = Z_NAME_GATEWAY_HONLETH_B
	desc = "The cold surface of some planet."
	mappath = "maps/gateway_vr/variable/honlethhighlands_b.dmm"


#include "../gateway_vr/variable/arynthilake.dm"
/datum/map_template/common_lateload/gateway/arynthilake
	name = Z_NAME_GATEWAY_ARYNTHI_A
	desc = "A grassy surface with some abandoned structures."
	mappath = "maps/gateway_vr/variable/arynthilake_a.dmm"

/datum/map_template/common_lateload/gateway/arynthilakeunderground
	name = Z_NAME_GATEWAY_ARYNTHI_CAVE_A
	desc = "A grassy surface with some abandoned structures."
	mappath = "maps/gateway_vr/variable/arynthilakeunderground_a.dmm"

/datum/map_template/common_lateload/gateway/arynthilake_b
	name = Z_NAME_GATEWAY_ARYNTHI_B
	desc = "A grassy surface with some abandoned structures."
	mappath = "maps/gateway_vr/variable/arynthilake_b.dmm"

/datum/map_template/common_lateload/gateway/arynthilakeunderground_b
	name = Z_NAME_GATEWAY_ARYNTHI_CAVE_B
	desc = "A grassy surface with some abandoned structures."
	mappath = "maps/gateway_vr/variable/arynthilakeunderground_b.dmm"

#include "../gateway_vr/wildwest.dm"
/datum/map_template/common_lateload/gateway/wildwest
	name = Z_NAME_GATEWAY_WILD_WEST
	desc = "A classic."
	mappath = "maps/gateway_vr/wildwest.dmm"

#include "../gateway_vr/lucky_7.dm"

/////////////////////////////////////////////////////////////////////////////////////

/datum/map_template/common_lateload/om_adventure
	name = "OM Adventure Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null
	name_alias = Z_NAME_ALIAS_OM_ADVENTURE

/datum/map_z_level/common_lateload/om_adventure_destination
	name = "OM Adventure Destination"
	//z = Z_NAME_ALIAS_OM_ADVENTURE

#include "../om_adventure/grasscave.dm"
/datum/map_template/common_lateload/om_adventure/grasscave
	name = Z_NAME_OM_GRASS_CAVE
	desc = "Looks like a cave with some grass in it."
	mappath = "maps/om_adventure/grasscave.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/om_adventure_destination

/datum/map_template/common_lateload/om_adventure/grasscave/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 60, /area/om_adventure/grasscave/unexplored, /datum/map_template/om_adventure/outdoor)
	seed_submaps(list(z), 60, /area/om_adventure/grasscave/rocks, /datum/map_template/om_adventure/cave)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/grasscave(null, 1, 1, z, 64, 64)

//////////////////////////////////////////////////////////////////////////////////////

#ifdef AWAY_MISSION_TEST
#include "../redgate/falls/falls.dmm"
#include "../redgate/abandonedisland.dmm"
#include "../redgate/cybercity.dmm"
#include "../redgate/darkadventure.dmm"
#include "../redgate/eggnogtown.dmm"
#include "../redgate/eggnogtownunderground.dmm"
#include "../redgate/facility.dmm"
#include "../redgate/fantasy_dungeon.dmm"
#include "../redgate/fantasy.dmm"
#include "../redgate/hotsprings.dmm"
#include "../redgate/innland.dmm"
#include "../redgate/islands_underwater.dmm"
#include "../redgate/islands.dmm"
#include "../redgate/jungle_underground.dmm"
#include "../redgate/jungle.dmm"
#include "../redgate/laserdome.dmm"
#include "../redgate/stardog.dmm"
#include "../redgate/teppiranch.dmm"
#include "../redgate/train_upper.dmm"
#include "../redgate/train.dmm"
#endif

/datum/map_template/common_lateload/redgate
	name = "Redgate Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = /datum/map_z_level/common_lateload/redgate_destination
	name_alias = Z_NAME_ALIAS_REDGATE

/datum/map_z_level/common_lateload/redgate_destination
	name = "Redgate Destination"
	//z = Z_NAME_ALIAS_REDGATE
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/common_lateload/redgate/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx, world.maxy)
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)

/datum/map_template/common_lateload/redgate/teppi_ranch
	name = Z_NAME_REDGATE_TEPPI_RANCH
	desc = "An abandoned teppi ranch!"
	mappath = "maps/redgate/teppiranch.dmm"

/datum/map_template/common_lateload/redgate/innland
	name = Z_NAME_REDGATE_INNLAND
	desc = "Caves and grass and a tavern, woah!"
	mappath = "maps/redgate/innland.dmm"

/datum/map_template/common_lateload/redgate/abandonedisland
	name = Z_NAME_REDGATE_ABANDONED_ISLAND
	desc = "It seems like it used to be people here!"
	mappath = "maps/redgate/abandonedisland.dmm"

/datum/map_template/common_lateload/redgate/darkadventure
	name = Z_NAME_REDGATE_DARK_ADVENTURE
	desc = "This place seems broken!"
	mappath = "maps/redgate/darkadventure.dmm"

/datum/map_template/common_lateload/redgate/stardog
	name = Z_NAME_REDGATE_STAR_DOG
	desc = "That's a big dog!"
	mappath = "maps/redgate/stardog.dmm"

#include "../redgate/eggnogtown.dm"
/datum/map_template/common_lateload/redgate/eggnogtown
	name = Z_NAME_REDGATE_EGGNOG_TOWN
	desc = "A comfortable snowy town."
	mappath = "maps/redgate/eggnogtown.dmm"

/datum/map_template/common_lateload/redgate/eggnogtownunderground
	name = Z_NAME_REDGATE_EGGNOG_CAVE
	desc = "A comfortable snowy town."
	mappath = "maps/redgate/eggnogtownunderground.dmm"

/datum/map_template/common_lateload/redgate/hotsprings
	name = Z_NAME_REDGATE_HOTSPRINGS
	desc = "This place is rather cosy for somewhere so abandoned!"
	mappath = "maps/redgate/hotsprings.dmm"

/datum/map_template/common_lateload/redgate/cybercity
	name = Z_NAME_REDGATE_RAIN_CITY
	desc = "A strange city on lockdown."
	mappath = "maps/redgate/cybercity.dmm"

/datum/map_template/common_lateload/redgate/islands
	name = Z_NAME_REDGATE_ISLANDS
	desc = "A series of islands out in the ocean."
	mappath = "maps/redgate/islands.dmm"

/datum/map_template/common_lateload/redgate/islands_underwater
	name = Z_NAME_REDGATE_ISLANDS_UNDERWATER
	desc = "A series of islands out in the ocean."
	mappath = "maps/redgate/islands_underwater.dmm"

/obj/effect/landmark/map_data/islands
	height = 2

/datum/map_template/common_lateload/redgate/train
	name = Z_NAME_REDGATE_MOVING_TRAIN
	desc = "A long train travelling to who-knows-where."
	mappath = "maps/redgate/train.dmm"

/datum/map_template/common_lateload/redgate/train_upper
	name = Z_NAME_REDGATE_MOVING_TRAIN_UPPER
	desc = "A long train travelling to who-knows-where."
	mappath = "maps/redgate/train_upper.dmm"

/obj/effect/landmark/map_data/train
	height = 2

/datum/map_template/common_lateload/redgate/fantasy
	name = Z_NAME_REDGATE_FANTASY_TOWN
	desc = "A fantasy town full of low tech stuff."
	mappath = "maps/redgate/fantasy.dmm"

/datum/map_template/common_lateload/redgate/fantasy_dungeon
	name = Z_NAME_REDGATE_FANTASY_DUNGEON
	desc = "A fantasy dungeon with lots of monsters and loot."
	mappath = "maps/redgate/fantasy_dungeon.dmm"

/obj/effect/landmark/map_data/fantasy
	height = 2

/datum/map_template/common_lateload/redgate/laserdome
	name = Z_NAME_REDGATE_LASERDOME
	desc = "A large orbital station with recreational facilities, namely a pair of laser tag arenas."
	mappath = "maps/redgate/laserdome.dmm"

/datum/map_template/common_lateload/redgate/falls
	name = Z_NAME_REDGATE_CASCADING_FALLS
	desc = "A world made up almost entirely of water, sprinkled with obscure marble structures."
	mappath = "maps/redgate/falls/falls.dmm"

/datum/map_template/common_lateload/redgate/jungle
	name = Z_NAME_REDGATE_JUNGLE
	desc = "A fantasy town full of low tech stuff."
	mappath = "maps/redgate/jungle.dmm"

/datum/map_template/common_lateload/redgate/jungle_underground
	name = Z_NAME_REDGATE_JUNGLE_CAVE
	desc = "A fantasy dungeon with lots of monsters and loot."
	mappath = "maps/redgate/jungle_underground.dmm"

/obj/effect/landmark/map_data/jungle
	height = 2

/datum/map_template/common_lateload/redgate/facility
	name = Z_NAME_REDGATE_FACILITY
	desc = "A facility full of unusual experiments."
	mappath = "maps/redgate/facility.dmm"

//////////////////////////////////////////////////////////////////////////////////////
// Admin-use z-levels for loading whenever an admin feels like
#ifdef AWAY_MISSION_TEST
#include "../submaps/admin_use_vr/spa.dmm"
#endif
#include "../submaps/admin_use_vr/fun.dm"
/datum/map_template/common_lateload/fun/spa
	name = "Space Spa"
	desc = "A pleasant spa located in a spaceship."
	mappath = "maps/submaps/admin_use_vr/spa.dmm"

	associated_map_datum = /datum/map_z_level/common_lateload/fun/spa

/datum/map_z_level/common_lateload/fun/spa
	name = "Spa"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED

//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Tether lateload maps
/datum/map_template/common_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/common_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)
	return ..()

/datum/map_z_level/common_lateload/New(datum/map/map, mapZ)
	z = mapZ
	return ..(map)

/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize(mapload)
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

/////////////////////////////
/obj/tether_away_spawner
	name = "RENAME ME, JERK"
	desc = "Spawns the mobs!"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = 0
	density = 0
	anchored = 1

	//Weighted with values (not %chance, but relative weight)
	//Can be left value-less for all equally likely
	var/list/mobs_to_pick_from

	//When the below chance fails, the spawner is marked as depleted and stops spawning
	var/prob_spawn = 100	//Chance of spawning a mob whenever they don't have one
	var/prob_fall = 5		//Above decreases by this much each time one spawns

	//Settings to help mappers/coders have their mobs do what they want in this case
	var/faction				//To prevent infighting if it spawns various mobs, set a faction
	var/atmos_comp			//TRUE will set all their survivability to be within 20% of the current air
	//var/guard				//# will set the mobs to remain nearby their spawn point within this dist

	//Internal use only
	var/mob/living/simple_mob/my_mob
	var/depleted = FALSE

/obj/tether_away_spawner/Initialize(mapload)
	. = ..()

	if(!LAZYLEN(mobs_to_pick_from))
		error("Mob spawner at [x],[y],[z] ([get_area(src)]) had no mobs_to_pick_from set on it!")
		flags |= ATOM_INITIALIZED
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSobj, src)

/obj/tether_away_spawner/process()
	if(my_mob && my_mob.stat != DEAD)
		return //No need

	for(var/mob/living/L in view(src,world.view))
		if(L.client)
			return //I'll wait.

	if(prob(prob_spawn))
		prob_spawn -= prob_fall
		var/picked_type = pickweight(mobs_to_pick_from)
		my_mob = new picked_type(get_turf(src))
		my_mob.low_priority = TRUE

		if(faction)
			my_mob.faction = faction

		if(atmos_comp)
			var/turf/T = get_turf(src)
			var/datum/gas_mixture/env = T.return_air()
			if(env)
				if(my_mob.minbodytemp > env.temperature)
					my_mob.minbodytemp = env.temperature * 0.8
				if(my_mob.maxbodytemp < env.temperature)
					my_mob.maxbodytemp = env.temperature * 1.2

				var/list/gaslist = env.gas
				if(my_mob.min_oxy)
					my_mob.min_oxy = gaslist[GAS_O2] * 0.8
				if(my_mob.min_tox)
					my_mob.min_tox = gaslist[GAS_PHORON] * 0.8
				if(my_mob.min_n2)
					my_mob.min_n2 = gaslist[GAS_N2] * 0.8
				if(my_mob.min_co2)
					my_mob.min_co2 = gaslist[GAS_CO2] * 0.8
				if(my_mob.max_oxy)
					my_mob.max_oxy = gaslist[GAS_O2] * 1.2
				if(my_mob.max_tox)
					my_mob.max_tox = gaslist[GAS_PHORON] * 1.2
				if(my_mob.max_n2)
					my_mob.max_n2 = gaslist[GAS_N2] * 1.2
				if(my_mob.max_co2)
					my_mob.max_co2 = gaslist[GAS_CO2] * 1.2
/* //VORESTATION AI TEMPORARY REMOVAL
		if(guard)
			my_mob.returns_home = TRUE
			my_mob.wander_distance = guard
*/
		return
	else
		STOP_PROCESSING(SSobj, src)
		depleted = TRUE
		return

//Shadekin spawner. Could have them show up on any mission, so it's here.
//Make sure to put them away from others, so they don't get demolished by rude mobs.
/obj/tether_away_spawner/shadekin
	name = "Shadekin Spawner"
	icon = 'icons/mob/vore_shadekin.dmi'
	icon_state = "spawner"

	faction = FACTION_SHADEKIN
	prob_spawn = 1
	prob_fall = 1
	//guard = 10 //Don't wander too far, to stay alive.
	mobs_to_pick_from = list(
		/mob/living/simple_mob/shadekin
	)

//////////////////////////////////////////////////////////////////////////////
//Antag/Event/ERT Areas

#include "../submaps/admin_use_vr/ert.dm"
#include "../submaps/admin_use_vr/mercship.dm"
#include "../submaps/admin_use_vr/salamander_trader.dm"

/datum/map_template/admin_use/ert
	name = "Special Area - ERT"
	desc = "It's the ERT ship! Lorge."
	mappath = "maps/submaps/admin_use_vr/ert.dmm"

/datum/map_template/admin_use/trader
	name = "Special Area - Trader"
	desc = "Big trader ship."
	mappath = "maps/submaps/admin_use_vr/tradeship.dmm"

/datum/map_template/admin_use/salamander_trader
	name = "Special Area - Salamander Trader"
	desc = "Modest trader ship."
	mappath = "maps/submaps/admin_use_vr/salamander_trader.dmm"

/datum/map_template/admin_use/mercenary
	name = "Special Area - Merc Ship"
	desc = "Prepare tae be boarded, arr!"
	mappath = "maps/submaps/admin_use_vr/kk_mercship.dmm"

/datum/map_template/admin_use/skipjack
	name = "Special Area - Skipjack Base"
	desc = "Stinky!"
	mappath = "maps/submaps/admin_use_vr/skipjack.dmm"

/datum/map_template/admin_use/thunderdome
	name = "Special Area - Thunderdome"
	desc = "Thunderrrrdomeee"
	mappath = "maps/submaps/admin_use_vr/thunderdome.dmm"

/datum/map_template/admin_use/wizardbase
	name = "Special Area - Wizard Base"
	desc = "Wingardium Levosia"
	mappath = "maps/submaps/admin_use_vr/wizard.dmm"

/datum/map_template/admin_use/dojo
	name = "Special Area - Ninja Dojo"
	desc = "Sneaky"
	mappath = "maps/submaps/admin_use_vr/dojo.dmm"

//////////////////////////////////////////////////////////////////////////////
//Overmap ship spawns

#include "../offmap_vr/om_ships/hybridshuttle.dm"
#include "../offmap_vr/om_ships/screebarge.dm"
#include "../offmap_vr/om_ships/aro.dm"
#include "../offmap_vr/om_ships/aro2.dm"
#include "../offmap_vr/om_ships/aro3.dm"
#include "../offmap_vr/om_ships/bearcat.dm"
#include "../offmap_vr/om_ships/vespa.dm"
#include "../offmap_vr/om_ships/generic_shuttle.dm"
#include "../offmap_vr/om_ships/salamander.dm"
#include "../offmap_vr/om_ships/geckos.dm"
#include "../offmap_vr/om_ships/mackerels.dm"
#include "../offmap_vr/om_ships/mercenarybase.dm"
#include "../offmap_vr/om_ships/mercship.dm"
#include "../offmap_vr/om_ships/curashuttle.dm"
#include "../offmap_vr/om_ships/itglight.dm"
#include "../offmap_vr/om_ships/abductor.dm"
#include "../offmap_vr/om_ships/lunaship.dm"
#include "../offmap_vr/om_ships/sdf_corvettes.dm"

//////////////////////////////////////////////////////////////////////////////
//Capsule deployed ships
#include "../offmap_vr/om_ships/shelter_5.dm"

//////////////////////////////////////////////////////////////////////////////
//Offmap Spawn Locations
#include "../offmap_vr/talon/talon_v2.dm"
#include "../offmap_vr/talon/talon_v2_areas.dm"

#ifdef MAP_TEST
#include "../offmap_vr/talon/talon_v2.dmm"
#endif

/datum/map_template/common_lateload/offmap/talon_v2
	name = Z_NAME_OFFMAP1
	desc = "Offmap spawn ship, the Talon."
	mappath = "maps/offmap_vr/talon/talon_v2.dmm"
	associated_map_datum = /datum/map_z_level/common_lateload/talon_v2

/datum/map_z_level/common_lateload/talon_v2
	name = "Talon"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_PERSIST|MAP_LEVEL_MAPPABLE
	base_turf = /turf/space
	//z = Z_NAME_OFFMAP1
