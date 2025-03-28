class Battle::ActiveSide
alias mag_initialize initialize
  def initialize
  	mag_initialize
    @effects[PBEffects::FaintedLast]           = 0
    @effects[PBEffects::GoldHoard]             = 0
	# Field Effects/Entry Hazards
	@effects[PBEffects::TerrainSmash]          = false
	@effects[PBEffects::RestictiveWinds]       = false
	@effects[PBEffects::HauntedOrbs]           = false
	@effects[PBEffects::SharpSteel]            = false
	@effects[PBEffects::BurningDebris]         = false
	@effects[PBEffects::WaterChannel]          = false
	@effects[PBEffects::RoseField]             = false
	@effects[PBEffects::ProtonOverload]        = false
	@effects[PBEffects::MindField]             = false
	@effects[PBEffects::IceRing]               = false
	@effects[PBEffects::DraconicRift]          = false
	@effects[PBEffects::DarkMist]              = false
	@effects[PBEffects::ManaFlux]              = false
	@effects[PBEffects::Miasma]                = false
  end
end