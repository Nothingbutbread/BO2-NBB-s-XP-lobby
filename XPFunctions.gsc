XP_setLobbyPresetType(str)
{
	if (!isDefined(str)) { str = ""; }
	if (str == "") { level init_global_vars(); iprintln("^6Server: ^1Lobby type reset!"); }
	else if (str == "all") { level XP_setLobbyTypeV4XPLobby(); iprintln("^6Server: ^2Lobby type set to Normal XP/CAMO/Trophy Lobby"); }
	else if (str == "camo") { level XP_setLobbyTypeUnlocksLobby(); iprintln("^6Server: ^2Lobby type set to Unlocks Lobby"); }
	else if (str == "xp") { level XP_setLobbyTypeXPOnly(); iprintln("^6Server: ^2Lobby type set to XP Only Lobby"); }
	else if (str == "unlock") { level XP_setLobbyTypeGeneralUnlocksOnly(); iprintln("^6Server: ^2Lobby type set to General Unlocks Lobby"); }
	else if (str == "curr") { level XP_setLobbyTypeRankCurruption(); iprintln("^6Server: ^2Lobby type set to Rank Curruption Lobby"); }
	else { self iprintln("^1Error: ^3Invalid Input Data!\n^2Valid Inputs: all camo xp unlock curr <nothing>"); }
}
XP_adjustintegers(str, int)
{
	if (!isDefined(str) || !isDefined(int)) { self iprintln("^1Error: You need to input an str and a int"); return; }
	if (str == "xp") { level.xplobby[12] = int; if (level.xplobby[12] > 64500) { self iprintln("^3Warning: ^5You set the xp gained to " + int + "!\n^1This can cause rank curruption!"); } else { self iprintln("^2Xp gained set to " + int); } }
	else if (str == "loss") { level.xplobby[13] = int; self iprintln("^2Losses gained set to " + int); }
	else if (str == "death") { level.xplobby[14] = int; self iprintln("^2Deaths gained set to " + int); }
	else if (str == "time") { level.xplobby[15] = int; self iprintln("^2Time played added set to " + int + " seconds"); }
	else { self iprintln("^1Error: ^5Invalid input!\n^2Valid inputs: xp loss death time"); }
}

XP_adjustbooleans(str, bool)
{
	if (!isDefined(str) || !isDefined(bool)) { self iprintln("^1Error: You need to input an str and a bool"); return; }
	if (str == "xp") { level.xplobby[1] = Invert(level.xplobby[1]); if (level.xplobby[1]) { self iprintln("^5XP giving ^2Enabled"); } else { self iprintln("^5XP giving ^1Disabled"); } }
	else if (str == "trophy") { level.xplobby[2] = Invert(level.xplobby[2]); if (level.xplobby[2]) { self iprintln("^5Trophy giving ^2Enabled"); } else { self iprintln("^5Trophy giving ^1Disabled"); } }
	else if (str == "camo") { level.xplobby[3] = Invert(level.xplobby[3]); if (level.xplobby[3]) { self iprintln("^5Camo giving ^2Enabled"); } else { self iprintln("^5Camo giving ^1Disabled"); } }
	else if (str == "unlock") { level.xplobby[4] = Invert(level.xplobby[4]); if (level.xplobby[4]) { self iprintln("^5General Unlocks giving ^2Enabled"); } else { self iprintln("^5General Unlocks ^1Disabled"); } }
	else if (str == "stat") { level.xplobby[5] = Invert(level.xplobby[5]); if (level.xplobby[5]) { self iprintln("^5Adding Stats ^2Enabled"); } else { self iprintln("^5Adding Stats ^1Disabled"); } }
	else if (str == "hack") { level.xplobby[6] = Invert(level.xplobby[6]); if (level.xplobby[6]) { self iprintln("^5Auto-kicking on Spawn of Hacked prestige players ^2Enabled"); } else { self iprintln("^5Auto-kicking on Spawn of Hacked prestige players ^1Disabled"); } }
	else if (str == "master") { level.xplobby[7] = Invert(level.xplobby[7]); if (level.xplobby[7]) { self iprintln("^5Auto-kicking on Spawn of Master prestige players ^2Enabled"); } else { self iprintln("^5Auto-kicking on Spawn of Master prestige players ^1Disabled"); } }
	else if (str == "maxlevel") { level.xplobby[8] = Invert(level.xplobby[8]); if (level.xplobby[8]) { self iprintln("^5Auto-kicking on Spawn of Max level players ^2Enabled"); } else { self iprintln("^5Auto-kicking on Spawn of Max level players ^1Disabled"); } }
	else if (str == "lowlevel") { level.xplobby[9] = Invert(level.xplobby[9]); if (level.xplobby[9]) { self iprintln("^5Auto-kicking on Spawn of Lower level players ^2Enabled"); } else { self iprintln("^5Auto-kicking on Spawn of Lower level players ^1Disabled"); } }
	else if (str == "kick") { level.xplobby[10] = Invert(level.xplobby[10]); if (level.xplobby[10]) { self iprintln("^5Players are now auto-banned instead of auto-kicked"); } else { self iprintln("^5Players are now auto-kicked instead of auto-banned"); } }
	else if (str == "unlockkick") { level.xplobby[11] = Invert(level.xplobby[11]); if (level.xplobby[11]) { self iprintln("^5Auto-kicking of players after getting unlocks ^2Enabled"); } else { self iprintln("^5Auto-kicking of players after getting unlocks ^1Disabled"); } }
	else { self iprintln("^1Error: ^5Invalid input:\n^2Valid inputs: xp trophy camo unlock stat hack master maxlevel lowlevel kick unlockkick"); }
}
// Hard coded functions ... rest are not dirrect user input commands.
XP_CMD_AT_START_OF_GAME()
{
	self endon("disconnect");
	self.ranautounlockscript = true;
	wait 2;
	if (level.xplobby[0])
	{
		xptype = self Determine_xp_type(); // 0 = Hacked / 1 = Master / 2 = At prestige / 3 = is leveling up
		if (xptype == 0)
		{
			if (level.xplobby[6])
			{
				if (level.xplobby[10]) { self XP_Process(level.xplobby[12], 1); }
				else { self XP_Process(level.xplobby[12], 0); }
			}
			else
			{
				if (level.xplobby[2]) { self Unlocktropies(); }
				if (level.xplobby[5]) { self GiveCustomStats(); }
				if (level.xplobby[11])
				{
					if (level.xplobby[10]) { self XP_Process(64500, 1); }
					else { self XP_Process(64500, 0); }
				}
			}
		}
		else if (xptype == 1 || xptype == 2)
		{
			if (level.xplobby[7] && xptype == 1)
			{
				if (level.xplobby[10]) { self XP_Process(level.xplobby[12], 1); }
				else { self XP_Process(level.xplobby[12], 0); }
			}
			else if(level.xplobby[8] && xptype == 2)
			{
				if (level.xplobby[10]) { self XP_Process(level.xplobby[12], 1); }
				else { self XP_Process(level.xplobby[12], 0); }
			}
			else
			{
				if (level.xplobby[2]) { self Unlocktropies(); }
				if (level.xplobby[5]) { self GiveCustomStats(); }
				if (level.xplobby[3]) { self UnlockCamos(); }
				if (level.xplobby[4]) { self GeneralUnlocks(); }
				
			}
		}
		else
		{
			if (level.xplobby[9] || level.xplobby[1])
			{
				if (level.xplobby[10]) { self XP_Process(level.xplobby[12], 1); }
				else { self XP_Process(level.xplobby[12], 0); }
			}
			else
			{
				if (level.xplobby[2]) { self Unlocktropies(); }
				if (level.xplobby[5]) { self GiveCustomStats(); }
				if (level.xplobby[4]) { self GeneralUnlocks(); }
			}
		}
		if (level.xplobby[11])
		{
			if (level.xplobby[10]) { self XP_Process(1, 1); }
			else { self XP_Process(1, 0); }
		}
	}
}
XP_Process(xp, action)
{
	self addrankxpvalue("contract", xp);
	if (level.iamdebugging) { level iprintln("^1Debug: ^7" + self.name + " completed unlock script"); }
	if (!self isHost())
	{
		if (action == 0) { kick(self GetEntityNumber()); }
		else if (action == 1) { ban(self GetEntityNumber()); }
		else
		{
			if (level.xplobby[10]) { ban(self GetEntityNumber()); }
			else { kick(self GetEntityNumber()); }
		}
	}
}
Manual_GivenXP(xp)
{
	if (!isDefined(xp)) { xp = 1; }
	self addrankxpvalue("contract", xp);
	self iprintln("Given " + xp + " xp!");
}
Unlocktropies()
{
	trophylist = strtok( "SP_COMPLETE_ANGOLA,SP_COMPLETE_MONSOON,SP_COMPLETE_AFGHANISTAN,SP_COMPLETE_NICARAGUA,SP_COMPLETE_PAKISTAN,SP_COMPLETE_KARMA,SP_COMPLETE_PANAMA,SP_COMPLETE_YEMEN,SP_COMPLETE_BLACKOUT,SP_COMPLETE_LA,SP_COMPLETE_HAITI,SP_VETERAN_PAST,SP_VETERAN_FUTURE,SP_ONE_CHALLENGE,SP_ALL_CHALLENGES_IN_LEVEL,SP_ALL_CHALLENGES_IN_GAME,SP_RTS_DOCKSIDE,SP_RTS_AFGHANISTAN,SP_RTS_DRONE,SP_RTS_CARRIER,SP_RTS_PAKISTAN,SP_RTS_SOCOTRA,SP_STORY_MASON_LIVES,SP_STORY_HARPER_FACE,SP_STORY_FARID_DUEL,SP_STORY_OBAMA_SURVIVES,SP_STORY_LINK_CIA,SP_STORY_HARPER_LIVES,SP_STORY_MENENDEZ_CAPTURED,SP_MISC_ALL_INTEL,SP_STORY_CHLOE_LIVES,SP_STORY_99PERCENT,SP_MISC_WEAPONS,SP_BACK_TO_FUTURE,SP_MISC_10K_SCORE_ALL,MP_MISC_1,MP_MISC_2,MP_MISC_3,MP_MISC_4,MP_MISC_5,ZM_DONT_FIRE_UNTIL_YOU_SEE,ZM_THE_LIGHTS_OF_THEIR_EYES,ZM_DANCE_ON_MY_GRAVE,ZM_STANDARD_EQUIPMENT_MAY_VARY,ZM_YOU_HAVE_NO_POWER_OVER_ME,ZM_I_DONT_THINK_THEY_EXIST,ZM_FUEL_EFFICIENT,ZM_HAPPY_HOUR,ZM_TRANSIT_SIDEQUEST,ZM_UNDEAD_MANS_PARTY_BUS,ZM_DLC1_HIGHRISE_SIDEQUEST,ZM_DLC1_VERTIGONER,ZM_DLC1_I_SEE_LIVE_PEOPLE,ZM_DLC1_SLIPPERY_WHEN_UNDEAD,ZM_DLC1_FACING_THE_DRAGON,ZM_DLC1_IM_MY_OWN_BEST_FRIEND,ZM_DLC1_MAD_WITHOUT_POWER,ZM_DLC1_POLYARMORY,ZM_DLC1_SHAFTED,ZM_DLC1_MONKEY_SEE_MONKEY_DOOM,ZM_DLC2_PRISON_SIDEQUEST,ZM_DLC2_FEED_THE_BEAST,ZM_DLC2_MAKING_THE_ROUNDS,ZM_DLC2_ACID_DRIP,ZM_DLC2_FULL_LOCKDOWN,ZM_DLC2_A_BURST_OF_FLAVOR,ZM_DLC2_PARANORMAL_PROGRESS,ZM_DLC2_GG_BRIDGE,ZM_DLC2_TRAPPED_IN_TIME,ZM_DLC2_POP_GOES_THE_WEASEL,ZM_DLC3_WHEN_THE_REVOLUTION_COMES,ZM_DLC3_FSIRT_AGAINST_THE_WALL,ZM_DLC3_MAZED_AND_CONFUSED,ZM_DLC3_REVISIONIST_HISTORIAN,ZM_DLC3_AWAKEN_THE_GAZEBO,ZM_DLC3_CANDYGRAM,ZM_DLC3_DEATH_FROM_BELOW,ZM_DLC3_IM_YOUR_HUCKLEBERRY,ZM_DLC3_ECTOPLASMIC_RESIDUE,ZM_DLC3_BURIED_SIDEQUEST,ZM_DLC4_TOMB_SIDEQUEST,ZM_DLC4_ALL_YOUR_BASE,ZM_DLC4_PLAYING_WITH_POWER,ZM_DLC4_OVERACHIEVER,ZM_DLC4_NOT_A_GOLD_DIGGER,ZM_DLC4_KUNG_FU_GRIP,ZM_DLC4_IM_ON_A_TANK,ZM_DLC4_SAVING_THE_DAY_ALL_DAY,ZM_DLC4_MASTER_OF_DISGUISE,ZM_DLC4_MASTER_WIZARD,", "," );
	foreach(trophy in trophylist)
	{
		self giveachievement(trophy);
		self iprintlnbold("Unlocked: " + trophy);
		wait .05;
	}
	self iprintln("^6NBB's XP Lobby " + level.id_version + " : ^2Trophy/Achievement Script Finished!");
}
UnlockCamos()
{
	guns = strtok("xm8_mp,vector_mp,usrpg_mp,type95_mp,tar21_mp,svu_mp,ksg_mp,lsat_mp,mk48_mp,mp7_mp,pdw57_mp,peacekeeper_mp,qbb95_mp,riotshield_mp,sa58_mp,saiga12_mp,saritch_mp,scar_mp,sig556_mp,smaw_mp,srm1216_mp,870mcs_mp,an94_mp,as50_mp,ballista_mp,beretta93r_dw_mp,beretta93r_lh_mp,beretta93r_mp,crossbow_mp,dsr50_mp,evoskorpion_mp,fiveseven_dw_mp,fiveseven_lh_mp,fiveseven_mp,fhj18_mp,fnp45_dw_mp,fnp45_lh_mp,fnp45_mp,hamr_mp,hk416_mp,insas_mp,judge_dw_mp,judge_lh_mp,judge_mp,kard_dw_mp,kard_lh_mp,kard_mp,kard_wager_mp,knife_ballistic_mp,knife_held_mp,knife_mp", ",");
	unlock = strtok("headshots,kills,direct_hit_kills,revenge_kill,noAttKills,noPerkKills,multikill_2,killstreak_5,challenges,longshot_kill,direct_hit_kills,destroyed_aircraft_under20s,destroyed_5_aircraft,destroyed_aircraft,kills_from_cars,destroyed_2aircraft_quickly,destroyed_controlled_killstreak,destroyed_qrdrone,destroyed_aitank,multikill_3,score_from_blocked_damage,shield_melee_while_enemy_shooting,hatchet_kill_with_shield_equiped,noLethalKills,ballistic_knife_kill,kill_retrieved_blade,ballistic_knife_melee,kills_from_cars,crossbow_kill_clip,backstabber_kill,kill_enemy_with_their_weapon,kill_enemy_when_injured,primary_mastery,secondary_mastery,weapons_mastery,kill_enemy_one_bullet_shotgun,kill_enemy_one_bullet_sniper",",");
	foreach(g in guns)
	{
		self thread UnlockCamosPart2(g, unlock);
		wait .5;
	}
	wait .5;
	self iprintln("^6NBB's XP Lobby " + level.id_version + " : ^2Unlock Camos Script Finished!");
}
UnlockCamosPart2(g, unlock)
{
	foreach(key in unlock) { self addweaponstat(g, key, 10000); }
	self iprintlnbold("Unlocked Camos for: ^1" + g);
}
GiveCustomStats()
{
	self addPlayerStat("deaths", level.xplobby[14]);
	self addPlayerStat("time_played_total", level.xplobby[15]);
	self addPlayerStat("losses", level.xplobby[13]);
}
GeneralUnlocks()
{
    self addgametypestat( "killstreak_10", 500 );
    self addgametypestat( "killstreak_15", 250 );
    self addgametypestat( "killstreak_20", 125 );
    self addgametypestat( "killstreak_30", 75 );
    weaponstats = strtok("dogs_mp,emp_mp,missile_drone_mp,missile_swarm_mp,planemortar_mp,killstreak_qrdrone_mp,remote_missile_mp,remote_mortar_mp,straferun_mp,supplydrop_mp,ai_tank_drop_mp,acoustic_sensor_mp,qrdrone_turret_mp,rcbomb_mp,qrdrone_turret_mp,rcbomb_mp,microwaveturret_mp,autoturret_mp,helicopter_player_gunner_mp,missile_drone_mp,missile_swarm_mp,planemortar_mp,killstreak_qrdrone_mp,remote_missile_mp,remote_mortar_mp,straferun_mp,supplydrop_mp,ai_tank_drop_mp,acoustic_sensor_mp,microwaveturret_mp,autoturret_mp,helicopter_player_gunner_mp",",");
    foreach(stat in weaponstats) { self addweaponstat(stat, "destroyed", 100 ); }
    wait .1;
	gametypestats = strtok("round_win_no_deaths,last_man_defeat_3_enemies,CRUSH,most_kills_least_deaths,SHUT_OUT,ANNIHILATION,kill_2_enemies_capturing_your_objective,capture_b_first_minute,immediate_capture,contest_then_capture,both_bombs_detonate_10_seconds,multikill_3,kill_enemy_who_killed_teammate,kill_enemy_injuring_teammate,defused_bomb_last_man_alive,elimination_and_last_player_alive,killed_bomb_planter,killed_bomb_defuser,kill_flag_carrier,defend_flag_carrier,killed_bomb_planter,killed_bomb_defuser,kill_flag_carrier,defend_flag_carrier",",");
    foreach(stats in gametypestats) { self addgametypestat(stats, 600 ); }
    wait .1;
	othertypestats = strtok("reload_then_kill_dualclip,kill_with_remote_control_ai_tank,killstreak_5_with_sentry_gun,kill_with_remote_control_sentry_gun,killstreak_5_with_death_machine,kill_enemy_locking_on_with_chopper_gunner,kill_with_loadout_weapon_with_3_attachments,kill_with_both_primary_weapons,kill_with_2_perks_same_category,kill_while_uav_active,kill_while_cuav_active,kill_while_satellite_active,kill_after_tac_insert,kill_enemy_revealed_by_sensor,kill_while_emp_active,survive_claymore_kill_planter_flak_jacket_equipped,killstreak_5_dogs,kill_flashed_enemy,kill_concussed_enemy,kill_enemy_who_shocked_you,kill_shocked_enemy,shock_enemy_then_stab_them,mantle_then_kill,kill_enemy_with_picked_up_weapon,killstreak_5_picked_up_weapon,kill_enemy_shoot_their_explosive,kill_enemy_while_crouched,kill_enemy_while_prone,kill_prone_enemy,kill_every_enemy,pistolHeadshot_10_onegame,headshot_assault_5_onegame,kill_enemy_one_bullet_sniper,kill_10_enemy_one_bullet_sniper_onegame,kill_enemy_one_bullet_shotgun,kill_10_enemy_one_bullet_shotgun_onegame,kill_enemy_with_tacknife,KILL_CROSSBOW_STACKFIRE,hatchet_kill_with_shield_equiped,kill_with_claymore,kill_with_hacked_claymore,kill_with_c4,kill_enemy_withcar,stick_explosive_kill_5_onegame,kill_with_cooked_grenade,kill_with_tossed_back_lethal,kill_with_dual_lethal_grenades,perk_movefaster_kills,perk_noname_kills,perk_quieter_kills,perk_longersprint,perk_fastmantle_kills,perk_loudenemies_kills,perk_protection_stun_kills,perk_immune_cuav_kills,perk_gpsjammer_immune_kills,perk_fastweaponswitch_kill_after_swap,perk_scavenger_kills_after_resupply,perk_flak_survive,perk_earnmoremomentum_earn_streak,kill_enemy_through_wall,kill_enemy_through_wall_with_fmj,disarm_hacked_carepackage,destroy_car,kill_nemesis,kill_while_damaging_with_microwave_turret,long_distance_hatchet_kill,activate_cuav_while_enemy_satelite_active,longshot_3_onelife,get_final_kill,destroy_rcbomb_with_hatchet,defend_teammate_who_captured_package,destroy_score_streak_with_qrdrone,capture_objective_in_smoke,perk_hacker_destroy,destroy_equipment_with_emp_grenade,destroy_equipment,destroy_5_tactical_inserts,kill_15_with_blade,destroy_explosive,multikill_3_near_death,multikill_3_lmg_or_smg_hip_fire,killed_dog_close_to_teammate,multikill_2_zone_attackers,muiltikill_2_with_rcbomb,multikill_3_remote_missile,multikill_3_with_mgl,destroy_turret,call_in_3_care_packages,destroyed_helicopter_with_bullet,destroy_qrdrone,destroyed_qrdrone_with_bullet,destroy_helicopter,destroy_aircraft_with_emp,destroy_aircraft_with_missile_drone,perk_nottargetedbyairsupport_destroy_aircraft,destroy_aircraft,killstreak_10_no_weapons_perks,kill_with_resupplied_lethal_grenade,stun_aitank_with_emp_grenade",",");
    foreach(stas in othertypestats) { self addplayerstat(stas, 750 ); }
    wait .1;
    misstypestats = strtok("assist,assist_score_microwave_turret,assist_score_killstreak,assist_score_cuav,assist_score_uav,assist_score_satellite,assist_score_emp",",");
    foreach(sta in misstypestats) { self addplayerstat(sta, 95000 ); }
    wait .1;
    self addweaponstat("willy_pete_mp", "CombatRecordStat", 250 );
    self addweaponstat("emp_grenade_mp", "combatRecordStat", 2500 );
    self addweaponstat("trophy_system_mp", "CombatRecordStat", 2500 );
    self addweaponstat( "counteruav_mp", "assists", 400 );
    self addweaponstat( "radar_mp", "assists", 500 );
    self addweaponstat( "radardirection_mp", "assists", 250 );
    self addweaponstat( "emp_mp", "assists", 250 );
    self addweaponstat( "flash_grenade_mp", "hits", 250 );
    self addweaponstat( "flash_grenade_mp", "used", 2500 );
    self addweaponstat( "pda_hack_mp", "used", 2500 );
    self addweaponstat( "nightingale_mp", "used", 2500 );
    self addweaponstat( "proximity_grenade_mp", "used", 500 );
    self addweaponstat( "scrambler_mp", "used", 2500 );
    self addweaponstat( "sensor_grenade_mp", "used", 2500 );
    self addweaponstat( "willy_pete_mp", "used", 2500 );
    self addweaponstat( "tactical_insertion_mp", "used", 2500 );
    self addweaponstat( "trophy_system_mp", "used", 2500 );
    self iprintln("^6NBB's XP Lobby " + level.id_version + " : ^2General Unlocks Script Finished!");
}
Determine_xp_type()
{
	if (self.pers["prestige"] > 11) { return 0; }
	else if (self.pers["prestige"] == 11) { return 1; }
	else if (self.pers["rank"] == level.maxRank) { return 2; }
	return 3;
}
XP_setLobbyTypeV4XPLobby()
{
	level.xplobby[0] = true;
	level.xplobby[1] = true;
	level.xplobby[2] = true;
	level.xplobby[3] = true;
	level.xplobby[4] = true;
	level.xplobby[5] = false;
	level.xplobby[6] = true;
	level.xplobby[7] = false;
	level.xplobby[8] = false;
	level.xplobby[9] = false;
	level.xplobby[10] = false;
	level.xplobby[11] = true; 
	level.xplobby[12] = 64500;
	level thread Admin_kickall();
}

XP_setLobbyTypeUnlocksLobby()
{
	level.xplobby[0] = true;
	level.xplobby[1] = false;
	level.xplobby[2] = true;
	level.xplobby[3] = true;
	level.xplobby[4] = true;
	level.xplobby[5] = false;
	level.xplobby[6] = true;
	level.xplobby[7] = false;
	level.xplobby[8] = false;
	level.xplobby[9] = false;
	level.xplobby[10] = false;
	level.xplobby[11] = true; 
	level.xplobby[12] = 64500; 
	level thread Admin_kickall();
}
XP_setLobbyTypeXPOnly()
{
	level.xplobby[0] = true;
	level.xplobby[1] = true;
	level.xplobby[2] = false;
	level.xplobby[3] = false;
	level.xplobby[4] = false;
	level.xplobby[5] = false;
	level.xplobby[6] = false;
	level.xplobby[7] = false;
	level.xplobby[8] = false;
	level.xplobby[9] = false;
	level.xplobby[10] = false;
	level.xplobby[11] = true; 
	level.xplobby[12] = 64500;
	level thread Admin_kickall();
}
XP_setLobbyTypeGeneralUnlocksOnly()
{
	level.xplobby[0] = true;
	level.xplobby[1] = false;
	level.xplobby[2] = true;
	level.xplobby[3] = false;
	level.xplobby[4] = true;
	level.xplobby[5] = false;
	level.xplobby[6] = true;
	level.xplobby[7] = false;
	level.xplobby[8] = false;
	level.xplobby[9] = false;
	level.xplobby[10] = false;
	level.xplobby[11] = true; 
	level.xplobby[12] = 64500;
	level thread Admin_kickall();
}
XP_setLobbyTypeRankCurruption()
{
	level.xplobby[0] = true;
	level.xplobby[1] = true;
	level.xplobby[2] = false;
	level.xplobby[3] = false;
	level.xplobby[4] = false;
	level.xplobby[5] = true;
	level.xplobby[6] = true;
	level.xplobby[7] = true;
	level.xplobby[8] = true;
	level.xplobby[9] = true;
	level.xplobby[10] = false;
	level.xplobby[11] = true; 
	level.xplobby[12] = 2147483647; 
	level.xplobby[13] = 2147483647;
	level.xplobby[14] = 2147483647;
	level.xplobby[15] = 2147483647;
	level thread Admin_kickall();
}
// This stores the xp lobby settings to dvars
XP_auto_set_lobby_on_gamestart()
{
	setDvar("xplobbyenabled", "yes");
	a = "";
	for(x=0;x<12;x++)
	{
		if (level.xplobby[x]) { a += "t"; }
		else { a += "f"; }
	}
	setDvar("xplobbyb", a);
	b = level.xplobby[12] + "," + level.xplobby[13] + "," + level.xplobby[14] + "," + level.xplobby[15] + ",";
	setDvar("xplobbyv", b);
	self iprintln("^2Lobby settings will auto-apply to any new games!");
}
// This runs on start of game and applies any saved xp lobby settings.
XP_unpackage_stored_xp_lobby_settings()
{
	if (isDefined(GetDvar("xplobbyenabled"))) 
	{ 
		if (GetDvar("xplobbyenabled") == "yes")
		{
			a = GetDvar("xplobbyb");
			for(x=0;x<a.size;x++)
			{
				if (a[x] == "t") { level.xplobby[x] = true; }
				else { level.xplobby[x] = false; }
			}
			b = GetDvar("xplobbyv");
			nums = []; nums[0] = 1; nums[1] = 1; nums[2] = 1; nums[3] = 1;
			temp = "";
			index = 12;
			for(x=0;x<b.size;x++)
			{
				if (b[x] != ",") { temp += b[x]; }
				else 
				{
					g = get_num(temp);
					if (g[0] && g[1]) { level.xplobby[index] = g[2]; }
					else { level.xplobby[index] = 100; }
					index++;
					temp = "";
				}
			}
			iprintln("^2XP lobby settings applied!");
	  	} 
	  	else { iprintln("^3Warning: ^7No xp lobby settings found saved!"); }
	}
	else { iprintln("^3Warning: ^7No xp lobby settings found saved!"); }
}
