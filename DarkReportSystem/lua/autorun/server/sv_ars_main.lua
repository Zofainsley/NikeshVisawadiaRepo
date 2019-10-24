local buildNum = "1.9.1"
MsgC( "[ARS] Admin Report System "..buildNum.." by Zofainsley and Church for Animegaming. \n" )
util.AddNetworkString("ARS_Reopen_ToClient")
util.AddNetworkString("ARS_Request")
util.AddNetworkString("ARS_AdminPanel")
util.AddNetworkString("ARS_GetTopAdmin_ToServer")
util.AddNetworkString("ARS_GetTopAdmin_ToClient")
util.AddNetworkString("ARS_GetAllAdmin_ToServer")
util.AddNetworkString("ARS_GetAllAdmin_ToClient")
util.AddNetworkString("ARS_RESET_ADMIN_STAT")
util.AddNetworkString("ARS_ClaimReport_ToServer")
util.AddNetworkString("ARS_Closed_Logs_ToServer")
util.AddNetworkString("ARS_Closed_Logs_ToClient")
util.AddNetworkString("ARS_SendReportToServer")
util.AddNetworkString( "ARS_GotAReport" )
util.AddNetworkString("ARS_RemoveNotification")
MsgC( "LOADED...VGUI BY ZOFAINSLEY, ANIMATION BY CHURCH\n" )


hook.Add( "PlayerSay", "RequestPanel", function( ply, text, to )
	if (string.lower(text) == ARS.PlayerChatCommand) then
		if ARS.OnlyAllowIfAdminOn then 
			if AnyAdmins() then 
				if ply:CanDoIt() == "true" then 
					net.Start("ARS_Request")
						net.WriteEntity(ply)
					net.Send(ply)
				else
					if ARS.SendTypeOfNotification == "Both" then 
						ARSNotify(ply, 1, 10, "You cannot place another report this soon!")
						ply:ChatPrint( "You cannot place another report this soon!" )
					elseif ARS.SendTypeOfNotification == "Chat" then
						ply:ChatPrint( "You cannot place another report this soon!" )
					elseif ARS.SendTypeOfNotification == "Notification" then
						ARSNotify(ply, 1, 10, "You cannot place another report this soon!")
					end
				end
			else
				if ARS.SendTypeOfNotification == "Both" then 
					ARSNotify(ply, 1, 10, "You cannot report. There are no admins!")
					ply:ChatPrint( "You cannot report. There are no admins!" )
				elseif ARS.SendTypeOfNotification == "Chat" then
					ply:ChatPrint( "You cannot report. There are no admins!" )
				elseif ARS.SendTypeOfNotification == "Notification" then
					ARSNotify(ply, 1, 10, "You cannot report. There are no admins!")
				end
			end
		else
			if ply:CanDoIt() == "true" then 
				net.Start("ARS_Request")
					net.WriteEntity(ply)
				net.Send(ply)
			else
				if ARS.SendTypeOfNotification == "Both" then 
					ARSNotify(ply, 1, 10, "You cannot place another report this soon!")
					ply:ChatPrint( "You cannot place another report this soon!" )
				elseif ARS.SendTypeOfNotification == "Chat" then
					ply:ChatPrint( "You cannot place another report this soon!" )
				elseif ARS.SendTypeOfNotification == "Notification" then
					ARSNotify(ply, 1, 10, "You cannot place another report this soon!")
				end
			end
		end
    end
    if ply:IsARSAdmin() then
		if (string.lower(text) == ARS.AdminChatCommand) then
			local HereorNah
			net.Start("ARS_AdminPanel")
				if file.Exists( "ars_reports/savedreports.txt", "DATA" ) then 
					local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
					TABLE = util.JSONToTable(FILE)
					HereorNah = true
				else 
					TABLE = {}
					HereorNah = false
				end
				net.WriteTable(TABLE)
				net.WriteBool(HereorNah)
			net.Send(ply)
		end
	end
end)

hook.Add( "PlayerSay", "WrongCommand", function( ply, text, to )
	if ARS.WrongCommandWarning then
		local subtxt = string.sub(text, 1, 1)
		if string.sub(ARS.PlayerChatCommand, 1, 1) != "@" then 
			if (subtxt == "@") then
				if ARS.SendTypeOfNotification == "Both" then 
					ARSNotify(ply, 1, 10, "To request an admin, you must use '"..ARS.PlayerChatCommand.."'.")
					ply:ChatPrint( "To request an admin, you must use '"..ARS.PlayerChatCommand.."'." )
				elseif ARS.SendTypeOfNotification == "Chat" then
					ply:ChatPrint( "To request an admin, you must use '"..ARS.PlayerChatCommand.."'." )
				elseif ARS.SendTypeOfNotification == "Notification" then
					ARSNotify(ply, 1, 10, "To request an admin, you must use '"..ARS.PlayerChatCommand.."'.")
				end
			end
		end
		local len = string.len(ARS.PlayerChatCommand)
		if ARS.RightCommandExtraTextWarning then
			if string.sub(text, 1, len) == ARS.PlayerChatCommand and string.len(text) > len and text != ARS.AdminChatCommand then
				if ARS.SendTypeOfNotification == "Both" then 
					ARSNotify(ply, 1, 10, "Sorry, You must type !report, and only !report.")
					ply:ChatPrint( "Sorry, You must type !report, and only !report." )
				elseif ARS.SendTypeOfNotification == "Chat" then
					ply:ChatPrint( "Sorry, You must type !report, and only !report." )
				elseif ARS.SendTypeOfNotification == "Notification" then
					ARSNotify(ply, 1, 10, "Sorry, You must type !report, and only !report.")
				end
			end
		end
	end
end)
