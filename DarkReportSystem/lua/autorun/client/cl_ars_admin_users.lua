local function DrawPlayerAv( panel, ply )
	local PlyAvatar = vgui.Create( "AvatarImage", panel )
	PlyAvatar:SetPos( 5, 5 )
	PlyAvatar:SetSize( 30, 30 )
	PlyAvatar:SetPlayer( ply, 32 )
	avatar = true
	timer.Simple( 1, function()
		avatar = false
	end)
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
		ARSdrawBoxLine( 1, 1, w-2, h-2 )
		ARSdrawBlackLine(0, 0, w, h )
	end
	ViewButton.DoClick = function()
		RunConsoleCommand( "say", command.." ".. target )
		CloseAllARS()
		timer.Simple(1, function()
			ARSAdminPanelUsers()
		end)
	end
	ViewButton.OnCursorEntered = function( self )
		self.hover = true
	end
	ViewButton.OnCursorExited = function( self )
		self.hover = false
	end
end
function ARSAdminPanelUsers()
	ARSUsersMain = vgui.Create( "DPanel", ARSAdminPanelFrame )
	ARSUsersMain:SetPos( 0, 100 )
	ARSUsersMain:SetSize( ARSAdminPanelFrame:GetWide(), ARSAdminPanelFrame:GetTall()-100)
	ARSUsersMain.Paint = function()
		draw.RoundedBox( 0, 0, 0, ARSUsersMain:GetWide(), ARSUsersMain:GetTall(), ARS.RequestBGColor )
		ARSdrawBlackLine(0, 0, ARSUsersMain:GetWide(), ARSUsersMain:GetTall())
		ARSdrawBoxLine(1, 1, ARSUsersMain:GetWide()-2, ARSUsersMain:GetTall()-2)
		draw.RoundedBox( 0, 15, 15, ARSUsersMain:GetWide()-30, ARSUsersMain:GetTall()-30, ARS.InnerBGColor )
		ARSdrawBlackLine(15, 15, ARSUsersMain:GetWide()-30, ARSUsersMain:GetTall()-30)
		ARSdrawBoxLine(16, 65, ARSUsersMain:GetWide()-32, ARSUsersMain:GetTall()-81)
	end
	
	local ARSUsersCategory = vgui.Create( "DPanel", ARSUsersMain )
	ARSUsersCategory:SetPos( 15, 15 )
	ARSUsersCategory:SetSize( ARSUsersMain:GetWide()-30, 50)
	ARSUsersCategory.Paint = function()
		draw.RoundedBox( 0, 0, 0, ARSUsersMain:GetWide(), ARSUsersMain:GetTall(), ARS.RequestHeaderColor )
		surface.SetDrawColor(Color(0, 0, 0))
		surface.DrawOutlinedRect( 0, 0, ARSUsersCategory:GetWide(), ARSUsersCategory:GetTall() )
		draw.SimpleText( "Name", "Category_Text", 120, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		if ARS.Gamemode == "DarkRP" then 
			draw.SimpleText( "Job", "Category_Text", 305, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		elseif ARS.Gamemode == "TTT" or ARS.Gamemode == "Deathrun" then 
			draw.SimpleText( "Role", "Category_Text", 305, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		end
		draw.SimpleText( "Rank", "Category_Text", 495, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		draw.SimpleText( "Commands", "Category_Text", 730, 12, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
		ARSdrawBoxLine(1, 1, 210, 48)
		ARSdrawBoxLine(211, 1, 190, 48)
		ARSdrawBoxLine(401, 1, 190, 48)
		ARSdrawBoxLine(591, 1, 278, 48)
		ARSdrawBlackLine(0, 0, 211, 50)
		ARSdrawBlackLine(210, 0, 191, 50)
		ARSdrawBlackLine(400, 0, 191, 50)
		ARSdrawBlackLine(590, 0, 280, 50)
	end
	
	local ARSUsersList = vgui.Create( "DPanelList", ARSUsersMain )
	ARSUsersList:SetPos( 17, 65 )
	ARSUsersList:SetSize( ARSUsersCategory:GetWide()-4, 450 )
	ARSUsersList:EnableHorizontal( false )
	ARSUsersList:EnableVerticalScrollbar( false )
	ARSUsersList:SetSpacing( 1 )
	
	for k, v in pairs(player.GetAll()) do
		local UsersList = vgui.Create( "DPanel" )
		UsersList:SetSize( ARSUsersList:GetWide(), 40 )
		UsersList.Paint = function(self, w, h)
			local NickLen = string.len( v:Nick() )
			local JobLen = string.len( team.GetName(v:Team()) )
			local RankLen = string.len( v:GetUserGroup() )
			local Team = team.GetName(v:Team())
			draw.RoundedBox( 0, 0, 0, w, h, ARS.RequestHeaderColor )
			if NickLen <= 18 then 
				draw.SimpleText( v:Nick(), "List_Text", 120, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( string.sub( v:Nick(), 1, 15 ).."...", "List_Text", 120, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end
			if JobLen <= 18 then 
				draw.SimpleText( Team, "List_Text", 304, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( string.sub( Team, 1, 13 ).."...", "List_Text", 349, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end
			if RankLen <= 18 then 
				draw.SimpleText( v:GetUserGroup(), "List_Text", 494, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( string.sub( v:GetUserGroup(), 1, 13 ).."...", "List_Text", 494, 10, ARS.TextRequestColor, TEXT_ALIGN_CENTER )
			end 
			ARSdrawLine(208, 0, 208, 40)
			ARSdrawLine(398, 0, 398, 40)
			ARSdrawLine(588, 0, 588, 40)
		end
		DrawPlayerAv( UsersList, v )
		CreateMeButton(UsersList, UsersList:GetWide()-271, 5, 60, 30, ARS.Commands.FirstButtonName, ARS.Commands.FirstButtonCommand, v:Nick() )
		CreateMeButton(UsersList, UsersList:GetWide()-203, 5, 60, 30, ARS.Commands.SecondButtonName, ARS.Commands.SecondButtonCommand, v:Nick() )
		CreateMeButton(UsersList, UsersList:GetWide()-135, 5, 60, 30, ARS.Commands.ThirdButtonName, ARS.Commands.ThirdButtonCommand, v:Nick() )
		CreateMeButton(UsersList, UsersList:GetWide()-67, 5, 60, 30, ARS.Commands.FourthButtonName, ARS.Commands.FourthButtonCommand, v:Nick() )
		ARSUsersList:AddItem( UsersList )
	end
end