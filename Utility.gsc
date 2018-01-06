Or(a,b)
{
	if (a || b) { return true; }
	return false;
}
And(a,b)
{
	if (a && b) { return true; }
	return false;
}
Xor(a,b)
{
	if (a || b)
	{
		if (a && b) { return false; }
		return true;
	}
	return false;
}
Invert(a)
{
	if (a) { return false; }
	return true;
}
NoN(num)
{
	if (num >= 0)
		return num;
	return num * -1;
}
playerAnglesToForward(player, distance)
{
	return player.origin + VectorScale(AnglesToForward(player getPlayerAngles(), distance));
}
Preventforfeit()
{
    level endon("game_ended");
    while(true)
    {
        if(level.gameForfeited)
        {
            level.onForfeit = false;
            level.gameForfeited = false;
            level notify("abort forfeit");
        }
        wait 5;
    }
}
Get_Clantag(n)
{
	i = "";
	if (n[0] == "[")
	{
		a = 1;
		while(n[a] != "]")
		{
			i += n[a]; 
			a++;
		}
	}
	return i;
}
Get_Name_No_Clantag(n)
{
	i = "";
	if (n[0] == "[")
	{
		a = 1;
		while(n[a] != "]") { a++; }
		a++;
		for(x = a; n.size; x++) { i += n[x]; }
	}
	else { i = n; }
	return i;
}
GiveGun(weapon, camo)
{
	if (!isDefined(camo))
		camo = 1;
	if (self.currentWeapon == self.primaryWeapon)
		self.primaryWeapon = weapon;
	if (self.currentWeapon == self.secondaryWeapon)
		self.secondaryWeapon = weapon;
	if (self.currentWeapon == "knife_held_mp")
		self TakeWeapon("knife_held_mp");
	else
		self TakeWeapon(self.currentWeapon);
	self GiveWeapon(weapon);
	self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
	self SwitchToWeapon(weapon);
	self setcamo(camo, weapon);
	self SwitchToWeapon(weapon);
	self giveMaxAmmo(weapon);
}
setcamo(camo, g)
{
	if (!isdefined(g))
		g = self getCurrentWeapon();
	if (g != "minigun_wager_mp" && "m32_wager_mp" != g)
	{
		self takeWeapon(g);
		self giveWeapon(g,0,true(camo,0,0,0,0));
	}
}
TraceShot() { return bulletTrace(self getEye(), self getEye()+vectorScale(anglesToForward(self getPlayerAngles()), 999999), false, self)["position"]; }
ModTraceShot(origin)
{
	angle = self getPlayerAngles();
	adjustx = RandomIntRange(-9, 9);
	adjusty = RandomIntRange(-9, 9);
	temp = angle[0] + adjustx;
	if (temp < 0)
	{
		temp = NoN(temp);
		temp = 360 - temp;
	}
	else if (temp >= 360)
		temp -= 360;
	adjustx = temp;
	temp = angle[1] + adjusty;
	if (temp < 0)
	{
		temp = NoN(temp);
		temp = 360 - temp;
	}
	else if (temp >= 360)
		temp -= 360;
	adjusty = temp;
	angle = (adjustx, adjusty, angle[2]);
	return bulletTrace(self getEye(), self getEye()+vectorScale(anglesToForward(angle), 1000000), false, self)["position"];
}
Play_A_Sound(str)
{
	if (!isDefined(str)) { str = "mpl_wager_humiliate"; self iprintln("^1You must input a string!"); }
	self playlocalsound(str);
}
isdateambasedgamemode()
{
	a = GetDvar("g_gametype");
	if (a == "oic" || a == "dm" || a == "gun" || a == "sas" || a == "shrp") { return false; }
	return true;
}
// Runs additional code should the game be in debugger mode.
// Debuggermode is not to be toggled from the menu.
DEBUG_DEBUGMODE()
{
	if (level.iamdebugging)
	{
		level.keyboardtextstring = "0 1 2 3 4 5 6 7 8 9\nA B C D E F G H I J\nK L M N O P Q R S T\nU V W X Y Z . _ / ^";
		self.HUD_KB setSafeText(level.keyboardtextstring);
		self.safemode = true;
	}
}
DEBUG_Setnewtext(str)
{
	if (!isDefined(str)) { self iprintln("You need a input string to set the keyboard to!"); return; }
	level.keyboardtextstring = str;
	self.HUD_KB setSafeText(level.keyboardtextstring);
	self iprintln("New Keyboard String set!");
}
//
