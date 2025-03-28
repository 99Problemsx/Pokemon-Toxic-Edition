#===============================================================================
# Setup Instructions
#
# In order to help reduce incompatibilities, I decided to not to overwrite a
# function for a single line. Instead, please do the following to enable
# Script Variables:
#
# 1. Open the Game_Event script in the Script Editor
# 2. Find the following line in that script:
#       next if c.variable_valid && $game_variables[c.variable_id] < c.variable_value
# 3. Comment out that line, and add the following line:
#       next if c.variable_valid && varValue?(c.variable_id) < c.variable_value
# 4. Save
#===============================================================================

#===============================================================================
# Game_Event (Do Not Edit)
#===============================================================================

class Game_Event < Game_Character
    def varValue?(id)
        varname = $data_system.variables[id]
        return 0 if !varname
        if varname[/^s\:/]
        return eval($~.post_match)
        else
        return $game_variables[id]
        end
    end
end