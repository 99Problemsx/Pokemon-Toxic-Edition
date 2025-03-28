module Rf
    @@name_window_skin = RfSettings::DEFAULT_WINDOW_SKIN
    def self.name_window_skin
        return @@name_window_skin ? @@name_window_skin : MessageConfig.pbGetSystemFrame
    end

    # override the windowskin used for the namewindow
    def self.name_window_skin=(skin)
        @@name_window_skin = skin ? skin : RfSettings::DEFAULT_WINDOW_SKIN
    end

    @@outline_colour = RfSettings::DEFAULT_OUTLINE_COLOR
    def self.portrait_outline_color
        return @@outline_colour
    end

    # override the colour used for portrait outlines
    def self.portrait_outline_color=(color)
        @@outline_colour = color ? color : RfSettings::DEFAULT_OUTLINE_COLOR
    end

    # set the active dialogue portrait and trigger the portrait opening animation
    # portrait is the name of a portrait graphic in Graphics/Portraits (ANIMATED GIFS ARE NOT SUPPORTED)
    def self.new_portrait(portrait, align = 0)
        $scene.spritesetGlobal.newPortrait(portrait, align) if $scene.is_a? Scene_Map
    end

    # set the active dialogue portrait and trigger the portrait "switching" animation
    # portrait is the name of a portrait graphic in Graphics/Portraits (ANIMATED GIFS ARE NOT SUPPORTED)
    def self.set_portrait(portrait)
        $scene.spritesetGlobal.activePortrait&.portrait = portrait if $scene.is_a? Scene_Map
    end

    def self.close_portrait
        $scene.spritesetGlobal.activePortrait&.state = :closing if $scene.is_a? Scene_Map
    end

    # slightly more readable way of suppressing player portrait on next showCommands
    def self.no_player_portrait
        $game_temp.player_portrait_disabled = true
    end

    # slightly more readable ways of setting the name label
    def self.set_speaker(name)
        $game_temp.speaker = name
    end
    def self.clear_speaker
        $game_temp.speaker = nil
    end
end

class Game_Temp
    attr_accessor :speaker
    attr_accessor :player_portrait_disabled # it may be bad practice to not initialize this variable but i'm also not sure if it matters like at all
end