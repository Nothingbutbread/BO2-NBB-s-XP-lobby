/* |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  | Nothingbutbread's XP Lobby [Terminal Eddition]    | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |               Version 4.0.0                       | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |          Version release: Beta                    | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |         Created by: Nothingbutbread               | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |    Made to better the Black ops 2 Community.      | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |    This Project must remain open sourced          | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |    Designed around a DEX PS3 Rebug 4.81.2 D-REX   | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*  |    Terminal Base: V1.0.0                          | *
*  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| *
*/

#include maps/mp/gametypes/_globallogic_score;
#include maps/mp/gametypes/_globallogic_utils;
#include maps/mp/_scoreevents;
#include maps/mp/teams/_teams;
#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/gametypes/_hud_message;
#include maps/mp/gametypes/_spawnlogic;
#include maps/mp/gametypes/_spawning;
#include maps/mp/killstreaks/_turret_killstreak;
#include maps/mp/gametypes/_rank;
#include maps/mp/gametypes/tdm;
#include maps/mp/bots/_bot;

init()
{
	// Allows the player to spawn the war and death machine.
	PrecacheItem("minigun_wager_mp");
	PrecacheItem("m32_wager_mp");
	level.strings = []; // Overflow fix
	level.opt = []; // Option array.
	level.id_version = "4.0.0 Beta 05"; // ID of version
	level.iamdebugging = true;
	level init_global_vars(); // Compact means of defining level varribles. Mostly used for XP lobby vars.
	level XP_unpackage_stored_xp_lobby_settings(); // Sets pre-stored xp lobby settings. Only runs if there is stored values.
	level thread BuildMenu(); // Builds the menu.
	level thread Preventforfeit(); // Prevents the game from ending in a public match due to lack of players.
	level thread Config(); // Loads user CONFIG found in Config.gsc
    level thread onPlayerConnect(); // 
}
onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player.menuinit = false;
        player.godmode = false;
        player.safemode = true;
        player.rank = 0;
        player.issuperuser = false;
        player.menu_open = false;
        player.ranautounlockscript = false;
        if(!isDefined(level.overflowFixThreaded))
		{
			level.overflowFixThreaded = true;
			level thread overflowFix();
		}
		if (level.whitelistenabled == 1)
		{
			n = Get_Name_No_Clantag(player.name);
			if (!inWhiteList(n) && !player is_bot() && !player isHost()) { ban(player GetEntityNumber()); }
		}
		else if (level.whitelistenabled == 2)
		{
			n = Get_Clantag(player.name);
			if (!inWhiteList(n) && !player is_bot() && !player isHost()) { ban(player GetEntityNumber()); }
		}
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("game_ended");
	if (self isHost()) { self thread DEBUG_DEBUGMODE(); self thread AntiEndgame(); self.issuperuser = true; self.rank = 100; self thread Menu_Init(); self setForcehost(true); }
    for(;;)
    {
    	self notify("menuresponse", "changeclass", "class_smg");
        self waittill("spawned_player");
        self FreezeControls(false);
        if (self is_bot())
        {
        	if (level.bot_teleport_enabled && isDefined(level.bot_teleport_origin))
        	{
				self setorigin(level.bot_teleport_origin);
				self setPlayerAngles((0,-90,0));
				self freezecontrols(true);
			}
        }
        else if (!self.ranautounlockscript) { self thread XP_CMD_AT_START_OF_GAME(); }
        self thread onPlayerDeath();
    }
}
init_global_vars()
{
	level.xplobby = [];
	// Booleans
	level.xplobby[0] = false; // Custom lobby type is active
	level.xplobby[1] = false; // Give XP
	level.xplobby[2] = false; // Give Trophies
	level.xplobby[3] = false; // Give Camos
	level.xplobby[4] = false; // Give General Unlocks
	level.xplobby[5] = false; // Give Custom Stats
	level.xplobby[6] = false; // Kick Hacked Prestige players
	level.xplobby[7] = false; // Kick Master Prestige players
	level.xplobby[8] = false; // Kick Max level players
	level.xplobby[9] = false; // Kick Non max level players.
	level.xplobby[10] = false; // Ban players instead of kicking.
	level.xplobby[11] = false; // Kick players after reciving all unlucks
	// Integers
	level.xplobby[12] = 64500; // XP Given
	level.xplobby[13] = 100; // Losses Added
	level.xplobby[14] = 100; // Deaths Added
	level.xplobby[15] = 100; // Time played Added
	// Other varribles that I need defined before I start the game
	level.chosebotteam = "Auto Assign"; // Used in the code that deals with spawning bots.
	level.bot_teleport_enabled = false; // Used in the code that deals with spawning bots.
	level.whitelist = []; // Whitelist array
	level.whitelistenabled = 0; // 0 = no whitelist, 1 = whitelist by name, 2 = whitelist by clantag
}
onPlayerDeath()
{
	self waittill("death");
	self.godmode = false;
	self.noclip = false;
	self.electriccherry = false;
	self.isvanished = false;
	self.unlimmitedammo = false;
	self.lagging = false;
	self.hasunfairaimbot = false;
}
NBBsFastXPLobbySetup()
{
	self Host_doPerks(true, self);
	self godMode(self);
	self thread jetPack();
	self XP_setLobbyTypeV4XPLobby();
	level.teamscoreperkill = 0;
	registertimelimit(0,0);
}
