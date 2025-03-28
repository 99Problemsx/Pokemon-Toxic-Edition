#===============================================================================
# Pester (25% chance to not attack. Takes 1/16 damage per turn)
#===============================================================================
class Battle::Move::PesterTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanPester?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbPester(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbPester(user) if target.pbCanPester?(user, false, self)
  end
end

#===============================================================================
