Battle::AI::Handlers::MoveFailureAgainstTargetCheck.add("DisableFairyMoves",
  proc { |move, user, target, ai, battle|
    next true if target.effects[PBEffects::MagicTampering]    = 0
    next true if move.move.pbMoveFailedAromaVeil?(user.battler, target.battler, false)
    next true if Settings::MECHANICS_GENERATION >= 6 &&
                 !battle.moldBreaker && target.has_active_ability?(:OBLIVIOUS)
    next false
  }
)

Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("DisableTargetStatusMoves",
  proc { |score, move, user, target, ai, battle|
    next Battle::AI::MOVE_USELESS_SCORE if !target.check_for_move { |m| m.statusMove? }
    # Not worth using on a sleeping target that won't imminently wake up
    if target.status == :SLEEP && target.statusCount > ((target.faster_than?(user)) ? 2 : 1)
      if !target.check_for_move { |m| m.statusMove? && m.usableWhenAsleep? }
        next Battle::AI::MOVE_USELESS_SCORE
      end
    end
    # Move is likely useless if the target will lock themselves into a move,
    # because they'll likely lock themselves into a damaging move
    if !target.effects[PBEffects::ChoiceBand]
      if target.has_active_item?([:CHOICEBAND, :CHOICESPECS, :CHOICESCARF]) ||
         target.has_active_ability?(:GORILLATACTICS)
        next Battle::AI::MOVE_USELESS_SCORE
      end
    end
    # Prefer based on how many status moves the target knows
    target.battler.eachMove do |m|
      score += 5 if m.statusMove? && (m.pp > 0 || m.total_pp == 0)
    end
    # Prefer if the target has a protection move
    protection_moves = [
      "ProtectUser",                                       # Detect, Protect
      "ProtectUserSideFromPriorityMoves",                  # Quick Guard
      "ProtectUserSideFromMultiTargetDamagingMoves",       # Wide Guard
      "UserEnduresFaintingThisTurn",                       # Endure
      "ProtectUserSideFromDamagingMovesIfUserFirstTurn",   # Mat Block
      "ProtectUserSideFromStatusMoves",                    # Crafty Shield
      "ProtectUserFromDamagingMovesKingsShield",           # King's Shield
      "ProtectUserFromDamagingMovesObstruct",              # Obstruct
      "ProtectUserFromTargetingMovesSpikyShield",          # Spiky Shield
      "ProtectUserBanefulBunker",                          # Baneful Bunker
	  "ProtectUserFromDamagingMovesQueensShield"           # Queen's Shield
    ]
    if target.check_for_move { |m| m.statusMove? && protection_moves.include?(m.function_code) }
      score += 10
    end
    next score
  }
)