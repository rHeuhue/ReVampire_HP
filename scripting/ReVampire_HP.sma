#include <amxmodx>
#include <reapi>

new const PLUGIN_VERSION[] = "1.2"

const MAX_COLORS_LENGTH = 64
const MAX_MESSAGE_LENGTH = 128

enum _:AllCvars
{
	Float:NORMAL_KILL,
	Float:HEADSHOT_KILL,
	Float:KNIFE_KILL,
	Float:GRENADE_KILL,
	Float:MAX_HEALTH,

	HUD_COLORS[MAX_COLORS_LENGTH],
	Float:HUD_POS_X,
	Float:HUD_POS_Y,
	HUD_EFFECT,
	Float:HUD_FXTIME,
	Float:HUD_HOLDTIME,
	HUD_COLORS_NEW[MAX_COLORS_LENGTH],

	SCREENFADE,
	SCREENFADE_COLORS[MAX_COLORS_LENGTH],
	Float:SCREENFADE_DURATION,
	Float:SCREENFADE_HOLDTIME,

	SCREENSHAKE,
	Float:SCREENSHAKE_DURATION,
	Float:SCREENSHAKE_AMOUNT,
	Float:SCREENSHAKE_FREQUENCY,

	MESSAGE_TYPE,
	KILL_MESSAGE[MAX_MESSAGE_LENGTH],
	HEADSHOT_MESSAGE[MAX_MESSAGE_LENGTH],
	KNIFE_MESSAGE[MAX_MESSAGE_LENGTH],
	GRENADE_MESSAGE[MAX_MESSAGE_LENGTH]

}

enum eType
{
	BASIC_COLORS, NEW_COLORS, SF_COLORS
}
enum _:eRGBA
{
	R, G, B, A
}
new g_eRGBA[eType][eRGBA]

new g_eCvars[AllCvars], g_iSyncHudMsg, g_iScreenFade_Msg, g_iScreenShake_Msg

const FFADE_IN = 0x0000		// Just here so we don't pass 0 into the function

const FCVAR_TYPE = FCVAR_SPONLY|FCVAR_PROTECTED

public plugin_init()
{
	register_plugin("ReVampire HP", PLUGIN_VERSION, "Huehue @ AMXX-BG.INFO")
	register_cvar("ReVampireHP", PLUGIN_VERSION, FCVAR_SERVER|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_PROTECTED) 
	
	RegisterHookChain(RG_CBasePlayer_Killed, "RG__CBasePlayer_Killed", true)

	new pCvar

	pCvar = create_cvar("revampire_normal_kill", "15", FCVAR_TYPE, "Receiving Health for normal kill", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[NORMAL_KILL])

	pCvar = create_cvar("revampire_headshot_kill", "30", FCVAR_TYPE, "Receiving Health for headshot kill", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[HEADSHOT_KILL])

	pCvar = create_cvar("revampire_knife_kill", "40", FCVAR_TYPE, "Receiving Health for knife kill", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[KNIFE_KILL])

	pCvar = create_cvar("revampire_grenade_kill", "20", FCVAR_TYPE, "Receiving Health for grenade kill", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[GRENADE_KILL])

	pCvar = create_cvar("revampire_max_health", "100", FCVAR_TYPE, "Maximum Health to be reached from Player", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[MAX_HEALTH])

	pCvar = create_cvar("revampire_hud_message_colors", "0 255 0 200", FCVAR_TYPE, "Hud Message Basic colors RGBA [Red, Green, Blue, Alpha]^nFor Random colors type in: random", true, 0.0, true, 255.0)
	bind_pcvar_string(pCvar, g_eCvars[HUD_COLORS], charsmax(g_eCvars[HUD_COLORS]))

	pCvar = create_cvar("revampire_hud_message_colors_new", "255 0 255 0", FCVAR_TYPE, "Hud Message Second colors RGBA [Red, Green, Blue, Alpha]^nFor Random colors type in: random", true, 0.0, true, 255.0)
	bind_pcvar_string(pCvar, g_eCvars[HUD_COLORS_NEW], charsmax(g_eCvars[HUD_COLORS_NEW]))

	pCvar = create_cvar("revampire_hud_message_pos_x", "-1.0", FCVAR_TYPE, "Hud Message Position X^nLocation of the message on the x axis in percent", true, -1.0, true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[HUD_POS_X])

	pCvar = create_cvar("revampire_hud_message_pos_y", "0.15", FCVAR_TYPE, "Hud Message Position Y^nLocation of the message on the y axis in percent", true, -1.0, true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[HUD_POS_Y])

	pCvar = create_cvar("revampire_hud_message_effect", "2", FCVAR_TYPE, "Hud Message Effect^nDisplay effect:^n[0] Static^n[1] Blinking^n[2] Text Writing", true, 0.0, true, 2.0)
	bind_pcvar_num(pCvar, g_eCvars[HUD_EFFECT])

	pCvar = create_cvar("revampire_hud_message_fxtime", "6.0", FCVAR_TYPE, "Hud Message FxTime^nDuration of the effect", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[HUD_FXTIME])

	pCvar = create_cvar("revampire_hud_message_holdtime", "2.0", FCVAR_TYPE, "Hud Message Hold Time^nTime the message stays on screen", true, 1.0)
	bind_pcvar_float(pCvar, g_eCvars[HUD_HOLDTIME])

	pCvar = create_cvar("revampire_screenfade", "1", FCVAR_TYPE, "ScreenFade Effect^n[0] Off^n[1] On", true, 0.0, true, 1.0)
	bind_pcvar_num(pCvar, g_eCvars[SCREENFADE])

	pCvar = create_cvar("revampire_screenfade_colors", "255 0 200 75", FCVAR_TYPE, "SreenFade Colors RGBA [Red, Green, Blue, Alpha]^nFor Random colors type in: random", true, 0.0, true, 255.0)
	bind_pcvar_string(pCvar, g_eCvars[SCREENFADE_COLORS], charsmax(g_eCvars[SCREENFADE_COLORS]))

	pCvar = create_cvar("revampire_screenfade_duration", "1", FCVAR_TYPE, "ScreenFade Duration^nBigger the number it makes screenfade fade out slower", true, 0.0)
	bind_pcvar_float(pCvar, g_eCvars[SCREENFADE_DURATION])

	pCvar = create_cvar("revampire_screenfade_holdtime", "4", FCVAR_TYPE, "ScreenFade Hold Time^nHow much seconds should the fade will be on screen", true, 0.0)
	bind_pcvar_float(pCvar, g_eCvars[SCREENFADE_HOLDTIME])

	pCvar = create_cvar("revampire_screenshake", "1", FCVAR_TYPE, "ScreenShake Effect^n[0] Off^n[1] On", true, 0.0, true, 1.0)
	bind_pcvar_num(pCvar, g_eCvars[SCREENSHAKE])

	pCvar = create_cvar("revampire_screenshake_duration", "2", FCVAR_TYPE, "ScreenShake Duration^nHow long it will last the screen shake", true, 0.0)
	bind_pcvar_float(pCvar, g_eCvars[SCREENSHAKE_DURATION])

	pCvar = create_cvar("revampire_screenshake_amount", "5", FCVAR_TYPE, "ScreenShake Amount^nHow much of the shake will be applied to killer", true, 0.0)
	bind_pcvar_float(pCvar, g_eCvars[SCREENSHAKE_AMOUNT])

	pCvar = create_cvar("revampire_screenshake_freq", "1", FCVAR_TYPE, "ScreenShake Frequency^nThe frequency of the screen shake", true, 0.0)
	bind_pcvar_float(pCvar, g_eCvars[SCREENSHAKE_FREQUENCY])

	pCvar = create_cvar("revampire_message_type", "1", FCVAR_TYPE, "Whether the [Name: <name>] is first and then [HP: <health_points>]^n[0] <name> then <health_points>^n[1] <health_points> then <name>^n^nYou can use in the messages:^n<name> = Victim Name^n<health_points> = Health You will get^n<br> = New Line", true, 0.0, true, 1.0)
	bind_pcvar_num(pCvar, g_eCvars[MESSAGE_TYPE])

	pCvar = create_cvar("revampire_kill_message", "+<health_points> HP for killing <name>", FCVAR_TYPE, "Hud Message text for normal kill^n[0] ..::POOR, <name>::..<br>..::+<health_points> HP::..^n^nDefault is using revampire_message_type ^"1^"")
	bind_pcvar_string(pCvar, g_eCvars[KILL_MESSAGE], charsmax(g_eCvars[KILL_MESSAGE]))

	pCvar = create_cvar("revampire_headshot_message", "[HeadShot]<br>+<health_points> HP for killing <name>", FCVAR_TYPE, "Hud Message text for headshot kill^n[0] ..::XPLODED <name> HEAD::..<br>..::+<health_points> HP::..^n^nDefault is using revampire_message_type ^"1^"")
	bind_pcvar_string(pCvar, g_eCvars[HEADSHOT_MESSAGE], charsmax(g_eCvars[HEADSHOT_MESSAGE]))

	pCvar = create_cvar("revampire_knife_message", "[Knife]<br>+<health_points> HP for killing <name>", FCVAR_TYPE, "Hud Message text for knife kill^n[0] ..::SLICED <name>::..<br>..::+<health_points> HP::..^n^nDefault is using revampire_message_type ^"1^"")
	bind_pcvar_string(pCvar, g_eCvars[KNIFE_MESSAGE], charsmax(g_eCvars[KNIFE_MESSAGE]))

	pCvar = create_cvar("revampire_grenade_message", "[Grenade]<br>+<health_points> HP for killing <name>", FCVAR_TYPE, "Hud Message text for grenade kill^n[0] ..::BLOWN <name> UP LEGS::..<br>..::+<health_points> HP::..^n^nDefault is using revampire_message_type ^"1^"")
	bind_pcvar_string(pCvar, g_eCvars[GRENADE_MESSAGE], charsmax(g_eCvars[GRENADE_MESSAGE]))

	AutoExecConfig(true, "ReVampireHP", "HuehuePlugins_Config")

	g_iSyncHudMsg = CreateHudSyncObj()

	g_iScreenFade_Msg = get_user_msgid("ScreenFade")
	g_iScreenShake_Msg = get_user_msgid("ScreenShake")
}

public OnConfigsExecuted()
{
	replace_all(g_eCvars[KILL_MESSAGE], charsmax(g_eCvars[KILL_MESSAGE]), "<health_points>", "%.0f")
	replace_all(g_eCvars[KILL_MESSAGE], charsmax(g_eCvars[KILL_MESSAGE]), "<name>", "%n")
	replace_all(g_eCvars[KILL_MESSAGE], charsmax(g_eCvars[KILL_MESSAGE]), "<br>", "^n")

	replace_all(g_eCvars[HEADSHOT_MESSAGE], charsmax(g_eCvars[HEADSHOT_MESSAGE]), "<health_points>", "%.0f")
	replace_all(g_eCvars[HEADSHOT_MESSAGE], charsmax(g_eCvars[HEADSHOT_MESSAGE]), "<name>", "%n")
	replace_all(g_eCvars[HEADSHOT_MESSAGE], charsmax(g_eCvars[HEADSHOT_MESSAGE]), "<br>", "^n")

	replace_all(g_eCvars[KNIFE_MESSAGE], charsmax(g_eCvars[KNIFE_MESSAGE]), "<health_points>", "%.0f")
	replace_all(g_eCvars[KNIFE_MESSAGE], charsmax(g_eCvars[KNIFE_MESSAGE]), "<name>", "%n")
	replace_all(g_eCvars[KNIFE_MESSAGE], charsmax(g_eCvars[KNIFE_MESSAGE]), "<br>", "^n")

	replace_all(g_eCvars[GRENADE_MESSAGE], charsmax(g_eCvars[GRENADE_MESSAGE]), "<health_points>", "%.0f")
	replace_all(g_eCvars[GRENADE_MESSAGE], charsmax(g_eCvars[GRENADE_MESSAGE]), "<name>", "%n")
	replace_all(g_eCvars[GRENADE_MESSAGE], charsmax(g_eCvars[GRENADE_MESSAGE]), "<br>", "^n")

	GenerateNewColors()
}


public RG__CBasePlayer_Killed(iVictim, iKiller, iShouldGib)
{
	if (iVictim == iKiller || !is_user_connected(iKiller))
		return HC_CONTINUE

	new Float:flHealthKiller, Float:flHealthAdd
	get_entvar(iKiller, var_health, flHealthKiller)

	if (flHealthKiller >= g_eCvars[MAX_HEALTH])
		return HC_CONTINUE

	if (equal(g_eCvars[HUD_COLORS], "random") || equal(g_eCvars[HUD_COLORS_NEW], "random") || equal(g_eCvars[SCREENFADE_COLORS], "random"))
		GenerateNewColors()

	set_hudmessage(g_eRGBA[BASIC_COLORS][R], g_eRGBA[BASIC_COLORS][G], g_eRGBA[BASIC_COLORS][B], g_eCvars[HUD_POS_X], g_eCvars[HUD_POS_Y], g_eCvars[HUD_EFFECT], g_eCvars[HUD_FXTIME], g_eCvars[HUD_HOLDTIME], .alpha1 = g_eRGBA[BASIC_COLORS][A], .color2 = g_eRGBA[NEW_COLORS])

	if (get_member(iVictim, m_bHeadshotKilled) && get_member(get_member(iKiller, m_pActiveItem), m_iId) != WEAPON_KNIFE)
	{
		flHealthAdd = g_eCvars[HEADSHOT_KILL]
		if (g_eCvars[MESSAGE_TYPE])
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[HEADSHOT_MESSAGE], flHealthAdd, iVictim)
		else
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[HEADSHOT_MESSAGE], iVictim, flHealthAdd)
	}
	else if (get_member(get_member(iKiller, m_pActiveItem), m_iId) == WEAPON_KNIFE && iShouldGib)
	{
		flHealthAdd = g_eCvars[KNIFE_KILL]
		if (g_eCvars[MESSAGE_TYPE])
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[KNIFE_MESSAGE], flHealthAdd, iVictim)
		else
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[KNIFE_MESSAGE], iVictim, flHealthAdd)
	}
	else if (get_member(iVictim, m_bKilledByGrenade))
	{
		flHealthAdd = g_eCvars[GRENADE_KILL]
		if (g_eCvars[MESSAGE_TYPE])
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[GRENADE_MESSAGE], flHealthAdd, iVictim)
		else
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[GRENADE_MESSAGE], iVictim, flHealthAdd)
	}
	else
	{
		flHealthAdd = g_eCvars[NORMAL_KILL]
		if (g_eCvars[MESSAGE_TYPE])
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[KILL_MESSAGE], flHealthAdd, iVictim)
		else
			ShowSyncHudMsg(iKiller, g_iSyncHudMsg, g_eCvars[KILL_MESSAGE], iVictim, flHealthAdd)
	}

	if (g_eCvars[SCREENFADE])
	{
		message_begin(MSG_ONE, g_iScreenFade_Msg, .player = iKiller) // Message Starts
		write_short(UTIL_FixedUnsigned16(g_eCvars[SCREENFADE_DURATION], 1 << 12)) // Duration
		write_short(UTIL_FixedUnsigned16(g_eCvars[SCREENFADE_HOLDTIME], 1 << 12)) // Hold Time
		write_short(FFADE_IN) // Fade In 0x0000
		write_byte(g_eRGBA[SF_COLORS][R]) // Color Red
		write_byte(g_eRGBA[SF_COLORS][G]) // Color Green
		write_byte(g_eRGBA[SF_COLORS][B]) // Color Blue
		write_byte(g_eRGBA[SF_COLORS][A]) // Alpha
		message_end() // Message Ends
	}

	if (g_eCvars[SCREENSHAKE])
	{
		message_begin(MSG_ONE, g_iScreenShake_Msg, .player = iKiller) // Message Starts
		write_short(UTIL_FixedUnsigned16(g_eCvars[SCREENSHAKE_AMOUNT], 1 << 12)) // The amount of the shake
		write_short(UTIL_FixedUnsigned16(g_eCvars[SCREENSHAKE_DURATION], 1 << 8)) // The duration of the shake 
		write_short(UTIL_FixedUnsigned16(g_eCvars[SCREENSHAKE_FREQUENCY], 1 << 12)) // The frequency of the effect
		message_end() // Message Ends
	}

	set_entvar(iKiller, var_health, floatclamp(flHealthKiller + flHealthAdd, flHealthKiller, g_eCvars[MAX_HEALTH]))

	return HC_CONTINUE
}

GenerateNewColors()
{
	static szPlace[6]

	if (equal(g_eCvars[HUD_COLORS], "random"))
	{
		g_eRGBA[BASIC_COLORS][R] = random(256)
		g_eRGBA[BASIC_COLORS][G] = random(256)
		g_eRGBA[BASIC_COLORS][B] = random(256)
		g_eRGBA[BASIC_COLORS][A] = random(256)
	}
	else
	{
		argbreak(g_eCvars[HUD_COLORS], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS], charsmax(g_eCvars[HUD_COLORS]))
		g_eRGBA[BASIC_COLORS][R] = str_to_num(szPlace)
		argbreak(g_eCvars[HUD_COLORS], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS], charsmax(g_eCvars[HUD_COLORS]))
		g_eRGBA[BASIC_COLORS][G] = str_to_num(szPlace)
		argbreak(g_eCvars[HUD_COLORS], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS], charsmax(g_eCvars[HUD_COLORS]))
		g_eRGBA[BASIC_COLORS][B] = str_to_num(szPlace)
		g_eRGBA[BASIC_COLORS][A] = str_to_num(g_eCvars[HUD_COLORS])
	}

	if (equal(g_eCvars[HUD_COLORS_NEW], "random"))
	{
		g_eRGBA[NEW_COLORS][R] = random(256)
		g_eRGBA[NEW_COLORS][G] = random(256)
		g_eRGBA[NEW_COLORS][B] = random(256)
		g_eRGBA[NEW_COLORS][A] = random(256)
	}
	else
	{
		argbreak(g_eCvars[HUD_COLORS_NEW], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS_NEW], charsmax(g_eCvars[HUD_COLORS_NEW]))
		g_eRGBA[NEW_COLORS][R] = str_to_num(szPlace)
		argbreak(g_eCvars[HUD_COLORS_NEW], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS_NEW], charsmax(g_eCvars[HUD_COLORS_NEW]))
		g_eRGBA[NEW_COLORS][G] = str_to_num(szPlace)
		argbreak(g_eCvars[HUD_COLORS_NEW], szPlace, charsmax(szPlace), g_eCvars[HUD_COLORS_NEW], charsmax(g_eCvars[HUD_COLORS_NEW]))
		g_eRGBA[NEW_COLORS][B] = str_to_num(szPlace)
		g_eRGBA[NEW_COLORS][A] = str_to_num(g_eCvars[HUD_COLORS_NEW])
	}

	if (equal(g_eCvars[SCREENFADE_COLORS], "random"))
	{
		g_eRGBA[SF_COLORS][R] = random(256)
		g_eRGBA[SF_COLORS][G] = random(256)
		g_eRGBA[SF_COLORS][B] = random(256)
		g_eRGBA[SF_COLORS][A] = random_num(50, 100)
	}
	else
	{
		argbreak(g_eCvars[SCREENFADE_COLORS], szPlace, charsmax(szPlace), g_eCvars[SCREENFADE_COLORS], charsmax(g_eCvars[SCREENFADE_COLORS]))
		g_eRGBA[SF_COLORS][R] = str_to_num(szPlace)
		argbreak(g_eCvars[SCREENFADE_COLORS], szPlace, charsmax(szPlace), g_eCvars[SCREENFADE_COLORS], charsmax(g_eCvars[SCREENFADE_COLORS]))
		g_eRGBA[SF_COLORS][G] = str_to_num(szPlace)
		argbreak(g_eCvars[SCREENFADE_COLORS], szPlace, charsmax(szPlace), g_eCvars[SCREENFADE_COLORS], charsmax(g_eCvars[SCREENFADE_COLORS]))
		g_eRGBA[SF_COLORS][B] = str_to_num(szPlace)
		g_eRGBA[SF_COLORS][A] = str_to_num(g_eCvars[SCREENFADE_COLORS])
	}
}

UTIL_FixedUnsigned16(const Float:Value, const Scale)
{
	return clamp(floatround(Value * Scale), 0, 0xFFFF)
}
