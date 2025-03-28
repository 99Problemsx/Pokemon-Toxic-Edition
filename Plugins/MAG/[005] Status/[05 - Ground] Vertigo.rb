#===============================================================================
# Vertigo (30% Chance to inflict confusion.)
#===============================================================================
class Battle::Move::VertigoTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanVertigo?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbVertigo(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbVertigo(user) if target.pbCanVertigo?(user, false, self)
  end
end