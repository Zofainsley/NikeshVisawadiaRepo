function CloseAllARS()
	if IsValid(ARSReportMain) then
		ARSReportMain:Remove()
	end
	if IsValid(ARSNoReportMain) then
		ARSNoReportMain:Remove()
	end
	if IsValid(ARSUsersMain) then
		ARSUsersMain:Remove()
	end
	if IsValid(ARSViewMain) then
		ARSViewMain:Remove()
	end
	if IsValid(ARSNoneClosedMain) then
		ARSNoneClosedMain:Remove()
	end
	if IsValid(ARSClosedMain) then
		ARSClosedMain:Remove()
	end
	if IsValid(ARSStatBGMain) then
		ARSStatBGMain:Remove()
	end
	if IsValid(ARSStatsMain) then
		ARSStatsMain:Remove()
	end
	if IsValid(ARSGraphMain) then
		ARSGraphMain:Remove()
	end
end

net.Receive( "ARS_AdminPanel", function()
	local reportsopen
	local usersopen
	local tbl = net.ReadTable()
	local reportsornah = net.ReadBool()
	if !IsValid(ARSAdminPanelFrame) then 
		ARSAdminPanelFrame = vgui.Create( "DFrame" ) 
		ARSAdminPanelFrame:SetSize( 900, 600 )
		ARSAdminPanelFrame:SetPos( ScrW()/2-ARSAdminPanelFrame:GetWide()/2, ScrH()/2-ARSAdminPanelFrame:GetTall()/2 )
		ARSAdminPanelFrame:SetTitle( " " ) 
		ARSAdminPanelFrame:SetVisible( true )
		ARSAdminPanelFrame:SetDraggable( false ) 
		ARSAdminPanelFrame:ShowCloseButton( false ) 				
		ARSAdminPanelFrame:MakePopup() 
		ARSAdminPanelFrame.Paint = function()
			draw.RoundedBoxEx( 4, 0, 0, ARSAdminPanelFrame:GetWide(), 30, ARS.RequestHeaderColor, true, true, false, false )
			draw.SimpleText( "SERVER REPORT MANAGER", "Headings_Text", ARSAdminPanelFrame:GetWide()/2, 2, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		end
		
		local CloseButton = vgui.Create( "DButton", ARSAdminPanelFrame )
		CloseButton:SetSize( 25, 30 )
		CloseButton:SetPos( ARSAdminPanelFrame:GetWide() - 25,0 )
		CloseButton:SetText( "r" )
		CloseButton:SetFont( "marlett" )
		CloseButton:SetTextColor( Color(235, 72, 73) )
		CloseButton.Paint = function()
			
		end
		CloseButton.DoClick = function()
			CloseAllARS()
			ARSAdminPanelFrame:Remove()					
		end
		CloseButton.OnCursorEntered = function( self )
			self.hover = true
			self:SetTextColor( Color(153, 0, 0) )
		end
		CloseButton.OnCursorExited = function( self )
			self.hover = false
			self:SetTextColor( Color(235, 72, 73) )
		end
		
		local PlayerList = vgui.Create( "DPanel", ARSAdminPanelFrame )
		PlayerList:SetPos( 0, 30 )
		PlayerList:SetSize( ARSAdminPanelFrame:GetWide(), 70)
		PlayerList.Paint = function()
			draw.RoundedBox( 0, 0, 0, PlayerList:GetWide(), PlayerList:GetTall(), ARS.InnerBGColor )
		end
		
		local ReportsButton = vgui.Create( "DButton", PlayerList )
		if LocalPlayer():DeleteAble() then
			ReportsButton:SetPos( PlayerList:GetWide()/2-215, 10 )
		else
			ReportsButton:SetPos( PlayerList:GetWide()/2-105, 10 )
		end
		ReportsButton:SetSize( 100, 50 )
		ReportsButton:SetText( "Reports" )
		ReportsButton:SetFont( "Buttons_Text" )
		ReportsButton.Paint = function( self, w, h )
			if reportsopen then 
				draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
				ReportsButton:SetTextColor( ARS.TextRequestColor )
				ARSdrawBoxLine(1, 1, w-2, h-2)
				ARSdrawBlackLine(0, 0, w, h)
			else
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
					ReportsButton:SetTextColor( ARS.TextRequestColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.InnerBGColor )
					ReportsButton:SetTextColor( ARS.TextRequestColor )
				end
			end
		end
		ReportsButton.DoClick = function()
			CloseAllARS()
			if !IsValid(ARSReportMain) then
				ARSAdminPanelReport(tbl, reportsornah)
			end
		end
		ReportsButton.OnCursorEntered = function( self )
			self.hover = true
		end
		ReportsButton.OnCursorExited = function( self )
			self.hover = false
		end
		function ReportsButton:Think()
			if IsValid(ARSReportMain) or IsValid(ARSNoReportMain) then
				reportsopen = true
			else 
				reportsopen = false
			end
		end
		
		local UsersButton = vgui.Create( "DButton", PlayerList )
		if LocalPlayer():DeleteAble() then
			UsersButton:SetPos( PlayerList:GetWide()/2-105, 10 )
		else
			UsersButton:SetPos( PlayerList:GetWide()/2+5, 10 )
		end
		UsersButton:SetSize( 100, 50 )
		UsersButton:SetText( "Users" )
		UsersButton:SetFont( "Buttons_Text" )
		UsersButton.Paint = function( self, w, h )
			if usersopen then 
				draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
				UsersButton:SetTextColor( ARS.TextRequestColor )
				ARSdrawBoxLine(1, 1, w-2, h-2)
				ARSdrawBlackLine(0, 0, w, h)
			else
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
					UsersButton:SetTextColor( ARS.TextRequestColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.InnerBGColor )
					UsersButton:SetTextColor( ARS.TextRequestColor )
				end
			end
		end
		UsersButton.DoClick = function()
			CloseAllARS()
			if !IsValid(ARSUsersMain) then
				ARSAdminPanelUsers()
			end
		end
		UsersButton.OnCursorEntered = function( self )
			self.hover = true
		end
		UsersButton.OnCursorExited = function( self )
			self.hover = false
		end
		function UsersButton:Think()
			if IsValid(ARSUsersMain) then
				usersopen = true
			else 
				usersopen = false
			end
		end

		if LocalPlayer():DeleteAble() then
			local StatButton = vgui.Create( "DButton", PlayerList )
			StatButton:SetPos( PlayerList:GetWide()/2+5, 10 )
			StatButton:SetSize( 100, 50 )
			StatButton:SetText( "Stats" )
			StatButton:SetFont( "Buttons_Text" )
			StatButton.Paint = function( self, w, h )
				if statopen then 
					draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
					StatButton:SetTextColor( ARS.TextRequestColor )
					ARSdrawBoxLine(1, 1, w-2, h-2)
					ARSdrawBlackLine(0, 0, w, h)
				else
					if self.hover then
						draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
						StatButton:SetTextColor( ARS.TextRequestColor )
					else
						draw.RoundedBox( 0, 0, 0, w, h, ARS.InnerBGColor )
						StatButton:SetTextColor( ARS.TextRequestColor )
					end
				end
			end
			StatButton.DoClick = function()
				CloseAllARS()
				if !IsValid(ARSStatBGMain) then
					ARSAdminPanelStatBG()
				end
			end
			StatButton.OnCursorEntered = function( self )
				self.hover = true
			end
			StatButton.OnCursorExited = function( self )
				self.hover = false
			end
			function StatButton:Think()
				if IsValid(ARSStatBGMain) then
					statopen = true
				else 
					statopen = false
				end
			end

			local ClosedButton = vgui.Create( "DButton", PlayerList )
			ClosedButton:SetPos( PlayerList:GetWide()/2+115, 10 )
			ClosedButton:SetSize( 100, 50 )
			ClosedButton:SetText( "Closed" )
			ClosedButton:SetFont( "Buttons_Text" )
			ClosedButton.Paint = function( self, w, h )
				if closedopen then 
					draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
					ClosedButton:SetTextColor( ARS.TextRequestColor )
					ARSdrawBoxLine(1, 1, w-2, h-2)
					ARSdrawBlackLine(0, 0, w, h)
				else
					if self.hover then
						draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestBGColor )
						ClosedButton:SetTextColor( ARS.TextRequestColor )
					else
						draw.RoundedBox( 0, 0, 0, w, h, ARS.InnerBGColor )
						ClosedButton:SetTextColor( ARS.TextRequestColor )
					end
				end
			end
			ClosedButton.DoClick = function()
				CloseAllARS()
				if !IsValid(ARSNoneClosedMain) or !IsValid(ARSClosedMain) then
					net.Start("ARS_Closed_Logs_ToServer")
						net.WriteString(LocalPlayer():Name())
					net.SendToServer()
				end
			end
			ClosedButton.OnCursorEntered = function( self )
				self.hover = true
			end
			ClosedButton.OnCursorExited = function( self )
				self.hover = false
			end
			function ClosedButton:Think()
				if IsValid(ARSNoneClosedMain) or IsValid(ARSClosedMain) then
					closedopen = true
				else 
					closedopen = false
				end
			end
		end
		
		ARSAdminPanelReport(tbl, reportsornah)
	end
end)

surface.CreateFont( "Buttons_Text", {
	font = "CloseCaption_Normal",
	size = 27,
	weight = 525
} )
surface.CreateFont( "Category_Text", {
	font = "CloseCaption_Normal",
	size = 25,
	weight = 525
} )
surface.CreateFont( "List_Text", {
	font = "HudHintTextLarge",
	size = 21,
	weight = 450
} )
surface.CreateFont( "Date_Text", {
	font = "CloseCaption_Normal",
	size = 16,
	weight = 530
} )
surface.CreateFont( "No_Report_Text", {
	font = "HudHintTextLarge",
	size = 30,
	weight = 525
} )

net.Receive("ARSClientNotify", function()
	local tbl = net.ReadTable()
	surface.SetFont( "GModNotify" )
	local w, h = surface.GetTextSize(tbl.msg)
	local NotifyPanel = vgui.Create( "DNotify" )
	NotifyPanel:SetPos( ScrW()-(w+40), ScrH()/2-(h+30)/2 )
	NotifyPanel:SetSize( w+30, h+30 )
	NotifyPanel:SetLife(10)
	local bg = vgui.Create( "DPanel", NotifyPanel )
	bg:Dock( FILL )
	bg:SetBackgroundColor( Color( 64, 64, 64 ) )
	local lbl = vgui.Create( "DLabel", bg )
	lbl:SetPos( 15, 15 )
	lbl:SetSize( w, h )
	lbl:SetText( tbl.msg )
	lbl:SetTextColor( Color( 255, 200, 0 ) )
	lbl:SetFont( "GModNotify" )
	lbl:SetWrap( true )
	timer.Simple(10, function()
		if IsValid(NotifyPanel) then
			NotifyPanel:Remove()
		end
	end)
end)