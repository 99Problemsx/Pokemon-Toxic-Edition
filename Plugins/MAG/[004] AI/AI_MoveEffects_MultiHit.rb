#===============================================================================
#
#===============================================================================
Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("TwoTurnAttack",
  proc { |score, move, user, target, ai, battle|
    # Power Herb makes this a 1 turn move, the same as a move with no effect
    next score if user.has_active_item?(:POWERHERB)
    # Treat as a failure if user has Truant (the charging turn has no effect)
    next Battle::AI::MOVE_USELESS_SCORE if user.has_active_ability?(:TRUANT)
    # Useless if user will faint from EoR damage before finishing this attack
    next Battle::AI::MOVE_USELESS_SCORE if user.rough_end_of_round_damage >= user.hp
    # Don't prefer because it uses up two turns
    score -= 10
    # Don't prefer if user is at a low HP (time is better spent on quicker moves)
    if ai.trainer.has_skill_flag?("HPAware")
      score -= 10 if user.hp < user.totalhp / 2
    end
    # Don't prefer if target has a protecting move
    if ai.trainer.high_skill? && !(user.has_active_ability?(:UNSEENFIST) && move.move.contactMove?)
      has_protect_move = false
      if move.pbTarget(user).num_targets > 1 &&
         (Settings::MECHANICS_GENERATION >= 7 || move.damagingMove?)
        if target.has_move_with_function?("ProtectUserSideFromMultiTargetDamagingMoves")
          has_protect_move = true
        end
      end
      if move.move.canProtectAgainst?
        if target.has_move_with_function?("ProtectUser",
                                          "ProtectUserFromTargetingMovesSpikyShield",
                                          "ProtectUserBanefulBunker")
          has_protect_move = true
        end
        if move.damagingMove?
          # NOTE: Doesn't check for Mat Block because it only works on its
          #       user's first turn in battle, so it can't be used in response
          #       to this move charging up.
          if target.has_move_with_function?("ProtectUserFromDamagingMovesKingsShield",
                                            "ProtectUserFromDamagingMovesObstruct",
											"ProtectUserFromDamagingMovesQueensShield")
            has_protect_move = true
          end
        end
        if move.rough_priority(user) > 0
          if target.has_move_with_function?("ProtectUserSideFromPriorityMoves")
            has_protect_move = true
          end
        end
      end
      score -= 20 if has_protect_move
    end
    next score
  }
)


Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("TwoTurnAttackFocusEnergy",
  proc { |score, move, user, target, ai, battle|
    # Score for being a two turn attack
    score = Battle::AI::Handlers.apply_move_effect_against_target_score("TwoTurnAttack",
       score, move, user, target, ai, battle)
    next score if score == Battle::AI::MOVE_USELESS_SCORE
    # Score for raising the user's stat
    score = Battle::AI::Handlers.apply_move_effect_score("RaiseUserCriticalHitRate2",
       score, move, user, ai, battle)
    next score
  }
)