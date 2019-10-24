local function FindPlayer( targ )
	local target
	for k, v in pairs( player.GetAll() ) do
		if targ == v:Name() or targ == v:SteamID() then
			target = v
		end
	end
	return target
end

function OpenARSRequestMenu(ply)
	local NigName = ""
	local Job = ""
	local Rank = ""
	local Target = ""
	if ply != FindPlayer(LocalPlayer():SteamID()) then
		ply = FindPlayer(LocalPlayer():SteamID())
	end
	if !IsValid(DaddyJustin) then 
		local DaddyJustin = vgui.Create( "DFrame" ) 
		DaddyJustin:SetSize( 650, 450 )
		DaddyJustin:SetPos( ScrW()/2-DaddyJustin:GetWide()/2, ScrH()/2-DaddyJustin:GetTall()/2 )
		DaddyJustin:SetTitle( " " ) 
		DaddyJustin:SetVisible( true )
		DaddyJustin:SetDraggable( false ) 
		DaddyJustin:ShowCloseButton( false ) 				
		DaddyJustin:MakePopup() 
		DaddyJustin.Paint = function(self, w, h)
			draw.RoundedBoxEx( 4, 0, 0, DaddyJustin:GetWide(), 30, ARS.RequestHeaderColor, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, DaddyJustin:GetWide(), DaddyJustin:GetTall()-30, ARS.RequestBGColor, false, false, true, true )	
			draw.SimpleText( "PLAYER REPORT FORM", "Headings_Text", DaddyJustin:GetWide()/2, 2, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBoxLine( 1, 31, w-2, h-32 )
			ARSdrawBlackLine(0, 30, w, h-30 )
		end
		
		local CloseButton = vgui.Create( "DButton", DaddyJustin )
		CloseButton:SetSize( 25, 30 )
		CloseButton:SetPos( DaddyJustin:GetWide() - 25,0 )
		CloseButton:SetText( "r" )
		CloseButton:SetFont( "marlett" )
		CloseButton:SetTextColor( Color(235, 72, 73) )
		CloseButton.Paint = function()
			
		end
		CloseButton.DoClick = function()
			DaddyJustin:Remove()					
		end
		CloseButton.OnCursorEntered = function( self )
			self.hover = true
			self:SetTextColor( Color(153, 0, 0) )
		end
		CloseButton.OnCursorExited = function( self )
			self.hover = false
			self:SetTextColor( Color(235, 72, 73) )
		end
		
		local PlayerList = vgui.Create( "DPanel", DaddyJustin )
		PlayerList:SetPos( 7.5, 37.5 )
		PlayerList:SetSize( 185, 405 )
		PlayerList.Paint = function(self, w, h)
			draw.RoundedBox( 4, 0, 0, 185, 405, ARS.RequestHeaderColor )
			draw.SimpleText( "Players", "Main_Text", PlayerList:GetWide()/2, 5, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			ARSdrawBoxLine( 1, 1, w-2, h-2 )
			ARSdrawBlackLine(0, 0, w, h )
		end
		
		local PlayerListPanel = vgui.Create( "DPanelList", PlayerList )
		PlayerListPanel:SetPos( 7.5, 37.5 )
		PlayerListPanel:SetSize( 170, 367.5 )
		PlayerListPanel:EnableHorizontal( false )
		PlayerListPanel:EnableVerticalScrollbar( false )
		PlayerListPanel:SetSpacing( 2 )

		if ARS.NonePlayerSelecter then
			local PlayerButton = vgui.Create( "DButton", PlayerListPanel )
			PlayerButton:SetSize( 170, 20 )
			PlayerButton:SetText( ARS.NoneButtonText )
			PlayerButton:SetFont( "Nick_Text" )
			PlayerButton.Paint = function( self, w, h )
				if self.hover then
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
					PlayerButton:SetTextColor( ARS.ButtonHoverTextColor )
				else
					draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
					PlayerButton:SetTextColor( ARS.ButtonTextColor )
				end
				ARSdrawBoxLine( 1, 1, w-2, h-2 )
				ARSdrawBlackLine(0, 0, w, h )
			end
			PlayerButton.DoClick = function()
				NigName = ARS.NoneButtonText
				Rank = "N/A"
				Job = "N/A"
				Target = ARS.NoneButtonText
			end
			PlayerButton.OnCursorEntered = function( self )
				self.hover = true
			end
			PlayerButton.OnCursorExited = function( self )
				self.hover = false
			end
			PlayerListPanel:AddItem( PlayerButton )
		end
		
		for k, v in pairs(player.GetAll()) do 
			if !v:IsNotTouchable() and v != ply then 
				local PlayerButton = vgui.Create( "DButton", PlayerListPanel )
				PlayerButton:SetSize( 170, 20 )
				PlayerButton:SetText( v:Nick() )
				PlayerButton:SetFont( "Nick_Text" )
				PlayerButton.Paint = function( self, w, h )
					if self.hover then
						draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonHoverColor )
						PlayerButton:SetTextColor( ARS.ButtonHoverTextColor )
					else
						draw.RoundedBox( 0, 0, 0, w, h, ARS.ButtonColor )
						PlayerButton:SetTextColor( ARS.ButtonTextColor )
					end
					ARSdrawBoxLine( 1, 1, w-2, h-2 )
					ARSdrawBlackLine(0, 0, w, h )
				end
				PlayerButton.DoClick = function()
					NigName = v:Nick()
					Rank = v:GetUserGroup()
					Job = team.GetName(v:Team())
					Target = v
				end
				PlayerButton.OnCursorEntered = function( self )
					self.hover = true
				end
				PlayerButton.OnCursorExited = function( self )
					self.hover = false
				end
				PlayerListPanel:AddItem( PlayerButton )
			end
		end
		
		local PlayerInfo = vgui.Create( "DPanel", DaddyJustin )
		PlayerInfo:SetPos( 200, 37.5 )
		PlayerInfo:SetSize( 442.5, 405 )
		PlayerInfo.Paint = function(self, w, h)
			draw.RoundedBox( 4, 0, 0, 442.5, 405, ARS.RequestHeaderColor )
			draw.SimpleText( "Player Information", "Headings_Text", PlayerInfo:GetWide()/2, 2, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Name: "..NigName, "Main_Text", 15, 35, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "Job: "..Job, "Main_Text", 15, 75, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "Rank: "..Rank, "Main_Text", 15, 115, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "Reason:", "Main_Text", 15, 155, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			draw.SimpleText( "More Information:", "Main_Text", 15, 195, ARS.TextRequestColor, TEXT_ALIGN_LEFT )
			ARSdrawBoxLine( 1, 1, w-2, h-2 )
			ARSdrawBlackLine(0, 0, w, h )
		end
		
		local DComboBox = vgui.Create( "DComboBox", PlayerInfo )
		DComboBox:SetPos( 100, 160 )
		DComboBox:SetSize( 250, 20 )
		DComboBox:SetValue( "Select a Reason" )
		for k, v in pairs(ARS.Reasons) do
			DComboBox:AddChoice( v )
		end		
		
		local DetailTextEntry = vgui.Create( "DTextEntry", PlayerInfo )
		DetailTextEntry:SetPos(15, 225)
		DetailTextEntry:SetSize(412.5, 165-37.5)
		DetailTextEntry:SetFont("Extra_Detail")
		DetailTextEntry:SetCursorColor(Color(0, 0, 0))
		DetailTextEntry:SetTextColor(Color(0, 0, 0))
		DetailTextEntry:SetMultiline(true)
		
		local SendButton = vgui.Create( "DButton", PlayerInfo )
		SendButton:SetPos( PlayerInfo:GetWide()-217.5, PlayerInfo:GetTall()-45 )
		SendButton:SetSize( 202.5, 30 )
		SendButton:SetText( "Submit" )
		SendButton:SetTextColor( Color(0, 0, 0) )
		SendButton:SetFont( "Nick_Text" )
		SendButton.Paint = function( self, w, h )
			if self.hover then
				draw.RoundedBox( 2, 0, 0, w, h, Color(0, 153, 0) )
			else
				draw.RoundedBox( 2, 0, 0, w, h, Color(123, 176, 68) )
			end
			ARSdrawBoxLine( 1, 1, w-2, h-2 )
			ARSdrawBlackLine(0, 0, w, h )
		end
		SendButton.DoClick = function()
			if NigName != "" and Job != "" and Rank != "" then
				if DComboBox:GetValue() != "Select a Reason" then 
					if DetailTextEntry:GetValue() != "" then 
						net.Start("ARS_SendReportToServer")
							local TABLE = {}
							TABLE.Name = Target
							TABLE.Reporter = ply
							TABLE.Reason = DComboBox:GetSelected()
							TABLE.ExtraDetails = DetailTextEntry:GetValue()
							net.WriteTable(TABLE)
						net.SendToServer()
						DaddyJustin:Remove()
						DaddyJustin:Remove()
					else
						Derma_Message( "You must add some extra details!", "Failed", "OK" )
					end
				else
					Derma_Message( "You must select a reason!", "Failed", "OK" )
				end
			else
				Derma_Message( "You must select a player!", "Failed", "OK" )
			end
		end
		SendButton.OnCursorEntered = function( self )
			self.hover = true
		end
		SendButton.OnCursorExited = function( self )
			self.hover = false
		end
		
		local CancelButton = vgui.Create( "DButton", PlayerInfo )
		CancelButton:SetPos( 15, PlayerInfo:GetTall()-45 )
		CancelButton:SetSize( 202.5, 30 )
		CancelButton:SetText( "Cancel" )
		CancelButton:SetTextColor( Color(0, 0, 0) )
		CancelButton:SetFont( "Nick_Text" )
		CancelButton.Paint = function( self, w, h )
			if self.hover then
				draw.RoundedBox( 2, 0, 0, w, h, Color(153, 0, 0) )
			else
				draw.RoundedBox( 2, 0, 0, w, h, Color(235, 72, 73) )
			end
			ARSdrawBoxLine( 1, 1, w-2, h-2 )
			ARSdrawBlackLine(0, 0, w, h )
		end
		CancelButton.DoClick = function()
			DaddyJustin:Remove()
		end
		CancelButton.OnCursorEntered = function( self )
			self.hover = true
		end
		CancelButton.OnCursorExited = function( self )
			self.hover = false
		end
	end
end

net.Receive( "ARS_Request", OpenARSRequestMenu)

if ARS.EnableFKey then
	local AlreadyPressed = false
	hook.Add("Think", "SuggestionsOpenKey", function()
		if input.IsKeyDown(ARS.FKeyCommand) and not AlreadyPressed then
			AlreadyPressed = true
			OpenARSRequestMenu(FindPlayer(LocalPlayer():SteamID()))
		elseif AlreadyPressed and not input.IsKeyDown(ARS.FKeyCommand) then
			AlreadyPressed = false
		end
	end)
end

surface.CreateFont( "Main_Text", {
	font = "CloseCaption_Normal",
	size = 25,
	weight = 525
} )
surface.CreateFont( "Headings_Text", {
	font = "CloseCaption_Normal",
	size = 27,
	weight = 525
} )
surface.CreateFont( "Nick_Text", {
	font = "CloseCaption_Normal",
	size = 18,
	weight = 525
} )
surface.CreateFont( "Extra_Detail", {
	font = "DebugFixed",
	size = 20,
	weight = 525
} )