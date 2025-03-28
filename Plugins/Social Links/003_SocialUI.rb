#===============================================================================
# Functions
#===============================================================================

# Opens your list of active social links
def pbSocialMedia
    pbFadeOutIn {
        scene = SocialMediaMenu_Scene.new
        screen = SocialMediaMenuScreen.new(scene)
        screen.pbStartScreen
    }
end

alias pbSocialLinks pbSocialMedia

# Directly opens a social media profile 
def pbSocialMediaDirect(profile_id, old_scene = nil)
    if SocialLinkSettings::DISABLE_SOCIAL_MEDIA_PROFILE
        Console.echo_warn "DISABLE_SOCIAL_MEDIA_PROFILE is set to true, so viewing profiles is disabled. Opening the list view, instead."
        pbSocialMedia
        return
    end
    pbFadeOutIn {
        scene = SocialMedia_Scene.new(profile_id, old_scene)
        screen = SocialMediaScreen.new(scene)
        screen.pbStartScreen
    }
end

alias pbSocialLinkDirect pbSocialMediaDirect

def pbAddSocialLink(profile_id, silent: false)
    ret = pbPlayerSocialLinksSaved.pbAddLink(profile_id, silent: silent)
    return ret
end

alias pbAddSL pbAddSocialLink

def pbRemoveSocialLink(profile_id, silent: false)
    ret = pbPlayerSocialLinksSaved.pbRemoveLink(profile_id, silent: silent)
    return ret
end

alias pbRemoveSL pbRemoveSocialLink

def pbHasSocialLink?(profile_id)
    ret = pbPlayerSocialLinksSaved.pbHasLink?(profile_id)
    return ret
end

alias pbHasSL? pbHasSocialLink?

def pbGainSocialLinkBond(profile_id, val = 1, silent: false)
   ret = pbPlayerSocialLinksSaved.pbGainLinkBond(profile_id, val, silent: silent)
   return ret
end

alias pbGainSLBond pbGainSocialLinkBond

def pbLowerSocialLinkBond(profile_id, val = 1, silent: false)
    ret = pbPlayerSocialLinksSaved.pbLowerLinkBond(profile_id, val, silent: silent)
    return ret
end

alias pbLowerSLBond pbLowerSocialLinkBond

def pbSetSocialLinkBond(profile_id, val, silent: false)
    ret = pbPlayerSocialLinksSaved.pbSetLinkBond(profile_id, val, silent: silent)
    return ret
end

alias pbSetSLBond pbSetSocialLinkBond

def pbGetSocialLinkBond(profile_id)
    return pbPlayerSocialLinksSaved.pbGetLinkBond(profile_id)
end

alias pbGetSLBond pbGetSocialLinkBond

def pbSocialLinkBondMaxed?(profile_id)
    return pbPlayerSocialLinksSaved.pbLinkBondMaxed?(profile_id)
end

alias pbSLBondMaxed? pbSocialLinkBondMaxed?

def pbSetSocialLinkLocation(profile_id, location)
    return pbPlayerSocialLinksSaved.pbSetLinkLocation(profile_id, location)
end

alias pbSetSLLocation pbSetSocialLinkLocation

def pbSetSocialLinkFavoritePokemon(profile_id, species = nil, gender = 0, form = 0, shiny = false)
    return pbPlayerSocialLinksSaved.pbSetLinkPokemon(profile_id, species, gender, form, shiny)
end

alias pbSetSLFavPoke pbSetSocialLinkFavoritePokemon

def pbSetSocialLinkStatus(profile_id, status)
    return pbPlayerSocialLinksSaved.pbSetLinkStatus(profile_id, status)
end

alias pbSetSLStatus pbSetSocialLinkStatus

def pbSetSocialLinkStatusRandom(profile_id)
    return pbPlayerSocialLinksSaved.pbSetLinkStatus(profile_id, :Random)
end

alias pbSetSLStatusRandom pbSetSocialLinkStatusRandom

def pbSetSocialTheme(color)
    pbPlayerSocialLinksSaved.theme_color = color
end


#===============================================================================
# Menu scene
#===============================================================================
class Window_Social_Menu < Window_DrawableCommand
    attr_accessor :item_max

    def initialize(x, y, width, height, viewport)
        @links = []
        super(x, y, width, height, viewport)
        @row_height = 64
        self.windowskin = nil
        @file_location = Essentials::VERSION.include?("21") ? "UI" : "Pictures"
        arrow_file = Essentials::VERSION.include?("21") ? "sel_arrow" : "selarrow"
        @selarrow = AnimatedBitmap.new("Graphics/#{@file_location}/#{arrow_file}")
    end
    
    def links=(value)
        @links = value
        refresh
    end
    
    def itemCount
        return @links.length
    end
    
    def drawItem(index, _count, rect)
        return if index >= self.top_row + self.page_item_max
        rect = Rect.new(rect.x + 16, rect.y, rect.width-16, rect.height)
        image = @links[index][1].image
        name = @links[index][1].name
        bond = @links[index][1].bond
        base = self.baseColor
        shadow = self.shadowColor
        pic_width = 56
        bond_level_max = @links[index][1].bond_max
        if bond >= bond_level_max && SocialLinkSettings::MAXED_BOND_TEXT_REPLACEMENT && SocialLinkSettings::MAXED_BOND_TEXT_REPLACEMENT != ""
            bond_value = SocialLinkSettings::MAXED_BOND_TEXT_REPLACEMENT
        else 
            bond_value = bond.to_s
        end
        img_x = 26
        img_x += 26 if SocialLinkSettings::ALT_COLOR_BOND_ICON_AT_MAX && bond >= bond_level_max

        x_adj = 0
        if SocialLinkSettings::ALLOW_FAVORITING 
            x_adj = 30
            if @links[index][1].favorite
                pbDrawImagePositions(self.contents, [[sprintf("Graphics/UI/Social Links/favorite"), rect.width - 16, rect.y + 6]]) 
            end
        end

        drawFormattedTextEx(self.contents, rect.x + pic_width + 4 ,rect.y + 2 + 16, 468, name, base, shadow)
        pbDrawTextPositions(self.contents, [[bond_value, rect.x + rect.width - 44 - x_adj ,rect.y + 2 + 16, 1, base, shadow]])
        pbDrawImagePositions(self.contents, [[sprintf("Graphics/UI/Social Links/Profile Pictures/#{image}"), rect.x, rect.y + 6]])
        pbDrawImagePositions(self.contents, [[sprintf("Graphics/UI/Social Links/bond"), rect.x + rect.width - 36 - x_adj, rect.y + 22, img_x, 0, 26, 26]])
    end

    def drawCursor(index, rect)
        if self.index == index
            pbCopyBitmap(self.contents, @selarrow.bitmap, rect.x, rect.y + 2 + 16)
        end
        return Rect.new(rect.x + 16, rect.y, rect.width - 16, rect.height)
    end

    # def itemRect(item)
    #   if item < 0 || item >= @item_max || item < self.top_item ||
    #      item > self.top_item + self.page_item_max
    #     return Rect.new(0, 0, 0, 0)
    #   else
    #     cursor_width = (self.width - self.borderX - ((@column_max - 1) * @column_spacing)) / @column_max
    #     x = item % @column_max * (cursor_width + @column_spacing)
    #     y = (item / @column_max * @row_height) - @virtualOy
    #     return Rect.new(x, y, cursor_width, @row_height)
    #   end
    # end
  
    def refresh
        @item_max = itemCount
        dwidth  = self.width - self.borderX
        dheight = self.height - self.borderY
        self.contents = pbDoEnsureBitmap(self.contents, dwidth, dheight)
        self.contents.clear
        for i in 0...@item_max
            next if i < self.top_item || i > self.top_item + self.page_item_max
            drawItem(i, @item_max, itemRect(i))
        end
        drawCursor(self.index, itemRect(self.index)) if itemCount > 0
    end
    
    def update
        super
        @uparrow.x -= 10
        @downarrow.x -= 10
    end
end

class SocialMediaMenu_Scene
        attr_accessor :sprites

    def pbStartScene

        @social_links = []
        pbPlayerSocialLinksSaved.links.each { |key, value| @social_links.push([key, value])}
        
        @sort_method = 0

        @sprites = {}
        @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
        @viewport.z = 99999
        @base_color = MessageConfig::DARK_TEXT_MAIN_COLOR
        @shadow_color = MessageConfig::DARK_TEXT_SHADOW_COLOR
        @title_color = MessageConfig::LIGHT_TEXT_MAIN_COLOR
        @title_shadow_color = MessageConfig::LIGHT_TEXT_SHADOW_COLOR
        @theme = pbPlayerSocialLinksSaved.theme_color
        @sprites["background"] = IconSprite.new(0, 0, @viewport)
        @sprites["background"].setBitmap("Graphics/UI/Social Links/Themes/#{@theme}/bg_menu")        
        @last_convo =  nil
        @sprites["itemlist"] = Window_Social_Menu.new(22, 28, Graphics.width - 22, Graphics.height - 28, @viewport)
        @sprites["itemlist"].index = 0
        @sprites["itemlist"].baseColor = @base_color
        @sprites["itemlist"].shadowColor = @shadow_color
        @sprites["itemlist"].links = @social_links
        @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
        pbSetSystemFont(@sprites["overlay"].bitmap)
        textpos = [[SocialLinkSettings::SOCIAL_LINKS_LIST_TITLE,Graphics.width / 2, 6, 2, @title_color, @title_shadow_color]]
        textpos.push([SocialLinkSettings::NO_LINKS_MESSAGE, Graphics.width / 2, Graphics.height / 2 - 12, 2, @base_color, @shadow_color]) if @sprites["itemlist"].item_max == 0
        pbDrawTextPositions(@sprites["overlay"].bitmap,textpos)

        pbSortSocialLinks

        if SocialLinkSettings::ALLOW_FAVORITING && @social_links.length > 0
            @sprites["favorite_button"] = IconSprite.new(0, 0, @viewport)
            @sprites["favorite_button"].setBitmap("Graphics/UI/Social Links/favorite_button")
            @sprites["favorite_button"].x = Graphics.width - @sprites["favorite_button"].width - 4
            @sprites["favorite_button"].y = 6
        end

        if SocialLinkSettings::ALLOW_SORTING && @social_links.length > 1
            @sprites["sort_button"] = IconSprite.new(0, 0, @viewport)
            @sprites["sort_button"].setBitmap("Graphics/UI/Social Links/sort_button")
            @sprites["sort_button"].x = 4
            @sprites["sort_button"].y = 6
        end

        pbFadeInAndShow(@sprites) { pbUpdate }
    end

    def pbScene
        loop do
            selected = @sprites["itemlist"].index
            @sprites["itemlist"].active = true
            Graphics.update
            Input.update
            pbUpdate
            if Input.trigger?(Input::BACK)
                pbPlayCloseMenuSE
                break
            elsif Input.trigger?(Input::USE) && !SocialLinkSettings::DISABLE_SOCIAL_MEDIA_PROFILE
                if @social_links.length == 0
                    #pbPlayBuzzerSE
                else
                    pbPlayDecisionSE
                    pbSocialMediaDirect(@social_links[selected][0], self)
                end
            elsif Input.trigger?(Input::ACTION) && SocialLinkSettings::ALLOW_FAVORITING && @social_links.length > 0
                pbPlayDecisionSE
                @social_links[selected][1].toggle_favorite
                pbSortSocialLinks
            elsif Input.trigger?(Input::SPECIAL) && SocialLinkSettings::ALLOW_SORTING && @social_links.length > 1
                commands = [_INTL("Sort by Newest First"),_INTL("Sort by Lowest Bond"),_INTL("Sort by Highest Bond"),_INTL("Sort Alphabetically")]
                ret = pbShowCommands(nil, commands, -1, @sort_method)
                if ret >= 0 && ret != @sort_method
                    pbPlayDecisionSE
                    @sort_method = ret
                    pbSortSocialLinks
                end
            end
        end
    end

    def pbSortSocialLinks
        if SocialLinkSettings::ALLOW_FAVORITING
            case @sort_method
            when 0 # Newest First, default
                @social_links.sort_by! { |s| [s[1].favorite ? 1 : 0, s[1].time_added, s[1].name] }
                @social_links.reverse!
            when 1 # Bond Low
                @social_links.sort_by! { |s| [s[1].favorite ? 0 : 1, s[1].bond, s[1].name] }
            when 2 # Bond High
                @social_links.sort_by! { |s| [s[1].favorite ? 0 : 1, -s[1].bond, s[1].name] }
            when 3 # Sort Alphabetically
                @social_links.sort_by! { |s| [s[1].favorite ? 0 : 1, s[1].name] }
            end
            @sprites["itemlist"].refresh
        else
            case @sort_method
            when 0 # Newest First, default
                #@social_links.sort! { |a, b| a[1].time_added <=> b[1].time_added}
                @social_links.sort_by! { |s| [s[1].time_added, s[1].name]}
                @social_links.reverse!
            when 1 # Bond Low
                # @social_links.sort! { |a, b| a[1].bond <=> b[1].bond}
                @social_links.sort_by! { |s| [s[1].bond, s[1].name]}
            when 2 # Bond High
                # @social_links.sort! { |a, b| a[1].bond <=> b[1].bond}
                @social_links.sort_by! { |s| [-s[1].bond, s[1].name]}
                #@social_links.reverse!
            when 3 # Sort Alphabetically
                @social_links.sort! { |a, b| a[1].name <=> b[1].name}
            end
            @sprites["itemlist"].refresh
        end
    end

    def pbUpdate
        pbUpdateSpriteHash(@sprites)
    end

    def pbEndScene
        pbFadeOutAndHide(@sprites) { pbUpdate }
        pbDisposeSpriteHash(@sprites)
        @viewport.dispose
    end

end

class SocialMediaMenuScreen
    def initialize(scene)
        @scene = scene
    end

    def pbStartScreen
        @scene.pbStartScene
        @scene.pbScene
        @scene.pbEndScene
    end
end

#===============================================================================
# Messages scene
#===============================================================================
class SocialMedia_Scene
    def initialize(profile_id, old_scene = nil)
        @profile = pbPlayerSocialLinksSaved.links[profile_id]
        @old_scene = old_scene
    end

    def pbStartScene
        @theme = pbPlayerSocialLinksSaved.theme_color
        @show_pokemon = !@profile.favorite_pokemon.nil? && SocialLinkSettings::SHOW_FAVORITE_POKEMON
        @instant_messages = !@profile.im_contact_id.nil? && PluginManager.installed?("Instant Messages", "1.1")

        @pic_center = [72, 72]
        @name_position = [344, 46]
        @name_position[1] -= 4 if SocialLinkSettings::PROFILE_NAME_FONT_SIZE > 27
        @name_alignment = 2
        @location_position = [200, 96]
        @pokemon_position = [24, 192]
        @im_button_position = nil
        @status_position = @show_pokemon ? [224, 192] : [24, 192]
        @status_max_width = @show_pokemon ? 264 : 464
        @bond_level_max = @profile.bond_max
        @bond_icon_positions = [
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

        if SocialLinkSettings::USE_CUSTOM_LAYOUT
            @pic_center = SocialLinkSettings::PROFILE_PIC_CENTER_COORDS
            @name_position = SocialLinkSettings::NAME_POSITION_COORDS
            @name_alignment = SocialLinkSettings::NAME_ALIGNMENT
            @location_position = SocialLinkSettings::LOCATION_SECTION_COORDS
            @pokemon_position = SocialLinkSettings::FAVORITE_POKEMON_COORDS
            @status_position = @show_pokemon ? SocialLinkSettings::STATUS_MESSAGE_COORDS : SocialLinkSettings::STATUS_MESSAGE_COORDS_NO_POKE 
            @status_max_width = @show_pokemon ? SocialLinkSettings::STATUS_MESSAGE_WIDTH : SocialLinkSettings::STATUS_MESSAGE_WIDTH_NO_POKE
            @bond_icon_positions = SocialLinkSettings::BOND_ICON_COORDS
            @im_button_position = SocialLinkSettings::INSTANT_MESSAGES_BUTTON_COORDS
        end

        @bond_icon_positions = @profile.bond_icon_coords if @profile.bond_icon_coords

        @sprites = {}
        @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
        @viewport.z = 99999
        @sprites["background"] = IconSprite.new(0, 0, @viewport)
        @sprites["background"].setBitmap("Graphics/UI/Social Links/Themes/#{@theme}/bg#{@show_pokemon ? "" : "_nopoke"}")
        @sprites["bondoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
        @sprites["nameoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
        @sprites["locationoverlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)

        #Profile Picture
        @sprites["profile_picture"] = IconSprite.new(0, 0, @viewport)
        if SocialLinkSettings::USE_LARGE_PIC_ON_PROFILE && pbResolveBitmap("Graphics/UI/Social Links/Profile Pictures/#{@profile.image}_large")
            profile_picture = "Graphics/UI/Social Links/Profile Pictures/#{@profile.image}_large"
            @sprites["profile_picture"].setBitmap(profile_picture)
            @sprites["profile_picture"].x = @pic_center[0] - @sprites["profile_picture"].width / 2
            @sprites["profile_picture"].y = @pic_center[1] - @sprites["profile_picture"].height / 2
        else
            profile_picture = "Graphics/UI/Social Links/Profile Pictures/#{@profile.image}"
            @sprites["profile_picture"].setBitmap(profile_picture)
            @sprites["profile_picture"].x = @pic_center[0] - @sprites["profile_picture"].width / 2
            @sprites["profile_picture"].y = @pic_center[1] - @sprites["profile_picture"].height / 2
            if SocialLinkSettings::USE_LARGE_PIC_ON_PROFILE
                @sprites["profile_picture"].zoom_x = 2.0
                @sprites["profile_picture"].zoom_y = 2.0
                @sprites["profile_picture"].x = @pic_center[0] - @sprites["profile_picture"].width
                @sprites["profile_picture"].y = @pic_center[1] - @sprites["profile_picture"].height
            end
        end

        #Bond Scale
        imgpos = []
        @bond_level_max.times do |i|
            next if @bond_icon_positions[i].nil?
            img_x = (@profile.bond > i ? 26 : 0)
            img_x += 26  if SocialLinkSettings::ALT_COLOR_BOND_ICON_AT_MAX && @profile.bond >= @bond_level_max
            imgpos.push(["Graphics/UI/Social Links/bond", @bond_icon_positions[i][0], @bond_icon_positions[i][1],
                img_x, 0, 26, 26])
        end
        pbDrawImagePositions(@sprites["bondoverlay"].bitmap,imgpos)

        #Name
        pbSetSystemFont(@sprites["nameoverlay"].bitmap)
        @sprites["nameoverlay"].bitmap.font.size = SocialLinkSettings::PROFILE_NAME_FONT_SIZE if SocialLinkSettings::PROFILE_NAME_FONT_SIZE > 0
        textpos = []
        textpos.push([@profile.name, @name_position[0], @name_position[1], @name_alignment, MessageConfig::DARK_TEXT_MAIN_COLOR, MessageConfig::DARK_TEXT_SHADOW_COLOR])
        pbDrawTextPositions(@sprites["nameoverlay"].bitmap,textpos)

        #Location
        pbSetSystemFont(@sprites["locationoverlay"].bitmap)
        textpos = []
        imgpos = []
        imgpos.push(["Graphics/UI/Social Links/location", @location_position[0] + 2, @location_position[1] + 8])
        textpos.push([@profile.current_location, @location_position[0] + 36, @location_position[1] + 14, 0, MessageConfig::DARK_TEXT_MAIN_COLOR, MessageConfig::DARK_TEXT_SHADOW_COLOR])
        pbDrawTextPositions(@sprites["locationoverlay"].bitmap,textpos)
        pbDrawImagePositions(@sprites["locationoverlay"].bitmap,imgpos)

        #Favorite Pokemon
        if @show_pokemon
            fav = Array(@profile.favorite_pokemon)
            fav[1] = 0 if fav[1].nil?
            fav[2] = 0 if fav[2].nil?
            fav[3] = false if fav[3].nil?
            @sprites["pokemonicon"] = PokemonSprite.new(@viewport)
            @sprites["pokemonicon"].setOffset(PictureOrigin::CENTER)
            @sprites["pokemonicon"].x = @pokemon_position[0] + 96
            @sprites["pokemonicon"].y = @pokemon_position[1] + 96
            @sprites["pokemonicon"].setSpeciesBitmap(fav[0], fav[1], fav[2], fav[3])
        end

        #Status Message
        text_to_show = pbRunTextThroughReplacement(@profile.current_status)
        @sprites["statustext"] = Window_AdvancedTextPokemon.new(text_to_show)
        @sprites["statustext"].opacity = 0
        @sprites["statustext"].resizeToFit(@sprites["statustext"].text, @status_max_width)
        @sprites["statustext"].viewport = @viewport
        @sprites["statustext"].x = @status_position[0]
        @sprites["statustext"].y = @status_position[1]
        @sprites["statustext"].visible = true

        #Instant Message Button
        if @instant_messages
            @sprites["im_button"] = IconSprite.new(0, 0, @viewport)
            @sprites["im_button"].setBitmap("Graphics/UI/Social Links/im_button")
            @im_button_position = [Graphics.width - @sprites["im_button"].width - 24, 152] if !@im_button_position
            @sprites["im_button"].x = @im_button_position[0]
            @sprites["im_button"].y = @im_button_position[1]
        end

        pbFadeInAndShow(@sprites)
    end

    def pbScene
        loop do
            Graphics.update
            Input.update
            pbUpdate
            if @instant_messages && Input.trigger?(Input::SPECIAL)
                pbPlayDecisionSE
                filter = [:Contact, @profile.im_contact_id]
                pbInstantMessages(filter)
            elsif Input.trigger?(Input::BACK)
                pbPlayCloseMenuSE
                break
            elsif Input.trigger?(Input::USE)

            end
        end
        return
    end

    def pbRunTextThroughReplacement(text)
        text.gsub!(/\\pn/i,  $player.name) if $player
        text.gsub!(/\\pm/i,  _INTL("${1}", $player.money.to_s_formatted)) if $player
        text.gsub!(/\\n/i,   "\n")
        text.gsub!(/\\\[([0-9a-f]{8,8})\]/i) { "<c2=" + $1 + ">" }
        text.gsub!(/\\pg/i,  "\\b") if $player&.male?
        text.gsub!(/\\pg/i,  "\\r") if $player&.female?
        text.gsub!(/\\pog/i, "\\r") if $player&.male?
        text.gsub!(/\\pog/i, "\\b") if $player&.female?
        text.gsub!(/\\pg/i,  "")
        text.gsub!(/\\pog/i, "")
        text.gsub!(/\\b/i,   "<c3=3050C8,D0D0C8>")
        text.gsub!(/\\r/i,   "<c3=E00808,D0D0C8>")
        loop do
            last_text = text.clone
            text.gsub!(/\\v\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
            break if text == last_text
        end
        return text
    end

    def pbEndScene
        pbFadeOutAndHide(@sprites)
        pbDisposeSpriteHash(@sprites)
        @viewport.dispose
        @old_scene.sprites["itemlist"].refresh if @old_scene && @old_scene.sprites["itemlist"]
    end
 
    def pbUpdate
        pbUpdateSpriteHash(@sprites)
    end

end

#===============================================================================
# Messages screen
#===============================================================================
class SocialMediaScreen
    attr_reader :scene

    def initialize(scene)
        @scene = scene
    end

    def pbStartScreen
        @scene.pbStartScene
        ret = @scene.pbScene
        @scene.pbEndScene
        return ret
    end

    def pbUpdate
        @scene.update
    end

    def pbRefresh
        @scene.pbRefresh
    end

    def pbDisplay(text)
        @scene.pbDisplay(text)
    end

    def pbDisplayForcedCommands(text, commands)
        @scene.pbDisplayForcedCommands(text, commands)
    end

    def pbConfirm(text)
        return @scene.pbDisplayConfirm(text)
    end

    def pbShowCommands(helptext, commands, index = 0)
        return @scene.pbShowCommands(helptext, commands, index)
    end

end
