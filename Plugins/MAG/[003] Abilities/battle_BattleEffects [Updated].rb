module Battle::AbilityEffects
#===============================================================================
# Gale Wings
#===============================================================================
Battle::AbilityEffects::PriorityChange.add(:GALEWINGS,
  proc { |ability, battler, move, pri|
  if Settings::MAG_GALEWINGS  == 0
    next pri + 1 if (Settings::MECHANICS_GENERATION <= 6 || battler.hp == battler.totalhp) &&
                    move.type == :FLYING
	end
  if Settings::MAG_GALEWINGS == 1
    next pri + 1 if (battler.hp >= battler.totalhp * 0.5) &&
                    move.type == :FLYING
    end
  if Settings::MAG_GALEWINGS == 2
    next pri + 1 if (battler.hp >= battler.totalhp * 0.75) &&
                    move.type == :FLYING
    end
  }
)
#===============================================================================
# Run Away
#===============================================================================
Battle::AbilityEffects::OnIntimidated.add(:RUNAWAY,
  proc { |ability, battler, battle|
    next if !Settings::MAG_RUNAWAY == true
    battler.pbRaiseStatStageByAbility(:SPEED, 2, battler)
  }
)

Battle::AbilityEffects::CertainSwitching.add(:RUNAWAY,
  proc { |ability, battler|
    next true if Settings::MAG_RUNAWAY == true
  }
)

#===============================================================================
# Light and Heavy metal
#===============================================================================
Battle::AbilityEffects::SpeedCalc.add(:LIGHTMETAL,
  proc { |ability, battler, mult|
    next mult * 1.3 if Settings::MAG_LIGHTMETAL == true
  }
)

Battle::AbilityEffects::SpeedCalc.add(:HEAVYMETAL,
  proc { |ability, battler, mult|
    next mult / 1.15 if Settings::MAG_HEAVYMETAL == true
  }
)

Battle::AbilityEffects::DamageCalcFromTarget.add(:HEAVYMETAL,
  proc { |ability, user, target, move, mults, power, type|
    mults[:power_multiplier] /= 1.5 if [:FIGHTING].include?(type) && Settings::MAG_HEAVYMETAL == true
  }
)

#===============================================================================
# Klutz
#===============================================================================
Battle::AbilityEffects::AccuracyCalcFromTarget.add(:KLUTZ,
  proc { |ability, mods, user, target, move, type|
    mods[:evasion_multiplier] *= 1.25 if target.item && Settings::MAG_KLUTZ == true
  }
)
#===============================================================================
# Forecast
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:FORECAST,
  proc { |ability, battler, battle, switch_in|
    battle.pbStartWeatherAbility(:Sun, battler)  if battler.item == :HEATROCK && Settings::MAG_FORECAST == true
	battle.pbStartWeatherAbility(:Rain, battler) if battler.item == :DAMPROCK && Settings::MAG_FORECAST == true
	battle.pbStartWeatherAbility(:Hail, battler) if battler.item == :ICYROCK  && Settings::MAG_FORECAST == true
  }
)

#===============================================================================
# Sticky Hold
#===============================================================================
Battle::AbilityEffects::TrappingByTarget.add(:STICKYHOLD,
  proc { |ability, switcher, bearer, battle|
    next true if !switcher.pbHasType?(:WATER) && Settings::MAG_STICKYHOLD == true
  }
)

#===============================================================================
# Anticipation
#===============================================================================
Battle::AbilityEffects::PriorityBracketChange.copy(:QUICKDRAW, :ANTICIPATION) if Settings::MAG_ANTICIPATION == 1
Battle::AbilityEffects::PriorityBracketUse.copy(:QUICKDRAW, :ANTICIPATION)    if Settings::MAG_ANTICIPATION == 1

Battle::AbilityEffects::OnSwitchIn.add(:DAUNTLESSSHIELD,
  proc { |ability, battler, battle, switch_in|
    next if Settings::MAG_ANTICIPATION == 2 && battler.ability_triggered?
    battler.pbRaiseStatStageByAbility(:SPEED, 1, battler)
    battle.pbSetAbilityTrigger(battler)
  }
)
#===============================================================================

#===============================================================================
# Good as Gold
#===============================================================================
Battle::AbilityEffects::MoveImmunity.add(:GOODASGOLD,
  proc { |ability, user, target, move, type, battle, show_message|
    next false if !move.statusMove?
    next false if user.index == target.index
	next if battler.ability_triggered?
    if show_message
      battle.pbShowAbilitySplash(target)
      if Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
      else
        battle.pbDisplay(_INTL("{1}'s {2} blocks {3}!",
           target.pbThis, target.abilityName, move.name))
      end
      battle.pbHideAbilitySplash(target)
	  if Settings::MAG_GOODASGOLD == true
	  battle.pbSetAbilityTrigger(battler)
	  end
    end
    next true
  }
)

#===============================================================================
# Teravolt
# Adds the Electric-Type if the user doesn't have it
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:TERAVOLT,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    if Settings::MAG_TERAVOLT == true && !battler.pbHasType?(:ELECTRIC)
    battler.effects[PBEffects::ExtraType] = :ELECTRIC
    typeName = GameData::Type.get(:ELECTRIC).name
    battle.pbDisplay(_INTL("{1} is radiating a bursting aura, gaining the {2} type!", battler.pbThis, typeName))
	else
    battle.pbDisplay(_INTL("{1} is radiating a bursting aura!", battler.pbThis))
	end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# Turboblaze
# Adds the Fire-Type if the user doesn't have it
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:TURBOBLAZE,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    if Settings::MAG_TURBOBLAZE == true && !battler.pbHasType?(:FIRE)
    battler.effects[PBEffects::ExtraType] = :FIRE
    typeName = GameData::Type.get(:FIRE).name
    battle.pbDisplay(_INTL("{1} is radiating a blazing aura, gaining the {2} type!", battler.pbThis, typeName))
	else
    battle.pbDisplay(_INTL("{1} is radiating a blazing aura!", battler.pbThis))
	end
    battle.pbHideAbilitySplash(battler)
  }
)

#===============================================================================
# Shell Armor
# Takes half damage from bomb moves
#===============================================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:SHELLARMOR,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if move.bombMove? && Settings::MAG_SHELLARMOR == true
  }
)

#===============================================================================
# Battle Armor
# Takes half damage from slicing moves
#===============================================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:SHELLARMOR,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if move.slicingMove? && Settings::MAG_BATTLEARMOR == true
  }
)

#===============================================================================
# Stench
# Chance to poison on hitting target 
#===============================================================================
Battle::AbilityEffects::OnDealingHit.add(:STENCH,
  proc { |ability, user, target, move, battle|
    next if Settings::MAG_STENCH == false
    next if target.fainted?
    next if battle.pbRandom(100) >= 30
    next if target.hasActiveItem?(:COVERTCLOAK)
    battle.pbShowAbilitySplash(user)
    if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
      battle.pbShowAbilitySplash(target)
      if !Battle::Scene::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
      end
      battle.pbHideAbilitySplash(target)
    elsif target.pbCanPoison?(user, Battle::Scene::USE_ABILITY_SPLASH)
      msg = nil
      if !Battle::Scene::USE_ABILITY_SPLASH
        msg = _INTL("{1} was poisoned!", target.pbThis)
      end
      target.pbPoison(user, msg)
    end
    battle.pbHideAbilitySplash(user)
  }
)

#===============================================================================
	# Monkey Business
	# Boosts special moves but locks in one move.
#===============================================================================
Battle::AbilityEffects::StatusCheckNonIgnorable.add(:TRUANT,
  proc { |ability, battler, status|
   if Settings::MAG_TRUANT == true
    next true if status.nil? || status == :SLEEP
   end
  }
)

Battle::AbilityEffects::StatusImmunityNonIgnorable.add(:TRUANT,
  proc { |ability, battler, status|
   if Settings::MAG_TRUANT == true
    next true if battler.isSpecies?(:SLAKOTH) || battler.isSpecies?(:SLAKING) || battler.isSpecies?(:DURANT)
   end
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:TRUANT,
  proc { |ability, battler, battle, switch_in|
   if Settings::MAG_TRUANT == true
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} is drowsing!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
   end
  }
)

#===============================================================================
# Magma Armor
# Takes half damage from Water type moves
#===============================================================================
Battle::AbilityEffects::DamageCalcFromTarget.add(:MAGMAARMOR,
  proc { |ability, user, target, move, mults, power, type|
    mults[:final_damage_multiplier] /= 2 if move.calcType == :WATER && Settings::MAG_MAGMAARMOR == true
  }
)
end