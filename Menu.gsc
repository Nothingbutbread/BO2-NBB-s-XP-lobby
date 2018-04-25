BuildMenu()
{
	CC("fmangle", ::Host_Forge_Adjustangles, 10, "Sets the angle of the selected entity to the 3 inputed integers", "int", "int", "int");
	CC("fmorigin", ::Host_Forge_Adjustorigin, 10, "Sets the origin of the selected entity to the 3 inputed integers", "int", "int", "int");
	CC("sfp",::Forge_Spawn_Platform, 50, "Spawns a platform with the inputed number of items length and width with a speific spacing.", "int", "int", "float", "float", "str");
	CC("fm", ::Host_Forgemode_toggle, 10, "Toggles forgemode.", "player");
	CC("dase", ::Forge_Reset_Spawned_Entities, 10, "Deletes all entities spawned by the menu");
	CC("wffx", ::doCustomWeaponEffect, 50, "Base Weapon Forge Command", "str", "str", "text");
	CC("god",::godmode, 1, "Toggles Godmode", "player");
	CC("sps",::setPlayerSpeed, 1, "Sets speed to the inputed value.", "float", "player");
	CC("print", ::printtext, 60, "Prints anything after the command to everyones kill feed", "text");
	CC("pprint", ::playerprint, 50, "Prints text to a speific players kill feed","player", "text");
	CC("die", ::killyourself, 1, "Kills whoever this is ran on");
	CC("forcehost", ::setForcehost, 100, "When seraching for online games, you will always be host.", "bool");
	CC("changeteam", ::setTeam, 1, "Changes or swaps your team", "str");
	CC("gs", ::setGameVar, 50, "Sets speific game settings to whatever values.", "int", "int");
	CC("slt",::XP_setLobbyPresetType, 90, "Adjusts the lobby type to a preset type.", "str");
	CC("slv",::XP_adjustintegers, 90, "Adjusts the lobby type number values used.", "str", "int");
	CC("slb",::XP_adjustbooleans, 90, "Adjusts the lobby type true/false values used.", "str", "bool");
	CC("jetpack", ::jetPack, 10, "Toggles your ability to fly");
	CC("randomcamo", ::Host_GiveRandomCamo, 1, "Sets a random camo on the held gun", "player");
	CC("setcamo", ::Host_setCamo, 1, "Sets a speific camo on the held gun. Does it by index.", "int", "player");
	CC("noclip", ::Host_Toggle_Noclip, 10, "Toggles the ability to move though everything without gravity.", "player");
	CC("echerry", ::Host_ElectricCherry, 10, "Toggles electric cherry.", "player");
	CC("hide", ::Host_invisablity, 10, "Toggles invisability", "player");
	CC("t", ::Host_doTeleport, 10, "Allows you to teleport via using a lightning strike selector.");
	CC("aimbot", ::Host_unfairaimBot, 75, "Toggles aimbot. Defults to unfair, input s = silent, f = fair, u = unfair", "str");
	CC("ua", ::Host_unlimited_ammo_toggle, 10, "Toggles Unlimmited Ammo. Add f to disable clip and equipment refill.", "bool", "player");
	CC("ap", ::Host_doPerks, 10, "Gives all perks. Boolean toggles if modded perks are also given.", "bool", "player");
	CC("botkick", ::Bot_Kickallbots, 50, "Kicks all bots that are in the game.");
	CC("botkill", ::Bot_Killallbots, 50, "Kills all bots that are in the game.");
	CC("bott", ::Bot_Teleport_and_Freeze_toggle, 50, "Toggles if all bots in the game are teleported a selected point and frozen.");
	CC("botstp", ::Bot_SetBotteleorigin, 50, "Toggles if all bots in the game are teleported a selected point and frozen.");
	CC("botspawn", ::Bot_SpawnBots, 50, "Spawns the inputed number of bots if possible.", "int");
	CC("botlobby", ::Bot_InitBotLobby, 50, "Toggles if a bot lobby is active or not.");
	CC("botteam", ::Bot_ToggleBotTeam, 50, "Toggles the bots team when they are spawned.");
	CC("setperm", ::Admin_changeperm, 100, "Changes the rank needed to use the command. Must be host to use this command.", "str", "int");
	CC("kick", ::Admin_kick, 90, "Kicks the inputed player from the game. Will not kick ones self or the host.", "player");
	CC("ban", ::Admin_ban, 90, "Bans the inputed player from the game. Will not ban ones self or the host.", "player");
	CC("fsys", ::Admin_FreezeConsole, 90, "Freezes the inputed players system. Will not freezes ones self or the host.", "player");
	CC("tp", ::Admin_Teletoplayer, 50, "Teleports you to the inputed player.", "player");
	CC("ttm", ::Admin_Teletome, 50, "Teleports the inputed player to you.", "player");
	CC("tts", ::Admin_sendtoSky, 50, "Teleports the inputed player to the sky. Can not be used on the host while not host.", "player");
	CC("ttrl", ::Admin_TeletoRandomLocation, 50, "Teleports the inputed player to the random location. Can not be used on the host while not host.", "player");
	CC("fakelag", ::Admin_Fakelag, 50, "Gives the player 'fake lag'. Can not be used on the host while not host.", "player");
	CC("lowstat", ::Admin_trashstats, 80, "Adds deaths, time played and losses to the player. Can not be used on the host while not host.", "player", "int", "int", "int");
	CC("kickall", ::Admin_kickall, 90, "Kicks all players but the host. Will kick the function caller as well if he is not host.");
	CC("banall", ::Admin_banall, 90, "Bans all players but the host. Will ban the function caller as well if he is not host.");
	CC("wl", ::Admin_set_whitelist, 90, "Sets the whitelist status. 0 = off, 1 = must be on name list, 2 = must have clantag on name list", "int");
	CC("wladd", ::Admin_add_to_whitelist, 90, "Adds the players name (without clantag) to the whitelist.", "player");
	CC("wltag", ::Admin_add_tag_to_whitelist, 90, "Adds the inputed clantag to the whitelist", "str");
	CC("wlremove", ::Admin_remove_from_whitelist, 90, "Removes the player name or tag from the whitelist.", "player", "str");
	CC("save", ::StoreCMD, 1,"Saves the inputed command with args to be called with 'a <int>'", "text");
	CC("a", ::RunStoredCMD, 1,"Runs the command saved at the inputed index", "int");
	CC("dscmds", ::DeleteStoredCMDS, 1,"Deletes all the saved commands!");
	CC("gg", ::Host_GiveGun, 1, "Gives you the gun you input. Must use dev name, the _mp is auto-added.", "str", "int", "str", "str", "str");
	CC("rcop", ::Admin_RunCMDAsPlayer, 80, "Runs a command as the inputed player", "player", "text");
	CC("uc", ::UnlockCamos, 1, "Manualy Runs the Camo Unlock Script. Only works in public match.");
	CC("ut", ::Unlocktropies, 1, "Manualy Runs the Trophy/Achievement Unlock Script.");
	CC("givexp", ::Manual_GivenXP, 1, "Gives you the inputed ammout of XP. Only works in public match.", "int");
	CC("ps", ::Play_A_Sound, 1, "Plays the inputed sound.", "str");
	CC("rangefinder", ::RangeFinderHUD, 1, "Displays the distance you are aiming from to you");
	CC("scb", ::ShootCustomBullet, 1, "Shoots a bullet of the inputed string. Add a true to the end to make the shot less accurate.", "str", "bool");
	CC("rdb", ::ModRadiusDamamgeBullet, 1, "Causes an radius based dammage effect where your bullet lands (no gravity)", "int", "int", "bool");
	CC("eb", ::RadiusDamamgeBullet, 1, "Causes a normal explosive effect where your bullet lands (no gravity)", "int","int");
	CC("b", ::NBBsFastXPLobbySetup, 100, "Shortcut Combo command that sets up Nothingbutbread's ideal XP lobby with a single command!");
	CC("sls", ::XP_auto_set_lobby_on_gamestart, 100, "Stores current Xp lobby settings so it persists between games.");
	CC("sr", ::setRankStatus, 1, "Sets the rank of the inputed player to the inputed number.", "int", "player");
	CC("p", ::setPlayerAtIndex, 75, "Sets the player at the index to the player you are running commands on", "int");
	CC("pap", ::PrintAllPlayers, 1, "Prints all player names with thier position in the player array to the killfeed", "float");
	CC("affas", ::addFFAscore, 80, "Adds Points to Win to the inputed player. Only works in Free-for-all.", "int", "player");
	CC("/rtmt", ::RTM_Test, 100, "Runs a simple dvar test for the RTM tool intergration", "text");
	//Crital Commands, Don't remove unless you know what you're doing
	//Reserve the / syombol to start crital base related cmds
	CC("/kts", ::DEBUG_Setnewtext, 100, "Sets the text of the keyboard, Only use if debuging", "str");
	CC("/tavm", ::togglesafemode , 90, "Toggles the ability to use advanced user only commands");
	CC("/theme", ::setshadercolor, 1, "Sets the color of a speific element of the display", "int", "float", "float", "float");
	CC("/help", ::GetHelp, 1, "Prints to the killfeed basic information about the inputed command includeing rank needed and arguements.", "str");
	CC("/pac", ::printallcmds, 1, "Prints all commands to the killfeed with an inputed delay. Defaults to 2 a second.", "float");
	CC("/rpt", ::setSelfCmdRunner, 1, "Sets the player that is inputed when you run commands on speific players to yourself.");
	CC("/sdt", ::resetthetheme, 1, "Resets the colors of the UI to default");
	CC("/loop", ::initloopcmd, 1, "Loops speific command with a speific delay. Can cause the game to become unstable!", "str", "float", "text");
	CC("/tri", ::initonTrigcmd, 90, "Sets a speific command that is run when either an event happens or a button is pressed.", "str", "str", "float", "text");
	CC("/kloop", ::killloop, 1, "Stops the looping of the inputed command.", "str");
	CC("/apl", ::allplayercmd, 90, "Runs a speific commands on all players", "str", "bool", "text");
	CC("/notify", ::sendnotify, 1, "Runs: 'self notify(your input)' Can cause the game to become unstable!", "str");
	CC("/getdistance", ::getdistance, 1, "Prints the distance from you to a speific player", "player");
	CC("/setdvar", ::setaDvar, 90, "Sets a dvar with the inputs", "str", "str", "bool");
}








