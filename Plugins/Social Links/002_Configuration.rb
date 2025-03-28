#===============================================================================
# Social Link Profile registrations
#
# These are the Social Links for individual NPCs the player can interact with.
#===============================================================================
# Parameters:
#   - :id => Symbol - The ID of the Social Link 
#   - :name => String - The name of the NPC
#   - :image => String - The filename of the image used to represent the NPC's profile picture. 
#               File location: UI/Social Links/Profile Pictures
#   - :init_location => (Optional) String - The default location to show for the Social Link
#   - :init_status => (Optional) String - The default status message to show for the Social link
#   - :favorite_pokemon => (Optional) The default favorite Pokemon for the Social link. You have two options to set:
#                       - Set to a Symbol defining the species of Pokemon
#                       - Set to an array with the following structure:
#                         [Symbol of the species of Pokemon, gender (0 = male, 1 = female), form number, shiny? (true or false)]
#   - :im_contact_id => [Requires the Instant Messages plugin] (Optional) Symbol defining the Contact ID to associate with this Social Link
#   - :bond_max => (Optional) Integer - The max bond level of the NPC, which overrides BOND_LEVEL_MAX
#   - :bond_icon_coords => (Optional) Array - Set custom bond icon coordinates. Review the BOND_ICON_COORDS setting for instructions on how to set up.
#   - :bond_effects => (Optional) Hash defining bond effects gained at certain bond levels. Use the following structure:
#                           {
#                               Integer => [[:EFFECT_TYPE, :TYPE, rate]],
#                           }
#                               - Integer => The bond level needed to gain the effect
#                               - :EFFECT_TYPE => Set as either :EXP or :Shiny, depending on which effect you want
#                               - :TYPE => Symbol defining the type of Pokemon to get the effects
#                               - rate => Set as either a Float to multiply the EXP rate by, or Integer to add that number of retries for being a shiny.
#
#      NOTE: If multiple EXP rates or shiny retries can be applied at once, either by the same Social Link or across all Social Links, only
#           the highest rate/retry value will be applied. For dual type Pokemon, rates/retries do not stack between the two types; only the
#           highest rate/retry value between the two types will be used.
#           For example:
#               - If one Social Link provide a 1.3 EXP rate for Fire types, and a second Social Link provides a 1.5 EXP rate for Fire types, only the 
#                 1.5 EXP rate will apply, not 1.5 * 1.3.
#               - If you have active effects for Normal types to gain 1.3 EXP, and Flying types to gain 1.2 EXP, a Pidgey will only gain 1.3 EXP, not 1.3 * 1.2.
#               - If you have active effects for Normal types to have 3 extra shiny retries, and Flying types to have 1 extra shiny retry, a Pidgey will only 
#                 gain 3 extra shiny retries, not 3 + 1.
#
#
#   - :static_status_pool => (Optional) An Array of Strings. These are predefined status messages you can make appear for the
#                            Social Link using pbSetSocialLinkStatus
#   - :random_status_pool => (Optional) An Array of Arrays. These are predefined status messages you can make appear for the
#                            Social Link using pbSetSocialLinkStatusRandom. Each status message can have a minimum bond level
#                            in order to appear. For each subarray, use the following structure:
#                               [Status, MinBondLevel]
#                               - Status => String representing the status message
#                               - MinBondLevel => (Optional) Integer representing the minimum bond level needed for this status to appear.
#===============================================================================

GameData::SocialLinkProfile.register({
    :id             => :PROFOAK,
    :name		    => _INTL("Professor Oak"),
    :image		    => "Oak",
    :init_location  => _INTL("Pallet Town"),
    :init_status    => _INTL("It's a good day."),
    :favorite_pokemon => :PIKACHU,
    :im_contact_id  => :PROFOAK,
    :bond_effects   => {
                        4 => [[:EXP, :ELECTRIC, 1.1]],
                        9 => [[:Shiny, :ELECTRIC, 2]]
                    },
    :static_status_pool => [
                        _INTL("Hello World"),
                        _INTL("#TooManyCharmander"),
                        _INTL("#NotEnoughBulbasaur"),
                         ],
    :random_status_pool =>[
                        [_INTL("It's a great day.")],
                        [_INTL("It's a fine day."), 2],
                        [_INTL("It's an okay day."), 6],
                        [_INTL("It's an alright day."), 8]
                        ]
})

GameData::SocialLinkProfile.register({
    :id             => :JOEY,
    :name		    => _INTL("Joey"),
    :image		    => "Joey",
    :init_location  => _INTL("Viridian City"),
    :init_status    => _INTL("It's getting cold out. Maybe I should try wearing longer shorts?"),
    :favorite_pokemon => [:RATTATA, 0, 0, true],
    :bond_effects   => {
                        2 => [[:EXP, :NORMAL, 1.1], [:Shiny, :NORMAL, 1]],
                        7 => [[:Shiny, :NORMAL, 2]],
                        10 => [[:EXP, :NORMAL, 1.8], [:Shiny, :NORMAL, 5]]
                    }
})

GameData::SocialLinkProfile.register({
    :id             => :BROCK,
    :name		    => _INTL("Brock"),
    :image		    => "Brock",
    :init_status    => _INTL("I've see a <b>lot</b> of Geodude around lately. It brings a tear to my eye."),
    :bond_max       => 3,
    :bond_icon_coords => [
                    [112, 154],
                    [138, 138],
                    [154, 112]
                    ]
})