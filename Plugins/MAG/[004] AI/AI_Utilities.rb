class Battle::AI

  def pokemon_can_be_burned?(pkmn)
    # Check pkmn's immunity to being poisoned
    return false if @battle.field.terrain == :Misty
    return false if pkmn.hasType?(:FIRE)
    return false if pkmn.hasAbility?(:IMMUNITY)
    return false if pkmn.hasAbility?(:WATERBUBBLE)
    return false if pkmn.hasAbility?(:THERMALEXCHANGE)
    return false if pkmn.hasAbility?(:FLOWERVEIL) && pkmn.hasType?(:GRASS)
    return false if pkmn.hasAbility?(:LEAFGUARD) && [:Sun, :HarshSun].include?(@battle.pbWeather)
    return false if pkmn.hasAbility?(:COMATOSE) && pkmn.isSpecies?(:KOMALA)
    return false if pkmn.hasAbility?(:SHIELDSDOWN) && pkmn.isSpecies?(:MINIOR) && pkmn.form < 7
    return true
  end

  def pokemon_can_be_paralyzed?(pkmn)
    # Check pkmn's immunity to being poisoned
    return false if @battle.field.terrain == :Misty
    return false if pkmn.hasType?(:ELECTRIC)
    return false if pkmn.hasAbility?(:IMMUNITY)
    return false if pkmn.hasAbility?(:LIMBER)
    return false if pkmn.hasAbility?(:VOLTABSORB)
    return false if pkmn.hasAbility?(:LIGHTNINGROD)
    return false if pkmn.hasAbility?(:MOTORDRIVE)
    return false if pkmn.hasAbility?(:FLOWERVEIL) && pkmn.hasType?(:GRASS)
    return false if pkmn.hasAbility?(:LEAFGUARD) && [:Sun, :HarshSun].include?(@battle.pbWeather)
    return false if pkmn.hasAbility?(:COMATOSE) && pkmn.isSpecies?(:KOMALA)
    return false if pkmn.hasAbility?(:SHIELDSDOWN) && pkmn.isSpecies?(:MINIOR) && pkmn.form < 7
    return true
  end  
  
MAG_BASE_ABILITY_RATINGS = {
    9 => [:OVERWHELMINGFROST, :OVERWHELMINGVOLTAGE, :OVERWHELMINGBLAZE,
	      :STORMFRONT],
    8 => [:WARRIORDANCER, :SEADIVER, :CRYOHEALING],
    7 => [:CHLOROPLAST, :TANGLEDROOTS, :VAMPIRICFANG, :MENACING, :POISONABSORB],
    6 => [:JOAT, :EXTREMEFOCUS],
    4 => [:BONECHILL]
	

}

alias mag_pokemon_can_absorb_move? pokemon_can_absorb_move?
  def pokemon_can_absorb_move?(pkmn, move, move_type)
   mag_pokemon_can_absorb_move?(pkmn, move, move_type)
    return false if pkmn.is_a?(Battle::AI::AIBattler) && !pkmn.ability_active?
    # Check pkmn's ability
    # Anything with a Battle::AbilityEffects::MoveImmunity handler
    case pkmn.ability_id
    when :BULLETPROOF
      move_data = GameData::Move.get(move.id)
      return move_data.has_flag?("Bomb")
    when :FLASHFIRE
      return move_type == :FIRE
    when :LIGHTNINGROD, :MOTORDRIVE, :VOLTABSORB
      return move_type == :ELECTRIC
    when :POISONABSORB
      return move_type == :POISON
    when :SAPSIPPER
      return move_type == :GRASS
    when :SOUNDPROOF
      move_data = GameData::Move.get(move.id)
      return move_data.has_flag?("Sound")
    when :STORMDRAIN, :WATERABSORB, :DRYSKIN
      return move_type == :WATER
    when :TELEPATHY
      # NOTE: The move is being used by a foe of pkmn.
      return false
    when :WONDERGUARD
      types = pkmn.types
      types = pkmn.pbTypes(true) if pkmn.is_a?(Battle::AI::AIBattler)
      return !Effectiveness.super_effective_type?(move_type, *types)
    end
    return false
  end








end

#===============================================================================
# Hell's Blaze
#===============================================================================
Battle::AI::Handlers::AbilityRanking.add(:HELLSBLAZE,
  proc { |ability, score, battler, ai|
    next score if battler.check_for_move { |m| m.type == :FIRE }
    next 0
  }
)

#===============================================================================
# Pollen Blast
#===============================================================================
Battle::AI::Handlers::ItemRanking.add(:BIGROOT,
  proc { |item, score, battler, ai|
    next score if battler.check_for_move do |m|
      m.is_a?(Battle::Move::HealUserByHalfOfDamageDone) ||
      m.is_a?(Battle::Move::HealUserByHalfOfDamageDoneIfTargetAsleep) ||
      m.is_a?(Battle::Move::HealUserByThreeQuartersOfDamageDone) ||
      m.is_a?(Battle::Move::HealUserByTargetAttackLowerTargetAttack1) ||
      m.is_a?(Battle::Move::StartLeechSeedTarget) ||
	  m.is_a?(Battle::Move::LeechSeedGrassSpeed)
    end
    next 0
  }
)

#===============================================================================
# Dual Wield
#===============================================================================
Battle::AI::Handlers::AbilityRanking.add(:DUALWIELD,
  proc { |ability, score, battler, ai|
    next score if battler.check_for_move { |m| m.pulseMove? } || battler.check_for_move { |m| m.slicingMove? }
    next 0
  }
)