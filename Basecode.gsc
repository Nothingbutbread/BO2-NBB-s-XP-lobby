Menu_Init()
{
	self.menuinit = true; // Is the menu initiized.
	self.selplayer = self; // Sets the target player of the commands to the player running this cmd.
	self.menu_open = false;
	self.cmdstr = "";
	self.optioncycleindex = 0;
	self.storeage = [];
	//
	self.storeage[self.storeage.size] = "/tri scb weapon_fired 0.05 m32_wager_mp";
	self.storeage[self.storeage.size] = "/tri wffx weapon_fired 6 scat aim 1 400 100 999 4";
	//
	if (self.rank > 0)
	{
		self BuildHUDS();
		self thread OpenMenuBlind();
	}
}
// cmd is the command that must be inputed to use. Must be unique the command.
// func is the function it's self. add a " :: " to the start then the function name and remove the parenthasses.
// des is the description of the command. When help <your cmd> is sent, this is printed.
// In addition, the rank needed and arguments are printed as well. Description should have any other info.
// Array can only cotain these values:
// "str" - value is to be a string
// "float" - any number can inputed
// "int" - any integer can be inputed
// "bool" - booleans 
// "text" - Must be last, the rest of the input after this point is inputed as a string. 
// "player" - Uses the player selected bound to the player. 
// rank is the self.rank value that is required to use the command. Defaults to 100 (Host only).
CC(cmd, func, rank, des, arg0, arg1, arg2, arg3, arg4)
{
	// If this is ran, the command lacks the minium arguements needed to be used.
	if (!isdefined(cmd) || !isdefined(func))
		return; 
	if (!isdefined(rank))
		rank = 100; //Host only
	if (!isdefined(des))
		des = "No other infomation was provided"; //When not inputed, Will defualt to Nothing provided.
	if (!isdefined(arg0))
		arg0 = "*";
	if (!isdefined(arg1))
		arg1 = "*";
	if (!isdefined(arg2))
		arg2 = "*";
	if (!isdefined(arg3))
		arg3 = "*";
	if (!isdefined(arg4))
		arg4 = "*";
	level.opt[cmd][0] = func;
	level.opt[cmd][1] = rank;
	level.opt[cmd][2] = des;
	level.opt[cmd][3] = arg0;
	level.opt[cmd][4] = arg1;
	level.opt[cmd][5] = arg2;
	level.opt[cmd][6] = arg3;
	level.opt[cmd][7] = arg4;
	level.opt[cmd][8] = cmd;
}
//Takes a string that should be encoded with commands and aruguements for the commands.
//Tears the string apart and converts it commands and runs them.
//Will error and end before a command is run should invalid types and or commands interfear with
//a commands configuation.
Parse_cmd(str, looping)
{
	self endon("disconnect");
	//Determine the command name
	curstr = "";
	for(x=0;x<str.size;x++)
	{
		if (str[x] == " ")
		{
			index = x;
			if (isdefined(str[index + 1]))
				index++;
			break;
		}
		else
			curstr += str[x];
	}
	// If the command name isn't found, send error message and kill function.
	if (!isDefined(level.opt[curstr]))
	{
		self iprintln("^1You've inputed an invalid command!");
		self iprintln("^1Press the [Help] option or use /pac <float> to list all valid commands");
		return;
	}
	// The users rank needs to be suffeicent to use this command otherwise it will deny them access.
	if (level.opt[curstr][1] > self.rank)
	{
		self iprintln("^1Command rejected: ^7You lack the permission to use this command!");
		self iprintln("^1You have ^2" + self.rank + " ^1rank, you need ^3" + level.opt[curstr][1] + " ^1rank to use this command");
		if (!self.issuperuser) { return; } // If the user isn't the host (the superuser), the player can not override the permission rejection
		self iprintln("^1Warning: ^7Command block overiden, you rank was originaly not suffient for this command.");
	}
	cmd = curstr;
	inputs = [];
	for(j=0;j<5;j++)
		inputs[j] = undefined;
	// If the loop was broken out of, then there are other arugements.
	if (isDefined(index))
	{
		str += " ";
		args = [];
		for(k=3;k<8;k++)
			args[k - 3] = level.opt[cmd][k];
		// There has to be atleast 1 arguement to use this part of the code.
		if (args.size > 0)
		{
			args_index = 0;
			ref = "";
			curstr = "";
			for(x=index;x<str.size;x++)
			{
				if (str[x] == " ")
				{
					if (args[args_index] == "player") { inputs[args_index] = self.selplayer; }
					else if (args[args_index] == "bool")
					{
						if (curstr[0] == "f") { inputs[args_index] = false; }
						else if (curstr[0] == "t") { inputs[args_index] = true; }
						else { self iprintln("^1Error: When inputing boolean values, the value must start with f or t!"); return; }
					}
					else if (args[args_index] == "str")
						inputs[args_index] = curstr;
					else if (args[args_index] == "int")
					{
						temp = self get_num(curstr);
						if (temp[0] && temp[1])
							inputs[args_index] = temp[2];
						else
						{
							self iprintln("^1Error: That wasn't a number or it had a decimal.");
							return;
						}
					}
					else if (args[args_index] == "float")
					{
						temp = self get_num(curstr);
						if (temp[0])
							inputs[args_index] = temp[2];
						else
						{
							self iprintln("^1Error: That wasn't a number.");
							return;
						}
					}
					// If this is run, the rest of the input is preserved as a string.
					else if (args[args_index] == "text")
					{
						index = x;
						break;
					}
					else if (args[args_index] == "*")
						break;
					// If this else statement is ran, either there is a bug with the parser or an invalid arg type was set for the cmd.
					else
					{
						self iprintln("^1Command parser error: Command requested an unsurported arguement type!");
						return;
					}
					args_index++;
					curstr = "";
				}
				else
					curstr += str[x];
			}
		}
		if (args[args_index] == "text")
		{
			for(x=index;x<str.size;x++)
				curstr += str[x];
			inputs[args_index] = curstr;
		}
	}
	if (!looping) { self thread [[level.opt[cmd][0]]] (inputs[0], inputs[1], inputs[2], inputs[3], inputs[4]); return; }
	else
	{
		rettdata = [];
		rettdata[0] = cmd;
		rettdata[1] = inputs[0];
		rettdata[2] = inputs[1];
		rettdata[3] = inputs[2];
		rettdata[4] = inputs[3];
		rettdata[5] = inputs[4];
		return rettdata;
	}
}
// Takes a string and returns the number that is within in. 
// If no number is present, returns 0. Also returns if returned number is an int.
get_num(str)
{
	self endon("disconnect");
	isint = true;
	hadanumber = false;
	dec = 0;
	curnum = 0;
	for(x=0;x<str.size;x++)
	{
		if (str[x] == "0" || str[x] == "1" || str[x] == "2" || str[x] == "3" || str[x] == "4" || str[x] == "5" || str[x] == "6" || str[x] == "7" || str[x] == "8" || str[x] == "9")
		{
			hadanumber = true;
			num = int(str[x]);
			if (isint)
			{
				curnum *= 10;
				curnum += num;
			}
			else
			{
				dec++;
				for(y=0;y<dec;y++) { curnum *= 10; }
				curnum += num;
				curnum = int(curnum);
				for(y=0;y<dec;y++) { curnum /= 10; }
			}
		}
		else if (str[x] == "." && isint) { isint = false; }
		else { break; }
	}
	data = [];
	data[0] = hadanumber;
	data[1] = isint;
	data[2] = curnum;
	return data;
}

CreateText(item, fontScale, x, y, color, alpha, sort, text, allpeeps, foreground, normal)
{
	if (!allpeeps)
		hud = self createFontString("objective", fontScale);
	else
		hud = level createServerFontString("objective", fontScale);
	if (!text)
    	hud setValue(item);
    else
    	hud setSafeText(item);
    hud.x = x;
	hud.y = y;
	hud.color = color;
	hud.alpha = alpha;
    hud.sort = sort;
	hud.foreground = foreground;
	if (!isDefined(normal) || normal)
	{
		hud.alignX = "left";
		hud.horzAlign = "left";
		hud.vertAlign = "center";
	}
	return hud;
}
SpawnShader(shader, x, y, width, height, color, alpha, sort)
{
	hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
   // hud.foreground = true;
    return hud;
}
overflowfix()
{
	level endon("game_ended");
	level endon("host_migration_begin");
	
	test = level createServerFontString("default", 1);
	test setText("xTUL");
	test.alpha = 0;

	if(GetDvar("g_gametype") == "sd")
    	limit = 35;
    else
    	limit = 45; 

	while(1)
	{
		level waittill("textset"); 
		if(level.strings.size >= limit)
		{
			test ClearAllTextAfterHudElem();
			level.strings = [];//re-building the string array
			iprintln("^1Debug: ^5Overflow prevented!"); //Remove after finishing your menu. 
			foreach(player in level.players) { if (player.menuinit) { player Rebuildtext(); } }
		}
	}
}

setSafeText(text)
{
    if (!isInArray(level.strings, text))
    {
        level.strings[level.strings.size] = text;
        self setText(text);
        level notify("textset");
    }
    else
        self setText(text);
}
Rebuildtext()
{
	self.HUD_KB setSafeText("0 1 2 3 4 5 6 7 8 9\nA B C D E F G H I J\nK L M N O P Q R S T\nU V W X Y Z . _ / ^");
	self.HUD_KB_speical setSafeText("[Space]\n[Run CMD]\n[Back]\n[Clear]\n[Help]\n[New CMD]\n[Player]\n[Exit]");
	self.HUD_CMD_text setSafeText("$ " + self.cmdstr);
	self.HUD_Menu_Name setSafeText("^5NBB's XP lobby V^1" + level.id_version);
	self.HUD_Info_text setSafeText(self.infobarstr);
	self.HUD_Info_text_2 setSafeText(self.infobarstr2);
}
// Creating the Keyboard //
BuildHUDS()
{
	self.HUD_KB_sel_left = self SpawnShader("white", -265, 60, 75, 25, (1,0,0), 0, 10);
	self.HUD_KB_sel_right = self SpawnShader("white", -206, 60, 20, 32, (1,0,0), 0, 10);
	self.HUD_BG_KB = self SpawnShader("white", -150, 60, 320, 200, (0,0,0), 0, 5);
	self.HUD_CMD_text = self CreateText("$ ", 2.4, 55, 30, (1,1,1), 0, 50, true, false, true, true);
	self.HUD_Menu_Name = self CreateText("^5NBB's XP lobby V^1" + level.id_version, 3, 80,-5, (1,1,1), 0, 20, true, false, true, true);
	self.HUD_BG_CMD = self SpawnShader("white", 190, 30, 1000, 30, (0,0,0), 0, 5);
	// SpawnShader(shader, x, y, width, height, color, alpha, sort)
	self.HUD_Info = self SpawnShader("white", 0, 360, 1000, 45, (.3, .3, .3), .8, 1);
	self.HUD_Info_text = self CreateText("Press ADS and [{+melee}] to open the terminal", 2, 0, 360, (1,1,1), 1, 20, true, false, true, false);
	self.HUD_Info_text_2 = self CreateText(" ", 2, 0, 380, (1,1,1), 1, 20, true, false, true, false);
	// -85 / 450
	self.HUD_x = 0;
	self.HUD_y = 0;
	self.HUD2_y = 0;
	self.cmdstr = "";
	self.infobarstr = "Press ADS and [{+melee}] to open the terminal";
	self.infobarstr2 = " ";
	//01234 56789
	//ABCDE FGHIJ
	//KLMNO PQRST
	//UVWXY Z.^|/
	self.HUD_KB = self CreateText("0 1 2 3 4 5 6 7 8 9\nA B C D E F G H I J\nK L M N O P Q R S T\nU V W X Y Z . _ / ^", 3, 150, 60, (1,1,1), 0, 50, true, false, true, true);
	self.HUD_KB_speical = self CreateText("[Space]\n[Run CMD]\n[Back]\n[Clear]\n[Help]\n[New CMD]\n[Player]\n[Exit]", 2, 62, 60, (1,1,1), 0, 50, true, false, true, true);
}
Map_CMD()
{
	self endon("disconnect");
	if (self.HUD_x == 0)
	{
		y = self.HUD2_y;
		if (y == 0)
			self.cmdstr += " ";
		if (y == 1)
			self thread Parse_cmd(self.cmdstr, false);
		if (y == 2)
			self thread back_space();
		if (y == 3)
			self.cmdstr = "";
		if (y == 4)
		{
			self notify("stop_printing_all_cmds");
			self thread printallcmds(1);
			wait 10;
		}
		if (y == 5) { self thread CycleCommands(); }
		if (y == 6) { self.cmdstr += self.selplayer.name; }
		if (y == 7) { self thread CloseMenu(); }
		self.HUD_CMD_text setSafeText("$ " + self.cmdstr);
		self Update_InfoBar_dynamic();
	}
	else
	{
		self.cmdstr += self get_char(self.HUD_x, self.HUD_y);
		self.HUD_CMD_text setSafeText("$ " + self.cmdstr);
		self Update_InfoBar_dynamic();
	}
}
back_space()
{
	str = "";
	for(x=0;x<self.cmdstr.size - 1;x++)
		str += self.cmdstr[x];
	self.cmdstr = str;
	self.HUD_CMD_text setSafeText("$ " + self.cmdstr);
	self Update_InfoBar_dynamic();
}
get_char(x,y)
{
	if (x == 10)
	{
		if (y == 0)
			return "9";
		if (y == 1)
			return "j";
		if (y == 2)
			return "t";
		else
			return "^";
	}
	else if (x == 9)
	{
		if (y == 0)
			return "8";
		if (y == 1)
			return "i";
		if (y == 2)
			return "s";
		else
			return "/";
	}
	else if (x == 8)
	{
		if (y == 0)
			return "7";
		if (y == 1)
			return "h";
		if (y == 2)
			return "r";
		else
			return "_";
	}
	else if (x == 7)
	{
		if (y == 0)
			return "6";
		if (y == 1)
			return "g";
		if (y == 2)
			return "q";
		else
			return ".";
	}
	else if (x == 6)
	{
		if (y == 0)
			return "5";
		if (y == 1)
			return "f";
		if (y == 2)
			return "p";
		else
			return "z";
	}
	else if (x == 5)
	{
		if (y == 0)
			return "4";
		if (y == 1)
			return "e";
		if (y == 2)
			return "o";
		else
			return "y";
	}
	else if (x == 4)
	{
		if (y == 0)
			return "3";
		if (y == 1)
			return "d";
		if (y == 2)
			return "n";
		else
			return "x";
	}
	else if (x == 3)
	{
		if (y == 0)
			return "2";
		if (y == 1)
			return "c";
		if (y == 2)
			return "m";
		else
			return "w";
	}
	else if (x == 2)
	{
		if (y == 0)
			return "1";
		if (y == 1)
			return "b";
		if (y == 2)
			return "l";
		else
			return "v";
	}
	else if (x == 1)
	{
		if (y == 0)
			return "0";
		if (y == 1)
			return "a";
		if (y == 2)
			return "k";
		else
			return "u";
	}
	else
		self iprintln("^1Error, command not reconized!");
}
// Original Default was 20
// Shader starting location X: -206, Y: 60
Keyboard_MoveAmount_X(x, y)
{
	if (x == 10) // Base -26
	{
		if (y == 0) { return -35; }
		else if (y == 1) { return -38; }
		else if (y == 2) { return -26; }
		else { return -28; }
	}
	else if (x == 9) // Base -46
	{
		if (y == 0) { return -54; }
		else if (y == 1) { return -49; }
		else if (y == 2) { return -46; }
		else { return -52; }
	}
	else if (x == 8) // Base -66
	{
		if (y == 0) { return -75; }
		else if (y == 1) { return -68; }
		else if (y == 2) { return -65; }
		else { return -68; }
	}
	else if (x == 7) // Base -86
	{
		if (y == 0) { return -92; }
		else if (y == 1) { return -89; }
		else if (y == 2) { return -86; }
		else { return -87; }
	}
	else if (x == 6) // Base -106
	{
		if (y == 0) { return -115; }
		else if (y == 1) { return -108; }
		else if (y == 2) { return -106; }
		else { return -95; }
	}
	else if (x == 5) // Base -126
	{
		if (y == 0) { return -132; }
		else if (y == 1) { return -126; }
		else if (y == 2) { return -126; }
		else { return -116; }
	}
	else if (x == 4) // Base -146
	{
		if (y == 0) { return -152; }
		else if (y == 1) { return -146; }
		else if (y == 2) { return -146; }
		else { return -140; }
	}
	else if (x == 3) // Base -166
	{
		if (y == 0) { return -172; }
		else if (y == 1) { return -166; }
		else if (y == 2) { return -168; }
		else { return -162; }
	}
	else if (x == 2) // Base -186
	{
		if (y == 0) { return -190; }
		else if (y == 1) { return -186; }
		else if (y == 2) { return -186; }
		else { return -180; }
	}
	else { return -206; } // Base -206
}
Keyboard_Controls()
{
	self endon("disconnect");
	while(self.menu_open)
	{
		if(self actionslotfourbuttonpressed() && self.HUD_x < 10)
		{
			if (self.HUD_x == 0)
			{
				self.HUD_KB_sel_left.alpha = 0;
				self.HUD_KB_sel_right.alpha = .9;
				self.HUD_x++;
			}
			else
			{
				self.HUD_x++;
				self.HUD_KB_sel_right moveOverTime(.05);
				self.HUD_KB_sel_right.x = Keyboard_MoveAmount_X(self.HUD_x,self.HUD_y);
			}
		}
		if(self actionslotthreebuttonpressed() && self.HUD_x > 0)
		{
			self.HUD_x--;
			if (self.HUD_x == 0)
			{
				self.HUD_KB_sel_left.alpha = .9;
				self.HUD_KB_sel_right.alpha = 0;
			}
			else
			{
				self.HUD_KB_sel_right moveOverTime(.05);
				self.HUD_KB_sel_right.x = Keyboard_MoveAmount_X(self.HUD_x,self.HUD_y);
			}
		}
		if(self actionslottwobuttonpressed())
		{
			if (self.HUD_x == 0 && self.HUD2_y < 7)
			{
				self.HUD_KB_sel_left moveOverTime(.05);
				self.HUD_KB_sel_left.y += 24;
				self.HUD2_y++;
			}
			else if (self.HUD_y < 3)
			{
				self.HUD_y++;
				self.HUD_KB_sel_right moveOverTime(.05);
				self.HUD_KB_sel_right.y += 36;
				self.HUD_KB_sel_right.x = Keyboard_MoveAmount_X(self.HUD_x,self.HUD_y);
			}
		}
		if(self actionslotonebuttonpressed())
		{
			if (self.HUD_x == 0 && self.HUD2_y > 0)
			{
				self.HUD_KB_sel_left moveOverTime(.05);
				self.HUD_KB_sel_left.y -= 24;
				self.HUD2_y--;
			}
			else if (self.HUD_y > 0)
			{
				self.HUD_y--;
				self.HUD_KB_sel_right moveOverTime(.05);
				self.HUD_KB_sel_right.y -= 36;
				self.HUD_KB_sel_right.x = Keyboard_MoveAmount_X(self.HUD_x,self.HUD_y);
			}
		}
		if(self usebuttonpressed())
		{
			self thread Map_CMD();
			wait .2;
		}
		wait .05;
	}
}
OpenMenuBlind()
{
	self endon("disconnect");
	while((self.rank > 0 && !self.menu_open) || (self.issuperuser && !self.menu_open)) // Impossible to remove menu from host.
	{
		if (self adsbuttonpressed() && self meleebuttonpressed())
			self thread OpenMenu();
		wait .1;
	}
}
OpenMenu()
{
	self endon("disconnect");
	self.menu_open = true;
	self.HUD_KB FadeOverTime(.5);
	self.HUD_KB_speical FadeOverTime(.5);
	self.HUD_CMD_text FadeOverTime(.5);
	self.HUD_KB_sel_left FadeOverTime(.5);
	self.HUD_KB_sel_right FadeOverTime(.5);
	self.HUD_BG_KB FadeOverTime(.5);
	self.HUD_BG_CMD FadeOverTime(.5);
	self.HUD_Menu_Name FadeOverTime(.5);
	if (self.HUD_x == 0)
	{
		self.HUD_KB_sel_left.alpha = .9;
		self.HUD_KB_sel_right.alpha = 0;
	}
	else
	{
		self.HUD_KB_sel_left.alpha = 0;
		self.HUD_KB_sel_right.alpha = .9;
	}
	self.HUD_BG_CMD.alpha = 1;
	self.HUD_KB.alpha = 1;
	self.HUD_KB_speical.alpha = 1;
	self.HUD_CMD_text.alpha = 1;
	self.HUD_BG_KB.alpha = 1;
	self.HUD_Menu_Name.alpha = 1;
	wait .5;
	self.infobarstr = self Update_InfoBar_dynamic();
	self thread Keyboard_Controls();
}
CloseMenu()
{
	self endon("disconnect");
	self.HUD_KB FadeOverTime(.5);
	self.HUD_KB_speical FadeOverTime(.5);
	self.HUD_CMD_text FadeOverTime(.5);
	self.HUD_KB_sel_left FadeOverTime(.5);
	self.HUD_KB_sel_right FadeOverTime(.5);
	self.HUD_BG_KB FadeOverTime(.5);
	self.HUD_BG_CMD FadeOverTime(.5);
	self.HUD_Menu_Name FadeOverTime(.5);
	
	self.HUD_KB.alpha = 0;
	self.HUD_KB_speical.alpha = 0;
	self.HUD_CMD_text.alpha = 0;
	self.HUD_KB_sel_left.alpha = 0;
	self.HUD_KB_sel_right.alpha = 0;
	self.HUD_BG_KB.alpha = 0;
	self.HUD_BG_CMD.alpha = 0;
	self.HUD_Menu_Name.alpha = 0;
	wait .5;
	self.infobarstr = "Press ADS and [{+melee}] to open the terminal";
	self.infobarstr2 = " ";
	self.HUD_Info_text setSafeText(self.infobarstr);
	self.HUD_Info_text_2 setSafeText(self.infobarstr2);
	self.menu_open = false;
	self thread OpenMenuBlind();
}
RemoveMenu()
{
	if (self.menu_open) { self thread CloseMenu(); }
	self.HUD_Info_text.alpha = 0;
	self.HUD_Info_text_2.alpha = 0;
	self.HUD_Info.alpha = 0;
}
ReGiveMenu()
{
	if (self.menuinit) 
	{
		self.HUD_Info_text.alpha = 1;
		self.HUD_Info_text_2.alpha = 1;
		self.HUD_Info.alpha = .8;
		self thread OpenMenuBlind();
		self.infobarstr = "Press ADS and [{+melee}] to open the terminal";
		self.infobarstr2 = " ";
		self.HUD_Info_text setSafeText(self.infobarstr);
		self.HUD_Info_text_2 setSafeText(self.infobarstr2);
	}
}
Update_InfoBar_dynamic()
{
	cmd = "";
	index = 0;
	if (self.cmdstr == "") { self.infobarstr = "^1Nothing is typed in! ^7Use /pac <float> to print all commands."; self.infobarstr2 = " "; self.HUD_Info_text setSafeText(self.infobarstr); self.HUD_Info_text_2 setSafeText(self.infobarstr2); return; }
	for(j=0;j<self.cmdstr.size;j++) { if (self.cmdstr[j] != " ") { cmd += self.cmdstr[j]; } else { index = j + 1; break; } }
	if (!isDefined(level.opt[cmd])) { self.infobarstr = "^1" + cmd + " is an invalid command! ^7Use /pac <float to print all commands."; self.infobarstr2 = " "; }
	else 
	{
		level.opt[cmd][2] = des;
		if (level.opt[cmd][1] <= self.rank) { self.infobarstr = "^2"; }
		else { self.infobarstr = "^3"; }
		self.infobarstr += cmd + ": ^7" + level.opt[cmd][2];
		args = "Args taken: ";
		for(x=3;x<8;x++) 
		{ 
			if (level.opt[cmd][x] != "*") {  args += "<" + level.opt[cmd][x] + "> "; } 
			else { break; }
		}
		if (args == "Args taken: ") {  args = "Dosn't take any Arguments"; }
		self.infobarstr2 = args;
	}
	self.HUD_Info_text setSafeText(self.infobarstr);
	if (level.opt[cmd] == "p")
	{
		if (self.cmdstr.size == 3)
		{
			data = get_num(self.cmdstr[2]);
			if (data[0] && data[1]) { if (isDefined(level.players[data[2]])) {  self.infobarstr2 += " ^6Player at index " + data[2] + ": ^2" + level.players[data[2]].name; } }
		}
		if (self.cmdstr.size == 4)
		{
			g = self.cmdstr[2] + self.cmdstr[3];
			data = get_num(g);
			if (data[0] && data[1]) { if (isDefined(level.players[data[2]])) { self.infobarstr2 += " ^6Player at index " + data[2] + ": ^2" + level.players[data[2]].name; } }
		}
	}
	self.HUD_Info_text_2 setSafeText(self.infobarstr2);
}
CycleCommands()
{
	if (level.opt.size <= self.optioncycleindex) { self.optioncycleindex = 0; }
	x = 0;
	foreach(cmd in level.opt)
	{
		if (x == self.optioncycleindex)
		{
			self.optioncycleindex++;
			self.cmdstr = cmd[8];
			self Update_InfoBar_dynamic();
			return;
		}
		x++;
	}
}








