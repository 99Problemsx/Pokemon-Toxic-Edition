#===============================================================================
# Scared (25% chance to force a switch out.)
#===============================================================================
class Battle::Move::ScaredTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanScared?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbScared(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbScared(user) if target.pbCanScared?(user, false, self)
  end
end

#===============================================================================
