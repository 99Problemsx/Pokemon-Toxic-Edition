#===============================================================================
#
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :roamPosition
  attr_accessor :roamedAlready   # Whether a roamer has been encountered on current map
  attr_accessor :roamEncounter
  attr_accessor :roamPokemon
  attr_writer   :roamPokemonCaught

  def roamPokemonCaught
    @roamPokemonCaught = [] if !@roamPokemonCaught
    return @roamPokemonCaught
  end
end

#===============================================================================
# Making roaming Pokémon roam around.
#===============================================================================
def each_active_roamer(ignore_caught = true)
  Settings::ROAMING_SPECIES.each_with_index do |roamer, i|
    next if !GameData::Species.exists?(roamer[:species])
    next if roamer[:game_switch] && roamer[:game_switch] > 0 && !$game_switches[roamer[:game_switch]]
    next if ignore_caught && $PokemonGlobal.roamPokemon[i] == true   # Has been caught
    yield roamer, i
  end
end

# Resets all roaming Pokemon that were defeated without having been caught.
def pbResetAllRoamers
  return if !$PokemonGlobal.roamPokemon
  $PokemonGlobal.roamPokemon.length.times do |i|
    next if $PokemonGlobal.roamPokemon[i] != true || $PokemonGlobal.roamPokemonCaught[i]
    $PokemonGlobal.roamPokemon[i] = nil
  end
end

# Gets the roaming areas for a particular Pokémon.
def pbRoamingAreas(idxRoamer)
  # [species ID, level, Game Switch, encounter type, battle BGM, area maps hash]
  roamData = Settings::ROAMING_SPECIES[idxRoamer]
  return roamData[:areas] if roamData && roamData[:areas]
  return Settings::ROAMING_AREAS
end

# Puts a roamer in a completely random map available to it.
def pbRandomRoam(index)
  return if !$PokemonGlobal.roamPosition
  keys = pbRoamingAreas(index).keys
  $PokemonGlobal.roamPosition[index] = keys[rand(keys.length)]
end

# Makes all roaming Pokémon roam to another map.
def pbRoamPokemon
  $PokemonGlobal.roamPokemon = [] if !$PokemonGlobal.roamPokemon
  # Start all roamers off in random maps
  if !$PokemonGlobal.roamPosition
    $PokemonGlobal.roamPosition = {}
    Settings::ROAMING_SPECIES.each_with_index do |roamer, i|
      next if !GameData::Species.exists?(roamer[:species])
      keys = pbRoamingAreas(i).keys
      $PokemonGlobal.roamPosition[i] = keys[rand(keys.length)]
    end
  end
  # Roam each Pokémon in turn
  Settings::ROAMING_SPECIES.length.times do |i|
    pbRoamPokemonOne(i)
  end
end

# Makes a single roaming Pokémon roam to another map. Doesn't roam if it isn't
# currently possible to encounter it (i.e. its Game Switch is off).
def pbRoamPokemonOne(idxRoamer)
  roamer = Settings::ROAMING_SPECIES[idxRoamer]
  return if !GameData::Species.exists?(roamer[:species])
  return if roamer[:game_switch] && roamer[:game_switch] > 0 && !$game_switches[roamer[:game_switch]]
  # Get hash of area patrolled by the roaming Pokémon
  mapIDs = pbRoamingAreas(idxRoamer).keys
  return if !mapIDs || mapIDs.length == 0   # No roaming area defined somehow
  # Get the roaming Pokémon's current map
  currentMap = $PokemonGlobal.roamPosition[idxRoamer]
  if !currentMap
    currentMap = mapIDs[rand(mapIDs.length)]
    $PokemonGlobal.roamPosition[idxRoamer] = currentMap
  end
  # Make an array of all possible maps the roaming Pokémon could roam to
  newMapChoices = []
  nextMaps = pbRoamingAreas(idxRoamer)[currentMap]
  return if !nextMaps
  nextMaps.each { |map| newMapChoices.push(map) }
  # Rarely, add a random possible map into the mix
  newMapChoices.push(mapIDs.sample) if rand(32) == 0
  # Choose a random new map to roam to
  if newMapChoices.length > 0
    $PokemonGlobal.roamPosition[idxRoamer] = newMapChoices.sample
  end
end

# When the player moves to a new map (with a different name), make all roaming
# Pokémon roam.
EventHandlers.add(:on_enter_map, :move_roaming_pokemon,
  proc { |old_map_id|
    # Get and compare map names
    mapInfos = pbLoadMapInfos
    next if mapInfos && old_map_id > 0 && mapInfos[old_map_id] &&
            mapInfos[old_map_id].name && $game_map.name == mapInfos[old_map_id].name
    # Make roaming Pokémon roam
    pbRoamPokemon
    $PokemonGlobal.roamedAlready = false
  }
)

#===============================================================================
# Encountering a roaming Pokémon in a wild battle.
#===============================================================================
class Game_Temp
  attr_accessor :roamer_index_for_encounter   # Index of roaming Pokémon to encounter next
end

#===============================================================================
#
#===============================================================================
# Returns whether the given category of encounter contains the actual encounter
# method that will occur in the player's current position.
def pbRoamingMethodAllowed(roamer_method)
  enc_type = $PokemonEncounters.encounter_type
  type = GameData::EncounterType.get(enc_type).type
  case roamer_method
  when :all   # Any step-triggered method (except Bug Contest)
    return [:land, :cave, :water].include?(type)
  when :land   # Walking (except Bug Contest)
    return [:land, :cave].include?(type)
  when :water   # Surfing or rishing
    return [:water, :fishing].include?(type)
  when :surfing   # Surfing
    return type == :water
  when :fishing   # Fishing
    return type == :fishing
  end
  return false
end

EventHandlers.add(:on_wild_species_chosen, :roaming_pokemon,
  proc { |encounter|
    $game_temp.roamer_index_for_encounter = nil
    next if !encounter
    # Give the regular encounter if encountering a roaming Pokémon isn't possible
    next if $PokemonGlobal.roamedAlready
    next if $PokemonGlobal.partner
    next if $game_temp.poke_radar_data
    next if rand(100) < 75   # 25% chance of encountering a roaming Pokémon
    # Look at each roaming Pokémon in turn and decide whether it's possible to
    # encounter it
    currentRegion = pbGetCurrentRegion
    currentMapName = $game_map.name
    possible_roamers = []
    each_active_roamer do |roamer, i|
      # Get the roamer's current map
      roamerMap = $PokemonGlobal.roamPosition[i]
      if !roamerMap
        mapIDs = pbRoamingAreas(i).keys   # Hash of area patrolled by the roaming Pokémon
        next if !mapIDs || mapIDs.length == 0   # No roaming area defined somehow
        roamerMap = mapIDs[rand(mapIDs.length)]
        $PokemonGlobal.roamPosition[i] = roamerMap
      end
      # If roamer isn't on the current map, check if it's on a map with the same
      # name and in the same region
      if roamerMap != $game_map.map_id
        map_metadata = GameData::MapMetadata.try_get(roamerMap)
        next if !map_metadata || !map_metadata.town_map_position ||
                map_metadata.town_map_position[0] != currentRegion
        next if pbGetMapNameFromId(roamerMap) != currentMapName
      end
      # Check whether the roamer's roamer method is currently possible
      next if !pbRoamingMethodAllowed(roamer[:encounter_type])
      # Add this roaming Pokémon to the list of possible roaming Pokémon to encounter
      possible_roamers.push([i, roamer[:species], roamer[:level], roamer[:bgm]])
    end
    # No encounterable roaming Pokémon were found, just have the regular encounter
    next if possible_roamers.length == 0
    # Pick a roaming Pokémon to encounter out of those available
    roamer = possible_roamers.sample
    $PokemonGlobal.roamEncounter = roamer
    $game_temp.roamer_index_for_encounter = roamer[0]
    $PokemonGlobal.nextBattleBGM = roamer[3] if roamer[3] && !roamer[3].empty?
    $game_temp.force_single_battle = true
    encounter[0] = roamer[1]   # Species
    encounter[1] = roamer[2]   # Level
  }
)

EventHandlers.add(:on_calling_wild_battle, :roaming_pokemon,
  proc { |pkmn, handled|
    # handled is an array: [nil]. If [true] or [false], the battle has already
    # been overridden (the boolean is its outcome), so don't do anything that
    # would override it again
    next if !handled[0].nil?
    next if !$PokemonGlobal.roamEncounter || $game_temp.roamer_index_for_encounter.nil?
    handled[0] = pbRoamingPokemonBattle(pkmn)
  }
)

def pbRoamingPokemonBattle(pkmn, level = 1)
  # Get the roaming Pokémon to encounter; generate it based on the species and
  # level if it doesn't already exist
  idxRoamer = $game_temp.roamer_index_for_encounter
  if !$PokemonGlobal.roamPokemon[idxRoamer] ||
     !$PokemonGlobal.roamPokemon[idxRoamer].is_a?(Pokemon)
    if pkmn.is_a?(Pokemon)
      $PokemonGlobal.roamPokemon[idxRoamer] = pbGenerateWildPokemon(pkmn.species_data.id, pkmn.level, true)
    else
      $PokemonGlobal.roamPokemon[idxRoamer] = pbGenerateWildPokemon(pkmn, level, true)
    end
  end
  # Set some battle rules
  setBattleRule("single")
  setBattleRule("roamerFlees")
  # Perform the battle
  outcome = WildBattle.start_core($PokemonGlobal.roamPokemon[idxRoamer])
  # Update Roaming Pokémon data based on result of battle
  if [Battle::Outcome::WIN, Battle::Outcome::CATCH].include?(outcome)   # Defeated or caught
    $PokemonGlobal.roamPokemon[idxRoamer]       = true
    $PokemonGlobal.roamPokemonCaught[idxRoamer] = (outcome == Battle::Outcome::CATCH)
  end
  $PokemonGlobal.roamEncounter = nil
  $PokemonGlobal.roamedAlready = true
  $game_temp.roamer_index_for_encounter = nil
  # Used by the Poké Radar to update/break the chain
  EventHandlers.trigger(:on_wild_battle_end, pkmn.species_data.id, pkmn.level, outcome)
  # Return false if the player lost or drew the battle, and true if any other result
  return !Battle::Outcome.should_black_out?(outcome)
end
