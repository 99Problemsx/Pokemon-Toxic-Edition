#===============================================================================
# Idolize (30% chance to not move.)
#===============================================================================
class Battle::Move::IdolizeTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanIdolize?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbIdolize(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbIdolize(user) if target.pbCanIdolize?(user, false, self)
  end
end

#===============================================================================