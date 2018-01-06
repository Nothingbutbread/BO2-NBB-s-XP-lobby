// Game settings:
//"gamesetting <int> <int>
setGameVar(sec, int)
{
	if (!isDefined(sec) || !isDefined(int)) { self iprintln("^1Error: ^7You must input two integers!"); return; }
	if (sec == 0)
	{
		level.teamscoreperkill = int;
		self iprintln("Points per kill set to " + int);
	}
	if (sec == 1)
	{
		registertimelimit( int, int);
		self iprintln("Time limit set to " + int + " minutes");
	}
}
// "changeteam <str>"
setTeam(str)
{
	if (!isDefined(str))
	{
		if (self.pers[ "team" ] != "allies") { self changeteam("axis"); }
		else { self changeteam("allies"); }
		self iprintln("^1Team swaped!");
	}
	else if (str != "allies" && str != "axis")
	{
		self iprintln("^1Error: ^7Invalid team inputed\nValid options are axis or allies");
		return;
	}
	else { self changeteam(str); }
}
// "forcehost" <bool>
setForcehost(bool)
{
	if (!self.issuperuser) { self iprintln("^1You must the host to use this command!"); return; }
	if (bool || !isDefined(bool))
	{
		setDvar("party_connectToOthers", "0");
		setDvar("partyMigrate_disabled", "1");
		setDvar("party_mergingEnabled", "0");
		setDvar("allowAllNAT", "1");
		self iprintln("^7Force Host ^2Enabled");
		return;
	}
	setDvar("party_connectToOthers", "1");
	setDvar("partyMigrate_disabled", "0");
	setDvar("party_mergingEnabled", "1");
	setDvar("allowAllNAT", "0");
	self iprintln("^7Force Host ^1Disabled");
}
killyourself() { self suicide(); }
jetPack()
{
	if (!isDefined(self.hasjetpack) || !self.hasjetpack) { self.hasjetpack = true; self iprintln("^5Jetpack ^2Enabled"); }
	else { self.hasjetpack = false; self iprintln("^5Jetpack ^1Disabled"); }
	while(self.hasjetpack) { if(self usebuttonpressed()) { if(self getvelocity() [2]<300) { self setvelocity(self getvelocity() +(0,0,120)); } } wait .1; }
}
// print <text>
printtext(text)
{
	if (!isDefined(text)) { self iprintln("^1Error: ^7You need to input something to print!"); }
	iprintln(text);
}
// pprint <anything> <text>
playerprint(play, text)
{
	if (!isDefined(play)) { play = self; }
	if (!isDefined(text)) { self iprintln("^1Error: ^7You need to input something to print!"); }
	if (play != self) { self iprintln("playerprint ran on " + play.name); }
	play iprintln(text);
}
//////////////// Utlity functions, don't delete! //////////////////
// "/tavm"
togglesafemode()
{
	if (self.safemode)
	{
		self.safemode = false;
		self iprintln("Advanced Features Unlocked!");
		self iprintln("^1Warning: ^7Becareful, you can freeze the game by missusing the commands this allows you to use!");
		return;
	}
	self.safemode = true;
	self iprintln("Advanced Features Re-locked!");
}
// "/allplayers <str> <bool> <text>"
allplayercmd(cmd, includehost, args)
{
	if (self.safemode) { self iprintln("^1Error: ^7Command can be misused and your advanced features are locked!"); self iprintln("Use /tavm to unlock this command!"); return; }
	if (!isdefined(cmd) || !isdefined(includehost)) { self iprintln("^1Error: ^7You must input atleast 2 arguements!"); return; }
	if (isDefined(args)) { cmds = self thread Parse_cmd(cmd + " " + args, true); }
	else { cmds = self thread Parse_cmd(cmd, true); }
	if (isDefined(cmds)) { foreach(player in level.players) { if (!player isHost() || includehost) { player thread [[level.opt[cmd[0]][0]]] (cmds[1], cmds[2], cmds[3], cmds[4], cmds[5]); } } }
	else { self iprintln("^1Error: ^7The command you want to run on all players must be valid!"); }
}
// "/kloop <str>"
killloop(cmd)
{
	self notify("loop_end_" + cmd);
	self iprintln("Ended all loops running with " + cmd);
}
// "/loop <str> <float> <text>"
initloopcmd(cmd, delay, args)
{
	if (self.safemode)
	{
		self iprintln("^1Error: ^7Command can be misused and your advanced features are locked!");
		self iprintln("Use /tavm to unlock this command!");
		return;
	}
	if (!isdefined(cmd) || !isdefined(delay))
	{
		self iprintln("^1Error: ^7You must input a command and a delay value!");
		return;
	}
	if (isDefined(args)) { cmds = self thread Parse_cmd(cmd + " " + args, true); }
	else { cmds = self thread Parse_cmd(cmd, true); }
	if (delay < .05) { delay = .05; }
	if (isDefined(cmds))
	{
		self notify("loop_end_" + cmd);
		wait .1;
		self thread loopcmd(delay, cmds[0], cmds[1], cmds[2], cmds[3], cmds[4], cmds[5]);
		return;
	}
	self iprintln("^1Error: ^7The command you want to loop must be valid!");
}
loopcmd(delay, cmd, arg1, arg2, arg3, arg4, arg5)
{
	self endon("loop_end_" + cmd);
	while(!self.safemode)
	{
		self thread [[level.opt[cmd][0]]] (arg1, arg2, arg3, arg4, arg5);
		wait delay;
	}
	self iprintlnbold("Advanced mode disabled, cmd loop killed!");
}
// "/theme <id> <red> <blue> <green>"
setshadercolor(int, r, g, b)
{
	if (!isDefined(int) || !isDefined(r) || !isDefined(g) || !isDefined(b))
	{
		self iprintln("^1Error: All arguements are required for this function!");
		self iprintln("^1You must input a HUD element id (Between 0 and 6) and 3 other numbers for the color");
		return;
	}
	if (r < 0 || r > 1 || g < 0 || g > 1 || b < 0 || b > 1)
	{
		self iprintln("^1Error: One or more of the inputed float values were either less than 0 or greater than 1");
		self iprintln("^1RGB values in GSC are between 0 and 1 as opposed to 0 and 255 or hex values.");
		return;
	}
	if (int == 0)
		self.HUD_KB.color = (r,g,b);
	else if (int == 1)
		self.HUD_KB_speical.color = (r,g,b);
	else if (int == 2)
		self.HUD_CMD_text.color = (r,g,b);
	else if (int == 3)
		self.HUD_KB_sel_left.color = (r,g,b);
	else if (int == 4)
		self.HUD_KB_sel_right.color = (r,g,b);
	else
	{
		self iprintln("^1Error: Inputed HUD element id was out of range!");
		return;
	}
	self iprintln("^2Shader/text color updated!");
}
// "/sdt" ~ Set Default Theme
resetthetheme()
{
	self iprintln("^2Theme set to default");
	self.HUD_KB.color = (1,1,1);
	self.HUD_KB_speical.color = (1,1,1);
	self.HUD_CMD_text.color = (1,1,1);
	self.HUD_KB_sel_left.color = (1,0,0);
	self.HUD_KB_sel_right.color = (1,0,0);
}
// "/listallcmds <float>"
printallcmds(delay)
{
	self endon("stop_printing_all_cmds");
	if (!isdefined(delay))
		delay = .5;
	if (delay < .05)
		delay = .05;
	self iprintlnbold("Printing all commands!");
	foreach(cmd in level.opt)
	{
		self iprintln(cmd[8]);
		wait delay;
	}
}
// "/setrank <int>"
setRankStatus(index, play)
{
	if (!isDefined(play)) { play = self; }
	if (index > 100) { index = 100; }
	if (play.rank >= self.rank || index > self.rank) { if (!self.issuperuser) { self iprintln("You can only adjust the rank of a player lower thans yours \nand only up to your rank without being host!"); return; } }
	if (play != self) { self iprintln("Menu rank of " + play.name + " set to " + index); }
	
	play iprintln("^2Your menu rank has been set to " + index);
	play.rank = index;
	if (play.rank == 0 && play.menu_open) { play CloseMenu(); }
	else if (play.rank > 0 && !play.menuinit) { play thread Menu_Init(); }
}
// "/spat <int>" 
setPlayerAtIndex(index)
{
	if (index < 0 || index > 17)
	{
		self iprintln("^1Error: Inputed interger must be between 0 and 17");
		return;
	}
	if (!isdefined(level.players[index]))
	{
		self iprintln("^1Error: There isn't a player at that index right now!");
		return;
	}
	self.selplayer = level.players[index];
	self iprintln("The player you are running commands as is now: " + self.selplayer.name);
}
// "/rpt" 
setSelfCmdRunner()
{
	self.selplayer = self;
	self iprintln("Now running commands on yourself");
}
// Built in command that lists off details of inputed commands.
// "/help <str>
GetHelp(cmd)
{
	if (isDefined(level.opt[cmd]))
	{
		args = "";
		for(x=3;x<8;x++) { if (level.opt[cmd][x] != "*") { args += " <" + level.opt[cmd][x] + ">"; } }
		self iprintln("Required rank : " + level.opt[cmd][1]);
		if (args == "") { self iprintln("Dosn't take any Arguments"); }
		else { self iprintln("Arguments taken:" + args); }
		self iprintln(level.opt[cmd][2]);
	}
	else { self iprintln("^1Error: No command at that input. Use /listallcmds <float> to print out all commands."); }
}
// /tri print jump .1 ^5hi
//CC("/tri", ::initonTrigcmd, 90, "Sets a speific command that is run when either an event happens or a button is pressed.", "str", "str", "float", "text");
initonTrigcmd(cmd, tri, delay, args)
{
	if (self.safemode) { self iprintln("^1Error: ^7Command can be misused and your advanced features are locked!"); self iprintln("Use /tavm to unlock this command!"); return; }
	if (!isdefined(cmd) || !isdefined(tri) || !isdefined(delay)) { self iprintln("^1Error: ^7You must input a command, delay and a trigger value!"); return; }
	if (isDefined(args)) { cmds = self thread Parse_cmd(cmd + " " + args, true); }
	else { cmds = self thread Parse_cmd(cmd, true); }
	//self iprintln("CMDS: " + cmds[0] + " " + cmds[1]);
	if (isValidTrig(tri) == 0) { self iprintln("^1Error: Invalid trigger inputed!"); return; }
	if (delay < .05) { delay = .05; }
	if (isDefined(cmds))
	{
		self notify("trig_end_" + cmd); wait .1;
		if (isValidTrig(tri) == 1) { self thread onTrigcmdwaittill(tri, delay, cmds[0], cmds[1], cmds[2], cmds[3], cmds[4], cmds[5]); }
		else if (isValidTrig(tri) == 2) { self thread onTrigcmdlooper(tri, delay, cmds[0], cmds[1], cmds[2], cmds[3], cmds[4], cmds[5]); } 
		else { self iprintln("^1Error: ^7Something went wrong that wasn't user error!"); }
		return;
	}
	self iprintln("^1Error: ^7The command you want to trigger must not be valid!");
}
isValidTrig(trig)
{
	if (trig == "weapon_fired") { return 1; }
	else if (trig == "grenade_fire") { return 1; }
	else if (trig == "reload_start") { return 1; }
	else if (trig == "death") { return 1; }
	else if (trig == "spawned_player") { return 1; }
	else if (trig == "1") { return 2; }
	else if (trig == "2") { return 2; }
	else if (trig == "3") { return 2; }
	else if (trig == "4") { return 2; }
	else if (trig == "ads") { return 2; }
	else if (trig == "tatical") { return 2; }
	else if (trig == "lethal") { return 2; }
	else if (trig == "fire") { return 2; }
	else if (trig == "jump") { return 2; }
	else if (trig == "crouch") { return 2; }
	else if (trig == "swap") { return 2; }
	else if (trig == "reload") { return 2; }
	else if (trig == "sprint") { return 2; }
	else if (trig == "melee") { return 2; }
	else { return 0; }
}
trigCMDLoopDesiredButtonPressed(trig)
{
	if (trig == "1" && self actionslotonebuttonpressed()) { return true; }
	else if (trig == "2" && self actionslottwobuttonpressed()) { return true; }
	else if (trig == "3" && self actionslotthreebuttonpressed()) { return true; }
	else if (trig == "4" && self actionslotfourbuttonpressed()) { return true; }
	else if (trig == "ads" && self adsbuttonpressed()) { return true; }
	else if (trig == "tatical" && self inventorybuttonpressed()) { return true; }
	else if (trig == "lethal" && self fragbuttonpressed()) { return true; }
	else if (trig == "fire" && self attackbuttonpressed()) { return true; }
	else if (trig == "jump" && self jumpbuttonpressed()) { return true; }
	else if (trig == "crouch" && self stancebuttonpressed()) { return true; }
	else if (trig == "swap" && self changeseatbuttonpressed()) { return true; }
	else if (trig == "reload" && self usebuttonpressed()) { return true; }
	else if (trig == "sprint" && self sprintbuttonpressed()) { return true; }
	else if (trig == "melee" && self meleebuttonpressed()) { return true; }
	else { return false;}
}
onTrigcmdlooper(trig, delay, cmd, arg1, arg2, arg3, arg4, arg5)
{
	self endon("trig_end_" + cmd);
	self iprintlnbold("Command trigged on " + trig + " activated!");
	while(!self.safemode)
	{
		if (trigCMDLoopDesiredButtonPressed(trig)) { self thread [[level.opt[cmd][0]]] (arg1, arg2, arg3, arg4, arg5); wait delay;}
		else { wait .1; }
	}
	self iprintlnbold("Advanced mode disabled, trigger loop killed!");
}
onTrigcmdwaittill(trig, delay, cmd, arg1, arg2, arg3, arg4, arg5)
{
	self endon("trig_end_" + cmd);
	self iprintlnbold("Command triged on " + trig + " activated!");
	while(!self.safemode)
	{
		self waittill(trig);
		self thread [[level.opt[cmd][0]]] (arg1, arg2, arg3, arg4, arg5);
		wait delay;
	}
	self iprintlnbold("Advanced mode disabled, trigger loop killed!");
}
// "/notify <str>"
sendnotify(str)
{
	if (self.safemode)
	{
		self iprintln("^1Error: ^7Command can be misused and your advanced features are locked!");
		self iprintln("Use /tavm to unlock this command!");
		return;
	}
	self notify(str);
}
// "/getdistance <player>"
getdistance(play)
{
	self iprintln("Distance from you to " + play.name + " is " + Distance(self.origin, play.origin));
}
setaDvar(str, str2)
{
	if (self.safemode)
	{
		self iprintln("^1Error: ^7Command can be misused and your advanced features are locked!");
		self iprintln("Use /tavm to unlock this command!");
		return;
	}
	if (!isDefined(str) || !isDefined(str2))
	{
		self iprintln("^1Error: You must enter atleast 2 string arguements");
		return;
	}
	setDvar(str, str2);
}





