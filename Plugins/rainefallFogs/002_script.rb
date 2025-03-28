# =============================================================================
#   Map Overlays are per map and do not repeat
#   They are intended for use in place of fogs for lighting effects
# =============================================================================

class Bitmap
  # Returns Bitmap or nil if the requested bitmap does not exist
  def self.try_load(path)
    real_path = pbResolveBitmap(path)
    return nil if real_path.nil?
    return self.new(real_path)
  end
end

class Spriteset_Map

  attr_reader :overlay

  alias _init_map_overlays initialize
  alias _update_map_overlays update
  alias _dispose_map_overlays dispose

  def initialize(map = nil)
    map ||= $game_map
    @overlay_bitmaps = [nil,nil]
    @overlay_bitmaps[0] = Bitmap.try_load("Graphics/Fogs/Overlays/#{map.map_id}")
    @overlay_bitmaps[1] = Bitmap.try_load("Graphics/Fogs/Overlays/#{map.map_id}_n")
    @overlay = Sprite.new(@@viewport1)
    @overlay.zoom_x = 2
    @overlay.zoom_y = 2
    @overlay.z = 2500
    @overlay.opacity = (!RfSettings::ADD_FOGS_TO_SETTINGS) || $PokemonSystem.disable_fogs&.zero? ? 255 : RfSettings::SETTINGS_MAP_OVERLAY_OPACITY
    @overlay.blend_type = (RfSettings::OVERLAY_ADDITIVE_MAPS.include? map.map_id) ? 1 : 0
    @overlay.bitmap = get_overlay_bitmap
    _init_map_overlays(map)
    # It would be better to just remove @fog entirely but we can't guarantee Spriteset_Map does not get modified
    @fog.visible = false
  end

  def get_overlay_bitmap
    ret = @overlay_bitmaps[1] if PBDayNight.isNight?
    ret = @overlay_bitmaps[0] if ret.nil?
    return ret
  end

  def update
    _update_map_overlays
    @overlay.bitmap = get_overlay_bitmap
    @overlay.x = -(@map.display_x / Game_Map::X_SUBPIXELS).round
    @overlay.y = -(@map.display_y / Game_Map::Y_SUBPIXELS).round
  end

  def dispose
    _dispose_map_overlays
    @overlay.dispose
  end
end

# =============================================================================
#   Fogs have been moved to Spriteset_Global ensuring there will only ever
#   be one fog in existence
#
#   This also implements Global Overlays, which are static images displayed
#   above everything else for vignette, static sunbeams etc
# =============================================================================
class Spriteset_Global
  alias _init_map_overlays initialize
  alias _update_map_overlays update
  alias _dispose_map_overlays dispose

  attr_reader :fog, :overlay

  def initialize
    @fog = AnimatedPlane.new(Spriteset_Map.viewport)
    @fog.opacity = 64
    @fog.z = 3000
    @fog.visible = $PokemonSystem.disable_fogs&.zero? if RfSettings::ADD_FOGS_TO_SETTINGS && RfSettings::SETTINGS_AFFECT_FOGS

    @overlay = Sprite.new(Spriteset_Map.viewport)
    @overlay.z = 3500
    @overlay.visible = $PokemonSystem.disable_fogs&.zero? if RfSettings::ADD_FOGS_TO_SETTINGS && RfSettings::SETTINGS_AFFECT_GLOBAL_OVERLAY
    _init_map_overlays
  end

  def update
    _update_map_overlays
    # Fogs
    if @fog_name != $game_map.fog_name || @fog_hue != $game_map.fog_hue
      @fog_name = $game_map.fog_name
      @fog_hue = $game_map.fog_hue
      @fog.set_fog(nil) if !@fog.bitmap.nil?
      @fog.set_fog(@fog_name, @fog_hue) if !nil_or_empty?(@fog_name)
      Graphics.frame_reset
    end
    @fog.ox         = ($game_map.display_x / Game_Map::X_SUBPIXELS).round + $game_map.fog_ox
    @fog.oy         = ($game_map.display_y / Game_Map::Y_SUBPIXELS).round + $game_map.fog_oy
    @fog.zoom_x     = $game_map.fog_zoom / 100.0
    @fog.zoom_y     = $game_map.fog_zoom / 100.0
    @fog.opacity    = $game_map.fog_opacity
    @fog.blend_type = $game_map.fog_blend_type
    @fog.tone       = $game_map.fog_tone
    @fog.update
    # Overlays
    if @overlay_name != $game_map.metadata&.overlay_name
      @overlay_name = $game_map.metadata.overlay_name
      @overlay.bitmap&.dispose if !@overlay.bitmap.nil?
      @overlay.bitmap = Bitmap.new("Graphics/Fogs/Overlays/#{@overlay_name}") if !nil_or_empty?(@overlay_name)
      Graphics.frame_reset
    end
  end

  def dispose
    @fog.dispose
    @overlay.dispose
    _dispose_map_overlays
  end
end

# Add global overlays to map metadata
module GameData
  class MapMetadata
    attr_reader :overlay_name

    SCHEMA["OverlayName"] = (Essentials::VERSION < "21") ? [23, "s"] : [:overlay_name, "s"]

    class << self; alias __get_original_editor_properties editor_properties; end
    def self.editor_properties
      properties = __get_original_editor_properties
      properties << ["OverlayName", StringProperty, _INTL("The name of the image in Graphics/Fogs/Overlays to be displayed as a \"global overlay\" on this map.")]
      return properties
    end

    alias __initialize_map_overlays initialize
    def initialize(hash)
      __initialize_map_overlays(hash)
      @overlay_name = hash[:overlay_name]
    end

    if Essentials::VERSION < "21"
      alias __property_from_string_map_overlays property_from_string
      def property_from_string(str)
        return @overlay_name if str == "OverlayName"
        return __property_from_string_map_overlays(str)
      end
    end
  end
end

if Essentials::VERSION < "21"
  module Compiler
    #=============================================================================
    # Compile map metadata
    #=============================================================================
    def compile_map_metadata(path = "PBS/map_metadata.txt")
      compile_pbs_file_message_start(path)
      GameData::MapMetadata::DATA.clear
      map_infos = pbLoadMapInfos
      map_names = []
      map_infos.each_key { |id| map_names[id] = map_infos[id].name }
      # Read from PBS file
      File.open(path, "rb") { |f|
        FileLineData.file = path   # For error reporting
        # Read a whole section's lines at once, then run through this code.
        # contents is a hash containing all the XXX=YYY lines in that section, where
        # the keys are the XXX and the values are the YYY (as unprocessed strings).
        schema = GameData::MapMetadata::SCHEMA
        idx = 0
        pbEachFileSectionNumbered(f) { |contents, map_id|
          echo "." if idx % 50 == 0
          idx += 1
          Graphics.update if idx % 250 == 0
          # Go through schema hash of compilable data and compile this section
          schema.each_key do |key|
            FileLineData.setSection(map_id, key, contents[key])   # For error reporting
            # Skip empty properties
            next if contents[key].nil?
            # Compile value for key
            value = pbGetCsvRecord(contents[key], key, schema[key])
            value = nil if value.is_a?(Array) && value.length == 0
            contents[key] = value
          end
          # Construct map metadata hash
          metadata_hash = {
            :id                   => map_id,
            :name                 => contents["Name"],
            :outdoor_map          => contents["Outdoor"],
            :announce_location    => contents["ShowArea"],
            :can_bicycle          => contents["Bicycle"],
            :always_bicycle       => contents["BicycleAlways"],
            :teleport_destination => contents["HealingSpot"],
            :weather              => contents["Weather"],
            :town_map_position    => contents["MapPosition"],
            :dive_map_id          => contents["DiveMap"],
            :dark_map             => contents["DarkMap"],
            :safari_map           => contents["SafariMap"],
            :snap_edges           => contents["SnapEdges"],
            :random_dungeon       => contents["Dungeon"],
            :battle_background    => contents["BattleBack"],
            :wild_battle_BGM      => contents["WildBattleBGM"],
            :trainer_battle_BGM   => contents["TrainerBattleBGM"],
            :wild_victory_BGM     => contents["WildVictoryBGM"],
            :trainer_victory_BGM  => contents["TrainerVictoryBGM"],
            :wild_capture_ME      => contents["WildCaptureME"],
            :town_map_size        => contents["MapSize"],
            :battle_environment   => contents["Environment"],
            :flags                => contents["Flags"],
            :overlay_name         => contents["OverlayName"]
          }
          # Add map metadata's data to records
          GameData::MapMetadata.register(metadata_hash)
          map_names[map_id] = metadata_hash[:name] if !nil_or_empty?(metadata_hash[:name])
        }
      }
      # Save all data
      GameData::MapMetadata.save
      MessageTypes.setMessages(MessageTypes::MapNames, map_names)
      process_pbs_file_message_end
    end
  end
end