DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:SetupDataTables()
	
	self.Player:NetworkVar( "String", 0, "NClass" )
	self.Player:NetworkVar( "Int", 0, "NKarma" )
	self.Player:NetworkVar( "Int", 1, "NEXP" )
	self.Player:NetworkVar( "Int", 2, "NLevel" )
	self.Player:NetworkVar( "Int", 3, "NGTeam" )
	self.Player:NetworkVar( "Bool", 0, "NActive" )
	self.Player:NetworkVar( "Bool", 1, "NPremium" )
	
	if SERVER then
		print("Setting up datatables for " .. self.Player:Nick())
		self.Player:SetNClass("Spectator")
		CheckPlayerData( self.Player, "breach_karma" )
		CheckPlayerData( self.Player, "breach_exp" )
		CheckPlayerData( self.Player, "breach_level" )
		local num
		if SaveKarma() then
			num = tonumber(self.Player:GetPData( "breach_karma", StartingKarma() ))
		else
			num = SaveKarma()
		end
		self.Player:SetNEXP( tonumber( self.Player:GetPData( "breach_exp", 0 ) ) )
		self.Player:SetNLevel( tonumber( self.Player:GetPData( "breach_level", 0 ) ) )
		self.Player:SetNKarma( num or 1000 )
		self.Player.Karma = num or 1000
		self.Player:SetNGTeam(1)
		--print( self.Player.ActivePlayer or false, self.Player.Premium or false )
		--print( debug.traceback() )
		self.Player:SetNActive( self.Player.ActivePlayer or false )
		self.Player:SetNPremium( self.Player.Premium or false )
	end
end

function CheckPlayerData( player, name )
	local pd = player:GetPData( name, 0 )
	if pd == "nil" then
		print( "Damaged playerdata found..." )
		player:RemovePData( name )
		player:SetPData( name, StartingKarma() ) 
	end
end

player_manager.RegisterClass( "class_breach", PLAYER, "player_default" )