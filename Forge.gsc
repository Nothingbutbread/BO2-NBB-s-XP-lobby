Forge_Spawn_Object(model, origin, angle)
{
	if (level.spawnedforgeentities.size > 300) { self iprintln("^1Error: Max Entity spawn limmit reached, some objects did not spawn to prevent overflow!"); return; }
	level.spawnedforgeentities[level.spawnedforgeentities.size] = spawnEntity(model, origin, angle);
}
Forge_Spawn_Cmd(model, x, y, z)
{
	if (!isDefined(model)) { model = "t6_wpn_supply_drop_ally"; }
	if (!isDefined(z)){ x = 0; y = 0; z = 0; }
	if (level.spawnedforgeentities.size > 300) { self iprintln("^1Error: Max Entity spawn limmit reached, some objects did not spawn to prevent overflow!"); return; }
	level.spawnedforgeentities[level.spawnedforgeentities.size] = spawnEntity(model, self.origin, (x,y,z));
}
spawnEntity(model, origin, angle)
{
	entity = spawn("script_model", origin);
    entity.angles = angle;
    entity setModel(model);
    return entity;
}
Forge_PrecacheModel(str)
{
	if (!isDefined(str)) { self iprintln("^1You must input model name in developer format"); return; }
	PrecacheModel(str);
}
Forge_Reset_Spawned_Entities()
{
	for(x=0;x<level.spawnedforgeentities.size;x++)
	{
		level.spawnedforgeentities[x] delete();
	}
	self iprintlnbold("All Spawned entities deleted!");
}
Forge_Spawn_Platform(x, y, spacex, spacey, obj)
{
	if (!isDefined(x) || !isDefined(y)) { self iprintln("You must input atleast 2 args"); return; }
	if (!isDefined(spacex)) { spacex = 40; }
	if (!isDefined(spacey)) { spacey = 70; }
	if (!isDefined(obj)) { obj = "t6_wpn_supply_drop_ally"; } 
	else { PrecacheModel(obj); } // Allows the model to be used by the menu.
	ref = self.origin;
	for(a = 0; a < x; a++) { for (b = 0; b < y; b++) { Forge_Spawn_Object(obj, ref + ((a * spacex), (b * spacey), 0)); } }
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
	self endon("disconnect");
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
	if (in1 >= 0 && in1 < 360 && in2 >= 0 && in2 < 360 && in3 >= 0 && in3 < 360) { 
		self.selentity.angles = (in1, in2, in3); 
		self iprintln("^2Angles set succesfuly!"); 
	}
	else { self iprintln("^1Error: ^7The inputed integers must be between 0 and 359"); }
}
Host_Forge_Adjustorigin(in1, in2, in3)
{
	if (!isDefined(self.selentity)) { self iprintln("^1Error: ^7You need to use forge mode to select an entity first!\nUse 'fm' to do so"); return; }
	if (!isDefined(in1) || !isDefined(in2) || !isDefined(in3)) { self iprintln("^1Error: ^7You must input 3 integers."); return; }
	self.selentity moveto((in1, in2, in3), .05);
}


