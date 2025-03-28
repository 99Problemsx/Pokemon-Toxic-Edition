#===============================================================================
# Pokemon Hunting
#===============================================================================
# Scaled Reward - Should the reward chances be scaled by price and Pokemon's
# level and rarity (true), or just be random (false)
# Not Hunted - Can Pokemon species that the player already successfully hunted
# become target again (true), or not (false)
#===============================================================================
module Pokemon_Hunting_Settings
    SCALED_REWARD = true
    USE_HUNTED = false

#===============================================================================
# Random Pokemon Selector settings:
# Baby Pokemon - Filter into only base/baby species of an evolution line (true)
# Base Form - Filter into only base form Pokemon (true)
# Have Evolution - Filter into species who have evolutions (true), filter into
# species who don't have evolutions (false), or ignore it (nil)
# Only Type - Filter into species who have specific type(s), or ignore (false)
# Seen - Filter into seen species (true), unseen (false), or ignore (nil)
# Caught - Filter into owned species (true), not owned (false), or ignore (nil)
# Generation - Filter into only species from specific generation(s)
#===============================================================================
    BABY_POKEMON = true
    BASE_FORM = true
    HAVE_EVOLUTION = true
    ONLY_TYPE = false
    SEEN = true
    CAUGHT = nil
    GENERATION = (1..8).to_a

#===============================================================================
# Text:
# What text should display on each part of the conversation
# {pokemon} = the target Pokemon
#===============================================================================
    # "Have you caught {target pokemon} for us?"
    ASKING_FOR_CAUGHT = "Have you caught {pokemon} for us?"
    # "Thank you for catching us {target pokemon}."
    AFTER_CAUGHT = "Thank you for catching us {pokemon}."
    # "Go and get us {target pokemon}."
    CATCH_COMMAND = "Go and get us {pokemon}."
    # "Here is your reward."
    REWARD_GIVING = "Here is your reward."
    # "Your next target is {target pokemon}."
    NEW_TARGET = "Your next target is {pokemon}."
    # "There are no Pokemon we are looking for right now."
    NO_MORE_TARGETS = "There are no Pokemon we are looking for right now."

#===============================================================================
# Rewards:
# A list of item rewards the player can get as a reward
#===============================================================================
    REWARDS = [
        :POKEBALL,:GREATBALL,:ULTRABALL,
        :POTION,:SUPERPOTION
    ]
end