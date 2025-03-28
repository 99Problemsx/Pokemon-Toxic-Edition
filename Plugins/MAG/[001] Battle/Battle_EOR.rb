  #-----------------------------------------------------------------------------
  # Resets various effects at the end of round.
  #-----------------------------------------------------------------------------
  class Battle
  
 alias mag_pbEOREndBattlerEffects pbEOREndBattlerEffects
  def pbEOREndBattlerEffects(priority)
    # Magic Tampering
    pbEORCountDownBattlerEffect(priority, PBEffects::MagicTampering) do |battler|
      pbDisplay(_INTL("{1}'s magic is back!", battler.pbThis))
    end
	mag_pbEOREndBattlerEffects(priority)
end

 alias mag_pbEOREndSideEffects pbEOREndSideEffects
  def pbEOREndSideEffects(side, priority)
     pbEORCountDownSideEffect(side, PBEffects::GoldHoard,
                                _INTL("{1}'s gold hoard wore off!", @battlers[side].pbTeam))
    mag_pbEOREndSideEffects(side, priority)
  end
	
 alias mag_pbEndOfRoundPhase pbEndOfRoundPhase
  def pbEndOfRoundPhase
    mag_pbEndOfRoundPhase
    priority = pbPriority(true)
	# Queen's Shield
    allBattlers.each_with_index do |battler, i|
	  battler.effects[PBEffects::QueensShield] = false
	  battler.effects[PBEffects::ProhibitorySignboard] = false
  end
	priority.each do |battler|
	if battler.status == :FATIGUE
	battler.pbContinueStatus
	#pbDisplay(_INTL("{1} is starting to feel the fatigue", battler.pbThis))
	  battler.pbLowerStatStage(:ATTACK, 1, nil) if battler.pbCanLowerStatStage?(:ATTACK)
	end
	old_status = battler.status
	case old_status
	when :WINDED
	  battler.statusCount -= 1
      if battler.statusCount <= 0
       battler.pbCureStatus(true)
	  end
	when :VERTIGO
	next if pbRandom(100) < 70
	if battler.pbCanConfuseSelf?(false)
      battler.pbConfuse(_INTL("{1} became confused due to vertigo!", battler.pbThis))
	  end
	when :SCARED
	next if pbRandom(100) < 75
	newPkmn = pbGetReplacementPokemonIndex(battler.index, true)
	pbDisplay(_INTL("{1} got scared and switched out!", battler.pbThis))
    pbRecallAndReplace(battler.index, newPkmn, true)
    pbClearChoice(battler.index)
    moldBreaker = false
    pbOnBattlerEnteringBattle(battler.index)
	when :ALLERGIES
	battler.pbContinueStatus
	rand = pbRandom(3)
	if rand == 0
	  battler.pbLowerStatStage(:SPEED, 1, nil) if battler.pbCanLowerStatStage?(:SPEED)
	elsif rand == 1
	  battler.pbLowerStatStage(:DEFENSE, 1, nil) if battler.pbCanLowerStatStage?(:DEFENSE)
	elsif rand == 2
	  battler.pbLowerStatStage(:SPECIAL_DEFENSE, 1, nil) if battler.pbCanLowerStatStage?(:SPECIAL_DEFENSE)
	  end
	when :OPULENT
	  battler.pbContinueStatus
	when :BLINDED	  
	battler.statusCount -= 1
      if battler.statusCount <= 0
       battler.pbCureStatus(true)
	  else
	   battler.pbContinueStatus
	  end
	end
 end
  	2.times do |side|	
	     @sides[side].effects[PBEffects::FaintedLast]      -= 1 if @sides[side].effects[PBEffects::FaintedLast] > 0
  end
end
 
 alias mag_pbEOREffectDamage pbEOREffectDamage
  def pbEOREffectDamage(priority)
    priority.each do |battler|
      next if !battler.effects[PBEffects::LimitBreak] || !battler.takesIndirectDamage?
      battler.pbTakeEffectDamage(battler.totalhp / 4) do |hp_lost|
        pbDisplay(_INTL("{1} is exhausted from breaking it's limits!", battler.pbThis))
      end
    end
	mag_pbEOREffectDamage(priority)
  end
  
  
  alias mag_pbEOREndBattlerSelfEffects pbEOREndBattlerSelfEffects
  def pbEOREndBattlerSelfEffects(battler)
    mag_pbEOREndBattlerSelfEffects(battler)
    return if battler.fainted?
    if battler.effects[PBEffects::VinyHold] > 0
      battler.effects[PBEffects::VinyHold] -= 1
	battlerStats = battler.AttackStats
    highestStatValue = 0
    battlerStats.each_value { |value| highestStatValue = value if highestStatValue < value }
    [:ATTACK, :SPECIAL_ATTACK].each do |s|
      next if battlerStats[s] < highestStatValue
      if battler.pbCanLowerStatStage?(s, battler)
        battler.pbLowerStatStage(s, 1, battler)
      end
      break
    end  
      pbDisplay(_INTL("{1} was freed from the restrictive vines!", battler.pbThis)) if battler.effects[PBEffects::VinyHold] == 0
    end
  end
end