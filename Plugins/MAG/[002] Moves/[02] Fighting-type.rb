#===============================================================================
# One-Inch Punch
# Doubles the damage and breaks through protect
#===============================================================================
class Battle::Move::DoubleDamageIfProtect < Battle::Move::RemoveProtections
  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 2 if (target.effects[PBEffects::Protect] || target.effects[PBEffects::BanefulBunker] ||
    target.effects[PBEffects::KingsShield] || target.effects[PBEffects::Obstruct] || target.effects[PBEffects::Protect] ||
    target.effects[PBEffects::SpikyShield] || target.effects[PBEffects::QueensShield])
    return baseDmg
  end
end

#===============================================================================
# Aikido Blast
# Charges attack and gains a focus energy on first turn. Attack on the second
#===============================================================================
class Battle::Move::TwoTurnAttackFocusEnergy < Battle::Move::TwoTurnMove
  def pbChargingTurnMessage(user, targets)
    @battle.pbDisplay(_INTL("{1} began to gather fighting energy!", user.pbThis))
  end
  
  def pbEffectGeneral(user)
  return if user.effects[PBEffects::FocusEnergy] >= 2
    user.effects[PBEffects::FocusEnergy] = 2
    @battle.pbDisplay(_INTL("This sudden energy is pumping {1} up!", user.pbThis))
  end
  end

#===============================================================================
# Whirlwind Fist
# Super Effective against Flying-Types. Bonus damage in Tailwind
#=============================================================================== 
class Battle::Move::SuperEffectiveAgainstFlyingExtraDamageInTailwind < Battle::Move 
  def pbBaseDamage(baseDmg, user, target)
    targetSide = target.pbOwnSide
    baseDmg *= 2 if targetSide.effects[PBEffects::Tailwind] > 0 
    return baseDmg
  end
  
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :FLYING
    return super
  end  
end
