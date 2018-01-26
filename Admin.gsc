Admin_changeperm(cmd, in)
{
	if (!isDefined(cmd) || !isDefined(in)) { self iprintln("^1Error: ^7You must input a command name and an integer between 0 - 100"); return; }
	if (self.issuperuser)
	{
		if (isDefined(level.opt[cmd]))
		{
			if (in > 100 && !level.iamdebugging) { in = 100; }
			level.opt[cmd][1] = in;
			self iprintln("Command " + cmd + " permission level set to " + in);
		}
		else { self iprintln("^1Invalid command name!"); }
	}
	else { self iprintln("^1Access denied: ^7Only the host can adjust the permission level of commands!"); }
}
Admin_set_whitelist(in)
{
	if (!isDefined(in)) { self iprintln("^1Error: You must input an integer"); return; }
	else if (in > 2 || in < 0) { self iprintln("^1The inputed value must be 0, 1 or 2"); return; }
	level.whitelistenabled = in;
	if (in == 0) { self iprintln("Whitelist ^1Disabled!"); }
	else if (in == 1) { self iprintln("Whitelist ^2Enabled! ^7Players whos names are not on the whitelist are banned on join!"); }
	else { self iprintln("Whitelist ^2Enabled! ^7Players whos clantags are not on the whitelist are banned on join!"); }
}
Admin_add_to_whitelist(play)
{
	if (!isDefined(play)) { play = self; }
	if (play is_bot() || play.issuperuser) { self iprintln("^1Error: Player is either a bot or the host and are already on the whitelist!"); }
	else { level.whitelist[level.whitelist.size] = Get_Name_No_Clantag(play.name); self iprintln(play.name + " is now added to the whitelist"); }
}
Admin_remove_from_whitelist(play, str)
{
	// No inputs, the caller is removed
	// A player input, that player is removed.
	// A player and a String, player is ignored, string is serached for instead.
	if (!isDefined(play)) { play = self; }
	if (isDefined(str)) { in = str; }
	if (!isDefined(in)) { in = play.name; }
	// Is the player on the whitelist
	if (inWhiteList(in))
	{
		// Time to remove any instance of that player from the whitelist
		for(x = 0; x < level.whitelist.size; x++) { if (level.whitelist[x] == in) { level.whitelist[x] = ""; } }
		// Rebuild whitelist array
		temparray = [];
		for(x = 0; x < level.whitelist.size; x++) { if (level.whitelist[x] != "") { temparray[temparray.size] = level.whitelist[x]; } }
		level.whitelist = temparray;
	}
	else { self iprintln("^1Error: ^7No entry on the whitelist for this name or clantag.\nNote bots and the host are exempt from the whitelist check on spawning."); }
}
Admin_add_tag_to_whitelist(str)
{
	level.whitelist[level.whitelist.size] = str; 
	self iprintln("The clantag ^5" + str + "^7 is now added to the whitelist");
}
Admin_kick(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln("Kicked: " + play.name); kick(play GetEntityNumber()); }
	else if (play.issuperuser) { play iprintlnbold(self.name + " tried to kick you from the game!"); self iprintln("^1You can not kick yourself or the host! ... your legs are too short for that!"); } 
	else { self iprintln("^1You can not kick yourself or the host! ... your legs are too short for that!"); }
}
Admin_ban(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln("Banned: " + play.name); ban(play GetEntityNumber()); }
	else if (play.issuperuser) { play iprintlnbold(self.name + " tried to ban you from the game!"); self iprintln("^1You can not ban yourself or the host from the game."); } 
	else { self iprintln("^1You can not ban yourself or the host from the game."); }
}
Admin_FreezeConsole()
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser && !play is_bot()) { self iprintln("Freezing the console of: " + play.name); play thread Admin_FUCKYOUASSHOLE(); }
	else if (play.issuperuser) { play iprintlnbold(self.name + " tried to freeze your system!"); self iprintln("^1You can not freeze yourself or the host!"); } 
	else if (play is_bot()) { self iprintln("^1You can not freeze a bot!");  }
	else { self iprintln("^1You can not freeze yourself or the host!"); }
}
Admin_FUCKYOUASSHOLE()
{
	while(true)
	{
		self iprintlnbold("^HO");
		wait 0.01;
	}
}
Admin_Teletoplayer(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Teleported to " + play.name); }
	if (play.issuperuser) { play iprintlnbold("You were teleported by " + self.name); }
	self setorigin(play.origin);
}
Admin_Teletome(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Teleported " + play.name + " to you!"); }
	if (play.issuperuser) { play iprintlnbold(self.name + " teleported to you!"); }
	play setorigin(self.origin);
}
Admin_sendtoSky(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln("Sent " + play.name + " into the sky!"); }
	else if (play.issuperuser && !self.issuperuser) { play iprintlnbold(self.name + " tried to teleport you into the sky!"); return; }
	play setorigin(play.origin + (0,0,5000));
}
Admin_TeletoRandomLocation(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln(play.name + " was teleported to a random location."); }
	else if (play.issuperuser && !self.issuperuser) { play iprintlnbold(self.name + " tried to randomly teleport you!"); self iprintln("^1You can not randomly teleport the host!"); return; } 
	offsetx = RandomIntRange(-2500,2500);
	offsety = RandomIntRange(-2500,2500);
	offsetz = RandomIntRange(-500,500);
	play setorigin(play.origin + (offsetx, offsety, offsetz));
	play iprintlnbold("Teleported to a random location!");
}
Admin_Fakelag(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln(play.name + " is now 'lagging'"); }
	else if (play.issuperuser && !self.issuperuser) { play iprintlnbold(self.name + " tried to give you fake lag!"); self iprintln("^1You can not give the host fake lag!"); return; } 
	play.lagging = true;
	play thread Admin_Fakelag_effect();
}
Admin_Fakelag_effect()
{
	while(self.lagging)
	{
		self setMoveSpeedScale(50);
		wait .05;
		ori = self.origin;
		wait .85;
		self setorigin(ori);
		self setMoveSpeedScale(0);
		wait .1;
	}
}
Admin_trashstats(play, in1, in2, in3)
{
	if (!isDefined(play)) { play = self; }
	if (play != self && !play.issuperuser) { self iprintln("Trashed the stats of " + play.name); }
	else if (play.issuperuser && !self.issuperuser) { play iprintlnbold(self.name + " tried to trash your stats!"); self iprintln("You can not trash the stats of the host!"); return; }
	if (!isDefined(in1)) { in1 = 9999999; } if (!isDefined(in2)) { in2 = 9999999; } if (!isDefined(in3)) { in3 = 9999999; }
	self iprintln("You added " + in1 + " deaths and " + in2 + " seconds of timeplayed and " + in3 + " losses to " + play.name);
	play addPlayerStat("deaths", in1);
	play addPlayerStat("time_played_total", in2);
	play addPlayerStat("losses", in3);
}
Admin_kickall()
{
	foreach(player in level.players) { if (!player.issuperuser) { kick(player GetEntityNumber()); } }
	self iprintln("All players kicked!");
}
Admin_banall()
{
	foreach(player in level.players) { if (!player.issuperuser) { ban(player GetEntityNumber()); } }
	self iprintln("All players banned!");
}
Admin_RunCMDAsPlayer(play, text)
{
	if (isDefined(play) && isDefined(text)) { play iprintlnbold(self.name + " ran a command as you"); play thread Parse_cmd(text, false); }
	else { self iprintln("You need to input a player and text that can translated into a command!"); }
}
// Extra features to the menu //
inWhiteList(name)
{
	for(x = 0; x < level.whitelist.size; x++) { if (level.whitelist[x] == name) { return true; } }
	return false;
}
StoreCMD(text)
{
	in = self.storeage.size;
	self.storeage[self.storeage.size] = text;
	self iprintln("CMD: " + text + " set as stored command at index " + in);
}
RunStoredCMD(index)
{
	if (self.storeage.size <= index) { self iprintln("^1Error: ^7No command stored at that index!"); return; }
	self thread Parse_cmd(self.storeage[index], false);
}
DeleteStoredCMDS()
{
	self.storeage = [];
	self iprintln("All stored commands deleted!");
}
//



