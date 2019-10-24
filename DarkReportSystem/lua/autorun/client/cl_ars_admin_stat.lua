local function CloseBadStat()
	if IsValid(ARSStatsMain) then
		ARSStatsMain:Remove()
	end
	if IsValid(ARSGraphMain) then
		ARSGraphMain:Remove()
	end
end

surface.CreateFont( "Graph_Numbers", {
	font = "Roboto",
	size = 15,
	weight = 525
} )
surface.CreateFont( "Graph_Names", {
	font = "Roboto",
	size = 18,
	weight = 525
} )
surface.CreateFont( "Graph_Title", {
	font = "Roboto",
	size = 30,
	weight = 525
} )

function ARSAdminPanelStatBG()
	ARSStatBGMain = vgui.Create( "DPanel", ARSAdminPanelFrame )
	ARSStatBGMain:SetPos( 0, 100 )
	ARSStatBGMain:SetSize( ARSAdminPanelFrame:GetWide(), ARSAdminPanelFrame:GetTall()-100)
	ARSStatBGMain.Paint = function(self, w, h)
		draw.RoundedBoxEx( 4, 0, 0, ARSStatBGMain:GetWide(), ARSStatBGMain:GetTall(), ARS.RequestBGColor, false, false, true, true )
		ARSdrawBlackLine(0, 0, ARSStatBGMain:GetWide(), ARSStatBGMain:GetTall())
		ARSdrawBoxLine(1, 1, ARSStatBGMain:GetWide()-2, ARSStatBGMain:GetTall()-2)
		draw.RoundedBox( 0, 15, 15, ARSStatBGMain:GetWide()-30, ARSStatBGMain:GetTall()-30, ARS.InnerBGColor )
		ARSdrawBlackLine(15, 15, ARSStatBGMain:GetWide()-30, ARSStatBGMain:GetTall()-30)
		ARSdrawBoxLine(16, 16, ARSStatBGMain:GetWide()-32, ARSStatBGMain:GetTall()-32)
		--ARSDrawCircle( w/2+10, h-35, 5, ARS.RequestBGColor, false )
		--ARSDrawCircle( w/2-10, h-35, 5, ARS.RequestBGColor, false )
	end
	local GraphCircle = vgui.Create( "DButton", ARSStatBGMain )
	GraphCircle:SetPos( ARSStatBGMain:GetWide()/2-15, ARSStatBGMain:GetTall()-40 )
	GraphCircle:SetSize( 10, 10 )
	GraphCircle:SetText("")
	GraphCircle.Paint = function( self, w, h )
		if IsValid(ARSGraphMain) then
			ARSDrawCircle( w/2, h/2, 5, ARS.TextRequestColor, false )
		else
			ARSDrawCircle( w/2, h/2, 5, ARS.RequestBGColor, false )
		end
	end
	GraphCircle.DoClick = function()
		CloseBadStat()
		ARSAdminPanelGraph()
	end

	local StatsCircle = vgui.Create( "DButton", ARSStatBGMain )
	StatsCircle:SetPos( ARSStatBGMain:GetWide()/2+5, ARSStatBGMain:GetTall()-40 )
	StatsCircle:SetSize( 10, 10 )
	StatsCircle:SetText("")
	StatsCircle.Paint = function( self, w, h )
		if IsValid(ARSStatsMain) then
			ARSDrawCircle( w/2, h/2, 5, ARS.TextRequestColor, false )
		else
			ARSDrawCircle( w/2, h/2, 5, ARS.RequestBGColor, false )
		end
	end
	StatsCircle.DoClick = function()
		CloseBadStat()
		ARSAdminPanelStats()
	end
	ARSAdminPanelGraph()
end

function ARSAdminPanelGraph()
	net.Start("ARS_GetTopAdmin_ToServer")
		net.WriteString(LocalPlayer():Nick())
	net.SendToServer()
end
net.Receive("ARS_GetTopAdmin_ToClient", function()
	local tbl = net.ReadTable()
	--PrintTable(tbl)
	table.SortByMember(tbl,"CLOSES",false)
	ARSGraphMain = vgui.Create( "DPanel", ARSStatBGMain )
	ARSGraphMain:SetPos( 30, 30 )
	ARSGraphMain:SetSize( ARSStatBGMain:GetWide()-60, ARSStatBGMain:GetTall()-85)
	ARSGraphMain.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestHeaderColor )
		ARSdrawBlackLine(0, 0, w, h)
		ARSdrawBoxLine(1, 1, w-2, h-2)
		draw.RoundedBox( 0, 75, 30, w-295, h-90, ARS.RequestBGColor )
		if table.Count(tbl) == 1 then
			ARSGraphBar(60, math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), 99.5, h-60-math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), ARS.FirstPlace)
		elseif table.Count(tbl) == 2 then
			ARSGraphBar(60, math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), 99.5, h-60-math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), ARS.FirstPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), 208.5, h-60-math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), ARS.SecondPlace)
		elseif table.Count(tbl) == 3 then
			ARSGraphBar(60, math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), 99.5, h-60-math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), ARS.FirstPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), 208.5, h-60-math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), ARS.SecondPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), 317.5, h-60-math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), ARS.ThirdPlace)
		elseif table.Count(tbl) == 4 then
			ARSGraphBar(60, math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), 99.5, h-60-math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), ARS.FirstPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), 208.5, h-60-math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), ARS.SecondPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), 317.5, h-60-math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), ARS.ThirdPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[4].CLOSES)*6.5, 0, 325), 426.5, h-60-math.Clamp(tonumber(tbl[4].CLOSES)*6.5, 0, 325), ARS.FourthPlace)
		else
			ARSGraphBar(60, math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), 99.5, h-60-math.Clamp(tonumber(tbl[1].CLOSES)*6.5, 0, 325), ARS.FirstPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), 208.5, h-60-math.Clamp(tonumber(tbl[2].CLOSES)*6.5, 0, 325), ARS.SecondPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), 317.5, h-60-math.Clamp(tonumber(tbl[3].CLOSES)*6.5, 0, 325), ARS.ThirdPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[4].CLOSES)*6.5, 0, 325), 426.5, h-60-math.Clamp(tonumber(tbl[4].CLOSES)*6.5, 0, 325), ARS.FourthPlace)
			ARSGraphBar(60, math.Clamp(tonumber(tbl[5].CLOSES)*6.5, 0, 325), 535.5, h-60-math.Clamp(tonumber(tbl[5].CLOSES)*6.5, 0, 325), ARS.FifthPlace)
		end
		ARSdrawBoxLine(75, 30, w-294, h-89)
		ARSdrawLine( 75, 30, 75, h-55 )
		ARSdrawLine( 70, h-60, 545+75, h-60 )
		ARSdrawLine( 70, h-92.5, 545+75, h-92.5 )
		ARSdrawLine( 70, h-125, 545+75, h-125 )
		ARSdrawLine( 70, h-157.5, 545+75, h-157.5 )
		ARSdrawLine( 70, h-190, 545+75, h-190 )
		ARSdrawLine( 70, h-222.5, 545+75, h-222.5 )
		ARSdrawLine( 70, h-255, 545+75, h-255 )
		ARSdrawLine( 70, h-287.5, 545+75, h-287.5 )
		ARSdrawLine( 70, h-320, 545+75, h-320 )
		ARSdrawLine( 70, h-352.5, 545+75, h-352.5 )
		ARSdrawLine( 70, h-385, 80, h-385 )
		ARSdrawLine( 184, h-65, 184, h-55 )
		ARSdrawLine( 293, h-65, 293, h-55 )
		ARSdrawLine( 402, h-65, 402, h-55 )
		ARSdrawLine( 511, h-65, 511, h-55 )
		ARSdrawLine( 620, h-65, 620, h-55 )
		ARSGraphNumber("0", 65, h-60)
		ARSGraphNumber("5", 65, h-92.5)
		ARSGraphNumber("10", 65, h-125)
		ARSGraphNumber("15", 65, h-157.5)
		ARSGraphNumber("20", 65, h-190)
		ARSGraphNumber("25", 65, h-222.5)
		ARSGraphNumber("30", 65, h-255)
		ARSGraphNumber("35", 65, h-287.5)
		ARSGraphNumber("40", 65, h-320)
		ARSGraphNumber("45", 65, h-352.5)
		ARSGraphNumber("50", 65, h-385)
		draw.SimpleText( "Top 5 Admins Based on Completion", "Graph_Title", w/2-75, h-45, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
	end

	local ARSGraphInfo = vgui.Create( "DPanel", ARSGraphMain )
	ARSGraphInfo:SetPos( ARSGraphMain:GetWide()-207.5, (ARSGraphMain:GetTall()/2)-62.5 )
	ARSGraphInfo:SetSize( 200, 135 )
	ARSGraphInfo.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, ARS.InnerBGColor )
		ARSdrawBlackLine(0, 0, w, h)
		ARSdrawBoxLine(1, 1, w-2, h-2)
		if table.Count(tbl) == 1 then
			draw.RoundedBox( 0, 10, 10, 15, 15, ARS.FirstPlace )
			ARSdrawBlackLine(10, 10, 15, 15)
			draw.SimpleText( tbl[1].CLOSES.." - "..tbl[1].NAME, "Graph_Names", 35, 9, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		elseif table.Count(tbl) == 2 then
			draw.RoundedBox( 0, 10, 10, 15, 15, ARS.FirstPlace )
			ARSdrawBlackLine(10, 10, 15, 15)
			draw.SimpleText( tbl[1].CLOSES.." - "..tbl[1].NAME, "Graph_Names", 35, 9, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 35, 15, 15, ARS.SecondPlace )
			ARSdrawBlackLine(10, 35, 15, 15)
			draw.SimpleText( tbl[2].CLOSES.." - "..tbl[2].NAME, "Graph_Names", 35, 34, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		elseif table.Count(tbl) == 3 then
			draw.RoundedBox( 0, 10, 10, 15, 15, ARS.FirstPlace )
			ARSdrawBlackLine(10, 10, 15, 15)
			draw.SimpleText( tbl[1].CLOSES.." - "..tbl[1].NAME, "Graph_Names", 35, 9, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 35, 15, 15, ARS.SecondPlace )
			ARSdrawBlackLine(10, 35, 15, 15)
			draw.SimpleText( tbl[2].CLOSES.." - "..tbl[2].NAME, "Graph_Names", 35, 34, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 60, 15, 15, ARS.ThirdPlace )
			ARSdrawBlackLine(10, 60, 15, 15)
			draw.SimpleText( tbl[3].CLOSES.." - "..tbl[3].NAME, "Graph_Names", 35, 59, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		elseif table.Count(tbl) == 4 then
			draw.RoundedBox( 0, 10, 10, 15, 15, ARS.FirstPlace )
			ARSdrawBlackLine(10, 10, 15, 15)
			draw.SimpleText( tbl[1].CLOSES.." - "..tbl[1].NAME, "Graph_Names", 35, 9, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 35, 15, 15, ARS.SecondPlace )
			ARSdrawBlackLine(10, 35, 15, 15)
			draw.SimpleText( tbl[2].CLOSES.." - "..tbl[2].NAME, "Graph_Names", 35, 34, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 60, 15, 15, ARS.ThirdPlace )
			ARSdrawBlackLine(10, 60, 15, 15)
			draw.SimpleText( tbl[3].CLOSES.." - "..tbl[3].NAME, "Graph_Names", 35, 59, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 85, 15, 15, ARS.FourthPlace )
			ARSdrawBlackLine(10, 85, 15, 15)
			draw.SimpleText( tbl[4].CLOSES.." - "..tbl[4].NAME, "Graph_Names", 35, 84, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		else
			draw.RoundedBox( 0, 10, 10, 15, 15, ARS.FirstPlace )
			ARSdrawBlackLine(10, 10, 15, 15)
			draw.SimpleText( tbl[1].CLOSES.." - "..tbl[1].NAME, "Graph_Names", 35, 9, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 35, 15, 15, ARS.SecondPlace )
			ARSdrawBlackLine(10, 35, 15, 15)
			draw.SimpleText( tbl[2].CLOSES.." - "..tbl[2].NAME, "Graph_Names", 35, 34, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 60, 15, 15, ARS.ThirdPlace )
			ARSdrawBlackLine(10, 60, 15, 15)
			draw.SimpleText( tbl[3].CLOSES.." - "..tbl[3].NAME, "Graph_Names", 35, 59, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 85, 15, 15, ARS.FourthPlace )
			ARSdrawBlackLine(10, 85, 15, 15)
			draw.SimpleText( tbl[4].CLOSES.." - "..tbl[4].NAME, "Graph_Names", 35, 84, ARS.TextRequestColor, TEXT_ALIGN_LEFT )

			draw.RoundedBox( 0, 10, 110, 15, 15, ARS.FifthPlace )
			ARSdrawBlackLine(10, 110, 15, 15)
			draw.SimpleText( tbl[5].CLOSES.." - "..tbl[5].NAME, "Graph_Names", 35, 109, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
		end
	end
end)

function ARSAdminPanelStats()
	net.Start("ARS_GetAllAdmin_ToServer")
		net.WriteString(LocalPlayer():Nick())
	net.SendToServer()
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
net.Receive( "ARS_GetAllAdmin_ToClient", function()
	local tbl = net.ReadTable()
	--PrintTable(tbl)
	if !IsValid(ARSStatsMain) then
		ARSStatsMain = vgui.Create( "DPanel", ARSStatBGMain )
		ARSStatsMain:SetPos( 15, 15 )
		ARSStatsMain:SetSize( ARSStatBGMain:GetWide()-30, 50)
		ARSStatsMain.Paint = function()
			draw.RoundedBox( 0, 0, 0, ARSStatBGMain:GetWide(), ARSStatBGMain:GetTall(), ARS.RequestBGColor )
			draw.SimpleText( "RANK", "Category_Text", 54.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "NAME", "Category_Text", 191.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "POSITION", "Category_Text", 349, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "CLAIM", "Category_Text", 499, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "COMPLETE", "Category_Text", 651.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "ACTION", "Category_Text", 800.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBoxLine(1, 1, 1010, 48)
			ARSdrawBoxLine(111, 1, 165, 48)
			ARSdrawBoxLine(276, 1, 150, 48)
			ARSdrawBoxLine(426, 1, 150, 48)
			ARSdrawBoxLine(576, 1, 155, 48)
			ARSdrawBoxLine(731, 1, ARSStatsMain:GetWide()-731, 48)
			ARSdrawBlackLine(0, 0, 111, 50)
			ARSdrawBlackLine(0, 0, 276, 50)
			ARSdrawBlackLine(0, 0, 426, 50)
			ARSdrawBlackLine(0, 0, 576, 50)
			ARSdrawBlackLine(0, 0, 731, 50)
			ARSdrawBlackLine(0, 0, ARSStatsMain:GetWide(), 50)
		end
	end

	local ARSPeportsList = vgui.Create( "DPanelList", ARSStatBGMain )
	ARSPeportsList:SetPos( 17, 65 )
	ARSPeportsList:SetSize( ARSStatsMain:GetWide()-4, 384 )
	ARSPeportsList:EnableHorizontal( false )
	ARSPeportsList:EnableVerticalScrollbar( false )
	ARSPeportsList:SetSpacing( 1 )
	
	for k, v in pairs(tbl) do 
		local ReportList = vgui.Create( "DPanel", ARSPeportsList )
		ReportList:SetSize( ARSPeportsList:GetWide(), 35 )
		ReportList.Paint = function(self, w, h)
			local ReporterLen = string.len( v.NAME )
			local PlayerLen = string.len( v.RANK )
			draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestHeaderColor )
			draw.SimpleText( k, "List_Text", 54.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			if ReporterLen <= 18 then 
				draw.SimpleText( v.NAME, "List_Text", 191.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( string.sub( v.NAME, 1, 15 ).."...", "List_Text", 191.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end
			if PlayerLen <= 16 then 
				draw.SimpleText( v.RANK, "List_Text", 349, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( string.sub( v.RANK, 1, 13 ).."...", "List_Text", 349, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end
			draw.SimpleText( v.CLAIMS, "List_Text", 499, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( v.CLOSES, "List_Text", 651.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawLine(108, 0, 108, 35)
			ARSdrawLine(273, 0, 273, 35)
			ARSdrawLine(423, 0, 423, 35)
			ARSdrawLine(573, 0, 573, 35)
			ARSdrawLine(728, 0, 728, 35)
		end

		local ViewButton = vgui.Create( "DButton", ReportList )
		ViewButton:SetPos( ReportList:GetWide()-103, 2.5 )
		ViewButton:SetSize( 70, 30 )
		ViewButton:SetText( "Reset" )
		ViewButton:SetFont( "Buttons_Text" )
		ViewButton.Paint = function( self, w, h )
			if self.hover then
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
				ViewButton:SetTextColor( ARS.ButtonHoverTextColor )
			else
				draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
				ViewButton:SetTextColor( ARS.ButtonTextColor )
			end
			ARSdrawBoxLine( 1, 1, w-2, h-2 )
			ARSdrawBlackLine(0, 0, w, h )
		end
		ViewButton.DoClick = function()
			Derma_Query( "What stats do you want to reset?", "Make a Selection", "Claims", function() net.Start("ARS_RESET_ADMIN_STAT") net.WriteString(v.NAME) net.WriteString("Claim") net.WriteEntity(FindPlayer(LocalPlayer():Nick())) net.SendToServer() ARSPeportsList:Remove() ARSAdminPanelStats() end, "Completes", function() net.Start("ARS_RESET_ADMIN_STAT") net.WriteString(v.NAME) net.WriteString("Complete") net.WriteEntity(FindPlayer(LocalPlayer():Nick())) net.SendToServer() ARSPeportsList:Remove() ARSAdminPanelStats() end, "All", function() net.Start("ARS_RESET_ADMIN_STAT") net.WriteString(v.NAME) net.WriteString("Both") net.WriteEntity(FindPlayer(LocalPlayer():Nick())) net.SendToServer() ARSPeportsList:Remove() ARSAdminPanelStats() end, "Cancel", function() return end)
		end
		ViewButton.OnCursorEntered = function( self )
			self.hover = true
		end
		ViewButton.OnCursorExited = function( self )
			self.hover = false
		end
		
		ARSPeportsList:AddItem( ReportList )
	end
end)		