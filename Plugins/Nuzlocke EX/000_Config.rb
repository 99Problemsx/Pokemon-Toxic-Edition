module ChallengeModes
  # Array of species that are to be ignored when checking for "One
  # Capture per Map" rule
  ONE_CAPTURE_WHITELIST = [
    :DIALGA, :PALKIA, :GIRATINA, :ARCEUS
  ]

  # Groups of Map IDs that should be considered as one map in the case
  # where one large map is split up into multiple small maps
  SPLIT_MAPS_FOR_ENCOUNTERS = [
    [44, 45],
    [49, 50, 51]
  ]


  # Name and Description for all the rules that can be toggled in the challenge
  RULES = {
    :PERMAFAINT => {
      :name  => _INTL("Permafaint"),
      :desc  => _INTL("Once a Pokémon faints, it cannot be revived until the challenge ends."),
      :order => 1
    },
    :ONE_CAPTURE => {
      :name  => _INTL("One Capture per Map"),
      :desc  => _INTL("Only the first Pokémon encountered on a map can be caught and added to your party."),
      :order => 2
    },
    :SHINY_CLAUSE => {
      :name  => _INTL("Shiny Clause"),
      :desc  => _INTL("Shiny Pokemon are exempt from the \"One Capture per Map\" rule."),
      :order => 3
    },
    :DUPS_CLAUSE => {
      :name  => _INTL("Dupes Clause"),
      :desc  => _INTL("Evolution lines of owned species don't count as \"first encounters\" for the \"One Capture per Map\" rule."),
      :order => 4
    },
    :GIFT_CLAUSE => {
      :name  => _INTL("Gift Clause"),
      :desc  => _INTL("Gifted Pokémon or eggs don't count as \"first encounters\" for the \"One Capture per Map\" rule."),
      :order => 5
    },
    :FORCE_NICKNAME => {
      :name  => _INTL("Forced Nicknames"),
      :desc  => _INTL("Any Pokémon that is caught/obtained must be nicknamed."),
      :order => 6
    },
    :FORCE_SET_BATTLES => {
      :name  => _INTL("Forced Set Battle Style"),
      :desc  => _INTL("The option to switch your Pokémon after fainting an opponent's Pokémon will not be shown."),
      :order => 7
    },
    :NO_TRAINER_BATTLE_ITEMS => {
      :name  => _INTL("No Items in Trainer Battles"),
      :desc  => _INTL("Item usage will be disabled in Trainer Battles."),
      :order => 8
    },
    :GAME_OVER_WHITEOUT => {
      :name  => _INTL("No White-out"),
      :desc  => _INTL("If all your party Pokémon faint in battle, you lose the challenge immediately."),
      :order => 9
    }
  }
end
