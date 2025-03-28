# =========== Instructions ===========
 # 1. Create a new switch with the name "s:bumpedInto?"
 # 2. Open the event page you want to trigger when the player bumps into the event
 # 3. Add the switch you created in step 1 as a Condition for the page
 # 4. Make the page be a Trigger of Player Touch
 # 5. Fill out your event to do whatever you want.
 # 6. At the end of your event commands, add a script call "pbResetBumpedInto". 
 #    Without this, the condition will stay met until the event refreshes on map refresh.
 
 # =========== Checking Player Speed ===========
 # If you want this bump check to only trigger if the player is moving a certain speed (for 
 # instance, running), create a new switch with the name "s:bumpedInto?(x)" where x is the 
 # minimum speed you want the player to be moving.
 # - Use 4 for running
 # - Use 5 for cycling
 #
 # Optionally, you can use "s:ranInto?" and it will always check for a speed of at least 4.

 # =========== Checking Bump Count ===========
 # What if you want the event to change their dialogue if you bumped into them a certain amount 
 # of times? Create a new switch with the name "s:bumpedIntoCount?(x)" where x is the minimum
 # number of times the player has run into the event for it to trigger. This value will reset
 # once the event refreshes on map refresh.
 #
 # If you want to check this value in a Conditional Branch instead, use the script 
 # "get_self.bumpedIntoCount?(x)".
 #
 # To reset the count manually, add a script call "pbResetBumpedIntoCount"

class Game_Player
	alias bumped_into_event bump_into_object
	def bump_into_object
		bumped_into_event
        event = pbFacingEvent
        if event
            event.bumped_into = true
            event.bumped_into_speed = self.move_speed
            event.refresh
            event.bumped_into_count += 1
            if [1,2].include?(event.trigger)
				event.set_starting
				event.update
			end
        end
	end
end

class Game_Event
	attr_accessor :bumped_into
	attr_accessor :bumped_into_speed
	attr_accessor :bumped_into_count

    def bumped_into_count
        @bumped_into_count = 0 if !@bumped_into_count
        return @bumped_into_count
    end
  
	def bumpedInto?(speed = nil)
        if bumped_into
            if speed
                #bumped_into = false
                return bumped_into_speed >= speed
            else
                #bumped_into = false
                return true
            end
        end
		return false
	end
	
	def ranInto?
		return bumpedInto?(4)
	end

    def bumpedIntoCount?(val = nil)
        return false if val.nil?
        return bumped_into_count >= val
    end
end

class Interpreter
	def pbResetBumpedInto
		get_self&.bumped_into = false
		get_self&.refresh
	end

	def pbResetBumpedIntoCount
		get_self&.bumped_into_count = 0
		get_self&.refresh
	end
end