#===============================================================================
# Screen transition animation classes.
#===============================================================================
module Transitions
    #=============================================================================
    # Normal-type transition
    #=============================================================================
    class PkMnLeagueNormal < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Normal_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Normal_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Fighting-type transition
    #=============================================================================
    class PkMnLeagueFighting < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Fighting_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Fighting_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Flying-type transition
    #=============================================================================
    class PkMnLeagueFlying < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Flying_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Flying_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Poison-type transition
    #=============================================================================
    class PkMnLeaguePoison < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Poison_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Poison_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Ground-type transition
    #=============================================================================
    class PkMnLeagueGround < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Ground_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Ground_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Rock-type transition
    #=============================================================================
    class PkMnLeagueRock < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Rock_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Rock_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Bug-type transition
    #=============================================================================
    class PkMnLeagueBug < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Bug_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Bug_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Ghost-type transition
    #=============================================================================
    class PkMnLeagueGhost < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Ghost_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Ghost_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Steel-type transition
    #=============================================================================
    class PkMnLeagueSteel < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Steel_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Steel_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Fire-type transition
    #=============================================================================
    class PkMnLeagueFire < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Fire_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Fire_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Water-type transition
    #=============================================================================
    class PkMnLeagueWater < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Water_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Water_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Grass-type transition
    #=============================================================================
    class PkMnLeagueGrass < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Grass_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Grass_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Electric-type transition
    #=============================================================================
    class PkMnLeagueElectric < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Electric_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Electric_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Psychic-type transition
    #=============================================================================
    class PkMnLeaguePsychic < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Psychic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Psychic_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Ice-type transition
    #=============================================================================
    class PkMnLeagueIce < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Ice_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Ice_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Dragon-type transition
    #=============================================================================
    class PkMnLeagueDragon < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Dragon_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Dragon_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Dark-type transition
    #=============================================================================
    class PkMnLeagueDark < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Dark_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Dark_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Fairy-type transition
    #=============================================================================
    class PkMnLeagueFairy < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Fairy_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Fairy_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Generic transition
    #=============================================================================
    class PkMnLeagueGeneric < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Generic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Generic_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Champion Cup transition
    #=============================================================================
    class PkMnLeagueChampionCup < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Generic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Champion_Cup_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # League Challenge transition
    #=============================================================================
    class PkMnLeagueChallenge < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Generic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Challenge_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Gym Challenge transition
    #=============================================================================
    class PkMnLeagueGymChallenge < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Generic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Gym_Challenge_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end

    #=============================================================================
    # Star Tournament transition
    #=============================================================================
    class PkMnLeagueStarTournament < Transition_Base
        DURATION = 3.86666666666667

        def initialize_bitmaps
            @shutter_bitmap = RPG::Cache.transition("League_Shutter")
            @background_bitmap = RPG::Cache.transition("League_Generic_Bg")
            @logo_bitmap = RPG::Cache.transition("League_Star_Tournament_Logo")
            @wiper_bitmap = RPG::Cache.transition("League_Wiper")
            dispose if !@shutter_bitmap || !@background_bitmap || !@logo_bitmap || !@wiper_bitmap
        end

        def initialize_sprites
            # Black "shutters" and initial screen wipe
            @shutter_sprite = new_sprite(0, Graphics.height, @shutter_bitmap)
            @shutter_sprite.x = 0
            @shutter_sprite.y = 760 # Starts fully off-screen
            @shutter_sprite.z = 20
            @shutter_sprite.opacity = 255
            # Scrolling background
            @background_sprite = new_sprite(0, Graphics.height, @background_bitmap)
            @background_sprite.x = 0
            @background_sprite.y = 0
            @background_sprite.z = 10
            @background_sprite.visible = false
            # Gym logo
            @logo_sprite = new_sprite(0, Graphics.height, @logo_bitmap)
            @logo_sprite.x = Graphics.width / 2
            @logo_sprite.y = Graphics.height / 2
            @logo_sprite.z = 15
            @logo_sprite.ox = @logo_bitmap.width / 2
            @logo_sprite.oy = @logo_bitmap.height / 2
            @logo_sprite.zoom_x = 0.0
            @logo_sprite.zoom_y = 0.0
            @logo_sprite.opacity = 0
            # Final screen wipe
            @wiper_sprite = new_sprite(0, Graphics.height, @wiper_bitmap)
            @wiper_sprite.x = -730 # Starts fully off-screen
            @wiper_sprite.y = 0
            @wiper_sprite.z = 25
        end

        def set_up_timings
            @screen_blacked_out = 0.316666666666667
            @logo_revealed = 0.716666666666667
            @start_final_wipe = 3.56666666666667
            @final_wipe_extras = 3.86666666666667
        end

        def dispose_all
            # Dispose sprites
            @shutter_sprite&.dispose
            @background_sprite&.dispose
            @logo_sprite&.dispose
            @wiper_sprite&.dispose
            # Dispose bitmaps
            @shutter_bitmap&.dispose
            @background_bitmap&.dispose
            @logo_bitmap&.dispose
            @wiper_bitmap&.dispose
        end

        def update_anim
            if timer < @screen_blacked_out
                proportion = timer / @screen_blacked_out
                # The shutter graphic animates on, blacking out the overworld
                @shutter_sprite.y = 760 - (786 * proportion)
            end
            if timer >= @screen_blacked_out && timer < @logo_revealed
                proportion = (timer - @screen_blacked_out) / (@logo_revealed - @screen_blacked_out)
                # The shutter finishes animating, revealing the scrolling background
                @shutter_sprite.y = -26 - (350 * proportion)
                # The logo scales up and fades in.
                @logo_sprite.zoom_x = proportion
                @logo_sprite.zoom_y = proportion
                @logo_sprite.opacity = 255 * proportion
            end
            if timer >= @screen_blacked_out
                proportion = (timer - @screen_blacked_out) / (@duration - @screen_blacked_out)
                # The background appears and slowly scrolls
                @background_sprite.visible = true
                @background_sprite.x = -52 * proportion
                @background_sprite.y = -117 * proportion
            end
            if timer >= @logo_revealed
                proportion = (timer - @logo_revealed) / (@duration - @logo_revealed)
                # Snap the shutter and logo to their final positions (fallback)
                @shutter_sprite.y = -376
                @logo_sprite.zoom_x = 1.0
                @logo_sprite.zoom_y = 1.0
                @logo_sprite.opacity = 255
            end
            if timer >= @start_final_wipe
                proportion = (timer - @start_final_wipe) / (@duration - @start_final_wipe)
                # The final screen wipe animates, blacking out the screen
                @wiper_sprite.x = -730 + (730 * proportion)
            end
            if timer >= @start_final_wipe && timer < @final_wipe_extras
                proportion = (timer - @start_final_wipe) / (@final_wipe_extras - @start_final_wipe)
                # We fake the shutters "opening" by fading them out
                @shutter_sprite.opacity = 255 * (1 - proportion)
                # The logo scales up, shifts to the right, and fades out
                @logo_sprite.zoom_x = 1.0 + (0.5 * proportion)
                @logo_sprite.zoom_y = @logo_sprite.zoom_x
                @logo_sprite.opacity = 255 * (1 - proportion)
                @logo_sprite.x = (Graphics.width / 2) + (85 * proportion)
            end
        end
    end
end
