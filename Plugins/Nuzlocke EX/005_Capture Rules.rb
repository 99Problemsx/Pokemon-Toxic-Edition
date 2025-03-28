#-------------------------------------------------------------------------------
# One-Capture per route rule with shiny and dups clause
#-------------------------------------------------------------------------------
class Battle::Scene
  #-----------------------------------------------------------------------------
  # Flag map for encounter after first wild mon fainted
  #-----------------------------------------------------------------------------
  alias __challenge__pbFaintBattler pbFaintBattler unless method_defined?(:__challenge__pbFaintBattler)
  def pbFaintBattler(*args)
    return __challenge__pbFaintBattler(*args) if !ChallengeModes.on? || ChallengeModes.had_first_encounter? || @first_fainted
    ChallengeModes.set_first_encounter(args[0]) if !@battle.trainerBattle?
    @first_fainted = true
    return __challenge__pbFaintBattler(*args)
  end

  #-----------------------------------------------------------------------------
  # Flag map for encounter after battle ends
  #-----------------------------------------------------------------------------
  alias __challenge__pbEndBattle pbEndBattle unless method_defined?(:__challenge__pbEndBattle)
  def pbEndBattle(*args)
    ret = __challenge__pbEndBattle(*args)
    return ret if !ChallengeModes.on? || ChallengeModes.had_first_encounter? || @battle.trainerBattle?
    battler = nil
    @battle.battlers.each do |b|
      next if !b || !b.opposes? || !b.pokemon
      battler = b
      break
    end
    ChallengeModes.set_first_encounter(battler) if battler
    return ret
  end
end

class Battle
  #-----------------------------------------------------------------------------
  # Main Catch blocker system + flag map for encounter after Pokemon caught
  #-----------------------------------------------------------------------------
  alias __challenge__pbThrowPokeBall pbThrowPokeBall unless method_defined?(:__challenge__pbThrowPokeBall)
  def pbThrowPokeBall(*args)
    return __challenge__pbThrowPokeBall(*args) if !ChallengeModes.on?
    battler = nil
    if opposes?(args[0])
      battler = @battlers[args[0]]
    else
      battler = @battlers[args[0]].pbDirectOpposing(true)
    end
    battler = battler.allAllies.first if battler.fainted?
    caught   = @caughtPokemon.length
    owned_b4 = false
    old_ball = @first_poke_ball
    battler.pokemon.species_data.get_family_species.each { |pk| owned_b4 = true if $player.owned?(pk) }
    ret      = __challenge__pbThrowPokeBall(*args)
    # Flag for caught Pokemon for map
    ChallengeModes.set_first_encounter(battler, owned_b4) if [1, 4].include?(@decision) || @caughtPokemon.length != caught || @first_poke_ball != old_ball
    return ret
  end
end

ItemHandlers::CanUseInBattle.remove(:poke_balls)
ItemHandlers::CanUseInBattle.addIf(:poke_balls,
  proc { |item| GameData::Item.get(item).is_poke_ball? },
  proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    if battle.pbPlayer.party_full? && $PokemonStorage.full?
      scene.pbDisplay(_INTL("There is no room left in the PC!")) if showMessages
      next false
    end
    if battle.disablePokeBalls
      scene.pbDisplay(_INTL("You can't throw a Poké Ball!")) if showMessages
      next false
    end
    # NOTE: Using a Poké Ball consumes all your actions for the round. The code
    #       below is one half of making this happen; the other half is in def
    #       pbItemUsesAllActions?.
    if !firstAction
      scene.pbDisplay(_INTL("It's impossible to aim without being focused!")) if showMessages
      next false
    end
    if battler.semiInvulnerable?
      scene.pbDisplay(_INTL("It's no good! It's impossible to aim at a Pokémon that's not in sight!")) if showMessages
      next false
    end
    # NOTE: The code below stops you from throwing a Poké Ball if there is more
    #       than one unfainted opposing Pokémon. (Snag Balls can be thrown in
    #       this case, but only in trainer battles, and the trainer will deflect
    #       them if they are trying to catch a non-Shadow Pokémon.)
    if battle.pbOpposingBattlerCount > 1 && !(GameData::Item.get(item).is_snag_ball? && battle.trainerBattle?)
      if battle.pbOpposingBattlerCount == 2
        scene.pbDisplay(_INTL("It's no good! It's impossible to aim when there are two Pokémon!")) if showMessages
      elsif showMessages
        scene.pbDisplay(_INTL("It's no good! It's impossible to aim when there is more than one Pokémon!"))
      end
      next false
    end
    target = battler.opposes? ? battler : battler.pbDirectOpposing(true)
    target = target.allAllies.first if target.fainted?
    # Disable Pokeball throwing if already caught)
    if ChallengeModes.had_first_encounter?(target)
      if showMessages
        rule_name = _INTL(ChallengeModes::RULES[:ONE_CAPTURE][:name])
        pbSEStop
        pbMessage(_INTL("The \"{1}\" rule prevents you from catching a Pokémon on a map you already had an encounter on!", rule_name))
      end
      next false
    end
    next true
  }
)

#-------------------------------------------------------------------------------
# One-Capture per route rule for gift Pokemon
#-------------------------------------------------------------------------------
alias __challenge__pbAddPokemon pbAddPokemon unless defined?(__challenge__pbAddPokemon)
def pbAddPokemon(*args)
  return false if !args[0]
  pkmn = args[0]; level = args[1]
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  if ChallengeModes.had_first_encounter?(pkmn)
    rule_name = _INTL(ChallengeModes::RULES[:ONE_CAPTURE][:name])
    pbMessage(_INTL("The \"{1}\" rule prevents you from obtaining a Pokémon on a map you already had an encounter on!", rule_name))
    return false
  end
  ret = __challenge__pbAddPokemon(*args)
  ChallengeModes.set_first_encounter(pkmn) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbAddPokemonSilent pbAddPokemonSilent unless defined?(__challenge__pbAddPokemonSilent)
def pbAddPokemonSilent(*args)
  return false if !args[0]
  pkmn = args[0]; level = args[1]
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  return false if ChallengeModes.had_first_encounter?(pkmn)
  ret = __challenge__pbAddPokemonSilent(*args)
  ChallengeModes.set_first_encounter(pkmn) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbAddToParty pbAddToParty unless defined?(__challenge__pbAddToParty)
def pbAddToParty(*args)
  return false if !args[0]
  pkmn = args[0]; level = args[1]
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  if ChallengeModes.had_first_encounter?(pkmn)
    rule_name = _INTL(ChallengeModes::RULES[:ONE_CAPTURE][:name])
    pbMessage(_INTL("The \"{1}\" rule prevents you from obtaining a Pokémon on a map you already had an encounter on!", rule_name))
    return false
  end
  ret = __challenge__pbAddToParty(*args)
  ChallengeModes.set_first_encounter(pkmn) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbAddToPartySilent pbAddToPartySilent unless defined?(__challenge__pbAddToPartySilent)
def pbAddToPartySilent(*args)
  return false if !args[0]
  pkmn = args[0]; level = args[1]
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  return false if ChallengeModes.had_first_encounter?(pkmn)
  ret = __challenge__pbAddToPartySilent(*args)
  ChallengeModes.set_first_encounter(pkmn) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbAddForeignPokemon pbAddForeignPokemon unless defined?(__challenge__pbAddForeignPokemon)
def pbAddForeignPokemon(*args)
  return false if !args[0]
  pkmn = args[0]; level = args[1]
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  if ChallengeModes.had_first_encounter?(pkmn)
    rule_name = _INTL(ChallengeModes::RULES[:ONE_CAPTURE][:name])
    pbMessage(_INTL("The \"{1}\" rule prevents you from obtaining a Pokémon on a map you already had an encounter on!", rule_name))
    return false
  end
  ret = __challenge__pbAddForeignPokemon(*args)
  ChallengeModes.set_first_encounter(pkmn) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbGenerateEgg pbGenerateEgg unless defined?(__challenge__pbGenerateEgg)
def pbGenerateEgg(*args)
  return false if !args[0]
  args[0] = Pokemon.new(args[0], Settings::EGG_LEVEL) if !args[0].is_a?(Pokemon)
  if ChallengeModes.had_first_encounter?(args[0])
    rule_name = _INTL(ChallengeModes::RULES[:ONE_CAPTURE][:name])
    pbMessage(_INTL("The \"{1}\" rule prevents you from obtaining a Pokémon on a map you already had an encounter on!", rule_name))
    return false
  end
  ret = __challenge__pbGenerateEgg(*args)
  ChallengeModes.set_first_encounter(args[0]) if !ChallengeModes.on?(:GIFT_CLAUSE)
  return ret
end

alias __challenge__pbReceiveMysteryGift pbReceiveMysteryGift unless defined?(__challenge__pbReceiveMysteryGift)
def pbReceiveMysteryGift(*args)
  $mystery_gift = true
  ret = __challenge__pbReceiveMysteryGift(*args)
  $mystery_gift = false
  return ret
end

alias __challenge__pbDebugMenu pbDebugMenu unless defined?(__challenge__pbDebugMenu)
def pbDebugMenu(*args)
  $mystery_gift = true
  ret = __challenge__pbDebugMenu(*args)
  $mystery_gift = false
  return ret
end
