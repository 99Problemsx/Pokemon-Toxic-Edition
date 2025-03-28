#===============================================================================
# * Easy Charm / Hard Charm
#===============================================================================

def pbWildDifficultyCharms(pkmn)
  extra_level = 0
  extra_level = LinCharmConfig::EASY_LEVEL if $player.activeCharm?(:EASYCHARM)
  extra_level = LinCharmConfig::HARD_LEVEL if $player.activeCharm?(:HARDCHARM)
  level = pkmn.level
  level += extra_level
  level = level.clamp(1, GameData::GrowthRate.max_level)
  pkmn.level = level
  pkmn.calc_stats
end

EventHandlers.add(:on_trainer_load, :easy_hard_charms,
  proc { |trainer|
    extra_level = 0
    extra_level = LinCharmConfig::EASY_LEVEL if $player.activeCharm?(:EASYCHARM)
    extra_level = LinCharmConfig::HARD_LEVEL if $player.activeCharm?(:HARDCHARM)
    if trainer
      for pokemon in trainer.party do
        isShiny = pokemon.shiny?
        level = pokemon.level
        level += extra_level
        level = level.clamp(1, GameData::GrowthRate.max_level)
        pokemon.level = level
        pokemon.shiny = true if isShiny
        pokemon.calc_stats
      end
    end
    if LinCharmConfig::EXTRA_POKEMON && !$player.activeCharm?(:HARDCHARM)
      position = trainer.party.length - 1 - LinCharmConfig::POKEMON_POSITION
      trainer.remove_pokemon_at_index(position)
    end
  }
)