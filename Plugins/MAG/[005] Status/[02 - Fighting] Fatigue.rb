#===============================================================================
# Fatigue (Lowers Attack by 1 every turn.)
#===============================================================================
class Battle::Move::FatigueTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanFatigue?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbFatigue(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbFatigue(user) if target.pbCanFatigue?(user, false, self)
  end
end

#===============================================================================
# Work out (+3 Attack, User gains Fatigue.)
#===============================================================================
class Battle::Move::FatiguesUserRaiseUserAtk3 < Battle::Move

  def pbMoveFailed?(user, targets)
    if user.status != :NONE || !user.pbCanFatigue?(user, false, self)
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
  showAnim = true
    if user.pbCanRaiseStatStage?(:ATTACK, user, self)
      user.pbRaiseStatStage(:ATTACK, 3, user, showAnim)
    end
    user.pbFatigue(user) if user.pbCanFatigue?(user, false, self)
  end
end
