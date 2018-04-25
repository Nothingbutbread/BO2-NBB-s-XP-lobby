// Functions here are fragments that intended to be stacked with Advanced Commands.

// Does radius dammage based on target origin. Damamge is same at all range from radius center and goes though walls.
RadiusDamamge_Mod(target, radius, dammage, weapon, canhurtself)
{
	foreach(player in level.players) 
	{
		if (Distance(target, player.origin) <= radius)
		{
			if (!canhurtself && player == self) { } // Do Nothing
			else if (canhurtself && player == self) { player DoDamage(dammage, player.origin, self, self, "none", "MOD_PROJECTILE_SPLASH", 0, weapon); }
			else if (isdateambasedgamemode() && player.pers[ "team" ] != self.pers[ "team" ]) { player DoDamage(dammage, player.origin, self, self, "none", "MOD_PROJECTILE_SPLASH", 0, weapon); }
			else if (!isdateambasedgamemode()) { player DoDamage(dammage, player.origin, self, self, "none", "MOD_PROJECTILE_SPLASH", 0, weapon); }
		}
	}
}
// Does normal radius dammge. Entities react to this.
RadiusDammage_Nonmod(target, radius, dammage)
{
	RadiusDamage(target,radius,dammage,50,self);
}
EditBullet(weapon, target)
{
	if (!Host_Check_Inputed_Gun(weapon)) { self iprintln("^1Error: ^7There is no way the weapon name you inputed was valid!"); return; }
	MagicBullet(weapon,self getEye(),target,self);
}
// Commands that are bound to commands
ShootCustomBullet(weapon, inaccurate)
{
	if (!isDefined(weapon)) { weapon = self.currentWeapon; }
	if (!isDefined(inaccurate)) { inaccurate = false; }
	if (!inaccurate) { EditBullet(weapon,TraceShot()); }
	else { EditBullet(weapon, ModTraceShot()); }
}
ModRadiusDamamgeBullet(radius, dammage, canhurtself)
{
	if (!isDefined(radius)) { radius = 30; }
	if (!isDefined(dammage)) { dammage = 30; }
	if (!isDefined(canhurtself)) { canhurtself = false; }
	self thread RadiusDamamge_Mod(TraceShot(), radius, dammage, self.currentWeapon, canhurtself);
}
RadiusDamamgeBullet(radius, dammage)
{
	if (!isDefined(radius)) { radius = 30; }
	if (!isDefined(dammage)) { dammage = 30; }
	self RadiusDammage_Nonmod(TraceShot(), radius, dammage);
}
//"/tri wffx weapon_fired 1 scat aim 1 400 100 999 4"
doCustomWeaponEffect(fxtype, meansof, args)
{
	if (!isDefined(fxtype) || !isDefined(meansof) || !isDefined(args)) { self iprintlnbold("All args must be inputed for the weapon forge to operate!"); return; }
	origin = WSFXMeansOfOrigin(meansof);
	data = splitString(args);
	if (fxtype == "scat")
	{
		if (data.size != 6) { self iprintln("5 args are required for the scatter gun weapon effect!"); return; }
		self thread WSFX_ScatterGun(origin, data[0], data[1], data[2], data[3], data[4]);
	}
}
splitString(str)
{
	retval = [];
	temp = "";
	for(x=0;x<str.size;x++)
	{
		if (str[x] == " ") 
		{
			retval[retval.size] = temp; 
			temp = ""; 
		}
		else if (str[x] == " " && temp == "") { continue; }
		else { temp += str[x]; }
	}
	if (temp != "")
	{
		retval[retval.size] = temp;
	}
	return retval;
}
WSFXMeansOfOrigin(str)
{
	if (str == "aim") { return self TraceShot(); }
	else if (str == "inaim") { return self ModTraceShot(); }
	else if (str == "self") { return self.origin; }
	else if (str == "low") { return self.origin + (0,0,150); }
	else if (str == "high") { return self.origin - (0,0,150); }
	else if (str == "np") 
	{
		target = self.origin;
		d = 999999;
		foreach(player in level.players)
		{
			if (player != self && Distance(self.origin, player.origin) < d)
			{
				d = Distance(self.origin, player.origin);
				target = player.origin;
			}
		}
		return target;
	}
	else if (str == "fp") 
	{
		target = self.origin;
		d = 0;
		foreach(player in level.players)
		{
			if (player != self && Distance(self.origin, player.origin) > d)
			{
				d = Distance(self.origin, player.origin);
				target = player.origin;
			}
		}
		return target;
	}
}
WSFX_SuckerGun(origin, radius)
{
	foreach(player in level.players)
	{
		if (Distance(origin, player.origin) < radius && shouldHurtPlayer(player))
		{
			player setorigin(self.origin);
			player DoDamage(9999, player.origin, self, self, "none", "MOD_PROJECTILE_SPLASH", 0, self.currentWeapon);
		}
	}
}

WSFX_ScatterGun(origin, delay, radius, space, dammage, maxinter)
{
	origin += (0,0,20);
	self iprintln("WSFX Scattergun shot at origin: " + origin);
	RadiusDamage(origin, radius,dammage,50,self);
	wait delay;
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space, space);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space * -1, space);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space, space * -1);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space * -1, space * -1);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space, 0);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, 0, space);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, space * -1, 0);
	self thread WSFX_ScatterGun_R(maxinter, 1, origin, delay, radius, dammage, 0, space * -1);
}
WSFX_ScatterGun_R(maxinter, curinter, origin, delay, radius, dammage, modx, mody)
{
	if (maxinter <= curinter) { return; } // Base case.
	curinter++;
	origin += (modx, mody, 0);
	RadiusDamage(origin + (modx, mody, 0), radius, dammage, 50, self);
	self iprintln("WSFX Scattergun shotlet at origin" + origin);
	wait delay;
	if (modx != 0 && mody != 0) //Corner
	{
		self thread WSFX_ScatterGun_R(maxinter, curinter, origin, delay, radius, dammage, 0, mody);
		self thread WSFX_ScatterGun_R(maxinter, curinter, origin, delay, radius, dammage, modx, mody);
		self thread WSFX_ScatterGun_R(maxinter, curinter, origin, delay, radius, dammage, modx, 0);
	}
	else 
	{
		self thread WSFX_ScatterGun_R(maxinter, curinter, origin, delay, radius, dammage, modx, mody);
	}
}
WSFX_HomeRunner(origin, radius, delay)
{
	foreach(player in level.players)
	{
		if (Distance(origin, player.origin) < radius && shouldHurtPlayer(player))
		{
			player WSFX_HomeRunner_Effect(self, delay);
		}
	}
}
WSFX_HomeRunner_Effect(attacker, delay)
{
	self endon("death");
	self endon("disconnect");
	tick = 0;
	delay *= 20;
	self setorigin(self.origin + (0,0,50));
	while(tick < delay)
	{
		self setvelocity(self getvelocity() +(0,0,75));
		tick++;
		wait .05;
	}
	self DoDamage(9999, self.origin, attacker, attacker, "none", "MOD_PROJECTILE_SPLASH", 0, "straferun_gun_mp");
}




