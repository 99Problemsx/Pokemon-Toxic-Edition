#===============================================================================
# Winded (2-3 turns. 50% chance to not move)
#===============================================================================
class Battle::Move::WindedTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanWinded?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbWinded(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbWinded(user) if target.pbCanWinded?(user, false, self)
  end
end