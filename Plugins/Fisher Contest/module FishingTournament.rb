module FishingTournament
  class Tournament
    attr_accessor :start_time, :end_time, :participants, :caught_pokemon

    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
      @participants = []
      @caught_pokemon = {}
    end

    def add_participant(trainer)
      @participants << trainer
      @caught_pokemon[trainer] = []
    end

    def record_catch(trainer, pokemon)
      return unless @participants.include?(trainer)
      @caught_pokemon[trainer] << pokemon
    end

    def end_tournament
      winner = determine_winner
      announce_winner(winner)
    end

    private

    def determine_winner
      @participants.max_by { |trainer| @caught_pokemon[trainer].size }
    end

    def announce_winner(winner)
      pbMessage(_INTL("{1} is the winner of the fishing tournament!", winner.name))
    end
  end

  def self.start_tournament(duration_in_minutes)
    $game_switches[TOURNAMENT_SWITCH] = true
    $current_tournament = Tournament.new(Time.now, Time.now + duration_in_minutes * 60)
    $current_tournament.add_participant($Trainer)
    pbMessage(_INTL("The fishing tournament has started! You have {1} minutes to catch as many Pokémon as you can!", duration_in_minutes))
  end

  def self.end_tournament
    $game_switches[TOURNAMENT_SWITCH] = false
    $current_tournament.end_tournament
    $current_tournament = nil
  end
end

# Example usage:
# FishingTournament.start_tournament(60)  # Start a tournament for 60 minutes
# FishingTournament.end_tournament        # End the tournament