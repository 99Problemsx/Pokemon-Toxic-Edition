#===============================================================================
# Trickster’s Ray
#===============================================================================
class Battle::Move::InverseDarkType < Battle::Move
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :FIGHTING
	return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :DARK
	return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :FAIRY
	return Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER if defType == :GHOST
	return Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER if defType == :PSYCHIC
    return super
  end
end

#===============================================================================
# Magic Tampering
#===============================================================================
class Battle::Move::DisableFairyMoves < Battle::Move
  def ignoresSubstitute?(user); return true; end
  def canMagicCoat?;            return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    if target.effects[PBEffects::MagicTampering] > 0
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    return true if pbMoveFailedAromaVeil?(user, target, show_message)
    if target.hasActiveAbility?(:OBLIVIOUS) &&
       !@battle.moldBreaker
      if show_message
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("But it failed!"))
        else
          @battle.pbDisplay(_INTL("But it failed because of {1}'s {2}!",
                                  target.pbThis(true), target.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      end
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::MagicTampering] = 4
    @battle.pbDisplay(_INTL("{1} had its magic tampered!", target.pbThis))
    target.pbItemStatusCureCheck
  end
end