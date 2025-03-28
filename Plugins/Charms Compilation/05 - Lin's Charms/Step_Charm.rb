#===============================================================================
# * Step Charm
#===============================================================================

EventHandlers.add(:on_player_step_taken, :eggs_charm,
  proc {
    $player.party.each do |egg|
      next if egg.steps_to_hatch <= 0
      egg.steps_to_hatch -= 1 if $player.activeCharm?(:STEPCHARM)
      if egg.steps_to_hatch <= 0
        egg.steps_to_hatch = 0
        pbHatch(egg)
      end
    end
  }
)