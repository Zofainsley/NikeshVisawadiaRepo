/***********************************************\
|/////////////////DO NOT TOUCH\\\\\\\\\\\\\\\\\\
|//////////////Made by Zofainsley\\\\\\\\\\\\\\\
\***********************************************/
ARS = {}
ARS.Commands = {}
/************************************************\
|/////////////////END NOT TOUCH\\\\\\\\\\\\\\\\\\|
|/////////////////CONFIG BELOW\\\\\\\\\\\\\\\\\\\|
\************************************************/

///////////////////////////General Configuration\\\\\\\\\\\\\\\\\\\\\\\\\\
ARS.Gamemode = "DarkRP"	--Options are: "DarkRP", "Deathrun", "TTT". If you have TTT or Deathrun where it says "Team" on the user panel will be "Role".
ARS.PlayerChatCommand = "!report" --Sets the command for users/players to use to report another player. ("!report" conflicts with things like neutron admin panel)
ARS.AdminChatCommand = "!areport" --Sets the command for admins to use to view the admin panel.
ARS.ResetReports = false --If set to true, the reports will be removed on restart. If set to false, the reports will be untouched.
ARS.SendPanelWarning = true --If this is true, admins will receive an on screen notification as well as sandbox notification that a report was sent.
ARS.PanelNotiTimeOpen = 60 --The amount of time the onscreen notification will stay. This will only work if "ARS.SendPanelWarning" is set to true. (in seconds)
ARS.WrongCommandWarning = true --If set to true, when a player types "@", they will recieve a sandbox notification telling them the right command.

--New
ARS.RemoveNotificationOnClaim = true --If set to true, it will remove the notification panel for everyone when someone claims the report. This only works if ARS.SendPanelWarning is true.

ARS.RightCommandExtraTextWarning = true --If set to true, when a player types "!report I got RDM'ed!!!@!@!@!@!", It replaces that text with "Sorry, You must type !report, and only !report.". 

ARS.NonePlayerSelecter = true
ARS.NoneButtonText = "None Apply"

ARS.OnlyAllowIfAdminOn = true --If set to true, reports are only allowed to be sent when there is at least one admin online. (Used to prevent spam of reports.)
ARS.SpamReportPreventTime = 10 --The amount of time between reports. This helps prevent little kids from spamming admins. (in seconds)
ARS.SendChatNotification = true --Whether or not to send a chat notification to admins when they recieve a report. True = yes. False = no.
ARS.SendNotificationsToUsers = true --Whether or not to notify users about the status of their report.
ARS.UseSoundNotification = true
	
ARS.EnableFKey = true --True enables the possibilty to use an Fkey to open the report menu. False disables that ability.
ARS.FKeyCommand = KEY_F10 --If the above is true, this will be the FKey that you will press to open the menu. Please use this as a guide: http://wiki.garrysmod.com/page/Enums/KEY

ARS.SoundUsed = "HL1/fvox/beep.wav"
ARS.SendTypeOfNotification = "Both" --Options are: "Chat", "Notification", "Both". FOR ANYTHING THAT DOES NOT HAVE SANDBOX BASE, KEEP ONLY CHAT. This includes but is not limited to TTT, Deathrun, and Jailbreak.
ARS.Reasons = {
	"RDM",
	"RDA",
	"NLR",
	"TROLL", 
	"Job Abuse",
	"Other"} --The options for reasoning.

///////////////////////////Rank Configuration\\\\\\\\\\\\\\\\\\\\\\\\\\
ARS.Admins = {"superadmin", "trialmoderator", "moderator", "senioradmin", "communitymanager", "developer", "owner",
	"admin"} --What ULX ranks can view the admin panel. (KEEP LOWERCASE)
ARS.NotReportable = {
	""} --What ULX ranks cannot be reported. (KEEP LOWERCASE)
ARS.DeleteAbility = {"superadmin", "developer", "communitymanager", 
	"owner"} --What ULX Ranks have the ability to delete reports, see admin stats, and see closed reports. (KEEP LOWERCASE)
	
///////////////////////////Color Configuration\\\\\\\\\\\\\\\\\\\\\\\\\\	
ARS.TextRequestColor = Color(198, 198, 198) --The color of all of the text except buttons.
ARS.RequestBGColor = Color(48, 48, 48) --The color of the background.
ARS.RequestHeaderColor = Color(42, 42, 42) --The color of the header and some background.
ARS.InnerBGColor = Color(31, 31, 31) --The color of some background.
ARS.ButtonHoverColor = Color(56, 129, 238) --The color of most buttons when you hover them.
ARS.ButtonHoverTextColor = Color(240, 240, 240) --The color of most of the button's text when you hover them.
ARS.ButtonColor = Color(15, 94, 212) --The color of most buttons when not hovered.
ARS.ButtonTextColor = Color(215, 215, 215) --The color of most button's text when not hovered.

ARS.FirstPlace = Color(255, 215, 0, 255)
ARS.SecondPlace = Color(192,192,192, 255)
ARS.ThirdPlace = Color(205,127,50, 255)
ARS.FourthPlace = Color(0, 128, 255, 255)
ARS.FifthPlace = Color(255, 0, 255, 255)

///////////////////////////Users Panel Configuration\\\\\\\\\\\\\\\\\\\\\\\\\\
ARS.Commands.FirstButtonName = "Jail" --The title of the first button on the users panel.
ARS.Commands.FirstButtonCommand = "!jail" --The command for the first button on the users panel.
ARS.Commands.SecondButtonName = "Gag" --The title of the second button on the users panel.
ARS.Commands.SecondButtonCommand = "!gag" --The command for the second button on the users panel.
ARS.Commands.ThirdButtonName = "Kick" --The title of the third button on the users panel.
ARS.Commands.ThirdButtonCommand = "!kick" --The command for the third button on the users panel.
ARS.Commands.FourthButtonName = "Slay" --The title of the fourth button on the users panel.
ARS.Commands.FourthButtonCommand = "!slay" --The command for the fourth button on the users panel.