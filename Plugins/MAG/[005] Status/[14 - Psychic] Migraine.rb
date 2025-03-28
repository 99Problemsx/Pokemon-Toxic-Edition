#===============================================================================
# Migraine (Damages the user 1/8 if a status move is used.))
#===============================================================================
class Battle::Move::MigraineTarget < Battle::Move
  def canMagicCoat?; return true; end

  def pbFailsAgainstTarget?(user, target, show_message)
    return false if damagingMove?
    return !target.pbCanMigraine?(user, show_message, self)
  end

  def pbEffectAgainstTarget(user, target)
    return if damagingMove?
    target.pbMigraine(user)
  end

  def pbAdditionalEffect(user, target)
    return if target.damageState.substitute
    target.pbMigraine(user) if target.pbCanMigraine?(user, false, self)
  end
end

#===============================================================================