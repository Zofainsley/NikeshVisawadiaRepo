net.Receive("ARS_Reopen_ToClient", function()
	local tbl = net.ReadTable()
	local hereornot = net.ReadBool()
	ARSAdminPanelReport(tbl, hereornot)
end)

function ARSAdminPanelReport(TABLE, HereorNah)
	if IsValid(ARSAdminPanelFrame) then
		if HereorNah then 
			ARSReportMain = vgui.Create( "DPanel", ARSAdminPanelFrame )
			ARSReportMain:SetPos( 0, 100 )
			ARSReportMain:SetSize( ARSAdminPanelFrame:GetWide(), ARSAdminPanelFrame:GetTall()-100)
			ARSReportMain.Paint = function()
				draw.RoundedBoxEx( 4, 0, 0, ARSReportMain:GetWide(), ARSReportMain:GetTall(), ARS.RequestBGColor, false, false, true, true )
				ARSdrawBlackLine(0, 0, ARSReportMain:GetWide(), ARSReportMain:GetTall())
				ARSdrawBoxLine(1, 1, ARSReportMain:GetWide()-2, ARSReportMain:GetTall()-2)
				draw.RoundedBox( 0, 15, 15, ARSReportMain:GetWide()-30, ARSReportMain:GetTall()-30, ARS.InnerBGColor )
				ARSdrawBlackLine(15, 15, ARSReportMain:GetWide()-30, ARSReportMain:GetTall()-30)
				ARSdrawBoxLine(16, 65, ARSReportMain:GetWide()-32, ARSReportMain:GetTall()-81)
			end
			
			local ARSReportCategory = vgui.Create( "DPanel", ARSReportMain )
			ARSReportCategory:SetPos( 15, 15 )
			ARSReportCategory:SetSize( ARSReportMain:GetWide()-30, 50)
			ARSReportCategory.Paint = function()
				draw.RoundedBox( 0, 0, 0, ARSReportMain:GetWide(), ARSReportMain:GetTall(), ARS.RequestBGColor )
				draw.SimpleText( "DATE", "Category_Text", 54.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "REPORTER", "Category_Text", 191.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "PLAYER", "Category_Text", 349, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "REASON", "Category_Text", 499, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "STATUS", "Category_Text", 651.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "DETAILS", "Category_Text", 800.5, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				ARSdrawBoxLine(1, 1, 1010, 48)
				ARSdrawBoxLine(111, 1, 165, 48)
				ARSdrawBoxLine(276, 1, 150, 48)
				ARSdrawBoxLine(426, 1, 150, 48)
				ARSdrawBoxLine(576, 1, 155, 48)
				ARSdrawBoxLine(731, 1, ARSReportCategory:GetWide()-731, 48)
				ARSdrawBlackLine(0, 0, 111, 50)
				ARSdrawBlackLine(0, 0, 276, 50)
				ARSdrawBlackLine(0, 0, 426, 50)
				ARSdrawBlackLine(0, 0, 576, 50)
				ARSdrawBlackLine(0, 0, 731, 50)
				ARSdrawBlackLine(0, 0, ARSReportCategory:GetWide(), 50)
			end
			
			local ARSPeportsList = vgui.Create( "DPanelList", ARSReportMain )
			ARSPeportsList:SetPos( 17, 65 )
			ARSPeportsList:SetSize( ARSReportCategory:GetWide()-4, 419 )
			ARSPeportsList:EnableHorizontal( false )
			ARSPeportsList:EnableVerticalScrollbar( false )
			ARSPeportsList:SetSpacing( 1 )
			
			for k, v in pairs(TABLE) do 
				local ReportList = vgui.Create( "DPanel" )
				ReportList:SetSize( ARSPeportsList:GetWide(), 35 )
				ReportList.Paint = function(self, w, h)
					local ReporterLen = string.len( v.REPORTER )
					local PlayerLen = string.len( v.NAME )
					local ReasonLen = string.len( v.REASON )
					draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestHeaderColor )
					draw.SimpleText( v.DATE, "Date_Text", 54.5, 19, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					draw.SimpleText( v.TIME, "List_Text", 54.5, 1, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					if ReporterLen <= 18 then 
						draw.SimpleText( v.REPORTER, "List_Text", 191.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.sub( v.REPORTER, 1, 15 ).."...", "List_Text", 191.5, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					end
					if PlayerLen <= 16 then 
						draw.SimpleText( v.NAME, "List_Text", 349, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.sub( v.NAME, 1, 13 ).."...", "List_Text", 349, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					end
					if ReasonLen <= 16 then 
						draw.SimpleText( v.REASON, "List_Text", 499, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.sub( v.REASON, 1, 13 ).."...", "List_Text", 499, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					end 
					if v.STATUS != "" then 
						draw.SimpleText( string.sub(v.STATUS, 1, 25), "Date_Text", 651.5, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
					end
					ARSdrawLine(108, 0, 108, 35)
					ARSdrawLine(273, 0, 273, 35)
					ARSdrawLine(423, 0, 423, 35)
					ARSdrawLine(573, 0, 573, 35)
					ARSdrawLine(728, 0, 728, 35)
				end
				if v.STATUS == "" then 
					local ClaimButton = vgui.Create( "DButton", ReportList )
					ClaimButton:SetPos( ReportList:GetWide()-250, 2.5 )
					ClaimButton:SetSize( 60, 30 )
					ClaimButton:SetText( "Claim" )
					ClaimButton:SetFont( "Buttons_Text" )
					ClaimButton.Paint = function( self, w, h )
						if self.hover then
							draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
							ClaimButton:SetTextColor( ARS.ButtonHoverTextColor )
						else
							draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
							ClaimButton:SetTextColor( ARS.ButtonTextColor )
						end
						ARSdrawBoxLine( 1, 1, w-2, h-2 )
						ARSdrawBlackLine(0, 0, w, h )
					end
					ClaimButton.DoClick = function()
						net.Start("ARS_ClaimReport_ToServer")
							local TABLE = {}
							TABLE.Number = k
							TABLE.Player = LocalPlayer():Nick()
							net.WriteTable(TABLE)
						net.SendToServer()
						ARSReportMain:Remove()
					end
					ClaimButton.OnCursorEntered = function( self )
						self.hover = true
					end
					ClaimButton.OnCursorExited = function( self )
						self.hover = false
					end
				end
				
				local ViewButton = vgui.Create( "DButton", ReportList )
				ViewButton:SetPos( ReportList:GetWide()-98, 2.5 )
				ViewButton:SetSize( 60, 30 )
				ViewButton:SetText( "View" )
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
					if IsValid(ARSViewMain) then 
						ARSViewMain:Remove()
						timer.Simple(0.5, function()
							net.Start("ARS_ViewReport_ToServer")
								local TABLE = {}
								TABLE.Number = k
								TABLE.Player = LocalPlayer():Nick()
								TABLE.close = false
								net.WriteTable(TABLE)
							net.SendToServer()
						end)
					else
						net.Start("ARS_ViewReport_ToServer")
							local TABLE = {}
							TABLE.Number = k
							TABLE.Player = LocalPlayer():Nick()
							TABLE.close = false
							net.WriteTable(TABLE)
						net.SendToServer()
					end
				end
				ViewButton.OnCursorEntered = function( self )
					self.hover = true
				end
				ViewButton.OnCursorExited = function( self )
					self.hover = false
				end
				
				ARSPeportsList:AddItem( ReportList )
			end
		else
			ARSNoReportMain = vgui.Create( "DPanel", ARSAdminPanelFrame )
			ARSNoReportMain:SetPos( 0, 100 )
			ARSNoReportMain:SetSize( ARSAdminPanelFrame:GetWide(), ARSAdminPanelFrame:GetTall()-100)
			ARSNoReportMain.Paint = function()
				draw.RoundedBoxEx( 4, 0, 0, ARSNoReportMain:GetWide(), ARSNoReportMain:GetTall(), ARS.RequestBGColor, false, false, true, true )
				ARSdrawBlackLine(0, 0, ARSNoReportMain:GetWide(), ARSNoReportMain:GetTall())
				ARSdrawBoxLine(1, 1, ARSNoReportMain:GetWide()-2, ARSNoReportMain:GetTall()-2)
				draw.RoundedBox( 0, 15, 15, ARSNoReportMain:GetWide()-30, ARSNoReportMain:GetTall()-30, ARS.InnerBGColor )
				ARSdrawBlackLine(15, 15, ARSNoReportMain:GetWide()-30, ARSNoReportMain:GetTall()-30)
				ARSdrawBoxLine(16, 65, ARSNoReportMain:GetWide()-32, ARSNoReportMain:GetTall()-81)
				draw.SimpleText( "You have no active admin requests!", "No_Report_Text", ARSNoReportMain:GetWide()/2, ARSNoReportMain:GetTall()/2-40, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Check back later for more!", "No_Report_Text", ARSNoReportMain:GetWide()/2, ARSNoReportMain:GetTall()/2+10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end
			
			local ARSNoReportCategory = vgui.Create( "DPanel", ARSNoReportMain )
			ARSNoReportCategory:SetPos( 15, 15 )
			ARSNoReportCategory:SetSize( ARSNoReportMain:GetWide()-30, 50)
			ARSNoReportCategory.Paint = function()
				draw.RoundedBox( 0, 0, 0, ARSNoReportMain:GetWide(), ARSNoReportMain:GetTall(), ARS.RequestHeaderColor )
				surface.SetDrawColor(Color(0, 0, 0))
				surface.DrawOutlinedRect( 0, 0, ARSNoReportCategory:GetWide(), ARSNoReportCategory:GetTall() )
				draw.SimpleText( "Date", "Category_Text", 30, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				draw.SimpleText( "Reporter", "Category_Text", 150, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				draw.SimpleText( "Player", "Category_Text", 320, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				draw.SimpleText( "Reason", "Category_Text", 470, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				draw.SimpleText( "Status", "Category_Text", 622.5, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				draw.SimpleText( "Details", "Category_Text", 770, 12, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
				ARSdrawBoxLine(1, 1, 109, 48)
				ARSdrawBoxLine(111, 1, 164, 48)
				ARSdrawBoxLine(276, 1, 149, 48)
				ARSdrawBoxLine(426, 1, 149, 48)
				ARSdrawBoxLine(576, 1, 154, 48)
				ARSdrawBoxLine(731, 1, ARSNoReportCategory:GetWide()-732, 48)
				ARSdrawBlackLine(0, 0, 111, 50)
				ARSdrawBlackLine(0, 0, 276, 50)
				ARSdrawBlackLine(0, 0, 426, 50)
				ARSdrawBlackLine(0, 0, 576, 50)
				ARSdrawBlackLine(0, 0, 731, 50)
				ARSdrawBlackLine(0, 0, ARSNoReportCategory:GetWide(), 50)
			end
		end
	end
end

local function CreateMeButton(panel, x, y, w, h, name, command, target )
	local ViewButton = vgui.Create( "DButton", panel )
	ViewButton:SetPos( x, y )
	ViewButton:SetSize( w, h )
	ViewButton:SetText( name )
	ViewButton:SetFont( "Buttons_Text" )
	ViewButton.Paint = function( self, w, h )
		if self.hover then
			draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
			ViewButton:SetTextColor( ARS.ButtonHoverTextColor )
		else
			draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
			ViewButton:SetTextColor( ARS.ButtonTextColor )
		end
	end
	ViewButton.DoClick = function()
		RunConsoleCommand( "ulx", command, target )
	end
	ViewButton.OnCursorEntered = function( self )
		self.hover = true
	end
	ViewButton.OnCursorExited = function( self )
		self.hover = false
	end
end