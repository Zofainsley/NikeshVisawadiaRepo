local Meta = FindMetaTable( "Player" )

function Meta:IsARSAdmin()
	if table.HasValue( ARS.Admins, string.lower( self:GetUserGroup() ) ) then
		return true
	else
		return false
	end
end

function GetAllAdmins()
	local rtbl = {}
	for k, v in ipairs(player.GetAll()) do
		if v:IsARSAdmin() then
			table.insert(rtbl, v)
		end
	end
	return rtbl
end

function IsHere(name)
	for k, v in pairs(player.GetAll()) do 
		if v:Nick() == name then 
			return true
		end
	end
	return false
end

function AnyAdmins()
	for k, v in pairs(player.GetAll()) do 
		if v:IsARSAdmin() then 
			return true
		end
	end
	return false
end

function Meta:IsNotTouchable() 
	if table.HasValue( ARS.NotReportable, string.lower( self:GetUserGroup() ) ) then
		return true
	else
		return false
	end
end

function Meta:DeleteAble() 
	if table.HasValue( ARS.DeleteAbility, string.lower( self:GetUserGroup() ) ) then
		return true
	else
		return false
	end
end

function AddReport( Table, Day, Time, Reporter, rteam, rrank, rid, Name, nteam, nrank, nid, Reason, Status, ExtraD )
	table.insert(Table, {DATE = Day, TIME = Time, REPORTER = Reporter, RTEAM = rteam, RRANK = rrank, RID = rid,  NAME = Name, NTEAM = nteam, NRANK = nrank, NID = nid, REASON = Reason, STATUS = Status, ED = ExtraD})
	return table.Count(Table)
end

function SetAdminStat(Table, Name, SteamID, Rank, Closes, Claims)
	table.insert(Table, {NAME = Name, SID = SteamID, RANK = Rank, CLOSES = Closes, CLAIMS = Claims})
end

function CheckClaimedOrNah(num)
	if file.Exists( "ars_reports/savedreports.txt", "DATA" ) then 
		local FILE = file.Read( "ars_reports/savedreports.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		if TABLE[num].STATUS == "" then
			return true
		else
			return false
		end
	else
		return false
	end
end

function CheckIfAdminExist(sid)
	if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
		local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
		local TABLE = util.JSONToTable(FILE)
		for k, v in pairs(TABLE) do
			if v.SID == sid then
				return true
			end
		end
		return false
	else
		return false
	end
end

function FindTopFiveAdmins()
	local rtbl = {}
	local topfive = {1, 2, 3, 4, 5}
	local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	table.SortByMember(TABLE,"CLOSES",false)
	for k, v in pairs(TABLE) do
		if table.HasValue(topfive, k) then
			table.insert(rtbl, v)
		end
	end
	return rtbl
end

function FindAllAdmins()
	local rtbl = {}
	local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	table.SortByMember(TABLE,"CLOSES",false)
	for k, v in pairs(TABLE) do
		table.insert(rtbl, v)
	end
	return rtbl
end

function RemoveAdmin(tarid)
	local rtbl = {}
	local FILE = file.Read( "ars_reports/admin/adminstats.txt", "DATA" )
	local TABLE = util.JSONToTable(FILE)
	for k, v in pairs(TABLE) do
		if v.SID == tarid then
			table.remove(TABLE, k)
			PrintTable(TABLE)
			file.Write("ars_reports/admin/adminstats.txt", util.TableToJSON(TABLE))
			MsgN("[ARS] Removed "..tarid.."'s Position in the Stats and Wrote the File!")
		end
	end
end

function FindAdminPlace(tbl, name, sid)
	if file.Exists( "ars_reports/admin/adminstats.txt", "DATA" ) then
		for k, v in pairs(tbl) do
			if v.SID == sid or v.NAME == name then
				return v
			end
		end
	end
end

function CheckTable(tbl, number)
	for k, v in pairs(tbl) do 
		if k == number then 
			return v
		end 
	end
end

function ARSdrawLine( Start, Start2, End, End2 )
	surface.SetDrawColor(Color(0, 0, 0))
	surface.DrawLine( Start, Start2, End, End2 )
end
function ARSdrawBlackLine( Start, Start2, End, End2 )
	surface.SetDrawColor(Color(0, 0, 0, 255))
	surface.DrawOutlinedRect( Start, Start2, End, End2 )
end
function ARSdrawBoxLine( Start, Start2, End, End2 )
	surface.SetDrawColor(Color(125, 125, 125, 76.5))
	surface.DrawOutlinedRect( Start, Start2, End, End2 )
end

hook.Add("PlayerInitialSpawn", "SetValuesRighARS", function(ply)
	ply:SetPData("ablereport", true)
	--MsgN("Set Values!") --Debug only
end)

function Meta:StartTimeSince()
	self:SetPData("ablereport", false)
	--print(self:GetPData("ablereport"))
	timer.Simple(ARS.SpamReportPreventTime, function()
		self:SetPData("ablereport", true)
		--print(self:GetPData("ablereport"))
	end)
end

function Meta:CanDoIt()
	--print(self:GetPData("ablereport", true))
	return self:GetPData("ablereport", true)
end

function ARSNotify(ply, type, time, message)
	if ply:IsValid() and ply:IsPlayer() then
		util.AddNetworkString("ARSClientNotify")
		net.Start("ARSClientNotify")
			local rtbl = {}
			rtbl.msg = message
			rtbl.type = type
			rtbl.time = time
			net.WriteTable(rtbl)
		net.Send(ply)
	end
end

local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() then
			target = v
		end
	end
	return target
end

function ReOpenReports(name)
	if FindPlayer(name):IsARSAdmin() then
		local HereorNah
		net.Start("ARS_Reopen_ToClient")
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
		net.Send(FindPlayer(name))
	end
end

function ARSDrawCircle( posx, posy, radius, color, selected )
	local poly = { }
	local v = 40
	for i = 0, v do
		poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
	if selected then
		surface.DrawCircle(posx, posy, radius, Color(255, 255, 255, 255))
	else
		surface.DrawCircle(posx, posy, radius, color)
	end
end

function ARSGraphNumber(num, x, y)
	draw.SimpleText( num, "Graph_Numbers", 60, y, ARS.TextRequestColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function ARSGraphBar(w, h, x, y, color)
	draw.RoundedBox( 0, x, y, w, h, color )
	ARSdrawLine( x, y, x, y+h )
	ARSdrawLine( x, y, x+w, y )
	ARSdrawLine( x+w, y, x+w, y+h )
end