Bot_ToggleBotTeam()
{
	if (level.chosebotteam == "Auto Assign")
	{
		level.chosebotteam = "Allies";
		self iprintln("^5Bots set to spawn on team ^2Allies");
	}
	else if (level.chosebotteam == "Allies")
	{
		level.chosebotteam = "Axis";
		self iprintln("^5Bots set to spawn on team ^2Axis");
	}
	else if (level.chosebotteam == "Axis")
	{
		level.chosebotteam = "Auto Assign";
		self iprintln("^5Bots set to spawn with ^2Auto Assigned teams");
	}
}
Bot_InitBotLobby()
{
	if (!isDefined(level.botlobbyactive)) { level.botlobbyactive = false; }
	if (!level.botlobbyactive)
	{
		level.botlobbyactive = true;
		self thread Bot_BotLobby();
		iprintln("^5Bot Lobby ^2Enabled");
	}
	else
	{
		level.botlobbyactive = false;
		iprintln("^5Bot Lobby ^1Disabled");
	}
}
Bot_BotLobby()
{
    while(level.botlobbyactive)
    {
   		if (level.chosebotteam == "Auto Assign") { self thread spawn_bot("autoassign"); }
		else if (level.chosebotteam == "Allies") { self thread spawn_bot("allies"); }
		else if (level.chosebotteam == "Axis") { self thread spawn_bot("axis"); }
		wait .5;
	}
}
Bot_SpawnBots(a)
{
	if (!isDefined(a)) { a = 1; }
	if (a > 17) { a = 17; }
    for(i = 0; i < a; i++)
    {
    	if (level.chosebotteam == "Auto Assign")
			self thread spawn_bot("autoassign");
		if (level.chosebotteam == "Allies")
			self thread spawn_bot("allies");
		if (level.chosebotteam == "Axis")
			self thread spawn_bot("axis");
		wait .25;
    }
}
// botstp 
Bot_SetBotteleorigin()
{
	level.bot_teleport_origin = self.origin;
	self iprintln("^5Bot Teleport Origin set to ^1" + self.origin + " (your origin)");
}
// bott
Bot_Teleport_and_Freeze_toggle()
{
	if (!isDefined(level.bot_teleport_origin)) { self iprintln("^1Error: ^7You haven't defined a point for the bots to teleport yet.\nThat point has been set to your origin, you can change it with 'botstp'"); self iprintln("Bot teleporting and freezing ^2Enabled!"); level.bot_teleport_origin = self.origin; level.bot_teleport_enabled = true; }
	else if (level.bot_teleport_enabled) { level.bot_teleport_enabled = false; self iprintln("Bot teleporting and freezing ^1Disabled!"); }
	else { level.bot_teleport_enabled = true; self iprintln("Bot teleporting and freezing ^2Enabled!"); }
	level thread Bot_Killallbots();
}
// botkick
Bot_Kickallbots()
{
	foreach(player in level.players) { if (player is_bot()) { kick(player GetEntityNumber()); } }
	self iprintln("^5All Bots Kicked");
}
// botkill
Bot_Killallbots()
{
	foreach(player in level.players) { if (player is_bot()) { player suicide(); } }
	self iprintln("^5All Bots Killed");
}




