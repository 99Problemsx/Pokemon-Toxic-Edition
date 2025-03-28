#===============================================================================
# Drenched (Cuts Speed. Deals 1/16 damage per turn.)
#===============================================================================
class Battle::Move::DrenchedTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanDrenched?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbDrenched(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbDrenched(user) if target.pbCanDrenched?(user, false, self)
  end
end

#===============================================================================
