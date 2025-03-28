#===============================================================================
# Blinded (2-3 turns. Cuts accuracy by 25%)
#===============================================================================
class Battle::Move::BlindedTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanBlinded?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbBlinded(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbBlinded(user) if target.pbCanBlinded?(user, false, self)
  end
end

#===============================================================================
