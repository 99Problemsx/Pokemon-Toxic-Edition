class PokemonEvolutionScene
  alias original_pbEvolution pbEvolution

  def pbEvolution(cancancel = true)
    pbBGMStop
    pbMessageDisplay(@sprites["msgwindow"], "\\se[]" + _INTL("What?") + "\1") { pbUpdate }
    pbPlayDecisionSE
    @pokemon.play_cry
    @sprites["msgwindow"].text = _INTL("{1} is evolving!", @pokemon.name)
    timer_start = System.uptime
    loop do
      Graphics.update
      Input.update
      pbUpdate
      break if System.uptime - timer_start >= 1
    end
    pbMEPlay("Evolution start")
    pbBGMPlay("Evolution")

    refusal_delay = 6.5 
    delay_start = System.uptime

    canceled = false
    refused_evolution = false
    happiness_refusal = false
    timer_start = System.uptime

    # Perform the random roll once and store it
    roll = rand(100)
    cancel_chance = MOTOConfig.get_evolution_cancel_chance
    echoln "Refuse Evolution (Random) Results: Evolution Cancel Chance: #{cancel_chance}; Random roll: #{roll}"

    loop do
      pbUpdateNarrowScreen(timer_start)
      @picture1.update
      setPictureSprite(@sprites["rsprite1"], @picture1)
      if @sprites["rsprite1"].zoom_x > 1.0
        @sprites["rsprite1"].zoom_x = 1.0
        @sprites["rsprite1"].zoom_y = 1.0
      end
      @picture2.update
      setPictureSprite(@sprites["rsprite2"], @picture2)
      if @sprites["rsprite2"].zoom_x > 1.0
        @sprites["rsprite2"].zoom_x = 1.0
        @sprites["rsprite2"].zoom_y = 1.0
      end

      Graphics.update
      Input.update
      pbUpdate(true)

      if System.uptime - delay_start >= refusal_delay
        if MOTOConfig.happiness_refusal_enabled? &&
           @pokemon.happiness < MOTOConfig.get_happiness_threshold
          pbBGMStop
          pbPlayCancelSE
          canceled = true
          refused_evolution = true
          happiness_refusal = true
	  echoln "Evolution canceled due to low happiness"
        elsif roll < cancel_chance
          pbBGMStop
          pbPlayCancelSE
          canceled = true
          refused_evolution = true
          echoln "Evolution canceled due to random chance"
        end
      end

      if Input.trigger?(Input::BACK) && cancancel
        pbBGMStop
        pbPlayCancelSE
        canceled = true
        break
      end

      break if !@picture1.running? && !@picture2.running? || canceled
    end

    pbFlashInOut(canceled)
    if canceled
      $stats.evolutions_cancelled += 1
      if happiness_refusal
        pbMessageDisplay(@sprites["msgwindow"],
                         _INTL("{1} is refusing to evolve!", @pokemon.name)) { pbUpdate }
        pbMessageDisplay(@sprites["msgwindow"],
                     _INTL("{1} glares at you. It doesn't trust you as a trainer yet...", @pokemon.name)) { pbUpdate }
      elsif refused_evolution
        pbMessageDisplay(@sprites["msgwindow"],
                         _INTL("{1} is refusing to evolve!", @pokemon.name)) { pbUpdate }
        pbMessageDisplay(@sprites["msgwindow"],
                         _INTL(" {1} is shaking its head. I wonder why? ", @pokemon.name)) { pbUpdate }
      else
        pbMessageDisplay(@sprites["msgwindow"],
                         _INTL("Huh? {1} stopped evolving!", @pokemon.name)) { pbUpdate }
      end
    else
      pbEvolutionSuccess
    end
  end
end
