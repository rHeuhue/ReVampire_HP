## Last Version (1.2) Here:
- https://github.com/rHeuhue/ReVampire_HP

# ReVampire HP

***ReVampire HP gives you the opportunity of more settings and more configurable than others***

 	// -
	// Default: "1.2"
	ReVampire_HP_Tracker "1.2"

	// Receiving Health for normal kill
	// -
	// Default: "15"
	// Minimum: "1.000000"
	revampire_normal_kill "15"

	// Receiving Health for headshot kill
	// -
	// Default: "30"
	// Minimum: "1.000000"
	revampire_headshot_kill "30"

	// Receiving Health for knife kill
	// -
	// Default: "40"
	// Minimum: "1.000000"
	revampire_knife_kill "40"

	// Receiving Health for grenade kill
	// -
	// Default: "20"
	// Minimum: "1.000000"
	revampire_grenade_kill "20"

	// Maximum Health to be reached from Player
	// If the cvar is set to 0 it will take automatically default max health of player
	// -
	// Default: "100.0"
	// Minimum: "0.000000"
	revampire_max_health "100.0"

	// Hud Message Basic colors RGBA [Red, Green, Blue, Alpha]
	// For Random colors type in: random
	// -
	// Default: "0 255 0 200"
	// Minimum: "0.000000"
	// Maximum: "255.000000"
	revampire_hud_message_colors "0 255 0 200"

	// Hud Message Second colors RGBA [Red, Green, Blue, Alpha]
	// For Random colors type in: random
	// -
	// Default: "255 0 255 0"
	// Minimum: "0.000000"
	// Maximum: "255.000000"
	revampire_hud_message_colors_new "255 0 255 0"

	// Hud Message Position X
	// Location of the message on the x axis in percent
	// -
	// Default: "-1.0"
	// Minimum: "-1.000000"
	// Maximum: "1.000000"
	revampire_hud_message_pos_x "-1.0"

	// Hud Message Position Y
	// Location of the message on the y axis in percent
	// -
	// Default: "0.15"
	// Minimum: "-1.000000"
	// Maximum: "1.000000"
	revampire_hud_message_pos_y "0.15"

	// Hud Message Effect
	// Display effect:
	// [0] Static
	// [1] Blinking
	// [2] Text Writing
	// -
	// Default: "2"
	// Minimum: "0.000000"
	// Maximum: "2.000000"
	revampire_hud_message_effect "2"

	// Hud Message FxTime
	// Duration of the effect
	// -
	// Default: "6.0"
	// Minimum: "1.000000"
	revampire_hud_message_fxtime "6.0"

	// Hud Message Hold Time
	// Time the message stays on screen
	// -
	// Default: "2.0"
	// Minimum: "1.000000"
	revampire_hud_message_holdtime "2.0"

	// ScreenFade Effect
	// [0] Off
	// [1] On
	// -
	// Default: "1"
	// Minimum: "0.000000"
	// Maximum: "1.000000"
	revampire_screenfade "1"

	// SreenFade Colors RGBA [Red, Green, Blue, Alpha]
	// For Random colors type in: random
	// -
	// Default: "255 0 200 75"
	// Minimum: "0.000000"
	// Maximum: "255.000000"
	revampire_screenfade_colors "255 0 200 75"

	// ScreenFade Duration
	// Bigger the number it makes screenfade fade out slower
	// -
	// Default: "1"
	// Minimum: "0.000000"
	revampire_screenfade_duration "1"

	// ScreenFade Hold Time
	// How much seconds should the fade will be on screen
	// -
	// Default: "4"
	// Minimum: "0.000000"
	revampire_screenfade_holdtime "4"

	// ScreenShake Effect
	// [0] Off
	// [1] On
	// -
	// Default: "1"
	// Minimum: "0.000000"
	// Maximum: "1.000000"
	revampire_screenshake "1"

	// ScreenShake Duration
	// How long it will last the screen shake
	// -
	// Default: "2"
	// Minimum: "0.000000"
	revampire_screenshake_duration "2"

	// ScreenShake Amount
	// How much of the shake will be applied to killer
	// -
	// Default: "5"
	// Minimum: "0.000000"
	revampire_screenshake_amount "5"

	// ScreenShake Frequency
	// The frequency of the screen shake
	// -
	// Default: "1"
	// Minimum: "0.000000"
	revampire_screenshake_freq "1"

	// Whether the name is first and then HP
	// [0] <name> then <health_points>
	// [1] <health_points> then <name>
	// 
	// You can use in the messages:
	// <name> = Victim Name
	// <health_points> = Health You will get
	// <br> = New Line
	// -
	// Default: "1"
	// Minimum: "0.000000"
	// Maximum: "1.000000"
	revampire_message_type "1"

	// Hud Message text for normal kill
	// [0] ..::POOR, <name>::..<br>..::+<health_points> HP::..
	// -
	// Default: "+<health_points> HP for killing <name>"
	revampire_kill_message "+<health_points> HP for killing <name>"

	// Hud Message text for headshot kill
	// [0] ..::XPLODED <name> HEAD::..<br>..::+<health_points> HP::..
	// -
	// Default: "[HeadShot]<br>+<health_points> HP for killing <name>"
	revampire_headshot_message "[HeadShot]<br>+<health_points> HP for killing <name>"

	// Hud Message text for knife kill
	// [0] ..::SLICED <name>::..<br>..::+<health_points> HP::..
	// -
	// Default: "[Knife]<br>+<health_points> HP for killing <name>"
	revampire_knife_message "[Knife]<br>+<health_points> HP for killing <name>"

	// Hud Message text for grenade kill
	// [0] ..::BLOWN <name> UP LEGS::..<br>..::+<health_points> HP::..
	// -
	// Default: "[Grenade]<br>+<health_points> HP for killing <name>"
	revampire_grenade_message "[Grenade]<br>+<health_points> HP for killing <name>"
