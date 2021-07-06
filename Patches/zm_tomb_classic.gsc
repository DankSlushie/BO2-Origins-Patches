//checked includes match cerberus output
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/zm_tomb_craftables;
#include maps/mp/zombies/_zm_craftables;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_ai_quadrotor;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zm_tomb_vo;
#include maps/mp/zm_tomb_main_quest;
#include maps/mp/zm_tomb_utility;
#include maps/mp/zombies/_zm_weapons;

precache() //checked matches cerberus output
{

	level.maxisBodySpawn = 0; 	// 0 = ice tunnel, 		1 = gen 5 tank path, 		2 = gen 4 tank path
	level.maxisEngineSpawn = 1; 	// 0 = top excavation, 		1 = mid excavation, 		2 = bottom excavation

	level.shieldTopSpawn = 2; 	// 0 = fire tunnel, 		1 = wheelbarrow, 		2 = under gen 3
	level.shieldDoorSpawn = 2; 	// 0 = gen 4 box, 		1 = mid nml, 			2 = gen 5 side nml
	level.shieldBracketSpawn = 0; 	// 0 = after first door, 	1 = inconvenient wheelbarrow, 	2 = gen 2 foot
	
	level.discMasterSpawn = 2; 	// 0 = top excavation, 		1 = excavation stairs, 		2 = behind excavation
	level.discWindSpawn = 1; 	// 0 = lightning tunnel, 	1 = rain fire side, 		2 = gen 5 box side
	level.discFireSpawn = 1; 	// 0 = upper church, 		1 = next to gen 6, 		2 = lower church
	level.discIceSpawn = 1; 	// 0 = tank side, 		1 = next to mystery box, 	2 = gen 2 side
	level.discLightningSpawn = 0; 	// 0 = next to fizz, 		1 = wind tunnel, 		2 = wagon

	level.gramophoneSpawn = 1; 	// 0 = closer to maxis spawn, 	1 = closer to entrance

	if ( is_true( level.createfx_enabled ) )
	{
		return;
	}
	maps/mp/zombies/_zm_craftables::init();

	// maps/mp/zm_tomb_craftables::randomize_craftable_spawns();
	randomizeCraftableSpawns();

	// maps/mp/zm_tomb_craftables::include_craftables();
	includeCraftables();

	maps/mp/zm_tomb_craftables::init_craftables();
}

randomizeCraftableSpawns() {

	a_randomized_craftables = array( "gramophone_vinyl_ice", "gramophone_vinyl_air", "gramophone_vinyl_elec", "gramophone_vinyl_fire", "gramophone_vinyl_master", "gramophone_vinyl_player" );
	
	foreach ( str_craftable in a_randomized_craftables )
	{
		s_original_pos = getstruct( str_craftable, "targetname" );
		a_alt_locations = getstructarray( str_craftable + "_alt", "targetname" );

		n_loc_index = 0; // randomintrange( 0, a_alt_locations.size + 1 );

		if (str_craftable == "gramophone_vinyl_ice") {

			n_loc_index = level.discIceSpawn;

		} else if (str_craftable == "gramophone_vinyl_air") {

			n_loc_index = level.discWindSpawn;

		} else if (str_craftable == "gramophone_vinyl_elec") {

			n_loc_index = level.discLightningSpawn;

		} else if (str_craftable == "gramophone_vinyl_fire") {

			n_loc_index = level.discFireSpawn;

		} else if (str_craftable == "gramophone_vinyl_master") {

			n_loc_index = level.discMasterSpawn;

		} else if (str_craftable == "gramophone_vinyl_player") {

			n_loc_index = level.gramophoneSpawn;

		} 

		if ( n_loc_index == a_alt_locations.size )
		{
		}
		else 
		{
			s_original_pos.origin = a_alt_locations[ n_loc_index ].origin;
			s_original_pos.angles = a_alt_locations[ n_loc_index ].angles;
		}
	}
}

includeCraftables() {
	level thread run_craftables_devgui();
	craftable_name = "equip_dieseldrone_zm";
	quadrotor_body = generateZombieCraftablePiece( craftable_name, "body", "veh_t6_dlc_zm_quad_piece_body", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_body", 1, "build_dd" );
	quadrotor_brain = generateZombieCraftablePiece( craftable_name, "brain", "veh_t6_dlc_zm_quad_piece_brain", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_brain", 1, "build_dd_brain" );
	quadrotor_engine = generateZombieCraftablePiece( craftable_name, "engine", "veh_t6_dlc_zm_quad_piece_engine", 32, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_quadrotor_zm_engine", 1, "build_dd" );
	quadrotor = spawnstruct();
	quadrotor.name = craftable_name;
	quadrotor add_craftable_piece( quadrotor_body );
	quadrotor add_craftable_piece( quadrotor_brain );
	quadrotor add_craftable_piece( quadrotor_engine );
	quadrotor.triggerthink = ::quadrotorcraftable;
	include_zombie_craftable( quadrotor );
	level thread add_craftable_cheat( quadrotor );
	craftable_name = "tomb_shield_zm";
	riotshield_top = generateZombieCraftablePiece( craftable_name, "top", "t6_wpn_zmb_shield_dlc4_top", 48, 64, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs" );
	riotshield_door = generateZombieCraftablePiece( craftable_name, "door", "t6_wpn_zmb_shield_dlc4_door", 48, 15, 25, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs" );
	riotshield_bracket = generateZombieCraftablePiece( craftable_name, "bracket", "t6_wpn_zmb_shield_dlc4_bracket", 48, 15, 0, undefined, ::onpickup_common, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs" );
	riotshield = spawnstruct();
	riotshield.name = craftable_name;
	riotshield add_craftable_piece( riotshield_top );
	riotshield add_craftable_piece( riotshield_door );
	riotshield add_craftable_piece( riotshield_bracket );
	riotshield.onbuyweapon = ::onbuyweapon_riotshield;
	riotshield.triggerthink = ::riotshieldcraftable;
	include_craftable( riotshield );
	level thread add_craftable_cheat( riotshield );
	craftable_name = "elemental_staff_air";
	staff_air_gem = generateZombieCraftablePiece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_air_part", 48, 64, 0, undefined, ::onpickup_aircrystal, ::ondrop_aircrystal, undefined, undefined, undefined, undefined, 2, 0, "crystal", 1 );
	staff_air_upper_staff = generateZombieCraftablePiece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_air_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_air", 1, "staff_part" );
	staff_air_middle_staff = generateZombieCraftablePiece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_air_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_air", 1, "staff_part" );
	staff_air_lower_staff = generateZombieCraftablePiece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_air", 1, "staff_part" );
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece( staff_air_gem );
	staff add_craftable_piece( staff_air_upper_staff );
	staff add_craftable_piece( staff_air_middle_staff );
	staff add_craftable_piece( staff_air_lower_staff );
	staff.triggerthink = ::staffcraftable_air;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable( staff );
	level thread add_craftable_cheat( staff );
	count_staff_piece_pickup( array( staff_air_upper_staff, staff_air_middle_staff, staff_air_lower_staff ) );
	craftable_name = "elemental_staff_fire";
	staff_fire_gem = generateZombieCraftablePiece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_fire_part", 48, 64, 0, undefined, ::onpickup_firecrystal, ::ondrop_firecrystal, undefined, undefined, undefined, undefined, 1, 0, "crystal", 1 );
	staff_fire_upper_staff = generateZombieCraftablePiece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_fire_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_fire", 1, "staff_part" );
	staff_fire_middle_staff = generateZombieCraftablePiece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_fire_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_fire", 1, "staff_part" );
	staff_fire_lower_staff = generateZombieCraftablePiece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 64, 128, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_fire", 1, "staff_part" );
	level thread maps/mp/zm_tomb_main_quest::staff_mechz_drop_pieces( staff_fire_lower_staff );
	level thread maps/mp/zm_tomb_main_quest::staff_biplane_drop_pieces( array( staff_fire_middle_staff ) );
	level thread maps/mp/zm_tomb_main_quest::staff_unlock_with_zone_capture( staff_fire_upper_staff );
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece( staff_fire_gem );
	staff add_craftable_piece( staff_fire_upper_staff );
	staff add_craftable_piece( staff_fire_middle_staff );
	staff add_craftable_piece( staff_fire_lower_staff );
	staff.triggerthink = ::staffcraftable_fire;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable( staff );
	level thread add_craftable_cheat( staff );
	count_staff_piece_pickup( array( staff_fire_upper_staff, staff_fire_middle_staff, staff_fire_lower_staff ) );
	craftable_name = "elemental_staff_lightning";
	staff_lightning_gem = generateZombieCraftablePiece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_bolt_part", 48, 64, 0, undefined, ::onpickup_lightningcrystal, ::ondrop_lightningcrystal, undefined, undefined, undefined, undefined, 3, 0, "crystal", 1 );
	staff_lightning_upper_staff = generateZombieCraftablePiece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_lightning_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_lightning", 1, "staff_part" );
	staff_lightning_middle_staff = generateZombieCraftablePiece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_bolt_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_lightning", 1, "staff_part" );
	staff_lightning_lower_staff = generateZombieCraftablePiece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_lightning", 1, "staff_part" );
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece( staff_lightning_gem );
	staff add_craftable_piece( staff_lightning_upper_staff );
	staff add_craftable_piece( staff_lightning_middle_staff );
	staff add_craftable_piece( staff_lightning_lower_staff );
	staff.triggerthink = ::staffcraftable_lightning;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable( staff );
	level thread add_craftable_cheat( staff );
	count_staff_piece_pickup( array( staff_lightning_upper_staff, staff_lightning_middle_staff, staff_lightning_lower_staff ) );
	craftable_name = "elemental_staff_water";
	staff_water_gem = generateZombieCraftablePiece( craftable_name, "gem", "t6_wpn_zmb_staff_crystal_water_part", 48, 64, 0, undefined, ::onpickup_watercrystal, ::ondrop_watercrystal, undefined, undefined, undefined, undefined, 4, 0, "crystal", 1 );
	staff_water_upper_staff = generateZombieCraftablePiece( craftable_name, "upper_staff", "t6_wpn_zmb_staff_tip_water_world", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_ustaff_water", 1, "staff_part" );
	staff_water_middle_staff = generateZombieCraftablePiece( craftable_name, "middle_staff", "t6_wpn_zmb_staff_stem_water_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_mstaff_water", 1, "staff_part" );
	staff_water_lower_staff = generateZombieCraftablePiece( craftable_name, "lower_staff", "t6_wpn_zmb_staff_revive_part", 32, 64, 0, undefined, ::onpickup_staffpiece, ::ondrop_common, undefined, undefined, undefined, undefined, "piece_staff_zm_lstaff_water", 1, "staff_part" );
	a_ice_staff_parts = array( staff_water_lower_staff, staff_water_middle_staff, staff_water_upper_staff );
	level thread maps/mp/zm_tomb_main_quest::staff_ice_dig_pieces( a_ice_staff_parts );
	staff = spawnstruct();
	staff.name = craftable_name;
	staff add_craftable_piece( staff_water_gem );
	staff add_craftable_piece( staff_water_upper_staff );
	staff add_craftable_piece( staff_water_middle_staff );
	staff add_craftable_piece( staff_water_lower_staff );
	staff.triggerthink = ::staffcraftable_water;
	staff.custom_craftablestub_update_prompt = ::tomb_staff_update_prompt;
	include_zombie_craftable( staff );
	level thread add_craftable_cheat( staff );
	count_staff_piece_pickup( array( staff_water_upper_staff, staff_water_middle_staff, staff_water_lower_staff ) );
	craftable_name = "gramophone";
	vinyl_pickup_player = vinyl_add_pickup( craftable_name, "vinyl_player", "p6_zm_tm_gramophone", "piece_record_zm_player", undefined, "gramophone" );
	vinyl_pickup_master = vinyl_add_pickup( craftable_name, "vinyl_master", "p6_zm_tm_record_master", "piece_record_zm_vinyl_master", undefined, "record" );
	vinyl_pickup_air = vinyl_add_pickup( craftable_name, "vinyl_air", "p6_zm_tm_record_wind", "piece_record_zm_vinyl_air", "quest_state2", "record" );
	vinyl_pickup_ice = vinyl_add_pickup( craftable_name, "vinyl_ice", "p6_zm_tm_record_ice", "piece_record_zm_vinyl_water", "quest_state4", "record" );
	vinyl_pickup_fire = vinyl_add_pickup( craftable_name, "vinyl_fire", "p6_zm_tm_record_fire", "piece_record_zm_vinyl_fire", "quest_state1", "record" );
	vinyl_pickup_elec = vinyl_add_pickup( craftable_name, "vinyl_elec", "p6_zm_tm_record_lightning", "piece_record_zm_vinyl_lightning", "quest_state3", "record" );
	vinyl_pickup_player.sam_line = "gramophone_found";
	vinyl_pickup_master.sam_line = "master_found";
	vinyl_pickup_air.sam_line = "first_record_found";
	vinyl_pickup_ice.sam_line = "first_record_found";
	vinyl_pickup_fire.sam_line = "first_record_found";
	vinyl_pickup_elec.sam_line = "first_record_found";
	level thread maps/mp/zm_tomb_vo::watch_one_shot_samantha_line( "vox_sam_1st_record_found_0", "first_record_found" );
	level thread maps/mp/zm_tomb_vo::watch_one_shot_samantha_line( "vox_sam_gramophone_found_0", "gramophone_found" );
	level thread maps/mp/zm_tomb_vo::watch_one_shot_samantha_line( "vox_sam_master_found_0", "master_found" );
	gramophone = spawnstruct();
	gramophone.name = craftable_name;
	gramophone add_craftable_piece( vinyl_pickup_player );
	gramophone add_craftable_piece( vinyl_pickup_master );
	gramophone add_craftable_piece( vinyl_pickup_air );
	gramophone add_craftable_piece( vinyl_pickup_ice );
	gramophone add_craftable_piece( vinyl_pickup_fire );
	gramophone add_craftable_piece( vinyl_pickup_elec );
	gramophone.triggerthink = ::gramophonecraftable;
	include_zombie_craftable( gramophone );
	level thread add_craftable_cheat( gramophone );
	staff_fire_gem thread watch_part_pickup( "quest_state1", 2 );
	staff_air_gem thread watch_part_pickup( "quest_state2", 2 );
	staff_lightning_gem thread watch_part_pickup( "quest_state3", 2 );
	staff_water_gem thread watch_part_pickup( "quest_state4", 2 );
	staff_fire_gem thread staff_crystal_wait_for_teleport( 1 );
	staff_air_gem thread staff_crystal_wait_for_teleport( 2 );
	staff_lightning_gem thread staff_crystal_wait_for_teleport( 3 );
	staff_water_gem thread staff_crystal_wait_for_teleport( 4 );
	level thread maps/mp/zm_tomb_vo::staff_craft_vo();
	level thread maps/mp/zm_tomb_vo::samantha_discourage_think();
	level thread maps/mp/zm_tomb_vo::samantha_encourage_think();
	level thread craftable_add_glow_fx();
}

generateZombieCraftablePiece( craftablename, piecename, modelname, radius, height, drop_offset, hud_icon, onpickup, ondrop, oncrafted, use_spawn_num, tag_name, can_reuse, client_field_value, is_shared, vox_id, b_one_time_vo ) {
	
	if ( !isDefined( is_shared ) )
	{
		is_shared = 0;
	}
	if ( !isDefined( b_one_time_vo ) )
	{
		b_one_time_vo = 0;
	}
	precachemodel( modelname );
	if ( isDefined( hud_icon ) )
	{
		precacheshader( hud_icon );
	}
	piecestub = spawnstruct();
	craftable_pieces = [];
	piece_alias = "";
	if ( !isDefined( piecename ) )
	{
		piecename = modelname;
	}
	craftable_pieces_structs = getstructarray( ( craftablename + "_" ) + piecename, "targetname" );

/*
/#
	if ( craftable_pieces_structs.size < 1 )
	{
		println( "ERROR: Missing craftable piece <" + craftablename + "> <" + piecename + ">\n" );
#/
	}
*/

	_a345 = craftable_pieces_structs;
	index = getFirstArrayKey( _a345 );
	while ( isDefined( index ) )
	{
		struct = _a345[ index ];
		craftable_pieces[ index ] = struct;
		craftable_pieces[ index ].hasspawned = 0;
		index = getNextArrayKey( _a345, index );
	}

	spawns = undefined;

	if (piecename == "body") {

		spawns = limitSpawns(craftable_pieces, level.maxisBodySpawn);

	} else if (piecename == "engine") {
		
		spawns = limitSpawns(craftable_pieces, level.maxisEngineSpawn);

	} else if (piecename == "top") {
		
		spawns = limitSpawns(craftable_pieces, level.shieldTopSpawn);

	} else if (piecename == "door") {
		
		spawns = limitSpawns(craftable_pieces, level.shieldDoorSpawn);

	} else if (piecename == "bracket") {
		
		spawns = limitSpawns(craftable_pieces, level.shieldBracketSpawn);

	} else {
		spawns = craftable_pieces;
	}

	piecestub.spawns = spawns;
	piecestub.craftablename = craftablename;
	piecestub.piecename = piecename;
	piecestub.modelname = modelname;
	piecestub.hud_icon = hud_icon;
	piecestub.radius = radius;
	piecestub.height = height;
	piecestub.tag_name = tag_name;
	piecestub.can_reuse = can_reuse;
	piecestub.drop_offset = drop_offset;
	piecestub.max_instances = 256;
	piecestub.onpickup = onpickup;
	piecestub.ondrop = ondrop;
	piecestub.oncrafted = oncrafted;
	piecestub.use_spawn_num = use_spawn_num;
	piecestub.is_shared = is_shared;
	piecestub.vox_id = vox_id;
	if ( isDefined( b_one_time_vo ) && b_one_time_vo )
	{
		piecestub.b_one_time_vo = b_one_time_vo;
	}
	if ( isDefined( client_field_value ) )
	{
		if ( isDefined( is_shared ) && is_shared )
		{
/*
/#
			assert( isstring( client_field_value ), "Client field value for shared item (" + piecename + ") should be a string (the name of the ClientField to use)" );
#/
*/
			piecestub.client_field_id = client_field_value;
		}
		else
		{
			piecestub.client_field_state = client_field_value;
		}
	}
	return piecestub;

}

limitSpawns(craftable_pieces, index) {
	spawns = [];
	spawns[0] = craftable_pieces[index];
	return spawns;	
}

main() //checked matches cerberus output
{
	maps/mp/gametypes_zm/_zm_gametype::setup_standard_objects( "tomb" );
	maps/mp/zombies/_zm_game_module::set_current_game_module( level.game_module_standard_index );
	level thread maps/mp/zombies/_zm_craftables::think_craftables();
	flag_wait( "initial_blackscreen_passed" );
}

zm_treasure_chest_init() //checked matches cerberus output
{
	chest1 = getstruct( "start_chest", "script_noteworthy" );
	level.chests = [];
	level.chests[ level.chests.size ] = chest1;
	maps/mp/zombies/_zm_magicbox::treasure_chest_init( "start_chest" );
}
