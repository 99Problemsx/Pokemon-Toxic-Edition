Battle::AI::Handlers::MoveFailureCheck.add("AddStickyWebToFoeSide",
  proc { |move, user, ai, battle|
    next user.pbOpposingSide.effects[PBEffects::StickyWeb]
  }
)
Battle::AI::Handlers::MoveEffectScore.add("AddStickyWebToFoeSide",
  proc { |score, move, user, ai, battle|
    inBattleIndices = battle.allSameSideBattlers(user.idxOpposingSide).map { |b| b.pokemonIndex }
    foe_reserves = []
    battle.pbParty(user.idxOpposingSide).each_with_index do |pkmn, idxParty|
      next if !pkmn || !pkmn.able? || inBattleIndices.include?(idxParty)
      if ai.trainer.medium_skill?
        next if pkmn.hasItem?(:HEAVYDUTYBOOTS)
        next if ai.pokemon_airborne?(pkmn)
      end
      foe_reserves.push(pkmn)   # pkmn will be affected by Sticky Web
    end
    next Battle::AI::MOVE_USELESS_SCORE if foe_reserves.empty?
    score += [8 * foe_reserves.length, 30].min
    next score
  }
)

#===============================================================================
#
#===============================================================================