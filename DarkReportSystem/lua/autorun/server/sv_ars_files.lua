hook.Add( "PostGamemodeLoaded", "WriteReportFiles", function()
	if !file.IsDir( "ars_reports", "DATA" ) then
		file.CreateDir( "ars_reports", "DATA" )
		MsgN( "[ARS] Created ars_reports!" )
	end
	if ARS.ResetReports then 
		if file.Exists( "ars_reports/savedreports.txt", "DATA" ) then
			file.Delete( "ars_reports/savedreports.txt" )
			MsgN( "[ARS] Deleted savedreports.txt!" )
		end
	end
end)
hook.Add( "PostGamemodeLoaded", "WriteClosedFiles", function()
	if !file.IsDir( "ars_reports/closed", "DATA" ) then
		file.CreateDir( "ars_reports/closed", "DATA" )
		MsgN( "[ARS] Created ars_reports/closed!" )
	end
	if !file.IsDir( "ars_reports/admin", "DATA" ) then
		file.CreateDir( "ars_reports/admin", "DATA" )
		MsgN( "[ARS] Created ars_reports/admin!" )
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

net.Receive("ARS_ClaimReport_ToServer", function()
	local tbl = net.ReadTable()
	local number = tbl.Number
	local ply = tbl.Player
	if file.Exists( "ars_reports/savedreports.txt", "DATA" ) then 
		local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		local ValueTable = CheckTable(TABLE, number)
		if CheckClaimedOrNah(number) then
			ValueTable.STATUS = "Claimed by: "..ply
			file.Write("ars_reports/savedreports.txt", util.TableToJSON(TABLE))
			--MsgN("Re-Wrote file for claim. The status of this report is: "..ValueTable.STATUS)--Debug
			hook.Call( "ARS_AdminClaimed_Report", GAMEMODE, number, ply )
		end
	end

	ReOpenReports(ply)
end)

net.Receive("ARS_Closed_Logs_ToServer", function()
	local name = net.ReadString()
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
