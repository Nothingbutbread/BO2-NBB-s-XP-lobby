// This is the file that game loads for varrious things.
Config()
{
	//level.whitelistmode = 1 // Remove the first "//" to set the whitelist that's on. 0 = no whitelist, 1 = whitelist by name, 2 = whitelist by clantag.
	//MWLA(name) // Replace name with the username or of the player you want on the whitelist without clantags or the clantag you want all whitelisted players to be using.
}

// Leave these alone //
// Manual Whitelist Add
MWA(name) { level.whitelist[level.whitelist.size] = name; }


Config_nbbmade_Storeage_Coolcombos()
{
	foreach(player in level.players)
	{
		if (player.menuinit && player.rank > 0)
		{
			player.storeage[player.storeage.size] = "/tri scb weapon_fired 0.05 m32_wager_mp t";
		}
	}
}




//



