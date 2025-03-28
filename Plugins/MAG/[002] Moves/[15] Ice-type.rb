#===============================================================================
# Queen's Shield
#===============================================================================
class Battle::Move::ProtectUserFromDamagingMovesQueensShield < Battle::Move::ProtectMove
  def initialize(battle, move)
    super
    @effect = PBEffects::QueensShield
  end
end
