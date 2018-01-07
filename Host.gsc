Host_doPerks(modded, play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Given all perks to " + play.name); }
	if (!isDefined(modded)) { modded = true; }
	play clearperks();
	play setperk("specialty_additionalprimaryweapon");
	play setperk("specialty_armorpiercing");
	play setperk("specialty_armorvest");
	play setperk("specialty_bulletaccuracy");
	play setperk("specialty_bulletdamage");
	play setperk("specialty_bulletflinch");
	play setperk("specialty_bulletpenetration");
	play setperk("specialty_deadshot");
	play setperk("specialty_delayexplosive");
	play setperk("specialty_detectexplosive");
	play setperk("specialty_disarmexplosive");
	play setperk("specialty_earnmoremomentum");
	play setperk("specialty_explosivedamage");
	play setperk("specialty_extraammo");
	play setperk("specialty_fallheight");
	play setperk("specialty_fastads");
	play setperk("specialty_fastequipmentuse");
	play setperk("specialty_fastladderclimb");
	play setperk("specialty_fastmantle");
	play setperk("specialty_fastmeleerecovery");
	play setperk("specialty_fastreload");
	play setperk("specialty_fasttoss");
	play setperk("specialty_fastweaponswitch");
	play setperk("specialty_finalstand");
	play setperk("specialty_fireproof");
	play setperk("specialty_flakjacket");
	play setperk("specialty_flashprotection");
	play setperk("specialty_gpsjammer");
	play setperk("specialty_grenadepulldeath");
	play setperk("specialty_healthregen");
	play setperk("specialty_holdbreath");
	play setperk("specialty_immunecounteruav");
	play setperk("specialty_immuneemp");
	play setperk("specialty_immunemms");
	play setperk("specialty_immunenvthermal");
	play setperk("specialty_immunerangefinder");
	play setperk("specialty_killstreak");
	play setperk("specialty_longersprint");
	play setperk("specialty_loudenemies");
	play setperk("specialty_marksman");
	play setperk("specialty_movefaster");
	play setperk("specialty_nomotionsensor");
	play setperk("specialty_noname");
	play setperk("specialty_nottargetedbyairsupport");
	play setperk("specialty_nokillstreakreticle");
	play setperk("specialty_nottargettedbysentry");
	play setperk("specialty_pin_back");
	play setperk("specialty_pistoldeath");
	play setperk("specialty_proximityprotection");
	play setperk("specialty_quickrevive");
	play setperk("specialty_quieter");
	play setperk("specialty_reconnaissance");
	play setperk("specialty_rof");
	play setperk("specialty_scavenger");
	play setperk("specialty_showenemyequipment");
	play setperk("specialty_stunprotection");
	play setperk("specialty_shellshock");
	play setperk("specialty_sprintrecovery");
	play setperk("specialty_showonradar");
	play setperk("specialty_stalker");
	play setperk("specialty_twogrenades");
	play setperk("specialty_twoprimaries");
	play setperk("specialty_unlimitedsprint");
	if (modded)
	{
		if (!play.electriccherry) { play thread Host_ElectricCherry(); }
	}
	play iprintln("^5All Perks Given");
}
Host_unlimited_ammo_toggle(includeclip, play)
{
	if (!isDefined(includeclip)) { includeclip = true; }
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled Unlimmited Ammo for " + play.name); }
	if (!isDefined(play.unlimmitedammo)) { play.unlimmitedammo = false; }
	if (!play.unlimmitedammo) { play.unlimmitedammo = true; play thread Host_unlimited_ammo(includeclip); play iprintln("^5Unlimited Ammo ^2Enabled"); }
	else { play.unlimmitedammo = false; play iprintln("^5Unlimited Ammo ^1Disabled"); }
}
Host_unlimited_ammo(includeclip)
{
	self endon("disconnect");
    while(self.unlimmitedammo)
    {
        currentWeapon = self getcurrentweapon();
        if ( currentWeapon != "none" )
        {
        	self givemaxammo( currentWeapon );
        	if (includeclip) { self setweaponammoclip( currentWeapon, weaponclipsize(currentWeapon) ); }
        }
		if (includeclip)
		{
	        currentoffhand = self getcurrentoffhand();
	        if ( currentoffhand != "none" )
	            self givemaxammo( currentoffhand );
	    }
	    wait 0.1;
    }
}
Host_Forgemode_toggle(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled Forge Mode for " + play.name); }
	if (!isDefined(play.forgemode)) { play.forgemode = false; }
	if (play.forgemode) { play.forgemode = false; play iprintln("Forge Mode has been ^1Disabled!"); }
	else { play.forgemode = true; play thread Host_ForgeMode(); play iprintln("Forge Mode has been ^2Enabled!"); }
}
Host_ForgeMode()
{
	self iprintln("^5Aim at objects to move them!\n^7You can use the terminal to adjust the angles and origin manualy\nof your most recently edited object.");
	axis = 0;
	ammout = 5;
	while(self.forgemode)
	{
		while(self adsbuttonpressed())
		{
			trace = bulletTrace(self GetTagOrigin("j_head"),self GetTagOrigin("j_head")+ anglesToForward(self GetPlayerAngles())* 1000000,true,self);
			while(self adsbuttonpressed())
			{
				self.selentity = trace["entity"];
				trace["entity"] setOrigin(self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200);
				trace["entity"].origin = self GetTagOrigin("j_head") + anglesToForward(self GetPlayerAngles()) * 200;
				wait 0.1;
			}
		}
		wait 0.1;
	}
}
Host_Forge_Adjustangles(in1, in2, in3)
{
	if (!isDefined(self.selentity)) { self iprintln("^1Error: ^7You need to use forge mode to select an entity first!\nUse 'fm' to do so"); return; }
	if (!isDefined(in1) || !isDefined(in2) || !isDefined(in3)) { self iprintln("^1Error: ^7You must input 3 integers between 0 and 359"); return; }
	if (in1 >= 0 && in1 < 360 && in2 >= 0 && in2 < 360 && in3 >= 0 && in3 < 360) { self.selentity.angles = (in1, in2, in3); self iprintln("^2Angles set succesfuly!"); }
	else { self iprintln("^1Error: ^7The inputed integers must be between 0 and 359"); }
}
Host_Forge_Adjustorigin(in1, in2, in3)
{
	if (!isDefined(self.selentity)) { self iprintln("^1Error: ^7You need to use forge mode to select an entity first!\nUse 'fm' to do so"); return; }
	if (!isDefined(in1) || !isDefined(in2) || !isDefined(in3)) { self iprintln("^1Error: ^7You must input 3 integers."); return; }
	self.selentity moveto((in1, in2, in3), .05);
}
Host_doTeleport()
{
	self endon("disconnect");
	self beginLocationSelection( "map_mortar_selector" ); 
	self.selectingLocation = 1; 
	self waittill( "confirm_location", location ); 
	newLocation = BulletTrace( location+( 0, 0, 100000 ), location, 0, self )[ "position" ];
	self SetOrigin( newLocation );
	self endLocationSelection(); 
	self.selectingLocation = undefined;
	self iPrintLn("^2Teleported!");
}
Host_invisablity()
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled Invisablity for " + play.name); }
	if (!isDefined(play.isvanished)) { play.isvanished = false; }
	if (play.isvanished) { play.isvanished = false; play show(); play iprintln("You are now ^1Visable!"); }
	else { play.isvanished = true; play hide(); play iprintln("You are now ^2invisable!"); }
}
Host_ElectricCherry(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled Electric Cherry for " + play.name); }
	if (!isDefined(play.electriccherry)) { play.electriccherry = false; }
	if (play.electriccherry) { play.electriccherry = false; play iprintln("Electric Cherry has been ^1Disabled!"); }
	else { play.electriccherry = true; play thread Host_ElectricCherry_effect(); }
}
Host_ElectricCherry_effect()
{
	self endon("disconnect");
	self iprintln("Electric Cherry has been ^1Enabled!");
	while(self.electriccherry)
	{
		self waittill("reload_start");
		playFxOnTag( level._effect["prox_grenade_player_shock"], self, "j_head");
		playFxOnTag( level._effect["prox_grenade_player_shock"], self, "J_Spine1");
		playFxOnTag( level._effect["prox_grenade_player_shock"], self, "J_Spine4");
		playFxOnTag( level._effect["prox_grenade_player_shock"], self, "pelvis");
		self PlaySound("wpn_taser_mine_zap");
		if (!self.godmode) { self EnableInvulnerability(); }
		RadiusDamage(self.origin,200,9999,50,self);
		wait .5;
		if (!self.godmode) { self DisableInvulnerability(); }
	}
}
Host_setCamo(num, play)
{
	if (!isDefined(num)) { self iprintln("^1Error: You must input an integer to use this command!"); return; }
	if (num < 1 || num > 44) { self iprintln("^1Error: Valid integer input is 1 - 44"); return; }
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Set a camo with the index of " + num + " on " + play.name + "'s gun"); }
	w = play getCurrentWeapon();
	play takeWeapon(w);
	play giveWeapon(w,0,true(num,0,0,0,0));
	play setSpawnWeapon(w);
}
Host_unfairaimBot(str)
{
	if (!isDefined(str)) { str = "u"; }
	if (str.size == 0) { str = "u"; }
	if (!self.hasunfairaimbot && str[0] == "u")
	{
		self iprintln("^5Unfair Aimbot ^2Enabled");
		self.hasunfairaimbot = true;
		self thread Host_unfairaimBot1();
	}
	else if (!self.hasunfairaimbot && str == "s")
	{
		self iprintln("^5Silent Aimbot ^2Enabled");
		self.hasunfairaimbot = true;
		self thread Host_unfairaimBot2();
	}
	else if (!self.hasunfairaimbot && str == "f")
	{
		self iprintln("^5Fair Aimbot ^2Enabled");
		self.hasunfairaimbot = true;
		self thread Host_fairaimbot();
	}
	else 
	{
		self iprintln("^5Aimbot ^1Disabled");
		self.hasunfairaimbot = false;
	}
}
Host_fairaimbot()
{
	self endon("disconnect");
	while(self.hasunfairaimbot)
	{
		distance = 99999;
		target = self;
		if(self adsbuttonpressed())
		{
			foreach(player in level.players)
			{
				if (player != self && isAlive(player))
				{
					if (level.teamBased && self.pers["team"] == player.pers["team"]) { continue; }
					if (Distance(self.origin, player.origin) < distance) { target = player; distance = Distance(self.origin, player.origin); }
				}
			}
			if (target != self) { self setplayerangles(VectorToAngles((target getTagOrigin("j_head")) - (self getTagOrigin("j_head")))); }
		}
		wait .1;
	}
}
Host_unfairaimBot2()
{
	self endon("disconnect");
	while(self.hasunfairaimbot)
	{
		if(self attackbuttonpressed() && self adsbuttonpressed())
		{
			foreach(player in level.players)
			{
				if (player != self && isAlive(player))
				{
					if (level.teamBased && self.pers["team"] == player.pers["team"]) { continue; }
					player thread [[level.callbackPlayerDamage]]( self, self, 999, 0, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0, 0 );
					break;
				}
			}
		}
		wait .1;
	}
}
Host_unfairaimBot1()
{
	self endon("disconnect");
	while(self.hasunfairaimbot)
	{
		aimAt = undefined;
		foreach(player in level.players)
		{
			if((player == self) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"])) { continue; }
			if(isDefined(aimAt)) { if(closer(self getTagOrigin("j_head"), player getTagOrigin("j_head"), aimAt getTagOrigin("j_head"))) { aimAt = player; } }
			else { aimAt = player; }
		}
		if(isDefined(aimAt)) 
		{
			if(self adsbuttonpressed())
			{
				self setplayerangles(VectorToAngles((aimAt getTagOrigin("j_head")) - (self getTagOrigin("j_head")))); 
				if(self attackbuttonpressed()) { aimAt thread [[level.callbackPlayerDamage]]( self, self, 999, 0, "MOD_HEAD_SHOT", self getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0, 0 ); }
			}
		}
		wait 0.1;
	}
}
Host_Toggle_Noclip(play)
{
    if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled Noclip for " + play.name); }
	
	if (!isDefined(play.noclip)) { play.noclip = false; }
	if (!play.noclip)
	{
		play.noclip = true;
		play thread Host_Noclip();
		play iprintln("Noclip ^2Enabled!. Press [{+gostand}] to move");
	}
	else
	{
		play.noclip = false;
		play iprintln("Noclip ^1Disabled!.");
	}
}
Host_Noclip()
{
	self endon("disconnect");
	obj = spawn("script_origin", self.origin);
	obj.angles = self.angles;
	self PlayerLinkTo(obj, undefined);
	while(self.noclip) { if (self jumpbuttonpressed()) { obj moveTo(playerAnglesToForward(self, 50), 0.1); } wait .1; }
	self unlink();
    obj delete();
}
Host_GiveRandomCamo(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Set a random camo on " + play.name + "'s gun"); }
	c = RandomIntRange(1,45);
	w = play getCurrentWeapon();
	play takeWeapon(w);
	play giveWeapon(w,0,true(c,0,0,0,0));
	play setSpawnWeapon(w);
}
setPlayerSpeed(float, play)
{
	if (!isdefined(float))
	{
		self iprintlnbold("^1No input detected!, set to default");
		float = 1;
	}
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Set the speed of " + play.name + " to " + float); }
	play setmovespeedscale(float);
	play iprintln("Your movement speed has been set to " + float);
}

godMode(play)
{
	if (!isDefined(play)) { play = self; }
	if (play != self) { self iprintln("Toggled godmode for " + play.name); }
	if (play.godmode)
	{
		play.godmode = false;
		play.health = 100;
		play.maxhealth = 100;
		play iprintln("^5God mode ^1Disabled");
		play disableInvulnerability();
		return;
	}
	play.godmode = true;
	play.health = 100000;
	play.maxhealth = 100000;
	play iprintln("^5God mode ^2Enabled");
	play enableInvulnerability();
}
// gg <str> <int> <str> <str> <str>
Host_GiveGun(gun, camo, a1, a2, a3)
{
	if (!isDefined(gun)) { self iprintln("^1Error: ^7You must input a string!"); return; }
	if (!Host_Check_Inputed_Gun(gun)) { self iprintln("^1Error: ^7There is no way the gun name you inputed was valid!"); return; }
	weapon = gun;
	if (isDefined(a1) && a1 != "") { weapon += "+" + a1; }
	if (isDefined(a2) && a2 != "") { weapon += "+" + a2; }
	if (isDefined(a3) && a3 != "") { weapon += "+" + a3; }
	self GiveGun(weapon, camo);
}
// Does some basic checks on the inputed gun to reduce the ammout of invalid guns inputed.
// Checks to see if the size of the gun string is long enough to be one and that it ends with _mp
Host_Check_Inputed_Gun(gun)
{
	a = gun.size;
	b = a - 3;
	if (a < 6) { return false; } // Can't be a valid gun
	i = gun[b]; i += gun[b + 1]; i += gun[b + 2];
	if (i != "_mp") { return false; } // Can't be a valid gun
	return true; // All basic tests passed.
}
// insas_mp+fmj+rf+steadyaim
// 0123456




