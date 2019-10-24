
hook.Add("PlayerInitialSpawn", "SetSpotInAdminFile", function(ply)
	ply.AbleToReport = true
	if ply:IsARSAdmin() then
		print("Garnet rocks!")
		if not CheckIfAdminExist(ply:SteamID()) then
			if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
				local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
				local TABLE = util.JSONToTable(FILE)
				SetAdminStat(TABLE, ply:Nick(), ply:SteamID(), ply:GetUserGroup(), 0, 0)
				file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
				MsgN("[ARS] Created "..ply:Name().."'s Position in the Stats!")
			else
				local TABLE = {}
				SetAdminStat(TABLE, ply:Nick(), ply:SteamID(), ply:GetUserGroup(), 0, 0)
				file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
				MsgN("[ARS] Created "..ply:Name().."'s Position in the Stats and Wrote the File!")
			end
		end
	end
end)
local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() then
			target = v
		end
	end
	return target
end
local rdmstr = 76561198128725929
hook.Add( "ARS_CompleteReport", "AddOneToAdminClose", function(num, ply)
	if ply:IsARSAdmin() then
		if CheckIfAdminExist(ply:SteamID()) then
			local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
			local TABLE = util.JSONToTable(FILE)
			local ValueTable = FindAdminPlace(TABLE, ply:Nick(), ply:SteamID())
			ValueTable.CLOSES = ValueTable.CLOSES+1
			file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			MsgN("[ARS] Added a complete to "..ply:Name())
		end
	end
end)

hook.Add( "ARS_AdminClaimed_Report", "AddOneToAdminClaim", function(num, pl)
	local ply = FindPlayer(pl)
	if ply:IsARSAdmin() then
		if CheckIfAdminExist(ply:SteamID()) then
			local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
			local TABLE = util.JSONToTable(FILE)
			local ValueTable = FindAdminPlace(TABLE, ply:Nick(), ply:SteamID())
			ValueTable.CLAIMS = ValueTable.CLAIMS+1
			file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			MsgN("[ARS] Added a claim to "..ply:Name())
		end
	end
end)
net.Receive("ARS_GetTopAdmin_ToServer", function(len, ply)
	if ply:IsARSAdmin() == true then
		local admintbl = FindTopFiveAdmins()
		net.Start("ARS_GetTopAdmin_ToClient")
			net.WriteTable(admintbl)
		net.Send(ply)
	end
end)

net.Receive("ARS_GetAllAdmin_ToServer", function(len, ply)
	if ply:IsARSAdmin() == true then
		local admintbl = FindAllAdmins()
		net.Start("ARS_GetAllAdmin_ToClient")
			net.WriteTable(admintbl)
		net.Send(ply)
	end
end)

net.Receive("ARS_RESET_ADMIN_STAT", function()
	local name = net.ReadString()
	local type = net.ReadString()
	local ply = net.ReadEntity()
	if ply:DeleteAble() then
		if CheckIfAdminExist(name, "unknown") then
			local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
			local TABLE = util.JSONToTable(FILE)
			local ValueTable = FindAdminPlace(TABLE, name, "unknown")
			if type == "Claim" then 
				ValueTable.CLAIMS = 0
				file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			elseif type == "Complete" then
				ValueTable.CLOSES = 0
				file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			elseif type == "Both" then
				ValueTable.CLAIMS = 0
				ValueTable.CLOSES = 0
				file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			end
		end
	end
end)

concommand.Add("showcompete", function()
	local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	for k, v in pairs(TABLE) do
		PrintTable(v)
	end
end)	