#===============================================================================
# Poison Absorb
# Black Sludge heals the user if they have Poison Absorb
#===============================================================================
Battle::ItemEffects::EndOfRoundHealing.add(:BLACKSLUDGE,
  proc { |item, battler, battle|
    if battler.pbHasType?(:POISON) || battler.hasActiveAbility?(:POISONABSORB)
      next if !battler.canHeal?
      battle.pbCommonAnimation("UseItem", battler)
      battler.pbRecoverHP(battler.totalhp / 16)
      battle.pbDisplay(_INTL("{1} restored a little HP using its {2}!",
         battler.pbThis, battler.itemName))
    elsif battler.takesIndirectDamage?
      battle.pbCommonAnimation("UseItem", battler)
      battler.pbTakeEffectDamage(battler.totalhp / 8) do |hp_lost|
        battle.pbDisplay(_INTL("{1} is hurt by its {2}!", battler.pbThis, battler.itemName))
      end
    end
  }
)