#===============================================================================
# Splinters (1/16 damage per turn. Reduces Defense.)
#===============================================================================
class Battle::Move::SplinterTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanSplinter?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbSplinter(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbSplinter(user) if target.pbCanSplinter?(user, false, self)
  end
end

#===============================================================================