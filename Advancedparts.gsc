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



//
