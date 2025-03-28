Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("DoubleDamageIfProtect",
  proc { |score, move, user, target, ai, battle|
    if target.check_for_move { |m| (m.is_a?(Battle::Move::ProtectMove) ||
                                    m.is_a?(Battle::Move::ProtectUserSideFromStatusMoves) ||
                                    m.is_a?(Battle::Move::ProtectUserSideFromDamagingMovesIfUserFirstTurn)) &&
                                   !m.is_a?(Battle::Move::UserEnduresFaintingThisTurn) }
      score += 7
    end
    next score
  }
)

Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("TargetMovesBecomeElectric",
  proc { |score, move, user, target, ai, battle|
    # Get Electric's effectiveness against the user
    electric_eff = user.effectiveness_of_type_against_battler(:ELECTRIC, target)
    electric_eff *= 1.5 if target.has_type?(:ELECTRIC)   # STAB
    electric_eff = 0 if user.has_active_ability?([:LIGHTNINGROD, :MOTORDRIVE, :VOLTABSORB])
    # For each of target's moves, get its effectiveness against the user and
    # decide whether it is better or worse than Electric's effectiveness
    old_type_better = 0
    electric_type_better = 0
    target.battler.eachMove do |m|
      next if !m.damagingMove?
      m_type = m.pbCalcType(target.battler)
      next if m_type == :ELECTRIC
      eff = user.effectiveness_of_type_against_battler(m_type, target, m)
      eff *= 1.5 if target.has_type?(m_type)   # STAB
      case m_type
      when :FIRE
        eff = 0 if user.has_active_ability?(:FLASHFIRE)
      when :GRASS
        eff = 0 if user.has_active_ability?(:SAPSIPPER)
      when :POISON
        eff = 0 if user.has_active_ability?(:POISONABSORB)
      when :WATER
        eff = 0 if user.has_active_ability?([:STORMDRAIN, :WATERABSORB])
      end
      if eff > electric_eff
        electric_type_better += 1
      elsif eff < electric_eff
        old_type_better += 1
      end
    end
    next Battle::AI::MOVE_USELESS_SCORE if electric_type_better == 0
    next Battle::AI::MOVE_USELESS_SCORE if electric_type_better < old_type_better
    score += 10 * (electric_type_better - old_type_better)
    next score
  }
)