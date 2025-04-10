#===============================================================================
# NOTE: Some Settings in here will be moved elsewhere eventually. They're all
#       just gathered here while the new UI is being written.
#===============================================================================
module Settings
  # :one, :adventure, :multiple
  SAVE_SLOTS = :multiple

  # Whether the main color of a move's name in the Fight menu in battle matches
  # the pixel at coordinate (10,34) in cursor_fight.png for that move's type
  # (true), or whether the move name's color is the default black (false).
  BATTLE_MOVE_NAME_COLOR_FROM_GRAPHIC = true

  # Whether "Town Map" will show as an option in the pause menu if the player
  # has that item in the Bag and doesn't have a Pokégear.
  SHOW_TOWN_MAP_IN_PAUSE_MENU = true

  # The filename of a location sign graphic to be used if the map metadata for a
  # map doesn't define one. Make this nil to use the default menu windowskin.
  DEFAULT_LOCATION_SIGN_GRAPHIC = "Pt default"
  # Assigns location sign graphics to text styles (numbers). These are used in
  # class LocationWindow to display the text appropriately for the graphic being
  # used. Style :none is reserved for the "no graphic" style. A filename may
  # instead be an array of [filename, text base color, text shadow color].
  LOCATION_SIGN_GRAPHIC_STYLES = {
    :dp       => [["DP", Color.new(72, 80, 72), Color.new(144, 160, 160)]],
    :hgss     => [["HGSS cave",    Color.new(232, 232, 232), Color.new(120, 144, 160)],
                  ["HGSS city",    Color.new(56, 64, 72),    Color.new(152, 152, 144)],
                  ["HGSS default", Color.new(48, 64, 72),    Color.new(144, 144, 96)],
                  ["HGSS forest",  Color.new(232, 232, 232), Color.new(120, 176, 144)],
                  ["HGSS lake",    Color.new(40, 48, 56),    Color.new(104, 144, 192)],
                  ["HGSS park",    Color.new(40, 48, 56),    Color.new(120, 136, 152)],
                  ["HGSS route",   Color.new(48, 64, 72),    Color.new(136, 136, 104)],
                  ["HGSS sea",     Color.new(216, 240, 248), Color.new(24, 96, 144)],
                  ["HGSS town",    Color.new(48, 56, 64),    Color.new(144, 120, 80)]],
    :platinum => ["Pt cave", "Pt city", "Pt default", "Pt forest", "Pt lake",
                  "Pt park", "Pt route", "Pt sea", "Pt town"]
  }

  # Whether a move's power/type/category/etc. as shown in battle, the summary
  # screen and the Move Reminder screen will appear as their calculated values
  # (true) or their values from the PBS file moves.txt (false). For example, if
  # this is true, Judgment's displayed type will depend on the Plate being held
  # by the Pokémon that knows it.
  SHOW_MODIFIED_MOVE_PROPERTIES = false

  # Whether pressing Use in the Town Map will zoom it in to 200% and show a text
  # pane on the right showing the selected point's description. The cursor can
  # still be moved while zoomed in.
  ENABLE_TOWN_MAP_ZOOM_IN_FOR_DETAILS = true
  # Whether points in the Town Map can be marked.
  ENABLE_TOWN_MAP_MARKING = true

  # TODO: Allow renaming a Pokémon from the party screen/summary screen (not
  #       sure which). Gen 9 feature.
  # TODO: Allow forgetting/remembering moves from the summary screen. Gen 9
  #       feature.
  # TODO: Show usability party balls in the Bag. Maybe?
  # TODO: Replace Run with Call in battle; don't have this depend on the Shadow
  #       type existing?
  # TODO: Whether new items go at the top or bottom of its Bag pocket?
end
