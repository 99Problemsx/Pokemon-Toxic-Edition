#===============================================================================
# Brittle (Cuts Defense. Deals 1/16 upon a contact move and 1/8 if the type is Steel.)
#===============================================================================
class Battle::Move::BrittleTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanBrittle?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbBrittle(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbBrittle(user) if target.pbCanBrittle?(user, false, self)
  end
end

#===============================================================================
