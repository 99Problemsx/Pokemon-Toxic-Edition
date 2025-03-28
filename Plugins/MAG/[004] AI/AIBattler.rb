class Battle::AI::AIBattler

alias mag_effectiveness_of_type_against_battler effectiveness_of_type_against_battler
  def effectiveness_of_type_against_battler(type, user = nil, move = nil)
    ret = Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
    return ret if !type
    return ret if type == :GROUND && has_type?(:FLYING) && has_active_item?(:IRONBALL)
    # Get effectivenesses
    if type == :SHADOW
      if battler.shadowPokemon?
        ret = Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER
      else
        ret = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER
      end
    else
      battler.pbTypes(true).each do |defend_type|
        mult = effectiveness_of_type_against_single_battler_type(type, defend_type, user)
        if move
          case move.function_code
          when "HitsTargetInSkyGroundsTarget"
            mult = Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER if type == :GROUND && defend_type == :FLYING
          when "FreezeTargetSuperEffectiveAgainstWater"
            mult = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defend_type == :WATER
		  when "SuperEffectiveAgainstDragon"
            mult = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defend_type == :DRAGON
		  when "InverseDarkType"
            mult = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defend_type == :FIGHTING
		  when "InverseDarkType"
            mult = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defend_type == :DARK
		  when "InverseDarkType"
            mult = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defend_type == :FAIRY
		  when "InverseDarkType"
            mult = Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER if defend_type == :GHOST
		  when "InverseDarkType"
            mult = Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER if defend_type == :PSYCHIC
          end
        end
        ret *= mult
      end
      ret *= 2 if self.effects[PBEffects::TarShot] && type == :FIRE
    end
    return ret
  end
#-------------------------------------------------------------------------------------------------------

alias mag_rough_end_of_round_damage rough_end_of_round_damage
  def rough_end_of_round_damage
    ret = 0
    # Weather
    weather = battler.effectiveWeather
    if @ai.battle.field.weatherDuration == 1
      weather = @ai.battle.field.defaultWeather
      weather = :None if @ai.battle.allBattlers.any? { |b| b.hasActiveAbility?([:CLOUDNINE, :AIRLOCK]) }
      weather = :None if [:Sun, :Rain, :HarshSun, :HeavyRain].include?(weather) && has_active_item?(:UTILITYUMBRELLA)
    end
    case weather
    when :Sandstorm
      ret += [self.totalhp / 16, 1].max if battler.takesSandstormDamage?
    when :Hail
      ret += [self.totalhp / 16, 1].max if battler.takesHailDamage?
    when :ShadowSky
      ret += [self.totalhp / 16, 1].max if battler.takesShadowSkyDamage?
    end
    case ability_id
    when :DRYSKIN
      ret += [self.totalhp / 8, 1].max if [:Sun, :HarshSun].include?(weather) && battler.takesIndirectDamage?
      ret -= [self.totalhp / 8, 1].max if [:Rain, :HeavyRain].include?(weather) && battler.canHeal?
    when :ICEBODY
      ret -= [self.totalhp / 16, 1].max if weather == :Hail && battler.canHeal?
    when :RAINDISH
      ret -= [self.totalhp / 16, 1].max if [:Rain, :HeavyRain].include?(weather) && battler.canHeal?
	when :VAMPIRICFANG
      ret -= [self.totalhp / 16, 1].max if battler.move.bitingMove? && battler.canHeal?
    when :SOLARPOWER
      ret += [self.totalhp / 8, 1].max if [:Sun, :HarshSun].include?(weather) && battler.takesIndirectDamage?
    end
    # Future Sight/Doom Desire
    # NOTE: Not worth estimating the damage from this.
    # Wish
    if @ai.battle.positions[@index].effects[PBEffects::Wish] == 1 && battler.canHeal?
      ret -= @ai.battle.positions[@index].effects[PBEffects::WishAmount]
    end
    # Sea of Fire
    if @ai.battle.sides[@side].effects[PBEffects::SeaOfFire] > 1 &&
       battler.takesIndirectDamage? && !has_type?(:FIRE)
      ret += [self.totalhp / 8, 1].max
    end
    # Grassy Terrain (healing)
    if @ai.battle.field.terrain == :Grassy && battler.affectedByTerrain? && battler.canHeal?
      ret -= [self.totalhp / 16, 1].max
    end
    # Leftovers/Black Sludge
    if has_active_item?(:BLACKSLUDGE)
      if has_type?(:POISON)
        ret -= [self.totalhp / 16, 1].max if battler.canHeal?
      else
        ret += [self.totalhp / 8, 1].max if battler.takesIndirectDamage?
      end
    elsif has_active_item?(:LEFTOVERS)
      ret -= [self.totalhp / 16, 1].max if battler.canHeal?
    end
    # Aqua Ring
    if self.effects[PBEffects::AquaRing] && battler.canHeal?
      amt = self.totalhp / 16
      amt = (amt * 1.3).floor if has_active_item?(:BIGROOT)
      ret -= [amt, 1].max
    end
    # Ingrain
    if self.effects[PBEffects::Ingrain] && battler.canHeal?
      amt = self.totalhp / 16
      amt = (amt * 1.3).floor if has_active_item?(:BIGROOT)
      ret -= [amt, 1].max
    end
    # Leech Seed
    if self.effects[PBEffects::LeechSeed] >= 0
      if battler.takesIndirectDamage?
        ret += [self.totalhp / 8, 1].max if battler.takesIndirectDamage?
      end
    else
      @ai.each_battler do |b, i|
        next if i == @index || b.effects[PBEffects::LeechSeed] != @index
        amt = [[b.totalhp / 8, b.hp].min, 1].max
        amt = (amt * 1.3).floor if has_active_item?(:BIGROOT)
        ret -= [amt, 1].max
      end
    end
    # Hyper Mode (Shadow Pokémon)
    if battler.inHyperMode?
      ret += [self.totalhp / 24, 1].max
    end
    # Poison/burn/Nightmare
    if self.status == :POISON
      if has_active_ability?(:POISONHEAL)
        ret -= [self.totalhp / 8, 1].max if battler.canHeal?
      elsif battler.takesIndirectDamage?
        mult = 2
        mult = [self.effects[PBEffects::Toxic] + 1, 16].min if self.statusCount > 0   # Toxic
        ret += [mult * self.totalhp / 16, 1].max
      end
    elsif self.status == :FROSTBITE
      if has_active_ability?(:CRYOHEALING)
        ret -= [self.totalhp / 8, 1].max if battler.canHeal?
      elsif battler.takesIndirectDamage?
        amt = (Settings::MECHANICS_GENERATION >= 7) ? self.totalhp / 16 : self.totalhp / 8
        ret += [amt, 1].max
      end
    elsif self.status == :BURN
      if battler.takesIndirectDamage?
        amt = (Settings::MECHANICS_GENERATION >= 7) ? self.totalhp / 16 : self.totalhp / 8
        amt = (amt / 2.0).round if has_active_ability?(:HEATPROOF)
        ret += [amt, 1].max
      end
    elsif battler.asleep? && self.statusCount > 1 && self.effects[PBEffects::Nightmare]
      ret += [self.totalhp / 4, 1].max if battler.takesIndirectDamage?
    end
    # Curse
    if self.effects[PBEffects::Curse]
      ret += [self.totalhp / 4, 1].max if battler.takesIndirectDamage?
    end
    # Trapping damage
    if self.effects[PBEffects::Trapping] > 1 && battler.takesIndirectDamage?
      amt = (Settings::MECHANICS_GENERATION >= 6) ? self.totalhp / 8 : self.totalhp / 16
      if @ai.battlers[self.effects[PBEffects::TrappingUser]].has_active_item?(:BINDINGBAND)
        amt = (Settings::MECHANICS_GENERATION >= 6) ? self.totalhp / 6 : self.totalhp / 8
      end
      ret += [amt, 1].max
    end
    # Perish Song
    return 999_999 if self.effects[PBEffects::PerishSong] == 1
    # Bad Dreams
    if battler.asleep? && self.statusCount > 1 && battler.takesIndirectDamage?
      @ai.each_battler do |b, i|
        next if i == @index || !b.battler.near?(battler) || !b.has_active_ability?(:BADDREAMS)
        ret += [self.totalhp / 8, 1].max
      end
    end
    # Sticky Barb
    if has_active_item?(:STICKYBARB) && battler.takesIndirectDamage?
      ret += [self.totalhp / 8, 1].max
    end
    return ret
#-----------------------------------------------------------------------------
alias mag_wants_status_problem? wants_status_problem?
  def wants_status_problem?(new_status)
    return true if new_status == :NONE
    if ability_active?
      case ability_id
      when :GUTS
        return true if ![:SLEEP, :FROZEN].include?(new_status) &&
                       @ai.stat_raise_worthwhile?(self, :ATTACK, true)
      when :MARVELSCALE
        return true if @ai.stat_raise_worthwhile?(self, :DEFENSE, true)
      when :QUICKFEET
        return true if ![:SLEEP, :FROZEN].include?(new_status) &&
                       @ai.stat_raise_worthwhile?(self, :SPEED, true)
      when :FLAREBOOST
        return true if new_status == :BURN && @ai.stat_raise_worthwhile?(self, :SPECIAL_ATTACK, true)
      when :TOXICBOOST
        return true if new_status == :POISON && @ai.stat_raise_worthwhile?(self, :ATTACK, true)
      when :POISONHEAL
        return true if new_status == :POISON
      when :CRYOHEALING
        return true if new_status == :FROSTBITE
      when :MAGICGUARD   # Want a harmless status problem to prevent getting a harmful one
        return true if new_status == :POISON ||
                       (new_status == :BURN && !@ai.stat_raise_worthwhile?(self, :ATTACK, true))
      end
    end
    return true if new_status == :SLEEP && check_for_move { |m| m.usableWhenAsleep? }
    if has_move_with_function?("DoublePowerIfUserPoisonedBurnedParalyzed")
      return true if [:POISON, :BURN, :PARALYSIS].include?(new_status)
    end
    return false
  end
end
end