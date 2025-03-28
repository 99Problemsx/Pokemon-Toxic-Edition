class Battle::Battler
  def pbObedienceCheck?(choice)
    return true if usingMultiTurnAttack?
    return true if choice[0] != :UseMove
    return true if !@battle.internalBattle
    return true if !@battle.pbOwnedByPlayer?(@index)
    
    disobedient = false
    happiness = @pokemon.happiness
    MOTOConfig::DISOBEY_CHANCES.each do |range, chance|
      if range.include?(happiness)
        roll = @battle.pbRandom(100)
        echoln "Battle Disobedience Results:  Happiness: #{happiness}, Chance to disobey: #{chance}, Random roll: #{roll}"
        disobedient = true if roll < chance
        break
      end
    end
    
    badge_level = 10 * (@battle.pbPlayer.badge_count + 1)
    badge_level = GameData::GrowthRate.max_level if @battle.pbPlayer.badge_count >= 8
    if Settings::ANY_HIGH_LEVEL_POKEMON_CAN_DISOBEY ||
       (Settings::FOREIGN_HIGH_LEVEL_POKEMON_CAN_DISOBEY && @pokemon.foreign?(@battle.pbPlayer))
      if @level > badge_level
        a = ((@level + badge_level) * @battle.pbRandom(256) / 256).floor
        disobedient |= (a >= badge_level)
      end
    end
    
    disobedient |= !pbHyperModeObedience(choice[2])
    return true if !disobedient
    return pbDisobey(choice, badge_level)
  end
end
