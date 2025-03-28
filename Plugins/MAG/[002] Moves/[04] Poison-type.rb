#===============================================================================
# Corroding Acid
# Super effective on Steel-Types. Chance to Poison
#===============================================================================
class Battle::Move::PoisonTargetSuperEffectiveAgainstSteel < Battle::Move
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :STEEL
    return super
  end
  
  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
  target.pbPoison(user)
   end
end

#===============================================================================
# Entry hazard. Lays 2 layers of poison spikes on the both sides.
# (Toxic Shedding)
#===============================================================================
class Battle::Move::AddTwoToxicSpikesToBothSides < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::ToxicSpikes] >= 2
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
	if user.pbOwnSide.effects[PBEffects::ToxicSpikes] >= 2
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
  end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::ToxicSpikes] == 2
    @battle.pbDisplay(_INTL("{1} threw Poison spikes across the battle field!",
                            user.this(true)))
  end
end