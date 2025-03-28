module MOTOConfig

  #===========================================================================
  # Random Evolution Refusal
  #===========================================================================
  # Random chance any pokemon will refuse evolution/ set to 0 to disable this feature
  
  EVOLUTION_CANCEL_CHANCE = 30

  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Optional Method: Happiness Determines Evolution Refusal
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # EVOLUTION_CANCEL_CHANCE will be disabled/overriden if ENABLE_HAPPINESS_REFUSAL is set to true  
  
  ENABLE_HAPPINESS_REFUSAL = false

  # Pokemon will 100% refuse evolution if happiness is below this value and ENABLE_HAPPINESS_REFUSAL = true
  
  EVOLUTION_HAPPINESS_THRESHOLD = 60   



  #============================================================================
  # Disobedience based on happiness
  #============================================================================
  # You can modify each tier of happiness (ranges are the first 2 numbers) and percent chance to disobey (3rd number)
  # Customize by adding/removing lines using same format
  # Set last number to 0 to disable this feature (each line) 
  # Happiness ranges outside set tier ranges will result in 100% obedience

  DISOBEY_CHANCES = {
    0..49   => 50, # Tier 1; ex.Happiness 0-49 is a 50% chance to disobey
    50..75 => 25,   # Tier 2; ex. Happiness 50-75 is a 25% chance to disobey
    76..100 => 10   # Tier 3; ex. Happiness 76-100 is a 10% chance to disobey
  }
  


  #=============================================================================
  # Refuse Switch-In 
  #=============================================================================
  # Once per battle, there is chance pokemon  with low happiness will refuse to switch in
  # Trainers can force the switch at cost of 10 happiness
  # Set happiness value; Happiness at and below this value will affected
  
  HAPPINESS_THRESHOLD = 60
  
  # Set chance to prevent switching in/ Set to 0 to Disable this feature
  
  DISOBEY_SWITCH_CHANCE = 50



  #=============================================================================
  # DO NOT EDIT BELOW!
  #=============================================================================

  def self.get_happiness_threshold
    return @happiness_threshold || HAPPINESS_THRESHOLD
  end

  def self.set_happiness_threshold(value)
    @happiness_threshold = [[value, 0].max, 255].min
  end

  def self.get_evolution_cancel_chance
    return @evolution_cancel_chance || EVOLUTION_CANCEL_CHANCE
  end

  def self.set_evolution_cancel_chance(value)
    @evolution_cancel_chance = [[value, 0].max, 100].min
  end

  def self.happiness_refusal_enabled?
    return @happiness_refusal_enabled || ENABLE_HAPPINESS_REFUSAL
  end

  def self.set_happiness_refusal_enabled(value)
    @happiness_refusal_enabled = value
  end
end
