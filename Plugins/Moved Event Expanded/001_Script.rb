class PokemonGlobalMetadata
  attr_accessor :saved_events_expanded
  
  def saved_events_expanded
    @saved_events_expanded = {} if !@saved_events_expanded
    return @saved_events_expanded
  end
  
end
  
class Game_Map
	alias save_events_expanded_setup setup
	def setup(map_id)
		save_events_expanded_setup(map_id)
		if $PokemonGlobal.saved_events_expanded[map_id]
		  $PokemonGlobal.saved_events_expanded[map_id].each do |data|
			next if data.nil? || data[1].nil?
			next if data[0][0] != map_id
			event = @events[data[0][1]]
			next if event.nil?
			event.moveto(data[1][0], data[1][1])
			case data[1][2]
			when 2 then event.turn_down
			when 4 then event.turn_left
			when 6 then event.turn_right
			when 8 then event.turn_up
			end
			event.through = data[1][3] if data[1][3]
		  end
		end
	end
end

class PokemonMapMetadata 
  alias save_events_expanded_addMovedEvent addMovedEvent
  def addMovedEvent(eventID, permanent: false)
    save_events_expanded_addMovedEvent(eventID)
    if permanent
        eventID = eventID.id if eventID.is_a?(Game_Event)
        key = [$game_map.map_id, eventID]
        event = $game_map.events[eventID]
        $PokemonGlobal.saved_events_expanded[$game_map.map_id] = {} unless 
                $PokemonGlobal.saved_events_expanded[$game_map.map_id]
        $PokemonGlobal.saved_events_expanded[$game_map.map_id][key] = 
                [event.x, event.y, event.direction, event.through] if event
    end
  end
      
  def clearMovedEvent(eventID, mapID = $game_map.map_id)
	eventID = eventID.id if eventID.is_a?(Game_Event)
    if $PokemonGlobal.saved_events_expanded[mapID]
      $PokemonGlobal.saved_events_expanded[mapID][[mapID, eventID]] = nil
    end
  end
    
end