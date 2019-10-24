-- DIMENSIONS
local HUDWidth = 510
local HUDHeight = 120
local BarWidth = 375
local BarHeight = 10
local HeaderHeight = 40
local Padding = 10
local LeftPadding = 10
local Indent = 135
local RightItemsIndent = 525
local RightItemWidth = 200
local RightItemText = 535
local AmmoCounterWidth = 180
local AmmoCounterHeight = 100
local AmmoCounterIndent = ScrW() - AmmoCounterWidth - Padding
local WantedInfoHeight = (HUDHeight + Padding) * 2 - 20
local InfoBoxWidth = 180
local InfoBoxIndent = ScrW() - InfoBoxWidth - Padding

-- COLORS
local HUDBackground = Color(10, 10, 10, 230)
local BarBackground = Color(40,40,40,255)
local BarBackgroundsBackground = Color(60,60,60, 255)
local BlackColor = Color(5, 5, 5, 255)
local BarTextColor = Color(255, 255, 255,255)
local HUDTextColor = Color(255, 255, 255,255)
local HeaderTextColor = Color(255, 255, 255,255)
local AmmoCounterTextColor = Color(255,255,255,255)

-- FONTS
local BarFont = "Oswald"
local HUDFont = "CloseCaption_Normal"
local HUDFontBold = "CloseCaption_Bold"

-- MISC
local LicenseIcon = Material("icon16/page_white_text.png") -- LICENSE LOGO
local WantedIcon = Material("icon16/delete.png") -- WANTED LOGO
local WantedSound = "buttons/button1.wav" -- WANTED SOUND

-- Try not to mess with things you dont need to mess with. in a future update ill work on this and add a configuration file, 
-- If you want to change the colors of the Health and Armor bars, change the values on lines 132 and 135

--[[---------------------------------------------------------------------------
Main HUD
---------------------------------------------------------------------------]]--

local function DarkHUDBase()

	draw.RoundedBox(0, LeftPadding, ScrH() - HUDHeight - Padding, HUDWidth, HUDHeight, HUDBackground) -- HUD Background
	draw.RoundedBox(0, RightItemsIndent, ScrH() - HUDHeight - Padding, RightItemWidth, HUDHeight, HUDBackground) -- Right Items Background
	
	-- You have a gun, draw ammo box
	local wep = LocalPlayer():GetActiveWeapon()
	if (IsValid(wep)) then
		draw.RoundedBox(0, AmmoCounterIndent, ScrH() - AmmoCounterHeight - Padding, AmmoCounterWidth, AmmoCounterHeight, HUDBackground) -- Ammo Counter Background
		draw.RoundedBox(0, AmmoCounterIndent, ScrH() - AmmoCounterHeight - Padding, AmmoCounterWidth, HeaderHeight, BlackColor) -- Ammo Counter Header
		draw.RoundedBox(0, AmmoCounterIndent + (AmmoCounterWidth / 2), ScrH() - AmmoCounterHeight + HeaderHeight - Padding, 2, AmmoCounterHeight - HeaderHeight, BlackColor) -- Ammo Counter Divider
		draw.DrawText("Ammo", "OswaldLarge", AmmoCounterIndent + (AmmoCounterWidth / 2) - 25, ScrH() - AmmoCounterHeight - Padding + 6, HeaderTextColor) -- Ammo Counter Header
		
		local currentAmmo = LocalPlayer():GetActiveWeapon():Clip1()
		local reserveAmmo = LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() )
		
		if reserveAmmo < 10 then
			draw.DrawText(reserveAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4 * 3) - 10, ScrH() - 77, AmmoCounterTextColor) -- Draw Total Ammo
		elseif reserveAmmo < 20 then
			draw.DrawText(reserveAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4 * 3) - 16, ScrH() - 77, AmmoCounterTextColor) -- Draw Total Ammo
		elseif reserveAmmo < 100 then
			draw.DrawText(reserveAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4 * 3) - 20, ScrH() - 77, AmmoCounterTextColor) -- Draw Total Ammo
		elseif reserveAmmo < 1000 then
			draw.DrawText(reserveAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4 * 3) - 35, ScrH() - 77, AmmoCounterTextColor) -- Draw Total Ammo
		else 
			draw.DrawText(reserveAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4 * 3) - 42, ScrH() - 77, AmmoCounterTextColor) -- Draw Total Ammo
		end
		
		if currentAmmo < 10 then
			draw.DrawText(currentAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4) - 8, ScrH() - 77, AmmoCounterTextColor) -- Draw Current Ammo
		elseif currentAmmo < 20 then
			draw.DrawText(currentAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4) - 15, ScrH() - 77, AmmoCounterTextColor) -- Draw Current Ammo
		elseif currentAmmo < 100 then
			draw.DrawText(currentAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4) - 20, ScrH() - 77, AmmoCounterTextColor) -- Draw Current Ammo
		elseif currentAmmo < 1000 then
			draw.DrawText(currentAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4) - 35, ScrH() - 77, AmmoCounterTextColor) -- Draw Current Ammo
		else 
			draw.DrawText(currentAmmo, "OswaldAmmo", AmmoCounterIndent + (AmmoCounterWidth / 4) - 42, ScrH() - 77, AmmoCounterTextColor) -- Draw Current Ammo
		end
	else
		--print("Not a Weapon") -- REENABLE FOR DEBUGGING
	end
	
	-- Set wanted to true if wanted
	if LocalPlayer():getDarkRPVar("wanted") then
		wanted = true
	else
		wanted = false
	end
	
	-- Set arrested to true if arrested
	if LocalPlayer():getDarkRPVar("Arrested") then
		arrested = true
	else
		arrested = false
	end

	-- Draw the name and header
	draw.DrawText(LocalPlayer():Nick(), "Magnolia", Indent + 2, ScrH() - HUDHeight - Padding + 5, HeaderTextColor) -- Draw Name
	
	if LocalPlayer():GetUserGroup() != "user" then
		--for key,value in pairs(AdminRanks) do
			--if LocalPlayer():GetUserGroup() == value then
		draw.DrawText(LocalPlayer():GetUserGroup(), "Magnolia Small", 210, ScrH() - 80, Color(255,255,255,25)) -- Draw Rank
			--end
		--end
	end
	
	-- Echo values are for text readouts
	local Health = LocalPlayer():Health() or 0
	local Armor = LocalPlayer():Armor() or 0
	
	-- Health/Armor/Hunger checkers to prevent negative values and make minimum 0
	if Health > 100 then Health = 100 end
	if Health < 0 then Health = 0 end
	
	if Armor > 100 then Armor = 100 end
	if Armor < 0 then Armor = 0 end
		
	-- Health/Armor/Hunger
	draw.RoundedBox(6, Indent - 2, ScrH() - 18 - Padding - 2, BarWidth + 4, BarHeight + 4, BarBackgroundsBackground) -- Armor Background's Background
	draw.RoundedBox(6, Indent - 2, ScrH() - 28 - Padding - 2, BarWidth + 4, BarHeight + 4, BarBackgroundsBackground) -- Health Background's Background
	draw.RoundedBox(6, Indent, ScrH() - 28 - Padding, BarWidth, BarHeight, BarBackground) -- Health Background
	draw.RoundedBox(6, Indent, ScrH() - 18 - Padding, BarWidth, BarHeight, BarBackground) -- Armor Background
	if Health != 0 then
		draw.RoundedBox(6, Indent, ScrH() - 28 - Padding, (BarWidth) * Health / 100, BarHeight, Color(227, 67, 67, 255))
	end
	if Armor != 0 then
		draw.RoundedBox(6, Indent, ScrH() - 18 - Padding, (BarWidth) * Armor / 100, BarHeight, Color(75, 75, 255, 255))
	end
	
	-- Wallet
	draw.DrawText("Wallet :", "DermaDefaultBold", RightItemText, ScrH() - 117, HUDTextColor) -- Draw Money Display
	draw.DrawText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")), "Oswald", RightItemText, ScrH() - 102, HUDTextColor) -- Draw Money Player
	-- Salary
	draw.DrawText("Salary :", "DermaDefaultBold", RightItemText, ScrH() - 82, HUDTextColor) -- Draw Salary Display
	draw.DrawText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")), "Oswald", RightItemText, ScrH() - 67, HUDTextColor) -- Draw Salary Player
	-- Job
	draw.DrawText("Job :", "DermaDefaultBold", RightItemText, ScrH() - 47, HUDTextColor) -- Draw Job Display
	draw.DrawText(LocalPlayer():getDarkRPVar("job"), "Oswald", RightItemText , ScrH() - 34, HUDTextColor) -- Draw Job Player
	
	-- Wanted
	if LocalPlayer():getDarkRPVar("wanted") then
		surface.SetMaterial(WantedIcon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(Indent + 45, ScrH() - 60, 20, 20)
		draw.DrawText("Wanted", "Oswald", Indent, ScrH() - 60, Color(255,255,255,255)) -- Draw Wanted ACTIVE
		--surface.PlaySound(WantedSound)
		-- Wanted info box, right side of screen
		draw.RoundedBox(0, InfoBoxIndent, ScrH() - WantedInfoHeight, InfoBoxWidth, HUDHeight, HUDBackground) -- Wanted Background
		draw.RoundedBox(0, InfoBoxIndent, ScrH() - WantedInfoHeight, InfoBoxWidth, HeaderHeight, BlackColor) -- Wanted Background
		draw.DrawText("WANTED!", "OswaldLarge", InfoBoxIndent + (InfoBoxWidth / 2) - 40, ScrH() - WantedInfoHeight + 5, Color(255,255,255,255)) -- Draw Wanted
		local wantedReason = DarkRP.textWrap(LocalPlayer():getWantedReason(), "Oswald", InfoBoxWidth - 10)
		draw.DrawText("Reason: \n"..wantedReason, "Oswald", InfoBoxIndent + 5, ScrH() - WantedInfoHeight + 50, Color(255,255,255,255)) -- Draw Wanted
	else
		surface.SetMaterial(WantedIcon)
		surface.SetDrawColor(150, 150, 150, 100)
		surface.DrawTexturedRect(Indent + 45, ScrH() - 60, 20, 20)
		draw.DrawText("Wanted", "Oswald", Indent, ScrH() - 60, Color(255,255,255,25)) -- Draw Wanted INACTIVE
	end
	
	-- Gun License
	if LocalPlayer():getDarkRPVar("HasGunlicense") then
		surface.SetMaterial(LicenseIcon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(Indent + 45, ScrH() - 82, 20, 20)
		draw.DrawText("License", "Oswald", Indent, ScrH() - 82, Color(255,255,255,255)) -- Draw License ACTIVE
	else
		surface.SetMaterial(LicenseIcon)
		surface.SetDrawColor(150, 150, 150, 100)
		surface.DrawTexturedRect(Indent + 45, ScrH() - 82, 20, 20)
		draw.DrawText("License", "Oswald", Indent, ScrH() - 82, Color(255,255,255,25)) -- Draw License INACTIVE
	end
	
end

--[[---------------------------------------------------------------------------
HUD ConVars
---------------------------------------------------------------------------]]--
local ConVars = {}
local HUDWidth
local HUDHeight

local Color = Color
local CurTime = CurTime
local cvars = cvars
local DarkRP = DarkRP
local draw = draw
local GetConVar = GetConVar
local hook = hook
local IsValid = IsValid
local Lerp = Lerp
local localplayer
local math = math
local pairs = pairs
local ScrW, ScrH = ScrW, ScrH
local SortedPairs = SortedPairs
local string = string
local surface = surface
local table = table
local timer = timer
local tostring = tostring
local plyMeta = FindMetaTable("Player")

local colors = {}
colors.black = Color(0, 0, 0, 255)
colors.blue = Color(0, 0, 255, 255)
colors.brightred = Color(200, 30, 30, 255)
colors.darkred = Color(0, 0, 70, 100)
colors.darkblack = Color(0, 0, 0, 200)
colors.gray1 = Color(0, 0, 0, 155)
colors.gray2 = Color(51, 58, 51,100)
colors.red = Color(255, 0, 0, 255)
colors.white = Color(255, 255, 255, 255)
colors.white1 = Color(255, 255, 255, 200)

local function ReloadConVars()
    ConVars = {
        background = {0,0,0,100},
        Healthbackground = {0,0,0,200},
        Healthforeground = {140,0,0,180},
        HealthText = {255,255,255,200},
        Job1 = {0,0,150,200},
        Job2 = {0,0,0,255},
        salary1 = {0,150,0,200},
        salary2 = {0,0,0,255}
    }

    for name, Colour in pairs(ConVars) do
        ConVars[name] = {}
        for num, rgb in SortedPairs(Colour) do
            local CVar = GetConVar(name .. num) or CreateClientConVar(name .. num, rgb, true, false)
            table.insert(ConVars[name], CVar:GetInt())

            if not cvars.GetConVarCallbacks(name .. num, false) then
                cvars.AddChangeCallback(name .. num, function()
                    timer.Simple(0, ReloadConVars)
                end)
            end
        end
        ConVars[name] = Color(unpack(ConVars[name]))
    end


    HUDWidth = (GetConVar("HudW") or  CreateClientConVar("HudW", 240, true, false)):GetInt()
    HUDHeight = (GetConVar("HudH") or CreateClientConVar("HudH", 115, true, false)):GetInt()

    if not cvars.GetConVarCallbacks("HudW", false) and not cvars.GetConVarCallbacks("HudH", false) then
        cvars.AddChangeCallback("HudW", function() timer.Simple(0,ReloadConVars) end)
        cvars.AddChangeCallback("HudH", function() timer.Simple(0,ReloadConVars) end)
    end
end
ReloadConVars()

local Scrw, Scrh, RelativeX, RelativeY

--[[---------------------------------------------------------------------------
Agenda
---------------------------------------------------------------------------]]--

local agendaText
local agendaXPos = 10
local agendaYPos = 10
local agendaWidth = 420
local agendaHeight = 120
local agendaBackground = Color(255,255,255,200)

local function Agenda()

    local agenda = localplayer:getAgendaTable()
    if not agenda then return end
    agendaText = agendaText or DarkRP.textWrap((localplayer:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "DarkRPHUD1", 380)

		draw.RoundedBox(0, agendaXPos, agendaYPos, agendaWidth, agendaHeight, agendaBackground) -- Draw background
		draw.RoundedBox(0, agendaXPos, agendaYPos, agendaWidth, 25, BlackColor) -- Draw header bar

    draw.DrawNonParsedText(agenda.Title, "Oswald", 30, 13, colors.white, 0)
    draw.DrawNonParsedText(agendaText, "Oswald", 30, 35, colors.black, 0)
		
end

hook.Add("DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)
    if ply ~= localplayer then return end
    if var == "agenda" and new then
        agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "Oswald", 380)
    else
        agendaText = nil
    end

    if var == "salary" then
        salaryText = DarkRP.getPhrase("salary", DarkRP.formatMoney(new), "")
    end

    if var == "job" or var == "money" then
        JobWalletText = string.format("%s\n%s",
            DarkRP.getPhrase("job", var == "job" and new or localplayer:getDarkRPVar("job") or ""),
            DarkRP.getPhrase("wallet", var == "money" and DarkRP.formatMoney(new) or DarkRP.formatMoney(localplayer:getDarkRPVar("money")), "")
        )
    end
end)


--[[---------------------------------------------------------------------------
Voice Box
---------------------------------------------------------------------------]]--

local VoiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
local function DrawVoiceChat()
    if localplayer.DRPIsTalking then
        local _, chboxY = chat.GetChatBoxPos()

        local Rotating = math.sin(CurTime() * 3)
        local backwards = 0

        if Rotating < 0 then
            Rotating = 1 - (1 + Rotating)
            backwards = 180
        end

        surface.SetTexture(VoiceChatTexture)
        surface.SetDrawColor(ConVars.Healthforeground)
        surface.DrawTexturedRectRotated(ScrW() - 100, chboxY, Rotating * 96, 96, backwards)
    end
end

--[[---------------------------------------------------------------------------
Lockdown
---------------------------------------------------------------------------]]--

local function LockDown()
    local chbxX, chboxY = chat.GetChatBoxPos()
    if GetGlobalBool("DarkRP_LockDown") then
			if arrested or wanted then -- if theyre wanted, move lockdown box up
				draw.RoundedBox(0, InfoBoxIndent, ScrH() - (HUDHeight * 2) - Padding - 5 - HeaderHeight - 5, InfoBoxWidth, HeaderHeight, BlackColor) -- Lockdown Box
				draw.DrawText("LOCKDOWN!", "OswaldLarge",  InfoBoxIndent + (InfoBoxWidth / 2) - 50, ScrH() - (HUDHeight * 2) - Padding - 5 - HeaderHeight - 2, Color(255,255,255,255)) -- Lockdown Text
			else -- else move it back down
				draw.RoundedBox(0, InfoBoxIndent, ScrH() - HUDHeight - HeaderHeight - Padding + 5, InfoBoxWidth, HeaderHeight, BlackColor) -- Lockdown Box
				draw.DrawText("LOCKDOWN!", "OswaldLarge",  InfoBoxIndent + (InfoBoxWidth / 2) - 50, ScrH() - HUDHeight - HeaderHeight - Padding + 7, Color(255,255,255,255)) -- Lockdown Text
			end
		end
end

--[[---------------------------------------------------------------------------
Arrested
---------------------------------------------------------------------------]]--

local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)
    local StartArrested = CurTime()
    local ArrestedUntil = msg:ReadFloat()

    Arrested = function()
        local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_ArrestedHUD")
        if shouldDraw == false then return end

        if CurTime() - StartArrested <= ArrestedUntil and localplayer:getDarkRPVar("Arrested") then
            draw.RoundedBox(0, InfoBoxIndent, ScrH() - WantedInfoHeight, InfoBoxWidth, HUDHeight, HUDBackground) -- Arrested Background
						draw.RoundedBox(0, InfoBoxIndent, ScrH() - WantedInfoHeight, InfoBoxWidth, HeaderHeight, BlackColor) -- Arrested Header
						draw.DrawText("ARRESTED!", "OswaldLarge", InfoBoxIndent + (InfoBoxWidth / 2) - 42, ScrH() - WantedInfoHeight + 5, Color(255,255,255,255)) -- Draw Arrested
						local TimeLeft = math.ceil((ArrestedUntil - (CurTime() - StartArrested)) * 1 / game.GetTimeScale())
						if TimeLeft > 999 then TimeLeft = "999+" end -- Set it to 999+ if over 999 seconds. why you have it that high I'll never know
						draw.DrawText("You've been arrested!\nTime Remaining: "..TimeLeft, "OswaldLarge", InfoBoxIndent + 15, ScrH() - WantedInfoHeight + 45, Color(0,0,0,255)) -- Draw Arrested Time Remaining
				elseif not localplayer:getDarkRPVar("Arrested") then
            Arrested = function() end
        end

    end
end)

--[[---------------------------------------------------------------------------
Admin Tell
---------------------------------------------------------------------------]]--

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
    timer.Remove("DarkRP_AdminTell")
    local Message = msg:ReadString()

    AdminTell = function()
        draw.RoundedBox(4, 10, 10, Scrw - 20, 110, colors.darkblack)
        draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", Scrw / 2 + 10, 10, colors.white, 1)
        draw.DrawNonParsedText(Message, "ChatFont", Scrw / 2 + 10, 90, colors.brightred, 1)
    end

    timer.Create("DarkRP_AdminTell", 10, 1, function()
        AdminTell = function() end
    end)
end)

--[[---------------------------------------------------------------------------
Entity HUDPaint things
---------------------------------------------------------------------------]]--
-- Draw a player's name, health and/or job above the head
-- This syntax allows for easy overriding
plyMeta.drawPlayerInfo = plyMeta.drawPlayerInfo or function(self)
    local pos = self:EyePos()

    pos.z = pos.z + 10 -- The position we want is a bit above the position of the eyes
    pos = pos:ToScreen()
    if not self:getDarkRPVar("wanted") then
        -- Move the text up a few pixels to compensate for the height of the text
        pos.y = pos.y - 50
    end

    if GAMEMODE.Config.showname then
        local nick, plyTeam = self:Nick(), self:Team()
        draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x + 1, pos.y + 1, colors.black, 1)
        draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)
    end

    if GAMEMODE.Config.showhealth then
        local health = DarkRP.getPhrase("health", self:Health())
        draw.DrawNonParsedText(health, "DarkRPHUD2", pos.x + 1, pos.y + 21, colors.black, 1)
        draw.DrawNonParsedText(health, "DarkRPHUD2", pos.x, pos.y + 20, colors.white1, 1)
    end

    if GAMEMODE.Config.showjob then
        local teamname = self:getDarkRPVar("job") or team.GetName(self:Team())
        draw.DrawNonParsedText(teamname, "DarkRPHUD2", pos.x + 1, pos.y + 41, colors.black, 1)
        draw.DrawNonParsedText(teamname, "DarkRPHUD2", pos.x, pos.y + 40, colors.white1, 1)
    end

    if self:getDarkRPVar("HasGunlicense") then
        surface.SetMaterial(Page)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(pos.x-16, pos.y + 60, 32, 32)
    end
end

-- Draw wanted information above a player's head
-- This syntax allows for easy overriding
plyMeta.drawWantedInfo = plyMeta.drawWantedInfo or function(self)
    if not self:Alive() then return end

    local pos = self:EyePos()
    if not pos:isInSight({localplayer, self}) then return end

    pos.z = pos.z + 10
    pos = pos:ToScreen()

    if GAMEMODE.Config.showname then
        local nick, plyTeam = self:Nick(), self:Team()
        draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x + 1, pos.y + 1, colors.black, 1)
        draw.DrawNonParsedText(nick, "DarkRPHUD2", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)
    end

    local wantedText = DarkRP.getPhrase("wanted", tostring(self:getDarkRPVar("wantedReason")))

    draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x, pos.y - 40, colors.white1, 1)
    draw.DrawNonParsedText(wantedText, "DarkRPHUD2", pos.x + 1, pos.y - 41, colors.red, 1)
end

--[[---------------------------------------------------------------------------
The Entity display: draw HUD information about entities
---------------------------------------------------------------------------]]--
local function DrawEntityDisplay()

    local shootPos = localplayer:GetShootPos()
    local aimVec = localplayer:GetAimVector()

    for k, ply in pairs(players or player.GetAll()) do
        if ply == localplayer or not ply:Alive() or ply:GetNoDraw() then continue end
        local hisPos = ply:GetShootPos()
        if ply:getDarkRPVar("wanted") then ply:drawWantedInfo() end

        if GAMEMODE.Config.globalshow then
            ply:drawPlayerInfo()
        -- Draw when you're (almost) looking at him
        elseif hisPos:DistToSqr(shootPos) < 160000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, localplayer)
                if trace.Hit and trace.Entity ~= ply then break end
                ply:drawPlayerInfo()
            end
        end
    end

    local tr = localplayer:GetEyeTrace()

    if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(localplayer:GetPos()) < 40000 then
        tr.Entity:drawOwnableInfo()
    end
end

--[[---------------------------------------------------------------------------
Drawing death notices
---------------------------------------------------------------------------]]--
function GAMEMODE:DrawDeathNotice(x, y)
    if not GAMEMODE.Config.showdeaths then return end
    self.Sandbox.DrawDeathNotice(self, x, y)
end

--[[---------------------------------------------------------------------------
Display notifications
---------------------------------------------------------------------------]]--
local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    -- Log to client console
    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

--[[---------------------------------------------------------------------------
Disable players' names popping up when looking at them
---------------------------------------------------------------------------]]--
function GAMEMODE:HUDDrawTargetID()
    return false
end


--[[---------------------------------------------------------------------------
Hide default DarkRP HUD
---------------------------------------------------------------------------]]--

local DarkRPIgnoreList = {
    ["DarkRP_HUD"]              = true,     // Controls all DarkRP huds including arrested, lockdown, etc
    ["DarkRP_LocalPlayerHUD"]   = true,     // Bottom left hud
    ["DarkRP_EntityDisplay"]    = true,     // Info for doors, vehicles, and above player head
    ["DarkRP_ZombieInfo"]       = true,     // Information from /showzombie
    ["DarkRP_Hungermod"]        = true,     // Hunger mod information
    ["DarkRP_Agenda"]           = true,     // Agenda hud
    ["CHudHealth"]              = true,     // Player health
    ["CHudBattery"]             = true,     // Suit battery
    ["CHudSuitPower"]           = true,     // Suit power
    ["CHudAmmo"]                = true,     // Weapon ammo
    ["CHudSecondaryAmmo"]       = true,     // Secondary weapon ammo
}

local function HideElements( element )
	if DarkRPIgnoreList[ element ] then
		return false
	end
end
hook.Add( "HUDShouldDraw", "HideElements", HideElements )

--[[---------------------------------------------------------------------------
Actual HUDPaint hook
---------------------------------------------------------------------------]]--
function DrawHUD()
    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end

		-- Custom RoseHUD
		DarkHUDBase()
    Agenda()
    LockDown()
    Arrested()
		
		-- Default DarkRP
    DrawVoiceChat()
    AdminTell()
		DrawEntityDisplay()
		
end

hook.Add("HUDPaint", "DrawHUD", DrawHUD)


--[[---------------------------------------------------------------------------
Player's Profile Pic -- Doesnt update until server rejoin
---------------------------------------------------------------------------]]--
local function HUDValidCheck()
	local Avatar = vgui.Create("AvatarImage", Panel)
	Avatar:SetSize(110, 110)
	Avatar:SetPos(LeftPadding + 5, ScrH() - 110 - Padding - 5)
	Avatar:SetPlayer(LocalPlayer(), 64)
end
hook.Add("InitPostEntity", "DarkHUDProfilePic", HUDValidCheck)