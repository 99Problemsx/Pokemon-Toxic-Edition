#===============================================================================
# Allergies (Randomly drops either Speed, Defense or Special Defence by 1.)
#===============================================================================
class Battle::Move::AllergiesTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanAllergies?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbAllergies(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbAllergies(user) if target.pbCanAllergies?(user, false, self)
  end
end

#===============================================================================
