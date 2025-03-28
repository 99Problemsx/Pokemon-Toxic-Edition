################################################################################
# Gale Punch
# +1 speed, +2 Speed in tail wind
################################################################################
class Battle::Move::RaiseUserSpeed1Raise2InTailWind < Battle::Move::StatUpMove
  def initialize(battle, move)
    super
    @statUp = [:SPEED, 1]
  end
  
  def pbOnStartUse(user, targets)
    increment = 1
    increment = 2 if user.pbOwnSide.effects[PBEffects::Tailwind] > 0
    @statUp[1] = @statUp[3] = increment
  end
end