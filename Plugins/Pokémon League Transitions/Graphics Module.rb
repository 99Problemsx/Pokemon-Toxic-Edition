#===============================================================================
#
#===============================================================================
module Graphics
  @@transition = nil
  STOP_WHILE_TRANSITION = true

  unless defined?(transition_KGC_SpecialTransition)
    class << Graphics
      alias transition_KGC_SpecialTransition transition
    end

    class << Graphics
      alias update_KGC_SpecialTransition update
    end
  end

  # duration is in 1/20ths of a second
  def self.transition(duration = 8, filename = "", vague = 20)
    duration = duration.floor
    if judge_special_transition(duration, filename)
      duration = 0
      filename = ""
    end
    duration *= Graphics.frame_rate / 20   # For default fade-in animation, must be in frames
    begin
      transition_KGC_SpecialTransition(duration, filename, vague)
    rescue Exception
      transition_KGC_SpecialTransition(duration, "", vague) if filename != ""
    end
    if STOP_WHILE_TRANSITION && !@_interrupt_transition
      while @@transition && !@@transition.disposed?
        update
      end
    end
  end

  def self.update
    update_KGC_SpecialTransition
    @@transition.update if @@transition && !@@transition.disposed?
    @@transition = nil if @@transition&.disposed?
  end

  def self.judge_special_transition(duration, filename)
    return false if @_interrupt_transition
    ret = true
    if @@transition && !@@transition.disposed?
      @@transition.dispose
      @@transition = nil
    end
    duration /= 20.0   # Turn into seconds
    dc = File.basename(filename).downcase
    case dc
    # Other coded transitions
    when "breakingglass"    then @@transition = Transitions::BreakingGlass.new(duration)
    when "rotatingpieces"   then @@transition = Transitions::ShrinkingPieces.new(duration, true)
    when "shrinkingpieces"  then @@transition = Transitions::ShrinkingPieces.new(duration, false)
    when "splash"           then @@transition = Transitions::SplashTransition.new(duration, 9.6)
    when "random_stripe_v"  then @@transition = Transitions::RandomStripeTransition.new(duration, 0)
    when "random_stripe_h"  then @@transition = Transitions::RandomStripeTransition.new(duration, 1)
    when "zoomin"           then @@transition = Transitions::ZoomInTransition.new(duration)
    when "scrolldown"       then @@transition = Transitions::ScrollScreen.new(duration, 2)
    when "scrollleft"       then @@transition = Transitions::ScrollScreen.new(duration, 4)
    when "scrollright"      then @@transition = Transitions::ScrollScreen.new(duration, 6)
    when "scrollup"         then @@transition = Transitions::ScrollScreen.new(duration, 8)
    when "scrolldownleft"   then @@transition = Transitions::ScrollScreen.new(duration, 1)
    when "scrolldownright"  then @@transition = Transitions::ScrollScreen.new(duration, 3)
    when "scrollupleft"     then @@transition = Transitions::ScrollScreen.new(duration, 7)
    when "scrollupright"    then @@transition = Transitions::ScrollScreen.new(duration, 9)
    when "mosaic"           then @@transition = Transitions::MosaicTransition.new(duration)
    # HGSS transitions
    when "snakesquares"     then @@transition = Transitions::SnakeSquares.new(duration)
    when "diagonalbubbletl" then @@transition = Transitions::DiagonalBubble.new(duration, 0)
    when "diagonalbubbletr" then @@transition = Transitions::DiagonalBubble.new(duration, 1)
    when "diagonalbubblebl" then @@transition = Transitions::DiagonalBubble.new(duration, 2)
    when "diagonalbubblebr" then @@transition = Transitions::DiagonalBubble.new(duration, 3)
    when "risingsplash"     then @@transition = Transitions::RisingSplash.new(duration)
    when "twoballpass"      then @@transition = Transitions::TwoBallPass.new(duration)
    when "spinballsplit"    then @@transition = Transitions::SpinBallSplit.new(duration)
    when "threeballdown"    then @@transition = Transitions::ThreeBallDown.new(duration)
    when "balldown"         then @@transition = Transitions::BallDown.new(duration)
    when "wavythreeballup"  then @@transition = Transitions::WavyThreeBallUp.new(duration)
    when "wavyspinball"     then @@transition = Transitions::WavySpinBall.new(duration)
    when "fourballburst"    then @@transition = Transitions::FourBallBurst.new(duration)
    when "vstrainer"        then @@transition = Transitions::VSTrainer.new(duration)
    when "vselitefour"      then @@transition = Transitions::VSEliteFour.new(duration)
    when "rocketgrunt"      then @@transition = Transitions::RocketGrunt.new(duration)
    when "vsrocketadmin"    then @@transition = Transitions::VSRocketAdmin.new(duration)
    # Graphic transitions
    when "fadetoblack"      then @@transition = Transitions::FadeToBlack.new(duration)
    when "fadefromblack"    then @@transition = Transitions::FadeFromBlack.new(duration)
    # Pokémon League transitions
    when "pkmnleaguenormal"         then @@transition = Transitions::PkMnLeagueNormal.new(duration)
    when "pkmnleaguefighting"       then @@transition = Transitions::PkMnLeagueFighting.new(duration)
    when "pkmnleagueflying"         then @@transition = Transitions::PkMnLeagueFlying.new(duration)
    when "pkmnleaguepoison"         then @@transition = Transitions::PkMnLeaguePoison.new(duration)
    when "pkmnleagueground"         then @@transition = Transitions::PkMnLeagueGround.new(duration)
    when "pkmnleaguerock"           then @@transition = Transitions::PkMnLeagueRock.new(duration)
    when "pkmnleaguebug"            then @@transition = Transitions::PkMnLeagueBug.new(duration)
    when "pkmnleagueghost"          then @@transition = Transitions::PkMnLeagueGhost.new(duration)
    when "pkmnleaguesteel"          then @@transition = Transitions::PkMnLeagueSteel.new(duration)
    when "pkmnleaguefire"           then @@transition = Transitions::PkMnLeagueFire.new(duration)
    when "pkmnleaguewater"          then @@transition = Transitions::PkMnLeagueWater.new(duration)
    when "pkmnleaguegrass"          then @@transition = Transitions::PkMnLeagueGrass.new(duration)
    when "pkmnleagueelectric"       then @@transition = Transitions::PkMnLeagueElectric.new(duration)
    when "pkmnleaguepsychic"        then @@transition = Transitions::PkMnLeaguePsychic.new(duration)
    when "pkmnleagueice"            then @@transition = Transitions::PkMnLeagueIce.new(duration)
    when "pkmnleaguedragon"         then @@transition = Transitions::PkMnLeagueDragon.new(duration)
    when "pkmnleaguedark"           then @@transition = Transitions::PkMnLeagueDark.new(duration)
    when "pkmnleaguefairy"          then @@transition = Transitions::PkMnLeagueFairy.new(duration)
    when "pkmnleaguegeneric"        then @@transition = Transitions::PkMnLeagueGeneric.new(duration)
    when "pkmnleaguechallenge"      then @@transition = Transitions::PkMnLeagueChallenge.new(duration)
    when "pkmnleaguechampioncup"    then @@transition = Transitions::PkMnLeagueChampionCup.new(duration)
    when "pkmnleaguegymchallenge"   then @@transition = Transitions::PkMnLeagueGymChallenge.new(duration)
    when "pkmnleaguestartournament" then @@transition = Transitions::PkMnLeagueStarTournament.new(duration)
    # Paste your existing custom transitions below this line

    # Paste your existing custom transitions above this line
    else                         ret = false
    end
    Graphics.frame_reset if ret
    return ret
  end
end
