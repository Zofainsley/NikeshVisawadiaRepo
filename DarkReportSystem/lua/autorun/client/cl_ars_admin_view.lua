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
		if v:Nick() == targ then 
			return true
		end
	end
	return false
end
local function DrawPlayerViewAv( panel, ply )
	local PlyAvatar = vgui.Create( "AvatarImage", panel )
	PlyAvatar:SetPos( 10, panel:GetTall()-90 )
	PlyAvatar:SetSize( 80, 80 )
	PlyAvatar:SetPlayer( ply, 64 )
	avatar = true
	timer.Simple( 1, function()
		avatar = false
	end)
end

net.Receive("ARS_ViewReport_ToClient", function()
	local tbl = net.ReadTable()
	local num = net.ReadString()
	local bool = net.ReadBool()
	if !IsValid(ARSViewMain) then 
		--print(bool)
		ARSViewMain = vgui.Create( "DFrame" ) 
		ARSViewMain:SetSize( 750, 480 )
		ARSViewMain:SetPos( ScrW()/2-ARSViewMain:GetWide()/2, ScrH()/2-ARSViewMain:GetTall()/2 )
		ARSViewMain:SetTitle( " " ) 
		ARSViewMain:SetVisible( true )
		ARSViewMain:SetDraggable( false ) 
		ARSViewMain:ShowCloseButton( false ) 				
		ARSViewMain:MakePopup() 
		ARSViewMain:SetBackgroundBlur( true )
		ARSViewMain.Paint = function()
			draw.RoundedBoxEx( 4, 0, 0, ARSViewMain:GetWide(), 30, ARS.RequestHeaderColor, true, true, false, false )
			draw.SimpleText( "Viewing Report: "..tbl.REPORTER.." VS "..tbl.NAME, "Headings_Text", ARSViewMain:GetWide()/2, 2, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.RoundedBoxEx( 0, 0, 30, ARSViewMain:GetWide(), ARSViewMain:GetTall()-30, ARS.RequestBGColor, false, false, true, true )
			surface.SetDrawColor(Color(0, 0, 0))
			surface.DrawOutlinedRect( 0, 0, ARSViewMain:GetWide(), ARSViewMain:GetTall() )
		end
		
		local CloseButton = vgui.Create( "DButton", ARSViewMain )
		CloseButton:SetSize( 50, 30 )
		CloseButton:SetPos( 10,0 )
		CloseButton:SetText( "Back" )
		CloseButton:SetFont( "Category_Text" )
		CloseButton:SetTextColor( ARS.TextRequestColor )
		CloseButton.Paint = function(self, w, h)
		
		end
		CloseButton.DoClick = function()
			ARSViewMain:Remove()
		end
		CloseButton.OnCursorEntered = function( self )
			self.hover = true
			self:SetTextColor( Color(255, 0, 0) )
		end
		CloseButton.OnCursorExited = function( self )
			self.hover = false
			self:SetTextColor( ARS.TextRequestColor )
		end
		
		local ARSViewReporterInfo = vgui.Create( "DPanel", ARSViewMain )
		ARSViewReporterInfo:SetPos( 10, 40 )
		ARSViewReporterInfo:SetSize( 360, 140 )
		ARSViewReporterInfo.Paint = function()
			local ply = FindPlayer(tbl.REPORTER)
			local NameLen = string.len(tbl.REPORTER)
			local JobLen = string.len(tbl.RTEAM)
			local RankLen = string.len(tbl.RRANK)
			draw.RoundedBox( 0, 0, 0, ARSViewReporterInfo:GetWide(), ARSViewReporterInfo:GetTall(), ARS.RequestHeaderColor )
			draw.SimpleText( "Reporter Information:", "Headings_Text", ARSViewReporterInfo:GetWide()/2, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBlackLine( 0, 0, ARSViewReporterInfo:GetWide(), ARSViewReporterInfo:GetTall() )
			ARSdrawBoxLine(1, 1, ARSViewReporterInfo:GetWide()-2, ARSViewReporterInfo:GetTall()-2)
			if NameLen <=16 then 
				draw.SimpleText( "Name: "..tbl.REPORTER, "List_Text", 100, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Name: "..string.sub(tbl.REPORTER, 1, 13).."...", "List_Text", 100, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			if JobLen <= 16 then
				draw.SimpleText( "Job: "..tbl.RTEAM, "List_Text", 100, 70, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Job: "..string.sub(tbl.RTEAM, 1, 13).."...", "List_Text", 100, 70, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			if RankLen <= 16 then 
				draw.SimpleText( "Rank: "..tbl.RRANK, "List_Text", 100, 90, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Rank: "..string.sub(tbl.RRANK, 1, 13).."...", "List_Text", 100, 90, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			draw.SimpleText( "SteamID: ", "List_Text", 100, 110, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		end
		
		DrawPlayerViewAv( ARSViewReporterInfo, FindPlayer(tbl.REPORTER) )
		
		local ARSViewReportedPlayerInfo = vgui.Create( "DPanel", ARSViewMain )
		ARSViewReportedPlayerInfo:SetPos( ARSViewMain:GetWide()-370, 40 )
		ARSViewReportedPlayerInfo:SetSize( 360, 140 )
		ARSViewReportedPlayerInfo.Paint = function()
			local NameLen = string.len(tbl.NAME)
			local JobLen = string.len(tbl.NTEAM)
			local RankLen = string.len(tbl.NRANK)
			draw.RoundedBox( 0, 0, 0, ARSViewReportedPlayerInfo:GetWide(), ARSViewReportedPlayerInfo:GetTall(), ARS.RequestHeaderColor )
			draw.SimpleText( "Reported Player Information:", "Headings_Text", ARSViewReportedPlayerInfo:GetWide()/2, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBlackLine( 0, 0, ARSViewReportedPlayerInfo:GetWide(), ARSViewReportedPlayerInfo:GetTall() )
			ARSdrawBoxLine(1, 1, ARSViewReportedPlayerInfo:GetWide()-2, ARSViewReportedPlayerInfo:GetTall()-2)
			if NameLen <=16 then 
				draw.SimpleText( "Name: "..tbl.NAME, "List_Text", 100, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Name: "..string.sub(tbl.NAME, 1, 13).."...", "List_Text", 100, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			if JobLen <= 16 then
				draw.SimpleText( "Job: "..tbl.NTEAM, "List_Text", 100, 70, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Job: "..string.sub(tbl.NTEAM, 1, 13).."...", "List_Text", 100, 70, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			if RankLen <= 16 then 
				draw.SimpleText( "Rank: "..tbl.NRANK, "List_Text", 100, 90, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				draw.SimpleText( "Rank: "..string.sub(tbl.NRANK, 1, 13).."...", "List_Text", 100, 90, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			end
			draw.SimpleText( "SteamID: ", "List_Text", 100, 110, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		end
		
		DrawPlayerViewAv( ARSViewReportedPlayerInfo, FindPlayer(tbl.NAME) )
		
		local ARSViewReportInfo = vgui.Create( "DPanel", ARSViewMain )
		ARSViewReportInfo:SetPos( 10, ARSViewMain:GetTall()-290 )
		ARSViewReportInfo:SetSize( 730, 280 )
		ARSViewReportInfo.Paint = function()
			local edlen = string.len(tbl.ED)
			local CheckStatusLen = string.len(tbl.STATUS)
			draw.RoundedBox( 0, 0, 0, ARSViewReportInfo:GetWide(), ARSViewReportInfo:GetTall(), ARS.RequestHeaderColor )
			draw.SimpleText( "Report Information:", "Headings_Text", 182.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBoxLine(1, 1, 365, 278)
			ARSdrawLine(365, 1, 365, 278)
			ARSdrawBoxLine(366, 1, 364, 278)
			ARSdrawBlackLine(0, 0, ARSViewReportInfo:GetWide(), ARSViewReportInfo:GetTall())
			draw.SimpleText( "Reason: "..tbl.REASON, "Category_Text", 20, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "Time: "..tbl.TIME, "Category_Text", 20, 80, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "Day: "..tbl.DATE, "Category_Text", 20, 110, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			if tbl.STATUS == "" then
				draw.SimpleText( "Status: Un-Claimed", "Category_Text", 20, 140, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			else
				if CheckStatusLen <= 29 then
					draw.SimpleText( "Status: "..tbl.STATUS, "Category_Text", 20, 140, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				else
					draw.SimpleText( "Status: "..string.sub(tbl.STATUS, 1, 26).."...", "Category_Text", 20, 140, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				end
			end
			draw.SimpleText( "The Reporter:", "List_Text", 20, 170, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "The Reported:", "List_Text", 345, 170, ARS.TextRequestColor, TEXT_ALIGN_RIGHT )
			draw.SimpleText( "Extra Information:", "Headings_Text", 547.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Extra Details: ", "Category_Text", 375, 50, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( string.sub(tbl.ED, 1, 45), "Date_Text", 375, 80, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( string.sub(tbl.ED, 46, 91), "Date_Text", 375, 100, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( string.sub(tbl.ED, 92, 136), "Date_Text", 375, 120, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( string.sub(tbl.ED, 137, 181), "Date_Text", 375, 140, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( string.sub(tbl.ED, 182, 226), "Date_Text", 375, 160, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		end
		
		local ReporterComboBox = vgui.Create( "DComboBox", ARSViewReportInfo )
		ReporterComboBox:SetPos( 22.5, 190 )
		ReporterComboBox:SetSize( 100, 20 )
		if IsHere(tbl.REPORTER) then 
			ReporterComboBox:SetValue("Select a Command")
			ReporterComboBox:AddChoice( "Teleport" )
			ReporterComboBox:AddChoice( "Goto" )
			ReporterComboBox:AddChoice( "Jail" )
			ReporterComboBox:AddChoice( "Slay" )
			ReporterComboBox.OnSelect = function( panel, index, value )
				if value == "Teleport" then 
					RunConsoleCommand( "say", "!teleport ".. tbl.REPORTER )
				elseif value == "Goto" then 
					RunConsoleCommand( "say", "!goto ".. tbl.REPORTER )
				elseif value == "Jail" then 
					RunConsoleCommand( "say", "!jail ".. tbl.REPORTER )
				elseif value == "Slay" then 
					RunConsoleCommand( "say", "!slay "..tbl.REPORTER )
				end
			end
		else
			ReporterComboBox:SetValue("No Player!")
		end
		
		
		local ReportedComboBox = vgui.Create( "DComboBox", ARSViewReportInfo )
		ReportedComboBox:SetPos( ARSViewReportInfo:GetWide()/2-122.5, 190 )
		ReportedComboBox:SetSize( 100, 20 )
		if IsHere(tbl.NAME) then
			ReportedComboBox:SetValue("Select a Command")
			ReportedComboBox:AddChoice( "Teleport" )
			ReportedComboBox:AddChoice( "Goto" )
			ReportedComboBox:AddChoice( "Jail" )
			ReportedComboBox:AddChoice( "Slay" )
			ReportedComboBox.OnSelect = function( panel, index, value )
				if value == "Teleport" then 
					RunConsoleCommand( "say", "!teleport ".. tbl.NAME )
				elseif value == "Goto" then 
					RunConsoleCommand( "say", "!goto ".. tbl.NAME )
				elseif value == "Jail" then 
					RunConsoleCommand( "say", "!jail ".. tbl.NAME )
				elseif value == "Slay" then 
					RunConsoleCommand( "say", "!slay "..tbl.NAME )
				end
			end
		else
			ReportedComboBox:SetValue("No Player!")
		end
		
		local CopySteamIDButton = vgui.Create( "DButton", ARSViewReporterInfo )
		CopySteamIDButton:SetSize( 175, 20 )
		CopySteamIDButton:SetPos( 175,112.5 )
		CopySteamIDButton:SetText( tbl.RID )
		CopySteamIDButton:SetFont( "List_Text" )
		CopySteamIDButton:SetTextColor( ARS.ButtonTextColor )
		CopySteamIDButton.Paint = function(self, w, h)
			if self.hover then
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
			else
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
			end
		end
		CopySteamIDButton.DoClick = function()
			SetClipboardText(tbl.RID)
		end
		CopySteamIDButton.OnCursorEntered = function( self )
			self.hover = true
			self:SetTextColor( ARS.ButtonTextColor )
		end
		CopySteamIDButton.OnCursorExited = function( self )
			self.hover = false
			self:SetTextColor( ARS.ButtonTextColor )
		end
		local CopySteamIDReportedButton = vgui.Create( "DButton", ARSViewReportedPlayerInfo )
		CopySteamIDReportedButton:SetSize( 175, 20 )
		CopySteamIDReportedButton:SetPos( 175,112.5 )
		CopySteamIDReportedButton:SetText( tbl.NID )
		CopySteamIDReportedButton:SetFont( "List_Text" )
		CopySteamIDReportedButton:SetTextColor( ARS.ButtonTextColor )
		CopySteamIDReportedButton.Paint = function(self, w, h)
			if self.hover then
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
			else
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
			end
		end
		CopySteamIDReportedButton.DoClick = function()
			SetClipboardText(tbl.NID)
		end
		CopySteamIDReportedButton.OnCursorEntered = function( self )
			self.hover = true
			self:SetTextColor( ARS.ButtonTextColor )
		end
		CopySteamIDReportedButton.OnCursorExited = function( self )
			self.hover = false
			self:SetTextColor( ARS.ButtonTextColor )
		end

		/*--Attackers SteamID is 'tbl.NID'
		if ARS.UsePlogsEasyAccess then
			local LogsButton = vgui.Create( "DButton", ARSViewReportInfo )
			LogsButton:SetSize( 345, 30 )
			if LocalPlayer():DeleteAble() then 
				LogsButton:SetPos( ARSViewReportInfo:GetWide()-355, ARSViewReportInfo:GetTall()-120 )
			else
				LogsButton:SetPos( ARSViewReportInfo:GetWide()-355, ARSViewReportInfo:GetTall()-80 )
			end
			LogsButton:SetText( "View Logs" )
			LogsButton:SetFont( "List_Text" )
			LogsButton:SetTextColor( ARS.ButtonTextColor )
			LogsButton.Paint = function(self, w, h)
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
				end
				ARSdrawBoxLine(1, 1, w-2, h-2)
				ARSdrawBlackLine(0, 0, w, h)
			end
			LogsButton.DoClick = function()
				
			end
			LogsButton.OnCursorEntered = function( self )
				self.hover = true
				self:SetTextColor( ARS.ButtonTextColor )
			end
			LogsButton.OnCursorExited = function( self )
				self.hover = false
				self:SetTextColor( ARS.ButtonTextColor )
			end
		end*/
		
		local CheckNameLen = string.len(LocalPlayer():Nick())
		if string.sub(tbl.STATUS, 13, 13+CheckNameLen) == LocalPlayer():Nick() and !bool then 
			local CompleteButton = vgui.Create( "DButton", ARSViewReportInfo )
			CompleteButton:SetSize( 345, 30 )
			if LocalPlayer():DeleteAble() then 
				CompleteButton:SetPos( ARSViewReportInfo:GetWide()-355,ARSViewReportInfo:GetTall()-80 )
			else
				CompleteButton:SetPos( ARSViewReportInfo:GetWide()-355,ARSViewReportInfo:GetTall()-40 )
			end
			CompleteButton:SetText( "Complete Report" )
			CompleteButton:SetFont( "List_Text" )
			CompleteButton:SetTextColor( ARS.ButtonTextColor )
			CompleteButton.Paint = function(self, w, h)
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
				end
				ARSdrawBoxLine(1, 1, w-2, h-2)
				ARSdrawBlackLine(0, 0, w, h)
			end
			CompleteButton.DoClick = function()
				Derma_Query( "Are you sure you want to complete this report?", "WARNING", "Complete", function() net.Start("ARS_CompleteReport_ToServer") net.WriteString(num) net.WriteEntity(FindPlayer(tbl.REPORTER)) net.WriteString(LocalPlayer():Name()) net.SendToServer() ARSViewMain:Remove() CloseAllARS() end, "Cancel", function() return end)
			end
			CompleteButton.OnCursorEntered = function( self )
				self.hover = true
				self:SetTextColor( ARS.ButtonTextColor )
			end
			CompleteButton.OnCursorExited = function( self )
				self.hover = false
				self:SetTextColor( ARS.ButtonTextColor )
			end
		end
		if LocalPlayer():DeleteAble() then 
			local DeleteButton = vgui.Create( "DButton", ARSViewReportInfo )
			DeleteButton:SetSize( 345, 30 )
			DeleteButton:SetPos( ARSViewReportInfo:GetWide()-355,ARSViewReportInfo:GetTall()-40 )
			DeleteButton:SetText( "Delete Report" )
			DeleteButton:SetFont( "List_Text" )
			DeleteButton:SetTextColor( ARS.ButtonTextColor )
			DeleteButton.Paint = function(self, w, h)
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
				end
				ARSdrawBoxLine(1, 1, w-2, h-2)
				ARSdrawBlackLine(0, 0, w, h)
			end
			DeleteButton.DoClick = function()
				Derma_Query( "Are you sure you want to permanantly delete this report?", "WARNING", "Delete", function() net.Start("ARS_DeleteButton") net.WriteString(num) net.WriteEntity(FindPlayer(tbl.REPORTER)) net.WriteString(LocalPlayer():Name()) net.WriteBool(bool) net.SendToServer() ARSViewMain:Remove() CloseAllARS() end, "Cancel", function() return end)
			end
			DeleteButton.OnCursorEntered = function( self )
				self.hover = true
				self:SetTextColor( ARS.ButtonTextColor )
			end
			DeleteButton.OnCursorExited = function( self )
				self.hover = false
				self:SetTextColor( ARS.ButtonTextColor )
			end
		end
	end
end)
