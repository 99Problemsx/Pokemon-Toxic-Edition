class Battle
  def pbCanSwitchIn?(idxBattler, idxParty, partyScene = nil)
    return true if idxParty < 0
    party = pbParty(idxBattler)
    return false if idxParty >= party.length
    return false if !party[idxParty]
    pkmn = party[idxParty]

    @refusal_checked ||= {} 
    if @refusal_checked[idxParty]
      echoln("Refusal mechanic locked for #{pkmn.name} until end of battle")
      return true  
    end

    if pkmn.egg?
      partyScene&.pbDisplay(_INTL("An Egg can't battle!"))
      return false
    end
    if !pbIsOwner?(idxBattler, idxParty)
      if partyScene
        owner = pbGetOwnerFromPartyIndex(idxBattler, idxParty)
        partyScene.pbDisplay(_INTL("You can't switch {1}'s Pokémon with one of yours!", owner.name))
      end
      return false
    end
    if pkmn.fainted?
      partyScene&.pbDisplay(_INTL("{1} has no energy left to battle!", pkmn.name))
      return false
    end
    if pbFindBattler(idxParty, idxBattler)
      partyScene&.pbDisplay(_INTL("{1} is already in battle!", pkmn.name))
      return false
    end
    if pkmn.happiness < MOTOConfig::HAPPINESS_THRESHOLD
      refusal_chance = MOTOConfig::DISOBEY_SWITCH_CHANCE
      random_value = rand(100)
      echoln("Random Roll: #{random_value} vs set happiness: #{MOTOConfig::HAPPINESS_THRESHOLD}/ If roll is higher, success")
      if random_value < refusal_chance
        echoln("#{pkmn.name} refuses to battle!")
        partyScene&.pbDisplay(_INTL("{1} is refusing to battle!", pkmn.name))
        if pbConfirmMessage(_INTL("Do you want to force {1} out?", pkmn.name))
          pbForceSwitchIn(pkmn, idxParty, partyScene)  
          return true
        else
          @refusal_checked[idxParty] = true 
          return false
        end
      else
        echoln("#{pkmn.name} agrees to battle.")
        @refusal_checked[idxParty] = true
        return true
      end
    end
    @refusal_checked[idxParty] = true 
    return true
  end


  def pbForceSwitchIn(pkmn, idxParty, partyScene)
    pkmn.happiness = [pkmn.happiness - 10, 0].max
    partyScene&.pbDisplay(_INTL("{1} is upset with you!", pkmn.name))
     @refusal_checked[idxParty] = true  
    return true
  end
end
