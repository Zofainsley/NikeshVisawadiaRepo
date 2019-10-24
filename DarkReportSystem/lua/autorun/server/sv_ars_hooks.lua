local function IsHere(targ)
	for k, v in pairs(player.GetAll()) do 
		if v:Nick() == targ or targ == v:SteamID() then 
			return true
		end
	end
	return false
end
local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() or targ == v:SteamID() then
			target = v
		end
	end
	return target
end
hook.Add( "ARS_PlayerReported", "There has been a report", function(reporter, name, reason)
	if ARS.SendChatNotification then 
		for k, v in pairs(player.GetAll()) do
			if v:IsARSAdmin() then 
				v:ChatPrint( reporter.." has reported "..name.." for "..reason.."." )
			end
		end
	end
end)

hook.Add( "ARS_AdminClaimed_Report", "Send notification to reporter", function(number, ply)
	local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	local v = CheckTable(TABLE, number)
	if IsHere(v.REPORTER) then
		if ARS.SendTypeOfNotification == "Both" then 
			ARSNotify(FindPlayer(v.REPORTER), 1, 10, ply.." has claimed your report and should be with you shortly.")
			FindPlayer(v.REPORTER):ChatPrint( ply.." has claimed your report and should be with you shortly." )
		elseif ARS.SendTypeOfNotification == "Chat" then
			FindPlayer(v.REPORTER):ChatPrint( ply.." has claimed your report and should be with you shortly." )
		elseif ARS.SendTypeOfNotification == "Notification" then
			ARSNotify(FindPlayer(v.REPORTER), 1, 10, ply.." has claimed your report and should be with you shortly.")
		end
	end
	if ARS.SendPanelWarning and ARS.RemoveNotificationOnClaim then
		for k, v in ipairs(GetAllAdmins()) do 
			net.Start("ARS_RemoveNotification")
			net.Send(v)
		end
	end
end)

hook.Add( "ULibPostTranslatedCommand", "PLogULX", function(ply, cmd, arg)
	if cmd == "ulx adduserid" then
		local id = arg[2]
		if table.HasValue(ARS.Admins, arg[3]) then
			if IsHere(id) then
				if CheckIfAdminExist(id) == false then
					if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
						local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
						local TABLE = util.JSONToTable(FILE)
						SetAdminStat(TABLE, FindPlayer(id):Nick(), id, arg[3], 0, 0)
						file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
						MsgN("[ARS] Created "..id.."'s Position in the Stats!")
					end
				elseif CheckIfAdminExist(id) == true then
					local id = arg[2]
					RemoveAdmin(id)
					timer.Simple(1, function()
						if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
							local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
							local TABLE = util.JSONToTable(FILE)
							SetAdminStat(TABLE, FindPlayer(id):Nick(), id, arg[3], 0, 0)
							file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
							MsgN("[ARS] Created "..id.."'s Position in the Stats!")
						end
					end)
				end 
			end
		else
			RemoveAdmin(id)
		end
	elseif cmd == "ulx adduser" then
		local ent = arg[2]
		if table.HasValue(ARS.Admins, arg[3]) then
			if not CheckIfAdminExist(ent:SteamID()) then
				if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
					local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
					local TABLE = util.JSONToTable(FILE)
					SetAdminStat(TABLE, ent:Nick(), ent:SteamID(), arg[3], 0, 0)
					file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
					MsgN("[ARS] Created "..ent:Nick().."'s Position in the Stats!")
				end
			else
				local ent = arg[2]
				RemoveAdmin(ent:SteamID())
				timer.Simple(1, function()
					if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
						local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
						local TABLE = util.JSONToTable(FILE)
						SetAdminStat(TABLE, ent:Nick(), ent:SteamID(), arg[3], 0, 0)
						file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
						MsgN("[ARS] Created "..ent:Nick().."'s Position in the Stats!")
					end
				end)
			end 
		else
			RemoveAdmin(ent:SteamID())
		end
	elseif cmd == "ulx removeuser" then
		local ent = arg[2]
		RemoveAdmin(ent:SteamID())
	elseif cmd == "ulx removeuserid" then
		local id = arg[2]
		RemoveAdmin(id)
	end
end)

