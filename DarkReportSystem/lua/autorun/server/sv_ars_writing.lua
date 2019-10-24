local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() then
			target = v
		end
	end
	return target
end
local function IsHere(targ)
	for k, v in pairs(player.GetAll()) do 
		if v:Nick() == targ or v == targ then 
			return true
		end
	end
	return false
end

net.Receive("ARS_SendReportToServer", function(len, ply)
	--MsgN("Done!") --Debug Only
	local tbl = net.ReadTable()
	local NN = tbl.Name
	local SR = tbl.Reason
	local ED = tbl.ExtraDetails
	local RP = ply
	--print(NN)
	if RP:IsValid() and RP:IsPlayer() then
	--	print(RP:CanDoIt())
		if RP:CanDoIt() == "true" then
			RP:StartTimeSince()
			if file.Exists( "ars_reports/savedreports.txt", "DATA" ) then
				local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
				local TABLE = util.JSONToTable(FILE)
				if NN == ARS.NoneButtonText then
					AddReport( TABLE, os.date( "%m/%d" ), os.date( "%H:%M:%S" ), RP:Nick(), team.GetName(RP:Team()), RP:GetUserGroup(), RP:SteamID(), ARS.NoneButtonText, "N/A", "N/A", "N/A", SR, "", ED )
				else	
					AddReport( TABLE, os.date( "%m/%d" ), os.date( "%H:%M:%S" ), RP:Nick(), team.GetName(RP:Team()), RP:GetUserGroup(), RP:SteamID(), NN:Nick(), team.GetName(NN:Team()), NN:GetUserGroup(), NN:SteamID(), SR, "", ED )
				end
				timer.Simple(2, function()
					file.Write("ars_reports/savedreports.txt", util.TableToJSON(TABLE))
				end)
			else 
				local ReportingTable = {}
				if NN == ARS.NoneButtonText then
					AddReport( ReportingTable, os.date( "%m/%d" ), os.date( "%H:%M:%S" ), RP:Nick(), team.GetName(RP:Team()), RP:GetUserGroup(), RP:SteamID(), ARS.NoneButtonText, "N/A", "N/A", "N/A", SR, "", ED )
				else	
					AddReport( ReportingTable, os.date( "%m/%d" ), os.date( "%H:%M:%S" ), RP:Nick(), team.GetName(RP:Team()), RP:GetUserGroup(), RP:SteamID(), NN:Nick(), team.GetName(NN:Team()), NN:GetUserGroup(), NN:SteamID(), SR, "", ED )
				end
				file.Write("ars_reports/savedreports.txt", util.TableToJSON(ReportingTable))
			end
			local strings
			if NN == ARS.NoneButtonText then
				strings = RP:Nick().." has reported "..ARS.NoneButtonText.." for "..SR.."."
			else
				strings = RP:Nick().." has reported "..NN:Nick().." for "..SR.."."
			end
			for k, v in ipairs(GetAllAdmins()) do 
				net.Start("ARS_GotAReport")
					net.WriteString( strings )
				net.Send(v)
				if ARS.SendTypeOfNotification == "Both" then 
					ARSNotify(v, 1, 10, strings)
					v:ChatPrint( strings )
				elseif ARS.SendTypeOfNotification == "Chat" then
					v:ChatPrint( strings )
				elseif ARS.SendTypeOfNotification == "Notification" then
					ARSNotify(v, 1, 10, strings)
				end
			end
			local reported
			if NN == ARS.NoneButtonText then
				reported = ARS.NoneButtonText
			else
				reported = NN:Nick()
			end
			hook.Call("ARS_PlayerReported", GAMEMODE, RP:Nick(), reported, SR)
		end
	end
end)



util.AddNetworkString( "ARS_ViewReport_ToServer" )
util.AddNetworkString( "ARS_ViewReport_ToClient" )
net.Receive("ARS_ViewReport_ToServer", function()
	local tbl = net.ReadTable()
	local number = tbl.Number
	local ply = tbl.Player
	if !tbl.close then
		local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		local ValueTable = CheckTable(TABLE, number)
		net.Start("ARS_ViewReport_ToClient")
			net.WriteTable(ValueTable)
			net.WriteString(number)
			net.WriteBool(false)
		net.Send(FindPlayer(ply))
	else
		local FILE = file.Read( "ars_reports/closed/closedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		local ValueTable = CheckTable(TABLE, number)
		net.Start("ARS_ViewReport_ToClient")
			net.WriteTable(ValueTable)
			net.WriteString(number)
			net.WriteBool(true)
		net.Send(FindPlayer(ply))
	end
end)

util.AddNetworkString( "ARS_DeleteButton" )
net.Receive("ARS_DeleteButton", function()
	local number = net.ReadString()
	local reporter = net.ReadEntity()
	local name = net.ReadString()
	local bool = net.ReadBool()
	if IsHere(reporter) then
		if ARS.SendTypeOfNotification == "Both" then 
			ARSNotify(reporter, 1, 10, "Your report has been closed.")
			reporter:ChatPrint( "Your report has been closed." )
		elseif ARS.SendTypeOfNotification == "Chat" then
			reporter:ChatPrint( "Your report has been closed." )
		elseif ARS.SendTypeOfNotification == "Notification" then
			ARSNotify(reporter, 1, 10, "Your report has been closed." )
		end
	end
	if bool == false then
		local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		timer.Simple(0.5, function() 
			if table.Count(TABLE) >= 2 then
				table.remove( TABLE, number )
				file.Write("ars_reports/savedreports.txt", util.TableToJSON(TABLE))
			else
				table.Empty(TABLE)
				file.Delete("ars_reports/savedreports.txt")
			end
			ReOpenReports(name)
		end)
		print("Not Closed!")
	elseif bool == true then
		print("Closed!")
		local FILE = file.Read( "ars_reports/closed/closedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		timer.Simple(0.5, function() 
			if table.Count(TABLE) >= 2 then
				table.remove( TABLE, number )
				file.Write("ars_reports/closed/closedreports.txt", util.TableToJSON(TABLE))
			else
				table.Empty(TABLE)
				file.Delete("ars_reports/closed/closedreports.txt")
			end
			if FindPlayer(name):DeleteAble() then
				local HereorNah
				net.Start("ARS_Closed_Logs_ToClient")
					if file.Exists( "ars_reports/closed/closedreports.txt", "DATA" ) then 
						local FILE = file.Read( "ars_reports/closed/closedreports.txt", "DATA" )
						TABLE = util.JSONToTable(FILE)
						HereorNah = true
					else 
						TABLE = {}
						HereorNah = false
					end
					net.WriteTable(TABLE)
					net.WriteBool(HereorNah)
				net.Send(FindPlayer(name))
			end
		end)
	end
end)

util.AddNetworkString("ARS_CompleteReport_ToServer")
net.Receive( "ARS_CompleteReport_ToServer", function()
	local number = net.ReadString()
	local reporter = net.ReadEntity()
	local name = net.ReadString()
	hook.Call( "ARS_CompleteReport", GAMEMODE, number, FindPlayer(name) )
	if IsHere(reporter) then
		if ARS.SendTypeOfNotification == "Both" then 
			ARSNotify(reporter, 1, 10, "Your report has been closed.")
			reporter:ChatPrint( "Your report has been closed." )
		elseif ARS.SendTypeOfNotification == "Chat" then
			reporter:ChatPrint( "Your report has been closed." )
		elseif ARS.SendTypeOfNotification == "Notification" then
			ARSNotify(reporter, 1, 10, "Your report has been closed." )
		end
	end

	local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
	local FILE2 = file.Read( "ars_reports/closed/closedreports.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	if file.Exists( "ars_reports/closed/closedreports.txt", "DATA" ) then
		local TABLE2 = util.JSONToTable(FILE2)
		TABLE2[table.Count(TABLE2)+1] = TABLE[tonumber(number)]
		file.Write("ars_reports/closed/closedreports.txt", util.TableToJSON(TABLE2))
		--print("File Here!")--Debug
		timer.Simple(0.5, function() 
			if table.Count(TABLE) >= 2 then
				table.remove( TABLE, number )
				file.Write("ars_reports/savedreports.txt", util.TableToJSON(TABLE))
			else
				table.Empty(TABLE)
				file.Delete("ars_reports/savedreports.txt")
			end
			ReOpenReports(name)
		end)
	else
		local TABLE2 = {}
		TABLE2[1] = TABLE[tonumber(number)]
		file.Write("ars_reports/closed/closedreports.txt", util.TableToJSON(TABLE2))
		--print("File Not Here!")--Debug
		timer.Simple(0.5, function() 
			if table.Count(TABLE) >= 2 then
				table.remove( TABLE, number )
				file.Write("ars_reports/savedreports.txt", util.TableToJSON(TABLE))
			else
				table.Empty(TABLE)
				file.Delete("ars_reports/savedreports.txt")
			end
			ReOpenReports(name)
		end)
	end
end)


