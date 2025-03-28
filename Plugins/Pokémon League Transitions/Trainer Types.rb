#===============================================================================
# NORMAL TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_normal_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueNormal", viewport, location)
    }
)

#===============================================================================
# FIGHTING TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_fighting_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueFighting", viewport, location)
    }
)

#===============================================================================
# FLYING TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_flying_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueFlying", viewport, location)
    }
)

#===============================================================================
# POISON TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_poison_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeaguePoison", viewport, location)
    }
)

#===============================================================================
# GROUND TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_ground_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueGround", viewport, location)
    }
)

#===============================================================================
# ROCK TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_rock_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueRock", viewport, location)
    }
)

#===============================================================================
# BUG TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_bug_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueBug", viewport, location)
    }
)

#===============================================================================
# GHOST TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_ghost_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueGhost", viewport, location)
    }
)

#===============================================================================
# STEEL TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_steel_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueSteel", viewport, location)
    }
)

#===============================================================================
# FIRE TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_fire_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueFire", viewport, location)
    }
)

#===============================================================================
# WATER TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_water_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueWater", viewport, location)
    }
)

#===============================================================================
# GRASS TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_grass_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueGrass", viewport, location)
    }
)

#===============================================================================
# ELECTRIC TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_electric_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueElectric", viewport, location)
    }
)

#===============================================================================
# PSYCHIC TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_psychic_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeaguePsychic", viewport, location)
    }
)

#===============================================================================
# ICE TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_ice_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueIce", viewport, location)
    }
)

#===============================================================================
# DRAGON TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_dragon_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueDragon", viewport, location)
    }
)

#===============================================================================
# DARK TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_dark_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueDark", viewport, location)
    }
)

#===============================================================================
# FAIRY TYPE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_fairy_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueFairy", viewport, location)
    }
)

#===============================================================================
# POKÉMON LEAGUE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_generic_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueGeneric", viewport, location)
    }
)

#===============================================================================
# POKÉMON LEAGUE CHALLENGE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_challenge_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueChallenge", viewport, location)
    }
)

#===============================================================================
# POKÉMON LEAGUE CHAMPION CUP
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_champion_cup_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueChampionCup", viewport, location)
    }
)

#===============================================================================
# POKÉMON LEAGUE GYM CHALLENGE
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_gym_challenge_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueGymChallenge", viewport, location)
    }
)

#===============================================================================
# POKÉMON LEAGUE STAR TOURNAMENT
#===============================================================================
SpecialBattleIntroAnimations.register("pkmn_league_star_tournament_animation", 100,
    proc { |battle_type, foe, location|   # Condition
        next false unless [1, 3].include?(battle_type)   # Only if a trainer battle
        trainer_types = [:ADD_YOUR, :TRAINER_TYPES, :HERE]
        next foe.any? { |f| trainer_types.include?(f.trainer_type) }
    },
    proc { |viewport, battle_type, foe, location|   # Animation
        pbBattleAnimationCore("PkMnLeagueStarTournament", viewport, location)
    }
)
