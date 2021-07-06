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

init() {
        level thread drawZombiesCounter();
	level thread onPlayerConnect();
	level thread markTwo();
	level thread gen4Fizz();
	level thread gen2Box();

	setdvar("player_strafeSpeedScale", 1);
	setdvar("player_backSpeedScale", 1);
}

drawZombiesCounter() {
	level.zombiesCounter = createServerFontString("hudsmall" , 1.9);
	level.zombiesCounter setPoint("RIGHT", "CENTER", 415, -225);
	for(;;)
	{
		enemies = get_round_enemy_array().size + level.zombie_total;

		level.zombiesCounter.label = &"";
		level.zombiesCounter setValue(enemies);

		wait 0.05;
	}
}

onPlayerConnect() {
	for(;;) {
        	level waittill("connected", player);

		player thread fixSnow();
		player thread fixPerks();

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

	wait 10;

	level.force_weather[2] = "rain";
	level.force_weather[3] = "snow";
	level.force_weather[4] = "snow";
	level.force_weather[11] = "snow";

	level.ice_staff_pieces[0].num_misses = 3;		
	level.ice_staff_pieces[1].num_misses = 3;		
	level.ice_staff_pieces[2].num_misses = 4;
}

fixPerks() {	
	self endon("disconnect");
	level endon("game_ended");

	level.custom_random_perk_weights = undefined;

	perkOrder = [];
	perkOrder[0] = "specialty_armorvest";
	perkOrder[1] = "specialty_longersprint";
	perkOrder[2] = "specialty_fastreload";

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
