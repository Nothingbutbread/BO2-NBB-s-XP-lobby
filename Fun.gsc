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
RangeFinderEffect() { while(self.rangefinder) { self.rangefinderHUD setValue(int(Distance(self TraceShot(), self getEye()))); wait .1; } }
// TraceShot()



//
