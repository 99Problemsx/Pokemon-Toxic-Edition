#-------------------------------------------------------------------------------
# Force nickname for any newly obtained Pokemon
#-------------------------------------------------------------------------------
alias __challenge__pbEnterPokemonName pbEnterPokemonName unless defined?(__challenge__pbEnterPokemonName)
def pbEnterPokemonName(*args)
  return __challenge__pbEnterPokemonName(*args) if !ChallengeModes.on?(:FORCE_NICKNAME)
  species_name = args[4].nil? ? args[3] : args[4].speciesName
  ret = ""
  loop do
    ret = __challenge__pbEnterPokemonName(*args)
    if ret.nil? || ret.empty? || ret.downcase == species_name.downcase
      rule_name = _INTL(ChallengeModes::RULES[:FORCE_NICKNAME][:name])
      pbMessage(_INTL("The \"{1}\" rule makes it mandatory to nickname your Pokémon!", rule_name))
      next
    end
    break
  end
  return ret
end

alias __challenge__pbNickname pbNickname unless defined?(__challenge__pbNickname)
def pbNickname(pkmn)
  return if $PokemonSystem.givenicknames != 0
  species_name = pkmn.speciesName
  if ChallengeModes.on?(:FORCE_NICKNAME) ||
     pbConfirmMessage(_INTL("Would you like to give a nickname to {1}?", species_name))
    pkmn.name = pbEnterPokemonName(_INTL("{1}'s nickname?", species_name),
                                   0, Pokemon::MAX_NAME_SIZE, "", pkmn)
  end
end

class Battle
  alias __challenge__pbStorePokemon pbStorePokemon unless method_defined?(:__challenge__pbStorePokemon)
  def pbStorePokemon(*args)
    return __challenge__pbStorePokemon(*args) if !ChallengeModes.on?(:FORCE_NICKNAME)
    pkmn = args[0]
    if !pkmn.shadowPokemon?
      nickname = @scene.pbNameEntry(_INTL("{1}'s nickname?", pkmn.speciesName), pkmn)
      pkmn.name = nickname
    end
    $PokemonSystem.givenicknames = 1
    ret = __challenge__pbStorePokemon(*args)
    $PokemonSystem.givenicknames = 0
    return ret
  end
end

alias __challenge__pbPurify pbPurify unless defined?(__challenge__pbPurify)
def pbPurify(*args)
  return __challenge__pbPurify(*args) if !ChallengeModes.on?(:FORCE_NICKNAME)
  $PokemonSystem.givenicknames = 1
  ret = __challenge__pbPurify(*args)
  pkmn = args[0]
  newname = pbEnterPokemonName(_INTL("{1}'s nickname?", pkmn.speciesName),
                                 0, Pokemon::MAX_NAME_SIZE, "", pkmn)
  pkmn.name = newname
  $PokemonSystem.givenicknames = 0
  return ret
end

class PokemonEggHatch_Scene
  alias __challenge__pbMain pbMain unless method_defined?(:__challenge__pbMain)
  def pbMain(*args)
    return __challenge__pbMain if !ChallengeModes.on?(:FORCE_NICKNAME)
    $PokemonSystem.givenicknames = 1
    ret = __challenge__pbMain(*args)
    $PokemonSystem.givenicknames = 0
    nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", @pokemon.name),
                                    0, Pokemon::MAX_NAME_SIZE, "", @pokemon, true)
    @pokemon.name = nickname
    @nicknamed = true
    return ret
  end
end

#-------------------------------------------------------------------------------
# Force set battle style in battle
#-------------------------------------------------------------------------------
MenuHandlers.remove(:options_menu, :battle_style)
MenuHandlers.remove(:options_menu, :give_nicknames)

MenuHandlers.add(:options_menu, :battle_style, {
  "name"        => _INTL("Battle Style"),
  "order"       => 50,
  "type"        => EnumOption,
  "condition"   => proc { next !ChallengeModes.on?(:FORCE_SET_BATTLES) },
  "parameters"  => [_INTL("Switch"), _INTL("Set")],
  "description" => _INTL("Choose whether you can switch Pokémon when an opponent's Pokémon faints."),
  "get_proc"    => proc { next $PokemonSystem.battlestyle },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.battlestyle = value }
})

MenuHandlers.add(:options_menu, :give_nicknames, {
  "name"        => _INTL("Give Nicknames"),
  "order"       => 80,
  "type"        => EnumOption,
  "condition"   => proc { next !ChallengeModes.on?(:FORCE_NICKNAME) },
  "parameters"  => [_INTL("Give"), _INTL("Don't give")],
  "description" => _INTL("Choose whether you can give a nickname to a Pokémon when you obtain it."),
  "get_proc"    => proc { next $PokemonSystem.givenicknames },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.givenicknames = value }
})

#-------------------------------------------------------------------------------
# Prevent item usage in trainer battles
#-------------------------------------------------------------------------------
class Battle::Scene
  alias __challenge__pbItemMenu pbItemMenu unless method_defined?(:__challenge__pbItemMenu)
  def pbItemMenu(*args, &block)
    if ChallengeModes.on?(:NO_TRAINER_BATTLE_ITEMS) && @battle.trainerBattle?
      rule_name = _INTL(ChallengeModes::RULES[:NO_TRAINER_BATTLE_ITEMS][:name])
      pbSEStop
      pbSEPlay("GUI sel buzzer")
      pbDisplayPausedMessage(_INTL("The \"{1}\" rule prevents item usage in Trainer Battles!", rule_name))
      return [0, -1]
    end
    return __challenge__pbItemMenu(*args, &block)
  end
end

#-------------------------------------------------------------------------------
# Various data to be stored related to challenge modes
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
  attr_accessor :challenge_qued
  attr_accessor :challenge_started
  attr_accessor :challenge_rules
  attr_accessor :challenge_encs

  attr_writer :challenge_state

  def challenge_state
    @challenge_state = {} if !@challenge_state.is_a?(Hash)
    return @challenge_state
  end
end

