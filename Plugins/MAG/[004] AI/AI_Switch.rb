class Battle::AI

Battle::AI::Handlers::ShouldSwitch.add(:significant_eor_damage,
  proc { |battler, reserves, ai, battle|
    eor_damage = battler.rough_end_of_round_damage
    # Switch if battler will take significant EOR damage
    if eor_damage >= battler.hp / 2 || eor_damage >= battler.totalhp / 4
      PBDebug.log_ai("#{battler.name} wants to switch because it will take a lot of EOR damage")
      next true
    end
    # Switch to remove certain effects that cause the battler EOR damage
    if ai.trainer.high_skill? && eor_damage > 0
      if battler.effects[PBEffects::LeechSeed] >= 0 && ai.pbAIRandom(100) < 50
        PBDebug.log_ai("#{battler.name} wants to switch to get rid of its Leech Seed")
        next true
      end
      if battler.effects[PBEffects::Nightmare]
        PBDebug.log_ai("#{battler.name} wants to switch to get rid of its Nightmare")
        next true
      end
      if battler.effects[PBEffects::Curse]
        PBDebug.log_ai("#{battler.name} wants to switch to get rid of its Curse")
        next true
      end
      if battler.status == :POISON && battler.statusCount > 0 && !battler.has_active_ability?(:POISONHEAL)
        poison_damage = battler.totalhp / 8
        next_toxic_damage = battler.totalhp * (battler.effects[PBEffects::Toxic] + 1) / 16
        if (battler.hp <= next_toxic_damage && battler.hp > poison_damage) ||
           next_toxic_damage > poison_damage * 2
          PBDebug.log_ai("#{battler.name} wants to switch to reduce toxic to regular poisoning")
          next true
        end
      end
    end
    next false
  }
)

alias mag_rate_replacement_pokemon rate_replacement_pokemon
  def rate_replacement_pokemon(idxBattler, pkmn, score)
    pkmn_types = pkmn.types
    entry_hazard_damage = calculate_entry_hazard_damage(pkmn, idxBattler & 1)
    if !pkmn.hasItem?(:HEAVYDUTYBOOTS) && !pokemon_airborne?(pkmn)
      # Toxic Spikes
      if @user.pbOwnSide.effects[PBEffects::BurningDebris]
        score -= 20 if pokemon_can_be_burned?(pkmn)
      end
      if @user.pbOwnSide.effects[PBEffects::ProtonOverload]
        score -= 20 if pokemon_can_be_paralyzed?(pkmn)
      end	  
      # Haunted Orbs
      if @user.pbOwnSide.effects[PBEffects::HauntedOrbs]
        score -= 15
      end
	  # Ice Ring
      if @user.pbOwnSide.effects[PBEffects::IceRing]
        score -= 15
      end
	  # Dark Mist
      if @user.pbOwnSide.effects[PBEffects::DarkMist]
        score -= 15
      end
	  # Mana Flux
      if @user.pbOwnSide.effects[PBEffects::ManaFlux]
        score -= 15
      end
    end
    mag_rate_replacement_pokemon(idxBattler, pkmn, score)
    return score
  end

alias mag_calculate_entry_hazard_damage calculate_entry_hazard_damage
  def calculate_entry_hazard_damage(pkmn, side)
    ret = mag_calculate_entry_hazard_damage(pkmn, side)
   if pkmn.hasAbility?(:MAGICGUARD) || pkmn.hasItem?(:HEAVYDUTYBOOTS)
    # Stealth Rock
    if @battle.sides[side].effects[PBEffects::WaterChannel] && GameData::Type.exists?(:WATER)
      pkmn_types = pkmn.types
      eff = Effectiveness.calculate(:WATER, *pkmn_types)
      ret += pkmn.totalhp * eff / 8 if !Effectiveness.ineffective?(eff)
    end
    # Stealth Rock
    if @battle.sides[side].effects[PBEffects::RoseField] && GameData::Type.exists?(:GRASS)
      pkmn_types = pkmn.types
      eff = Effectiveness.calculate(:GRASS, *pkmn_types)
      ret += pkmn.totalhp * eff / 8 if !Effectiveness.ineffective?(eff)
    end
    # Stealth Rock
    if @battle.sides[side].effects[PBEffects::MindField] && GameData::Type.exists?(:PSYCHIC)
      pkmn_types = pkmn.types
      eff = Effectiveness.calculate(:PSYCHIC, *pkmn_types)
      ret += pkmn.totalhp * eff / 8 if !Effectiveness.ineffective?(eff)
    end
    # Stealth Rock
    if @battle.sides[side].effects[PBEffects::DraconicRift] && GameData::Type.exists?(:DRAGON)
      pkmn_types = pkmn.types
      eff = Effectiveness.calculate(:DRAGON, *pkmn_types)
      ret += pkmn.totalhp * eff / 8 if !Effectiveness.ineffective?(eff)
    end
  end
    return ret
  end
end