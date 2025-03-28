if RfSettings::ADD_FOGS_TO_SETTINGS
  def rf_reload_overlays
    return if !$scene.is_a? Scene_Map
    $scene.spritesetGlobal.fog.visible = $PokemonSystem.disable_fogs.zero? if RfSettings::SETTINGS_AFFECT_FOGS
    $scene.spritesetGlobal.overlay.visible = $PokemonSystem.disable_fogs.zero? if RfSettings::SETTINGS_AFFECT_GLOBAL_OVERLAY
    $map_factory.maps.each { |map| $scene.spriteset(map.map_id).overlay.opacity = $PokemonSystem.disable_fogs.zero? ? 255 : RfSettings::SETTINGS_MAP_OVERLAY_OPACITY }
  end

  class PokemonSystem
    attr_accessor :disable_fogs

    alias __initialize_fogs initialize
    def initialize
      __initialize_fogs
      @disable_fogs = 0
    end
  end

  class PokemonOption_Scene
    alias __end_scene_fogs pbEndScene
    def pbEndScene
      __end_scene_fogs
      rf_reload_overlays
    end
  end

  MenuHandlers.add(:options_menu, :disable_fogs, {
    "name"        => _INTL("Reduced Lighting Effects"),
    "order"       => 80,
    "type"        => EnumOption,
    "parameters"  => [_INTL("Off"), _INTL("On")],
    "description" => _INTL("Reduces lighting effects in certain areas of the game in order to aid visibility."),
    "get_proc"    => proc { next $PokemonSystem.disable_fogs },
    "set_proc"    => proc { |value, _sceme| $PokemonSystem.disable_fogs = value }
  })
end