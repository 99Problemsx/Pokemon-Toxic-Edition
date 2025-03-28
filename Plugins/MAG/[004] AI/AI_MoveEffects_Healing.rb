Battle::AI::Handlers::MoveFailureAgainstTargetCheck.add("LeechSeedGrassSpeed",
  proc { |move, user, target, ai, battle|
    next true if target.effects[PBEffects::LeechSeed] >= 0
    next true if target.has_type?(:GRASS) || !target.battler.takesIndirectDamage?
    next false
  }
)
Battle::AI::Handlers::MoveEffectAgainstTargetScore.add("LeechSeedGrassSpeed",
  proc { |score, move, user, target, ai, battle|
    score += 15
    # Prefer early on
    score += 10 if user.turnCount < 2
    if ai.trainer.medium_skill?
      # Prefer if the user has no damaging moves
      score += 10 if !user.check_for_move { |m| m.damagingMove? }
      # Prefer if the target can't switch out to remove its seeding
      score += 8 if !battle.pbCanChooseNonActive?(target.index)
      # Don't prefer if the leeched HP will hurt the user
      score -= 20 if target.has_active_ability?([:LIQUIDOOZE])
    end
    if ai.trainer.high_skill?
      # Prefer if user can stall while damage is dealt
      if user.check_for_move { |m| m.is_a?(Battle::Move::ProtectMove) }
        score += 10
      end
      # Don't prefer if target can remove the seed
      if target.has_move_with_function?("RemoveUserBindingAndEntryHazards")
        score -= 15
      end
    end
    next score
  }
)

Battle::AI::Handlers::MoveFailureAgainstTargetCheck.add("LeechSeedGrassSpeed",
  proc { |move, user, target, ai, battle|
    next !target.opposes?(user)
    next !target.battler.pbCanRaiseStatStage?(:SPEED, user.battler, move.move)
  }
)