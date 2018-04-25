RangeFinderHUD()
{
	if (!isDefined(self.rangefinder)) { self.rangefinder = false; }
	if (self.rangefinder) { self thread DisableRangeFinderHUD(); self iprintln("Range Finder ^1Disabled!"); }
	else { self thread EnableRangeFinderHUD(); self iprintln("Range Finder ^2Enabled!"); }
}
EnableRangeFinderHUD()
{
	self.rangefinderHUD destroy();
	self.rangefinderHUD = self CreateText(0, 2, 0, 320, (1,1,1), 1, 15, false, false, false, false);
	self.rangefinder = true;
	self thread RangeFinderEffect();
}
DisableRangeFinderHUD() { self.rangefinder = false; wait .2; self.rangefinderHUD destroy(); }
RangeFinderEffect() { self endon("disconnect"); while(self.rangefinder) { self.rangefinderHUD setValue(int(Distance(self TraceShot(), self getEye()))); wait .1; } }
// TraceShot()


Fun_Player_Grenades(play)
{
	if (!isDefined(self.fungrenademod)) { self.fungrenademod = false; }
	if (self.fungrenademod) { self.fungrenademod = false; self iprintln("Player Grenades ^1Disabled!"); }
	else { self.fungrenademode = true; self iprintln("Player Grenades ^2Enabled!"); self thread Fun_Player_Grenades_Effect(play);}
}
Fun_Player_Grenades_Effect(play)
{
	self endon("disconnect");
	if (!isDefined(play)) { closestplayer = true; play = self; }
	else { closestplayer = false; }
	while(self.fungrenademod)
	{
		self waittill("grenade_fire", eqipment, nade);
		if (closestplayer) // I'm getting the nearest player
		{
			dis = 999999;
			foreach(player in level.players)
			{
				if (player != self && isAlive(player) && !player.isbeingthrown)
				{
					if (Distance(self.origin, player.origin) < dis)
					{
						play = player;
						dis = Distance(self.origin, player.origin);
					}
				}
			}
			// Got my nearest player that isn't me, if no other players, I am thrown instead.
		}
		play thread Fun_Player_Greandes_Effect_Throw(eqipment);
	}
}
Fun_Player_Greandes_Effect_Throw(e)
{
	self endon("disconnect");
	self.isbeingthrown = true;
	self LinkTo(eqipment);
	t = e.origin;
	while(self.isbeingthrown)
	{
		wait .1;
		if (t == e.origin) { break; }
		else { t = e.origin; }
	}
	self DetachAll();
}
Fun_Control_player()
{
	
}







