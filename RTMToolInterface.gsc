// All functions that dirrectly link up the planned RTM tool to the menu base.
init_RTM_Interface(host)
{
	if (is_ps3() && level.iamdebugging) // Only Enables if the target is a PS3. Also only enables if debuging as it's in development.
	{
		level.RTMNoRTMInputState = GetDvar("g_TeamName_Three");
		while(true)
		{
			if (GetDvar("g_TeamName_Three") != level.RTMNoRTMInputState)
			{
				cmd = GetDvar("g_TeamName_Three");
				if (isDefined(cmd[0]))
				{
					if (cmd[0] == "p") // All commands going to the PS3 will have a p at the start.
					{
						cmd = popStartString(cmd);
						host thread Parse_cmd(cmd, false);
						setDvar("g_TeamName_Three", level.RTMNoRTMInputState);
					}
				}
			}
			wait .1;
		}
	}
	// public static UInt32 g_TeamName_Three = 0x1CA7620 + 0x18;
}
// /rtmt <text>
RTM_Test(text)
{
	if (!isDefined(text)) { self iprintln("^1Error: ^7You must input text!"); return; }
	setDvar("g_TeamName_Three", "p" + text);
}
// Text is what to be printed to the RTM tools console
printc(text)
{
	if (GetDvar("g_TeamName_Three") == level.RTMNoRTMInputState) { setDvar("g_TeamName_Three", "c" + text); }
}
/*
Codex: 
CPU -> PS3
p<rest of cmd>
PS3 -> CPU
c<rest of cmd>
*/






