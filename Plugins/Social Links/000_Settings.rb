#===============================================================================
# Settings
#===============================================================================
module SocialLinkSettings

    #====================================================================================
    #================================= Display Settings =================================
    #====================================================================================

    #------------------------------------------------------------------------------------
    # The name of the Social Links app.
    #------------------------------------------------------------------------------------
    SOCIAL_LINKS_LIST_TITLE             = _INTL("Social Links")

    #------------------------------------------------------------------------------------
    # The text that appears in the Social Links app if you have no active Social Links.
    #------------------------------------------------------------------------------------
    NO_LINKS_MESSAGE                    = _INTL("You have no links.")

    #------------------------------------------------------------------------------------
    # The name of the default theme for the app. Set it to a name of a folder in
    # UI/Social Links/Themes
    #------------------------------------------------------------------------------------
    DEFAULT_THEME_COLOR                 = "Blue"  

    #------------------------------------------------------------------------------------
    # If true, when a Social Link's bond is maxed, it will change the bond icon to be 
    # the third frame. For the default graphic, it will be the golden Pokeball instead of
    # the regular one.
    #------------------------------------------------------------------------------------
    ALT_COLOR_BOND_ICON_AT_MAX          = true

    #------------------------------------------------------------------------------------
    # When a Social Link's bond is maxed, this string will replace the number.
    # Set to nil or "" to not replace the number with a string.
    #------------------------------------------------------------------------------------
    MAXED_BOND_TEXT_REPLACEMENT         = _INTL("MAX")

    #------------------------------------------------------------------------------------
    # If true, larger Profile Pictures images will be used on the profile page for each
    # link. By default, it will take the normal Profile Picture and zoom in by 200%. To
    # use a custom larger image, add "_large" to the end of the file name. For example,
    # to add a custom large image for Brock, name the large image "Brock_large".
    #------------------------------------------------------------------------------------
    USE_LARGE_PIC_ON_PROFILE            = true

    #------------------------------------------------------------------------------------
    # Set the font size of the Social Link's name on their profile page.
    # Set to 0 to use the system default.
    #------------------------------------------------------------------------------------
    PROFILE_NAME_FONT_SIZE              = 37

    #------------------------------------------------------------------------------------
    # If true, a Social Link's favorite Pokemon will appear on their profile page.
    #------------------------------------------------------------------------------------
    SHOW_FAVORITE_POKEMON               = true

    #====================================================================================
    #=============================== Functional Settings ================================
    #====================================================================================

    #------------------------------------------------------------------------------------
    # Set the max bond level.
    #------------------------------------------------------------------------------------
    BOND_LEVEL_MAX                      = 10

    #------------------------------------------------------------------------------------
    # If true, the player can use the SPECIAL key to change how Social Links in the menu     
    # are storted.
    #------------------------------------------------------------------------------------
    ALLOW_SORTING                       = true

    #------------------------------------------------------------------------------------
    # If true, the player can favorite a Social Link when using the ACTION key. A favorited
    # Social Link will always appear at the top of the list.
    #------------------------------------------------------------------------------------
    ALLOW_FAVORITING                    = true

    #------------------------------------------------------------------------------------
    # If true, the social media profile will not be accessible. The player will only be
    # able to view the list view when opening the Social Link app.
    #------------------------------------------------------------------------------------
    DISABLE_SOCIAL_MEDIA_PROFILE        = false

    #------------------------------------------------------------------------------------
    #  Set the sound effect to play when the player adds a new Social Link.
    #------------------------------------------------------------------------------------
    NEW_LINK_SOUND_EFFECT               = "Mining reveal"

    #------------------------------------------------------------------------------------
    #  Set the message to show when the player adds a new Social Link.
    #  If you include {1}, it will be replaced with the Social Link's name.
    #------------------------------------------------------------------------------------
    NEW_LINK_MESSAGE                    = _INTL("{1} was added as a social link!") 

    #------------------------------------------------------------------------------------
    #  Set the message to show when the player removes a Social Link.
    #  If you include {1}, it will be replaced with the Social Link's name.
    #------------------------------------------------------------------------------------
    REMOVED_LINK_MESSAGE                = _INTL("{1} is no longer a social link.")

    #------------------------------------------------------------------------------------
    # If true, a different message will be shown when a Social Link's bond is maxed.
    #------------------------------------------------------------------------------------
    SHOW_MAXED_BOND_MESSAGE             = true

    #------------------------------------------------------------------------------------
    #  Set the sound effect to play when the player maxes the bond with a Social Link.
    #------------------------------------------------------------------------------------
    MAXED_BOND_SOUND_EFFECT             = "Mining reveal full"

    #------------------------------------------------------------------------------------
    #  Set the message to show when the player maxes the bond with a Social Link.
    #  If you include {1}, it will be replaced with the Social Link's name.
    #------------------------------------------------------------------------------------
    MAXED_BOND_MESSAGE                  = _INTL("Your bond with {1} has reached its peak!")

    #------------------------------------------------------------------------------------
    # If true, when the player increases their bond with a Social Link and a new Bond
    # Effect gets enabled, shows a message stating what the Bond Effect is.
    #------------------------------------------------------------------------------------
    SHOW_BOND_EFFECT_MESSAGE            = true

    #====================================================================================
    #======================= Custom Profile Page Layout Settings ========================
    #====================================================================================

    #------------------------------------------------------------------------------------
    # If true, the other settings in this section will be applied to the profile page
    # layout instead of the default.
    #------------------------------------------------------------------------------------
    USE_CUSTOM_LAYOUT                   = false

    #------------------------------------------------------------------------------------
    # Set the coordinates for the center of the profile picture.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    PROFILE_PIC_CENTER_COORDS           = [72, 72]

    #------------------------------------------------------------------------------------
    # Set the coordinates for each of the icons used to show the bond you have with the
    # Social Link. Each index of the array corresponds to a bond level value - 1. For
    # example, the coordinates set in index 0 will be for bond level 1.
    # Use the format [x-coord, y-coord]. Set an index to nil for it to never show an
    # icon. For example, the default layout only allows 9 icons to fit so the 10th
    # index is set to nil (it instead turns all of the icons to the golden Pokeball to
    # represent having bond level 10).
    #------------------------------------------------------------------------------------
    BOND_ICON_COORDS                    = [
                                            [22, 162],
                                            [52, 162],
                                            [82, 162],
                                            [112, 154],
                                            [138, 138],
                                            [154, 112],
                                            [162, 82],
                                            [162, 52],
                                            [162, 22],
                                            nil
                                        ]

    #------------------------------------------------------------------------------------
    # Set the coordinates for the Social Link's name in the profile page.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    NAME_POSITION_COORDS                = [344, 62]

    #------------------------------------------------------------------------------------
    # Set the alignment for the name. Set to 0 for left aligned, 1 for right aligned, and
    # 2 for centered.
    #------------------------------------------------------------------------------------
    NAME_ALIGNMENT                      = 2

    #------------------------------------------------------------------------------------
    # Set the coordinates for the Social Link's location in the profile page. The
    # coordinates are for the top left corner of the text.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    LOCATION_SECTION_COORDS             = [200, 96]

    #------------------------------------------------------------------------------------
    # (Requires the Instant Messages plugin)
    # Set the coordinates for the Instant Messages button in the profile page. The
    # coordinates are for the top left corner of the button.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    INSTANT_MESSAGES_BUTTON_COORDS      = [0, 0]

    #------------------------------------------------------------------------------------
    # Set the coordinates for the Social Link's favorite Pokemon in the profile page. The
    # coordinates are for the top left corner of the graphic.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    FAVORITE_POKEMON_COORDS             = [24, 192]

    #------------------------------------------------------------------------------------
    # Set the coordinates for the Social Link's status message in the profile page. The
    # coordinates are for the top left corner of the text.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    STATUS_MESSAGE_COORDS               = [224, 192]

    #------------------------------------------------------------------------------------
    # Set the maximum width for the Social Link's status message in the profile page.
    #------------------------------------------------------------------------------------
    STATUS_MESSAGE_WIDTH                = 264

    #------------------------------------------------------------------------------------
    # Set the coordinates for the Social Link's status message in the profile page when 
    # the Social Link doesn't have a favorite Pokemon or favorite Pokemon are disabled.
    # The coordinates are for the top left corner of the text.
    # Use the format [x-coord, y-coord]
    #------------------------------------------------------------------------------------
    STATUS_MESSAGE_COORDS_NO_POKE       = [24, 192]

    #------------------------------------------------------------------------------------
    # Set the maximum width for the Social Link's status message in the profile page when
    # the Social Link doesn't have a favorite Pokemon or favorite Pokemon are disabled.
    #------------------------------------------------------------------------------------
    STATUS_MESSAGE_WIDTH_NO_POKE        = 464
    
end