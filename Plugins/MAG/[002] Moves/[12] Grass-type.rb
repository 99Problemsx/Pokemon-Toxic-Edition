#===============================================================================
# Viny Hold
# Traps the target, Lowers highest offensive stat.
#===============================================================================
class Battle::Move::TrapTargetLowerHighestStat < Battle::Move
  def pbEffectAgainstTarget(user, target)
    return if target.fainted? || target.damageState.substitute
    return if target.effects[PBEffects::VinyHold] > 0
	target.effects[PBEffects::VinyHold] = 3
    @battle.pbDisplay(_INTL("{1} got captured by {2}'s vines and can't escape!", target.pbThis, user.pbThis))
  end
end