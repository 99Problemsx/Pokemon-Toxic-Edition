class Battle::AI

  # Returns whether the target raising the given stat will have any impact.
  def stat_raise_worthwhile?(target, stat, fixed_change = false)
    if !fixed_change
      return false if !target.battler.pbCanRaiseStatStage?(stat, @user.battler, @move.move)
    end
    # Check if target won't benefit from the stat being raised
    return true if target.has_move_with_function?("SwitchOutUserPassOnEffects",
                                                  "PowerHigherWithUserPositiveStatStages")
    case stat
    when :ATTACK
      return false if !target.check_for_move { |m| m.physicalMove?(m.type) &&
                                                   m.function_code != "UseUserDefenseInsteadOfUserAttack" &&
                                                   m.function_code != "UseTargetAttackInsteadOfUserAttack" &&
												   m.function_code != "UseUserSpeedInsteadOfUserAttack" &&
												   m.function_code != "UseUserSpDefenseInsteadOfUserSpAttack"}
    when :DEFENSE
      each_foe_battler(target.side) do |b, i|
        return true if b.check_for_move { |m| m.physicalMove?(m.type) ||
                                              m.function_code == "UseTargetDefenseInsteadOfTargetSpDef" }
      end
      return false
    when :SPECIAL_ATTACK
      return false if !target.check_for_move { |m| m.specialMove?(m.type) }
    when :SPECIAL_DEFENSE
      each_foe_battler(target.side) do |b, i|
        return true if b.check_for_move { |m| m.specialMove?(m.type) &&
                                              m.function_code != "UseTargetDefenseInsteadOfTargetSpDef" }
      end
      return false
    when :SPEED
      moves_that_prefer_high_speed = [
        "PowerHigherWithUserFasterThanTarget",
        "PowerHigherWithUserPositiveStatStages"
      ]
      if !target.has_move_with_function?(*moves_that_prefer_high_speed)
        meaningful = false
        target_speed = target.rough_stat(:SPEED)
        each_foe_battler(target.side) do |b, i|
          b_speed = b.rough_stat(:SPEED)
          meaningful = true if target_speed < b_speed && target_speed * 2.5 > b_speed
          break if meaningful
        end
        return false if !meaningful
      end
    when :ACCURACY
      min_accuracy = 100
      target.battler.moves.each do |m|
        next if m.accuracy == 0 || m.is_a?(Battle::Move::OHKO)
        min_accuracy = m.accuracy if m.accuracy < min_accuracy
      end
      if min_accuracy >= 90 && target.stages[:ACCURACY] >= 0
        meaningful = false
        each_foe_battler(target.side) do |b, i|
          meaningful = true if b.stages[:EVASION] > 0
          break if meaningful
        end
        return false if !meaningful
      end
    when :EVASION
    end
    return true
  end
 
alias mag_get_target_stat_raise_score_one get_target_stat_raise_score_one
    def get_target_stat_raise_score_one(score, target, stat, increment, desire_mult = 1)
    # Figure out how much the stat will actually change by
    max_stage = Battle::Battler::STAT_STAGE_MAXIMUM
    stage_mul = Battle::Battler::STAT_STAGE_MULTIPLIERS
    stage_div = Battle::Battler::STAT_STAGE_DIVISORS
    if [:ACCURACY, :EVASION].include?(stat)
      stage_mul = Battle::Battler::ACC_EVA_STAGE_MULTIPLIERS
      stage_div = Battle::Battler::ACC_EVA_STAGE_DIVISORS
    end
    old_stage = target.stages[stat]
    new_stage = old_stage + increment
    inc_mult = (stage_mul[new_stage + max_stage].to_f * stage_div[old_stage + max_stage]) / (stage_div[new_stage + max_stage] * stage_mul[old_stage + max_stage])
    inc_mult -= 1
    inc_mult *= desire_mult
    # Stat-based score changes
    case stat
    when :ATTACK
      # Modify score depending on current stat stage
      # More strongly prefer if the target has no special moves
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        has_special_moves = target.check_for_move { |m| m.specialMove?(m.type) }
        inc = (has_special_moves) ? 8 : 12
        score += inc * inc_mult
      end
    when :DEFENSE
      # Modify score depending on current stat stage
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * inc_mult
      end
    when :SPECIAL_ATTACK
      # Modify score depending on current stat stage
      # More strongly prefer if the target has no physical moves
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        has_physical_moves = target.check_for_move { |m| m.physicalMove?(m.type) &&
                                                         m.function_code != "UseUserDefenseInsteadOfUserAttack" &&
                                                         m.function_code != "UseTargetAttackInsteadOfUserAttack" &&
														 m.function_code != "UseUserSpeedInsteadOfUserAttack" &&
												         m.function_code != "UseUserSpDefenseInsteadOfUserSpAttack"}
        inc = (has_physical_moves) ? 8 : 12
        score += inc * inc_mult
      end
    when :SPECIAL_DEFENSE
      # Modify score depending on current stat stage
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * inc_mult
      end
    when :SPEED
      # Prefer if target is slower than a foe
      target_speed = target.rough_stat(:SPEED)
      each_foe_battler(target.side) do |b, i|
        b_speed = b.rough_stat(:SPEED)
        next if b_speed <= target_speed   # Target already outspeeds the foe b
        next if b_speed > target_speed * 2.5   # Much too slow to reasonably catch up
        if b_speed < target_speed * (increment + 2) / 2
          score += 15 * inc_mult   # Target will become faster than the foe b
        else
          score += 8 * inc_mult
        end
        break
      end
      # Prefer if the target has Electro Ball or Power Trip/Stored Power
      moves_that_prefer_high_speed = [
        "PowerHigherWithUserFasterThanTarget",
        "PowerHigherWithUserPositiveStatStages"
      ]
      if target.has_move_with_function?(*moves_that_prefer_high_speed)
        score += 5 * inc_mult
      end
      # Don't prefer if any foe has Gyro Ball
      each_foe_battler(target.side) do |b, i|
        next if !b.has_move_with_function?("PowerHigherWithTargetFasterThanUser")
        score -= 5 * inc_mult
      end
      # Don't prefer if target has Speed Boost (will be gaining Speed anyway)
      if target.has_active_ability?(:SPEEDBOOST)
        score -= 15 * ((target.opposes?(@user)) ? 1 : desire_mult)
      end
    when :ACCURACY
      # Modify score depending on current stat stage
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        min_accuracy = 100
        target.battler.moves.each do |m|
          next if m.accuracy == 0 || m.is_a?(Battle::Move::OHKO)
          min_accuracy = m.accuracy if m.accuracy < min_accuracy
        end
        min_accuracy = min_accuracy * stage_mul[old_stage] / stage_div[old_stage]
        if min_accuracy < 90
          score += 10 * inc_mult
        end
      end
    when :EVASION
      # Prefer if a foe of the target will take damage at the end of the round
      each_foe_battler(target.side) do |b, i|
        eor_damage = b.rough_end_of_round_damage
        score += 5 * inc_mult if eor_damage > 0
      end
      # Modify score depending on current stat stage
      if old_stage >= 2 && increment == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * inc_mult
      end
    end
    # Prefer if target has Stored Power
    if target.has_move_with_function?("PowerHigherWithUserPositiveStatStages")
      score += 5 * increment * desire_mult
    end
    # Don't prefer if any foe has Punishment
    each_foe_battler(target.side) do |b, i|
      next if !b.has_move_with_function?("PowerHigherWithTargetPositiveStatStages")
      score -= 5 * increment * desire_mult
    end
    return score
  end


  # Returns whether the target lowering the given stat will have any impact.
alias mag_stat_drop_worthwhile? stat_drop_worthwhile?
  def stat_drop_worthwhile?(target, stat, fixed_change = false)
    if !fixed_change
      return false if !target.battler.pbCanLowerStatStage?(stat, @user.battler, @move.move)
    end
    # Check if target won't benefit from the stat being lowered
    case stat
    when :ATTACK
      return false if !target.check_for_move { |m| m.physicalMove?(m.type) &&
                                                   m.function_code != "UseUserDefenseInsteadOfUserAttack" &&
                                                   m.function_code != "UseTargetAttackInsteadOfUserAttack" &&
												   m.function_code != "UseUserSpeedInsteadOfUserAttack" &&
												   m.function_code != "UseUserSpDefenseInsteadOfUserSpAttack"}
    when :DEFENSE
      each_foe_battler(target.side) do |b, i|
        return true if b.check_for_move { |m| m.physicalMove?(m.type) ||
                                              m.function_code == "UseTargetDefenseInsteadOfTargetSpDef" }
      end
      return false
    when :SPECIAL_ATTACK
      return false if !target.check_for_move { |m| m.specialMove?(m.type) }
    when :SPECIAL_DEFENSE
      each_foe_battler(target.side) do |b, i|
        return true if b.check_for_move { |m| m.specialMove?(m.type) &&
                                              m.function_code != "UseTargetDefenseInsteadOfTargetSpDef" }
      end
      return false
    when :SPEED
      moves_that_prefer_high_speed = [
        "PowerHigherWithUserFasterThanTarget",
        "PowerHigherWithUserPositiveStatStages"
      ]
      if !target.has_move_with_function?(*moves_that_prefer_high_speed)
        meaningful = false
        target_speed = target.rough_stat(:SPEED)
        each_foe_battler(target.side) do |b, i|
          b_speed = b.rough_stat(:SPEED)
          meaningful = true if target_speed > b_speed && target_speed < b_speed * 2.5
          break if meaningful
        end
        return false if !meaningful
      end
    when :ACCURACY
      meaningful = false
      target.battler.moves.each do |m|
        meaningful = true if m.accuracy > 0 && !m.is_a?(Battle::Move::OHKO)
        break if meaningful
      end
      return false if !meaningful
    when :EVASION
    end
    return true
  end
  
alias mag_get_target_stat_drop_score_one get_target_stat_drop_score_one
  def get_target_stat_drop_score_one(score, target, stat, decrement, desire_mult = 1)
    # Figure out how much the stat will actually change by
    max_stage = Battle::Battler::STAT_STAGE_MAXIMUM
    stage_mul = Battle::Battler::STAT_STAGE_MULTIPLIERS
    stage_div = Battle::Battler::STAT_STAGE_DIVISORS
    if [:ACCURACY, :EVASION].include?(stat)
      stage_mul = Battle::Battler::ACC_EVA_STAGE_MULTIPLIERS
      stage_div = Battle::Battler::ACC_EVA_STAGE_DIVISORS
    end
    old_stage = target.stages[stat]
    new_stage = old_stage - decrement
    dec_mult = (stage_mul[old_stage + max_stage].to_f * stage_div[new_stage + max_stage]) / (stage_div[old_stage + max_stage] * stage_mul[new_stage + max_stage])
    dec_mult -= 1
    dec_mult *= desire_mult
    # Stat-based score changes
    case stat
    when :ATTACK
      # Modify score depending on current stat stage
      # More strongly prefer if the target has no special moves
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        has_special_moves = target.check_for_move { |m| m.specialMove?(m.type) }
        dec = (has_special_moves) ? 8 : 12
        score += dec * dec_mult
      end
    when :DEFENSE
      # Modify score depending on current stat stage
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * dec_mult
      end
    when :SPECIAL_ATTACK
      # Modify score depending on current stat stage
      # More strongly prefer if the target has no physical moves
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        has_physical_moves = target.check_for_move { |m| m.physicalMove?(m.type) &&
                                                         m.function_code != "UseUserDefenseInsteadOfUserAttack" &&
                                                         m.function_code != "UseTargetAttackInsteadOfUserAttack" &&
												         m.function_code != "UseUserSpeedInsteadOfUserAttack" &&
												         m.function_code != "UseUserSpDefenseInsteadOfUserSpAttack"}
        dec = (has_physical_moves) ? 8 : 12
        score += dec * dec_mult
      end
    when :SPECIAL_DEFENSE
      # Modify score depending on current stat stage
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * dec_mult
      end
    when :SPEED
      # Prefer if target is faster than an ally
      target_speed = target.rough_stat(:SPEED)
      each_foe_battler(target.side) do |b, i|
        b_speed = b.rough_stat(:SPEED)
        next if target_speed < b_speed   # Target is already slower than foe b
        next if target_speed > b_speed * 2.5   # Much too fast to reasonably be overtaken
        if target_speed < b_speed * 2 / (decrement + 2)
          score += 15 * dec_mult   # Target will become slower than foe b
        else
          score += 8 * dec_mult
        end
        break
      end
      # Prefer if any ally has Electro Ball
      each_foe_battler(target.side) do |b, i|
        next if !b.has_move_with_function?("PowerHigherWithUserFasterThanTarget")
        score += 5 * dec_mult
      end
      # Don't prefer if target has Speed Boost (will be gaining Speed anyway)
      if target.has_active_ability?(:SPEEDBOOST)
        score -= 15 * ((target.opposes?(@user)) ? 1 : desire_mult)
      end
    when :ACCURACY
      # Modify score depending on current stat stage
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * dec_mult
      end
    when :EVASION
      # Modify score depending on current stat stage
      if old_stage <= -2 && decrement == 1
        score -= 10 * ((target.opposes?(@user)) ? 1 : desire_mult)
      else
        score += 10 * dec_mult
      end
    end
    # Prefer if target has Stored Power
    if target.has_move_with_function?("PowerHigherWithUserPositiveStatStages")
      score += 5 * decrement * desire_mult
    end
    # Don't prefer if any foe has Punishment
    each_foe_battler(target.side) do |b, i|
      next if !b.has_move_with_function?("PowerHigherWithTargetPositiveStatStages")
      score -= 5 * decrement * desire_mult
    end
    return score
  end


end