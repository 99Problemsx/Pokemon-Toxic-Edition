class Battle::AI::AIMove
alias mag_rough_damage rough_damage
  def rough_damage
   mag_rough_damage
    base_dmg = base_power
    return base_dmg if @move.is_a?(Battle::Move::FixedDamageMove)
    max_stage = Battle::Battler::STAT_STAGE_MAXIMUM
    stage_mul = Battle::Battler::STAT_STAGE_MULTIPLIERS
    stage_div = Battle::Battler::STAT_STAGE_DIVISORS
    # Get the user and target of this move
    user = @ai.user
    user_battler = user.battler
    target = @ai.target
    target_battler = target.battler
    # Get the move's type
    calc_type = rough_type
    # Decide whether the move has 50% chance of higher of being a critical hit
    crit_stage = rough_critical_hit_stage
    is_critical = crit_stage >= Battle::Move::CRITICAL_HIT_RATIOS.length ||
                  Battle::Move::CRITICAL_HIT_RATIOS[crit_stage] <= 2
    ##### Calculate user's attack stat #####
    if ["CategoryDependsOnHigherDamagePoisonTarget",
        "CategoryDependsOnHigherDamageIgnoreTargetAbility"].include?(function_code)
      @move.pbOnStartUse(user.battler, [target.battler])   # Calculate category
    end
    atk, atk_stage = @move.pbGetAttackStats(user.battler, target.battler)
    if !target.has_active_ability?(:UNAWARE) || @ai.battle.moldBreaker
      atk_stage = max_stage if is_critical && atk_stage < max_stage
      atk = (atk.to_f * stage_mul[atk_stage] / stage_div[atk_stage]).floor
    end
    ##### Calculate target's defense stat #####
    defense, def_stage = @move.pbGetDefenseStats(user.battler, target.battler)
    if !user.has_active_ability?(:UNAWARE) || @ai.battle.moldBreaker
      def_stage = max_stage if is_critical && def_stage > max_stage
      defense = (defense.to_f * stage_mul[def_stage] / stage_div[def_stage]).floor
    end
    ##### Calculate all multiplier effects #####
    multipliers = {
      :power_multiplier        => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
    # Global abilities
    if @ai.trainer.medium_skill? &&
       ((@ai.battle.pbCheckGlobalAbility(:DARKAURA) && calc_type == :DARK) ||
        (@ai.battle.pbCheckGlobalAbility(:FAIRYAURA) && calc_type == :FAIRY))
      if @ai.battle.pbCheckGlobalAbility(:AURABREAK)
        multipliers[:power_multiplier] *= 3 / 4.0
      else
        multipliers[:power_multiplier] *= 4 / 3.0
      end
    end
    # Ability effects that alter damage
    if user.ability_active?
      case user.ability_id
      when :AERILATE, :GALVANIZE, :PIXILATE, :REFRIGERATE
        multipliers[:power_multiplier] *= 1.2 if type == :NORMAL   # NOTE: Not calc_type.
	  when :CRYSTALLIZE
        multipliers[:power_multiplier] *= 1.5 if type == :ROCK     # NOTE: Not calc_type.
	  when :UNDERHANDED
        multipliers[:power_multiplier] *= 1.2 if type == :FIGHTING     # NOTE: Not calc_type.
	  when :FLAMEWING
        multipliers[:power_multiplier] *= 1.2 if type == :FLYING   # NOTE: Not calc_type.
      when :ANALYTIC
        if rough_priority(user) <= 0
          user_faster = false
          @ai.each_battler do |b, i|
            user_faster = (i != user.index && user.faster_than?(b))
            break if user_faster
          end
          multipliers[:power_multiplier] *= 1.3 if !user_faster
        end
      when :NEUROFORCE
        if Effectiveness.super_effective_type?(calc_type, *target.pbTypes(true))
          multipliers[:final_damage_multiplier] *= 1.25
        end
      when :NORMALIZE
        multipliers[:power_multiplier] *= 1.2 if Settings::MECHANICS_GENERATION >= 7
      when :SNIPER
        multipliers[:final_damage_multiplier] *= 1.5 if is_critical
      when :STAKEOUT
        # NOTE: Can't predict whether the target will switch out this round.
      when :TINTEDLENS
        if Effectiveness.resistant_type?(calc_type, *target.pbTypes(true))
          multipliers[:final_damage_multiplier] *= 2
        end
      else
        Battle::AbilityEffects.triggerDamageCalcFromUser(
          user.ability, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
        )
      end
    end
    if !@ai.battle.moldBreaker
      user_battler.allAllies.each do |b|
        next if !b.abilityActive?
        Battle::AbilityEffects.triggerDamageCalcFromAlly(
          b.ability, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
        )
      end
      if target.ability_active?
        case target.ability_id
        when :FILTER, :SOLIDROCK
          if Effectiveness.super_effective_type?(calc_type, *target.pbTypes(true))
            multipliers[:final_damage_multiplier] *= 0.75
          end
        else
          Battle::AbilityEffects.triggerDamageCalcFromTarget(
            target.ability, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
          )
        end
      end
    end
    if target.ability_active?
      Battle::AbilityEffects.triggerDamageCalcFromTargetNonIgnorable(
        target.ability, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
      )
    end
    if !@ai.battle.moldBreaker
      target_battler.allAllies.each do |b|
        next if !b.abilityActive?
        Battle::AbilityEffects.triggerDamageCalcFromTargetAlly(
          b.ability, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
        )
      end
    end
    # Item effects that alter damage
    if user.item_active?
      case user.item_id
      when :EXPERTBELT
        if Effectiveness.super_effective_type?(calc_type, *target.pbTypes(true))
          multipliers[:final_damage_multiplier] *= 1.2
        end
      when :LIFEORB
        multipliers[:final_damage_multiplier] *= 1.3
      else
        Battle::ItemEffects.triggerDamageCalcFromUser(
          user.item, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
        )
        user.effects[PBEffects::GemConsumed] = nil   # Untrigger consuming of Gems
      end
    end
    if target.item_active? && target.item && !target.item.is_berry?
      Battle::ItemEffects.triggerDamageCalcFromTarget(
        target.item, user_battler, target_battler, @move, multipliers, base_dmg, calc_type
      )
    end
    # Parental Bond
    if user.has_active_ability?(:PARENTALBOND)
      multipliers[:power_multiplier] *= (Settings::MECHANICS_GENERATION >= 7) ? 1.25 : 1.5
    end
    # Me First - n/a because can't predict the move Me First will use
    # Helping Hand - n/a
    # Charge
    if @ai.trainer.medium_skill? &&
       user.effects[PBEffects::Charge] > 0 && calc_type == :ELECTRIC
      multipliers[:power_multiplier] *= 2
    end
    # Mud Sport and Water Sport
    if @ai.trainer.medium_skill?
      case calc_type
      when :ELECTRIC
        if @ai.battle.allBattlers.any? { |b| b.effects[PBEffects::MudSport] }
          multipliers[:power_multiplier] /= 3
        end
        if @ai.battle.field.effects[PBEffects::MudSportField] > 0
          multipliers[:power_multiplier] /= 3
        end
      when :FIRE
        if @ai.battle.allBattlers.any? { |b| b.effects[PBEffects::WaterSport] }
          multipliers[:power_multiplier] /= 3
        end
        if @ai.battle.field.effects[PBEffects::WaterSportField] > 0
          multipliers[:power_multiplier] /= 3
        end
      end
    end
    # Terrain moves
    if @ai.trainer.medium_skill?
      terrain_multiplier = (Settings::MECHANICS_GENERATION >= 8) ? 1.3 : 1.5
      case @ai.battle.field.terrain
      when :Electric
        multipliers[:power_multiplier] *= terrain_multiplier if calc_type == :ELECTRIC && user_battler.affectedByTerrain?
      when :Grassy
        multipliers[:power_multiplier] *= terrain_multiplier if calc_type == :GRASS && user_battler.affectedByTerrain?
      when :Psychic
        multipliers[:power_multiplier] *= terrain_multiplier if calc_type == :PSYCHIC && user_battler.affectedByTerrain?
      when :Misty
        multipliers[:power_multiplier] /= 2 if calc_type == :DRAGON && target_battler.affectedByTerrain?
      end
    end
    # Badge multipliers
    if @ai.trainer.high_skill? && @ai.battle.internalBattle && target_battler.pbOwnedByPlayer?
      # Don't need to check the Atk/Sp Atk-boosting badges because the AI
      # won't control the player's Pokémon.
      if physicalMove?(calc_type) && @ai.battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_DEFENSE
        multipliers[:defense_multiplier] *= 1.1
      elsif specialMove?(calc_type) && @ai.battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_SPDEF
        multipliers[:defense_multiplier] *= 1.1
      end
    end
    # Multi-targeting attacks
    if @ai.trainer.high_skill? && targets_multiple_battlers?
      multipliers[:final_damage_multiplier] *= 0.75
    end
    # Weather
    if @ai.trainer.medium_skill?
      case user_battler.effectiveWeather
      when :Sun, :HarshSun
        case calc_type
        when :FIRE
          multipliers[:final_damage_multiplier] *= 1.5
        when :WATER
          multipliers[:final_damage_multiplier] /= 2
        end
      when :Rain, :HeavyRain
        case calc_type
        when :FIRE
          multipliers[:final_damage_multiplier] /= 2
        when :WATER
          multipliers[:final_damage_multiplier] *= 1.5
        end
      when :Sandstorm
        if target.has_type?(:ROCK) && specialMove?(calc_type) &&
           function_code != "UseTargetDefenseInsteadOfTargetSpDef"   # Psyshock
          multipliers[:defense_multiplier] *= 1.5
        end
      end
    end
    # Critical hits
    if is_critical
      if Settings::NEW_CRITICAL_HIT_RATE_MECHANICS
        multipliers[:final_damage_multiplier] *= 1.5
      else
        multipliers[:final_damage_multiplier] *= 2
      end
    end
    # Random variance - n/a
    # STAB
    if calc_type && user.has_type?(calc_type)
      if user.has_active_ability?(:ADAPTABILITY)
        multipliers[:final_damage_multiplier] *= 2
      else
        multipliers[:final_damage_multiplier] *= 1.5
      end
    end
    # Type effectiveness
    typemod = target.effectiveness_of_type_against_battler(calc_type, user, @move)
    multipliers[:final_damage_multiplier] *= typemod
    # Burn
    if @ai.trainer.high_skill? && user.status == :BURN && physicalMove?(calc_type) &&
       @move.damageReducedByBurn? && !user.has_active_ability?(:GUTS)
      multipliers[:final_damage_multiplier] /= 2
    end
    # Aurora Veil, Reflect, Light Screen
    if @ai.trainer.medium_skill? && !@move.ignoresReflect? && !is_critical &&
       !user.has_active_ability?(:INFILTRATOR)
      if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
        if @ai.battle.pbSideBattlerCount(target_battler) > 1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      elsif target.pbOwnSide.effects[PBEffects::Reflect] > 0 && physicalMove?(calc_type)
        if @ai.battle.pbSideBattlerCount(target_battler) > 1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      elsif target.pbOwnSide.effects[PBEffects::LightScreen] > 0 && specialMove?(calc_type)
        if @ai.battle.pbSideBattlerCount(target_battler) > 1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      end
    end
    # Minimize
    if @ai.trainer.medium_skill? && target.effects[PBEffects::Minimize] && @move.tramplesMinimize?
      multipliers[:final_damage_multiplier] *= 2
    end
    # NOTE: No need to check pbBaseDamageMultiplier, as it's already accounted
    #       for in an AI's MoveBasePower handler or can't be checked now anyway.
    # NOTE: No need to check pbModifyDamage, as it's already accounted for in an
    #       AI's MoveBasePower handler.
    ##### Main damage calculation #####
    base_dmg = [(base_dmg * multipliers[:power_multiplier]).round, 1].max
    atk      = [(atk      * multipliers[:attack_multiplier]).round, 1].max
    defense  = [(defense  * multipliers[:defense_multiplier]).round, 1].max
    damage   = ((((2.0 * user.level / 5) + 2).floor * base_dmg * atk / defense).floor / 50).floor + 2
    damage   = [(damage * multipliers[:final_damage_multiplier]).round, 1].max
    ret = damage.floor
    ret = target.hp - 1 if @move.nonLethal?(user_battler, target_battler) && ret >= target.hp
    return ret
  end
end