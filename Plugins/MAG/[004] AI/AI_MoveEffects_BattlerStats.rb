Battle::AI::Handlers::MoveFailureCheck.copy("RaiseUserAtkSpAtk1",
                                            "RaiseUserDefSDef1LowerSpeed1")
Battle::AI::Handlers::MoveEffectScore.copy("RaiseUserAtkSpAtk1",
                                           "RaiseUserDefSDef1LowerSpeed1")
										   
										   
Battle::AI::Handlers::MoveFailureCheck.copy("RaiseUserSpeed1",
                                            "RaiseUserSpeed1Raise2InTailWind")
Battle::AI::Handlers::MoveEffectScore.copy("RaiseUserSpeed1",
                                           "RaiseUserSpeed1Raise2InTailWind")						
										  
										  
										  
Battle::AI::Handlers::MoveFailureCheck.add("RaiseUserMainStats2TrapUserInBattleHurt8th",
  proc { |move, user, ai, battle|
    next true if user.effects[PBEffects::LimitBreak]
    next Battle::AI::Handlers.move_will_fail?("RaiseUserAtkDef1", move, user, ai, battle)
  }
)	

Battle::AI::Handlers::MoveEffectScore.add("RaiseUserMainStats2TrapUserInBattleHurt8th",
  proc { |score, move, user, ai, battle|
    # Score for stat increase
    score = ai.get_score_for_target_stat_raise(score, user, move.move.statUp)
    # Score for user becoming trapped in battle
    if user.can_become_trapped? && battle.pbCanChooseNonActive?(user.index)
      # Not worth trapping if user will faint this round anyway
      eor_damage = user.rough_end_of_round_damage
      if eor_damage >= user.hp
        next (move.damagingMove?) ? score : Battle::AI::MOVE_USELESS_SCORE
      end
      # Score for user becoming trapped in battle
      if user.effects[PBEffects::PerishSong] > 0 ||
         user.effects[PBEffects::Attract] >= 0 ||
         eor_damage > 0
        score -= 15
      end
    end
    next score
  }
)									  