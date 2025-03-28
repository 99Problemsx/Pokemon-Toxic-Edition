class Battle
alias mag_pbEntryHazards pbEntryHazards
  def pbEntryHazards(battler)
    battler_side = battler.pbOwnSide
	# Restictive Winds
    if battler_side.effects[PBEffects::RestictiveWinds] && !battler.fainted? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS) && battler.airborne?
      pbDisplay(_INTL("{1} is struggling agaisnt the restrictive winds!", battler.pbThis))
	    battler.effects[PBEffects::SmackDown] = true
	  pbDisplay(_INTL("{1} fell straight down!", battler.pbThis))
      if battler.pbCanLowerStatStage?(:EVASION) && !battler.airborne? && Settings::MAG_RESTRICTIVEWINDS == true
        battler.pbLowerStatStage(:EVASION, 1, nil)
        battler.pbItemStatRestoreCheck
       end
     end
    # Toxic Spikes
    if battler_side.effects[PBEffects::ToxicSpikes] > 0 && !battler.fainted? && !battler.airborne?
	  if battler.pbHasType?(:POISON)
        battler_side.effects[PBEffects::ToxicSpikes] = 0
        pbDisplay(_INTL("{1} absorbed the poison spikes!", battler.pbThis))
      elsif battler.pbCanPoison?(nil, false) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS) && !battler.hasActiveAbility?(:POISONABSORB)
        if battler_side.effects[PBEffects::ToxicSpikes] == 2
          battler.pbPoison(nil, _INTL("{1} was badly poisoned by the poison spikes!", battler.pbThis), true)
        else
          battler.pbPoison(nil, _INTL("{1} was poisoned by the poison spikes!", battler.pbThis))
        end
      end
	end
	 # Haunted Orbs
    if battler_side.effects[PBEffects::HauntedOrbs] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      pbDisplay(_INTL("A haunted orb attacked {1}!", battler.pbThis))
      if battler.pbCanLowerStatStage?(:SPECIAL_DEFENSE)
        battler.pbLowerStatStage(:SPECIAL_DEFENSE, 1, nil)
        battler.pbItemStatRestoreCheck
		mag_pbEntryHazards(battler)
       end
     end
    # Sharp Steel
    if battler_side.effects[PBEffects::SharpSteel] && battler.takesIndirectDamage? &&
       GameData::Type.exists?(:STEEL) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      bTypes = battler.pbTypes(true)
      eff = Effectiveness.calculate(:STEEL, *bTypes)
      if !Effectiveness.ineffective?(eff)
        battler.pbReduceHP(battler.totalhp * eff / 8, false)
        pbDisplay(_INTL("The sharp steel dug into {1}!", battler.pbThis))
        battler.pbItemHPHealCheck
      end
    end
	 # Burning Debris
    if battler_side.effects[PBEffects::BurningDebris] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS) && !battler.hasActiveAbility?(:FLASHFIRE) && battler.pbCanBurn?(nil, false)
	   battler.pbBurn(nil, _INTL("{1} was burnt by the smouldering rocks!", battler.pbThis))
    end
    # Water Channel
    if battler_side.effects[PBEffects::WaterChannel] && battler.takesIndirectDamage? &&
       GameData::Type.exists?(:WATER) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS) &&
	   !battler.hasActiveAbility?(:WATERABSORB) && !battler.hasActiveAbility?(:STORMDRAIN) && !battler.hasActiveAbility?(:DRYSKIN)
      bTypes = battler.pbTypes(true)
      eff = Effectiveness.calculate(:WATER, *bTypes)
      if !Effectiveness.ineffective?(eff)
        battler.pbReduceHP(battler.totalhp * eff / 8, false)
        pbDisplay(_INTL("A rough wave crashed into {1}!", battler.pbThis))
        battler.pbItemHPHealCheck
      end
    end
	 # Proton Overload
    if battler_side.effects[PBEffects::ProtonOverload] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS) && battler.pbCanParalyze?(nil, false) &&
	   !battler.hasActiveAbility?(:VOLTABSORB) && !battler.hasActiveAbility?(:LIGHTNINGROD)
	   battler.pbParalyze(nil, _INTL("{1} was paralyzed by the energized field!", battler.pbThis))
    end
    # Mind Field
    if battler_side.effects[PBEffects::MindField] && battler.takesIndirectDamage? &&
       GameData::Type.exists?(:PSYCHIC) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      bTypes = battler.pbTypes(true)
      eff = Effectiveness.calculate(:PSYCHIC, *bTypes)
      if !Effectiveness.ineffective?(eff)
        battler.pbReduceHP(battler.totalhp * eff / 8, false)
        pbDisplay(_INTL("{1} was hit by a mind bomb!", battler.pbThis))
        battler.pbItemHPHealCheck
      end
    end
	 # Ice Ring
    if battler_side.effects[PBEffects::IceRing] && !battler.fainted? && !battler.airborne?
      if battler.pbHasType?(:ICE)
        pbDisplay(_INTL("{1} can freely move around on the ice!", battler.pbThis))      
	 elsif !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      pbDisplay(_INTL("{1} slipped on the ice!", battler.pbThis))
      if battler.pbCanLowerStatStage?(:DEFENSE)
        battler.pbLowerStatStage(:DEFENSE, 1, nil)
        battler.pbItemStatRestoreCheck
		mag_pbEntryHazards(battler)
       end
     end
  end
    # Draconic Rift
    if battler_side.effects[PBEffects::DraconicRift] && battler.takesIndirectDamage?
	 if battler.pbHasType?(:FAIRY)
        battler_side.effects[PBEffects::DraconicRift] = false
        pbDisplay(_INTL("{1} sealed up the Dragon Force!", battler.pbThis))
    elsif GameData::Type.exists?(:DRAGON) && !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      bTypes = battler.pbTypes(true)
      eff = Effectiveness.calculate(:DRAGON, *bTypes)
      if !Effectiveness.ineffective?(eff)
        battler.pbReduceHP(battler.totalhp * eff / 6, false)
        pbDisplay(_INTL("{1} was hurt by the Dragon Force!", battler.pbThis))
        battler.pbItemHPHealCheck
      end
    end
 end
	 # Dark Mist
    if battler_side.effects[PBEffects::DarkMist] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      pbDisplay(_INTL("The smog crawled up and scared {1}!", battler.pbThis))
      if battler.pbCanLowerStatStage?(:ATTACK)
        battler.pbLowerStatStage(:ATTACK, 1, nil)
        battler.pbItemStatRestoreCheck
       end
     end
	 # Mana Flux
    if battler_side.effects[PBEffects::ManaFlux] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
      pbDisplay(_INTL("{1} was disrupted by the magic!", battler.pbThis))
      if battler.pbCanLowerStatStage?(:SPECIAL_ATTACK)
        battler.pbLowerStatStage(:SPECIAL_ATTACK, 1, nil)
        battler.pbItemStatRestoreCheck
		mag_pbEntryHazards(battler)
       end
     end
	 # Miasma
    if battler_side.effects[PBEffects::Miasma] && !battler.fainted? && !battler.airborne? &&
       !battler.hasActiveItem?(:HEAVYDUTYBOOTS)
	   effect = pbRandom(3)
	   if battler.pbCanBurn?(nil, false) && effect == 0
	   battler.pbBurn(nil, _INTL("{1} was burnt by the magical miasma!", battler.pbThis))
	   end
	   if battler.pbCanParalyze?(nil, false) && effect == 1
	   battler.pbParalyze(nil, _INTL("{1} was paralyzed by the magical miasma!", battler.pbThis))
	   end
	   if battler.pbCanPoison?(nil, false) && effect == 2
	   battler.pbPoison(nil, _INTL("{1} was poisoned by the magical miasma!", battler.pbThis))
	   end
	   if battler.pbCanFreeze?(nil, false) && effect == 3
	   battler.pbFreeze(nil, _INTL("{1} was poisoned by the magical miasma!", battler.pbThis))
	   end
    end
  end
end