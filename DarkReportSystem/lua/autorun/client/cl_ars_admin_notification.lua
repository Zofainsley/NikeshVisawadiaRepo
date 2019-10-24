local AdminNotifyPanel
net.Receive( "ARS_GotAReport", function()
	local TXT = net.ReadString()
	if ARS.UseSoundNotification then
		surface.PlaySound( ARS.SoundUsed )
	end
	local timeleft = 0
	if ARS.SendPanelWarning and not IsValid(AdminNotifyPanel) then
		surface.SetFont("Date_Text")
		local wid, hit = surface.GetTextSize(TXT)
		AdminNotifyPanel = vgui.Create( "DNotify" )
		if wid+40 > 300 then
			AdminNotifyPanel:SetSize( wid + 40, 140 )
			AdminNotifyPanel:SetPos( ScrW()-(wid + 50), 10 )
		else
			AdminNotifyPanel:SetSize( 300, 140 )
			AdminNotifyPanel:SetPos( ScrW()-310, 10 )
		end
		AdminNotifyPanel:SetLife(ARS.PanelNotiTimeOpen)
		local bg = vgui.Create( "DPanel", AdminNotifyPanel )
		bg:Dock( FILL )
		bg.Paint = function(self, w, h)
			draw.RoundedBoxEx( 4, 0, 0, w, 30, ARS.RequestHeaderColor, true, true, false, false )
			draw.RoundedBoxEx( 4, 0, 30, w, h-30, ARS.RequestBGColor, false, false, true, true )	
			draw.SimpleText( "You have received a Report!", "Headings_Text", w/2, 2, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( TXT, "Date_Text", w/2, 35, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Type '"..ARS.AdminChatCommand.."' to view!", "Date_Text", w/2, 55, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			draw.SimpleText( math.Round(timeleft), "List_Text", w/2, 75, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		end
		timer.Create("TimeOpen", ARS.PanelNotiTimeOpen, 1, function()
			--AdminNotifyPanel:Remove()
			timer.Remove("TimeOpen")
		end)
		AdminNotifyPanel.Think = function()
			timeleft = timer.TimeLeft("TimeOpen")
		end
		timer.Simple(ARS.PanelNotiTimeOpen, function()
			if IsValid(AdminNotifyPanel) then
				AdminNotifyPanel:Remove()
			end
		end)
		local PlayerButton = vgui.Create( "DButton", AdminNotifyPanel )
		PlayerButton:SetSize( 100, 30 )
		PlayerButton:SetPos( AdminNotifyPanel:GetWide()/2-50, AdminNotifyPanel:GetTall()-40 )
		PlayerButton:SetText( "Open Menu" )
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
			LocalPlayer():ConCommand("say "..ARS.AdminChatCommand)
		end
		PlayerButton.OnCursorEntered = function( self )
			self.hover = true
		end
		PlayerButton.OnCursorExited = function( self )
			self.hover = false
		end
	end
end)

net.Receive("ARS_RemoveNotification", function()
	if IsValid(AdminNotifyPanel) then
		AdminNotifyPanel:Remove()
	end
	/*if timer.Exists("TimeOpen") then
		timer.Remove("TimeOpen")
	end*/
end)

