#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_perk_random;
#include maps/mp/zm_tomb_utility;
#include maps/mp/zm_tomb_dig;
#include maps/mp/zm_tomb_capture_zones;

init() {
	level thread onPlayerConnect();
	level thread markTwo();
	level thread gen4Fizz();
	level thread gen2Box();

	setdvar("player_strafeSpeedScale", 1);
	setdvar("player_backSpeedScale", 1);
}

onPlayerConnect() {
	for(;;) {
        	level waittill("connected", player);

		player thread fixSnow();
		player thread fixPerks();

		player thread noLuckyPowerups();
		player thread noUnluckyDigs();

		player thread fixTemplars();
		player thread easyIce();
		setInitialDrops();

		wait 3;

        	setdvar("cg_fov", 100);
	}
}

gen4Fizz() {
	for(;;)
	{
		level waittill("connecting", player );
		level waittill("initial_players_connected");
		wait 10;

		machines = getentarray("random_perk_machine", "targetname");
		/*
		gen1 is machines[5]
		gen2 is machines[0]
		gen3 is machines[1]
		gen4 is machines[2]
		gen5 is machines[3]
		gen6 is machines[4]
		*/		
		level.random_perk_start_machine = machines[2];

		foreach(machine in machines)
		{
			if (machine != level.random_perk_start_machine) {
				machine hidepart("j_ball");
				machine.is_current_ball_location = 0;
				machine setclientfield("turn_on_location_indicator", 0);
			} else {
				machine.is_current_ball_location = 1;
				level.wunderfizz_starting_machine = machine;
				level notify("wunderfizz_setup");
				machine thread machine_think();
			}
		}
	}
}

gen2Box() {
	for(;;)
	{
		level waittill("connecting", player );
		level waittill("initial_players_connected");

		index = -1;
		for (i = 0; i < level.chests.size; i++) {

			if (level.chests[i].script_noteworthy == "bunker_tank_chest") {
				if (index == -1) {
					break;
				}
				index = i;
			} else if (level.chests[i].script_noteworthy == "bunker_cp_chest") {
				level.chests[i] hide_chest();
				level.chests[i].hidden = 1;
				index = i;
			} 

			wait 1;
		}	
		
		if (index >= 0) {
			level.chest_index = index;
			level.chests[level.chest_index].hidden = 0;
			level.chests[level.chest_index] show_chest();
		}
	}	
}

markTwo() {
	for(;;)
	{
		level waittill("connecting", player );
		level waittill("initial_players_connected");
		
		level.special_weapon_magicbox_check = undefined;

		foreach(weapon in level.zombie_weapons) {
			weapon.is_in_box = 0;
		}
        
		level.zombie_weapons["raygun_mark2_zm"].is_in_box = 1;
		level.zombie_weapons["scar_zm"].is_in_box = 1;
	}
}

fixSnow() {	
	self endon("disconnect");
	level endon("game_ended");

	for(;;) {
		level waittill("end_of_round");
		// round numbers are n - 1 because you need to set level.last_snow_round before the round you want snow on
		if (level.round_number == 2 || level.round_number == 3 || level.round_number == 10) {			
			wait 10;
			level.last_snow_round = -4;
		}		
	}
}

fixPerks() {	
	self endon("disconnect");
	level endon("game_ended");

	level.custom_random_perk_weights = undefined;

	perkOrder = [];
	perkOrder[0] = "specialty_fastreload";
	perkOrder[1] = "specialty_additionalprimaryweapon";
	perkOrder[2] = "specialty_longersprint";

	for(i = 0; i < perkOrder.size;) 
	{
		for (j = 0; j < level._random_perk_machine_perk_list.size; j++) {
        		level._random_perk_machine_perk_list[j] = perkOrder[i];
    		}

		self waittill("perk_acquired");	

		if (self hasperk(perkOrder[i])) {
			i++;
		}			
	}
}

noLuckyPowerups() {
	self endon("disconnect");
	level endon("game_ended");

	for (;;) {	
		level.dig_n_powerups_spawned = 5;
		level waittill("end_of_round");
		wait 3;
	}
}

noUnluckyDigs() {
	self endon("disconnect");
	level endon("game_ended");

	for (;;) {		
		self.dig_vars["n_losing_streak"] = 3;
		wait 5;
	}
}

fixTemplars() {	
	self endon("disconnect");
	level endon("game_ended");

	for (;;) {	
		level waittill("end_of_round");

		/*
		gen1 is level.zone_capture.zones["generator_start_bunker"]
		gen2 is level.zone_capture.zones["generator_tank_trench"]
		gen3 is level.zone_capture.zones["generator_mid_trench"]
		gen4 is level.zone_capture.zones["generator_nml_right"]
		gen5 is level.zone_capture.zones["generator_nml_left"]
		gen6 is level.zone_capture.zones["generator_church"]
		*/	
		if (level.round_number >= 10 && get_captured_zone_count() == 6) {			

			first = undefined;
			second = undefined;

			if (level.round_number <= 12) {
				first = level.zone_capture.zones["generator_church"];
				second = level.zone_capture.zones["generator_nml_left"];
			} else {
				first = level.zone_capture.zones["generator_start_bunker"];
				second = level.zone_capture.zones["generator_tank_trench"];
			}

			first ent_flag_clear("player_controlled");
			second ent_flag_clear("player_controlled");

			wait 20;

			first ent_flag_set("player_controlled");
			second ent_flag_set("player_controlled");

			update_captured_zone_count();
		}
	}
}


easyIce() {	
	self endon("disconnect");
	level endon("game_ended");

	for (;;) {	
		wait 3;

		if (isDefined(level.ice_staff_pieces[0].num_misses) && level.ice_staff_pieces[0].num_misses >= 1) {			
			level.ice_staff_pieces[0].num_misses = 4;
		}

		if (isDefined(level.ice_staff_pieces[1].num_misses) && level.ice_staff_pieces[1].num_misses >= 1) {			
			level.ice_staff_pieces[1].num_misses = 4;
		}

		if (isDefined(level.ice_staff_pieces[2].num_misses)) {			
			level.ice_staff_pieces[2].num_misses = 4;
		}
	}
}

setInitialDrops() {
	swapPowerupToIndex("full_ammo", 0);
        swapPowerupToIndex("double_points", 1);
        swapPowerupToIndex("insta_kill", 2);
        swapPowerupToIndex("nuke", 3);
        swapPowerupToIndex("zombie_blood", 4);
}

swapPowerupToIndex(powerup, index) {
	currentIndex = 0;
	while (level.zombie_powerup_array[currentIndex] != powerup) {
		currentIndex++;
	}

	temp = level.zombie_powerup_array[index];
	level.zombie_powerup_array[index] = powerup;
	level.zombie_powerup_array[currentIndex] = temp;
}