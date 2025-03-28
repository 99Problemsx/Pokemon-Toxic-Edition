class Battle
  alias mag_pbStartWeather pbStartWeather
  def pbStartWeather(user, newWeather, fixedDuration = false, showAnim = true)
    return if @field.weather == newWeather
    @field.weather = newWeather
    duration = (fixedDuration) ? 5 : -1
    if duration > 0 && user && user.itemActive?
      duration = Battle::ItemEffects.triggerWeatherExtender(user.item, @field.weather,
                                                            duration, user, self)
    end
    @field.weatherDuration = duration
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if showAnim && weather_data
    pbHideAbilitySplash(user) if user
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight turned harsh!"))
    when :Rain        then pbDisplay(_INTL("It started to rain!"))
    when :Sandstorm   then pbDisplay(_INTL("A sandstorm brewed!"))
    when :Hail        then pbDisplay(_INTL("It started to hail!"))
    when :HarshSun    then pbDisplay(_INTL("The sunlight turned extremely harsh!"))
    when :HeavyRain   then pbDisplay(_INTL("A heavy rain began to fall!"))
    when :StrongWinds then pbDisplay(_INTL("Mysterious strong winds are protecting Flying-type Pokémon!"))
    when :ShadowSky   then pbDisplay(_INTL("A shadow sky appeared!"))
    end
    # Check for end of primordial weather, and weather-triggered form changes
    allBattlers.each { |b| b.pbCheckFormOnWeatherChange }
    allBattlers.each { |b| b.pbAbilityOnWeatherChange }
    pbEndPrimordialWeather
  end
 
alias mag_pbEndPrimordialWeather pbEndPrimordialWeather
  def pbEndPrimordialWeather
    oldWeather = @field.weather
    # End Primordial Sea, Desolate Land, Delta Stream
    case @field.weather
    when :HarshSun
      if !pbCheckGlobalAbility(:DESOLATELAND)
        @field.weather = :None
        pbDisplay("The harsh sunlight faded!")
      end
    when :HeavyRain
      if !pbCheckGlobalAbility(:PRIMORDIALSEA)
        @field.weather = :None
        pbDisplay("The heavy rain has lifted!")
      end
    when :StrongWinds
      if !pbCheckGlobalAbility(:DELTASTREAM)
        @field.weather = :None
        pbDisplay("The mysterious air current has dissipated!")
      end
    end
    if @field.weather != oldWeather
      # Check for form changes caused by the weather changing
      allBattlers.each { |b| b.pbCheckFormOnWeatherChange }
	  allBattlers.each { |b| b.pbAbilityOnWeatherChange }
      # Start up the default weather
      pbStartWeather(nil, @field.defaultWeather) if @field.defaultWeather != :None
    end
  end
  
alias mag_pbEOREndWeather pbEOREndWeather
  def pbEOREndWeather(priority)
    # NOTE: Primordial weather doesn't need to be checked here, because if it
    #       could wear off here, it will have worn off already.
    # Count down weather duration
    @field.weatherDuration -= 1 if @field.weatherDuration > 0
    # Weather wears off
    if @field.weatherDuration == 0
      case @field.weather
      when :Sun       then pbDisplay(_INTL("The sunlight faded."))
      when :Rain      then pbDisplay(_INTL("The rain stopped."))
      when :Sandstorm then pbDisplay(_INTL("The sandstorm subsided."))
      when :Hail      then pbDisplay(_INTL("The hail stopped."))
      when :ShadowSky then pbDisplay(_INTL("The shadow sky faded."))
      end
      @field.weather = :None
      # Check for form changes caused by the weather changing
      allBattlers.each { |battler| battler.pbCheckFormOnWeatherChange }
	  allBattlers.each { |battler| battler.pbAbilityOnWeatherChange }
      # Start up the default weather
      pbStartWeather(nil, @field.defaultWeather) if @field.defaultWeather != :None
      return if @field.weather == :None
    end
    # Weather continues
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if weather_data
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight is strong."))
    when :Rain        then pbDisplay(_INTL("Rain continues to fall."))
    when :Sandstorm   then pbDisplay(_INTL("The sandstorm is raging."))
    when :Hail        then pbDisplay(_INTL("The hail is crashing down."))
    when :HarshSun    then pbDisplay(_INTL("The sunlight is extremely harsh."))
    when :HeavyRain   then pbDisplay(_INTL("It is raining heavily."))
    when :StrongWinds then pbDisplay(_INTL("The wind is strong."))
    when :ShadowSky   then pbDisplay(_INTL("The shadow sky continues."))
    end
    # Effects due to weather
    priority.each do |battler|
      # Weather-related abilities
      if battler.abilityActive?
        Battle::AbilityEffects.triggerEndOfRoundWeather(battler.ability, battler.effectiveWeather, battler, self)
        battler.pbFaint if battler.fainted?
      end
      # Weather damage
      pbEORWeatherDamage(battler)
    end
  end

alias mag_pbDebugMenu pbDebugMenu
  def pbDebugMenu
    pbBattleDebug(self)
    @scene.pbRefreshEverything
    allBattlers.each { |b| b.pbCheckFormOnWeatherChange }
	allBattlers.each { |b| b.pbAbilityOnWeatherChange }
    pbEndPrimordialWeather
    allBattlers.each { |b| b.pbAbilityOnTerrainChange }
    allBattlers.each do |b|
      b.pbCheckFormOnMovesetChange
      b.pbCheckFormOnStatusChange
    end
	mag_pbDebugMenu
  end
end

class Battle::Battler
alias mag_pbOnLosingAbility pbOnLosingAbility
  def pbOnLosingAbility(oldAbil, suppressed = false)
   mag_pbOnLosingAbility(oldAbil, suppressed = false)
    if oldAbil == :NEUTRALIZINGGAS && (suppressed || !@effects[PBEffects::GastroAcid])
      pbAbilitiesOnNeutralizingGasEnding
    elsif [:UNNERVE, :ASONECHILLINGNEIGH, :ASONEGRIMNEIGH].include?(oldAbil) &&
          (suppressed || !@effects[PBEffects::GastroAcid])
      pbItemsOnUnnerveEnding
    elsif oldAbil == :ILLUSION && @effects[PBEffects::Illusion]
      @effects[PBEffects::Illusion] = nil
      if !@effects[PBEffects::Transform]
        @battle.scene.pbChangePokemon(self, @pokemon)
        @battle.pbDisplay(_INTL("{1}'s {2} wore off!", pbThis, GameData::Ability.get(oldAbil).name))
        @battle.pbSetSeen(self)
      end
    end
    @effects[PBEffects::GastroAcid] = false if unstoppableAbility?
    @effects[PBEffects::SlowStart]  = 0 if self.ability != :SLOWSTART
    @effects[PBEffects::Truant]     = false if self.ability != :TRUANT
    # Check for end of primordial weather
    @battle.pbEndPrimordialWeather
    # Revert form if Flower Gift/Forecast was lost
    pbCheckFormOnWeatherChange(true)
	pbAbilityOnWeatherChange(true)
    # Abilities that trigger when the terrain changes
    pbAbilityOnTerrainChange(true)
  end

  
  def pbAbilityOnWeatherChange(ability_changed = false)
    return if !abilityActive?
    Battle::AbilityEffects.triggerOnWeatherChange(self.ability, self, @battle, ability_changed)
  end
end