class Battle::Battler
alias mag_pbInitEffects pbInitEffects
  def pbInitEffects(batonPass)
    mag_pbInitEffects(batonPass)
  @effects[PBEffects::QueensShield]      = false
  @effects[PBEffects::MagicTampering]    = 0
  @effects[PBEffects::LimitBreak]        = false
  @effects[PBEffects::Vengence]          = 0
  @effects[PBEffects::VinyHold]          = 0
  @effects[PBEffects::BallFetch]         = false
  @effects[PBEffects::ProhibitorySignboard] = false

  
  end

  def AttackStats
    ret = {}
    ret[:ATTACK]          = self.attack
    ret[:SPECIAL_ATTACK]  = self.spatk
    return ret
  end
  
alias mag_pbSuccessCheckAgainstTarget pbSuccessCheckAgainstTarget  
def pbSuccessCheckAgainstTarget(move, user, target, targets)
# Queens's Shield
        if target.effects[PBEffects::QueensShield] && move.damagingMove?
          if move.pbShowFailMessages?(targets)
            @battle.pbCommonAnimation("QueensShield", target)
            @battle.pbDisplay(_INTL("{1} protected itself!", target.pbThis))
          end
          target.damageState.protected = true
          @battle.successStates[user.index].protected = true
          if move.specialMove? &&
             user.pbCanLowerStatStage?(:SPECIAL_ATTACK, target)
            user.pbLowerStatStage(:SPECIAL_ATTACK, 2, target)
          end
          return false
        end
	if user.hasActiveAbility?(:ARCANEMAGE) && target.pbHasType?(:DARK) && 
	(move.calcType == :ELECTRIC || move.calcType == :FIRE || move.calcType == :ICE)
	@battle.pbDisplay(_INTL("{1} is immune to {2}'s magic!", target.pbThis, user.pbThis))
	  return false
	end
	    ret = mag_pbSuccessCheckAgainstTarget(move, user, target, targets)
    if ret
      Battle::AbilityEffects.triggerOnMoveSuccessCheck(
        target.ability, user, target, move, @battle)
    end
    return ret
 end
  
alias mag_pbCanChooseMove? pbCanChooseMove?    
  def pbCanChooseMove?(move, commandPhase, showMessages = true, specialUsage = false)
    # Magic Tampering
    if @effects[PBEffects::MagicTampering] > 0 && move.calcType == :FAIRY && !specialUsage
      if showMessages
        msg = _INTL("{1} can't use {2} after tampering!", pbThis, move.name)
        (commandPhase) ? @battle.pbDisplayPaused(msg) : @battle.pbDisplay(msg)
      end
      return false
    end
# Choice Band/Gorilla Tactics
    @effects[PBEffects::ChoiceBand] = nil if !pbHasMove?(@effects[PBEffects::ChoiceBand])
    if @effects[PBEffects::ChoiceBand] && move.id != @effects[PBEffects::ChoiceBand]
      choiced_move = GameData::Move.try_get(@effects[PBEffects::ChoiceBand])
      if choiced_move
        if hasActiveItem?([:CHOICEBAND, :CHOICESPECS, :CHOICESCARF])
          if showMessages
            msg = _INTL("The {1} only allows the use of {2}!", itemName, choiced_move.name)
            (commandPhase) ? @battle.pbDisplayPaused(msg) : @battle.pbDisplay(msg)
          end
          return false
        elsif hasActiveAbility?(:GORILLATACTICS, :MONKEYBUSINESS)
          if showMessages
            msg = _INTL("{1} can only use {2}!", pbThis, choiced_move.name)
            (commandPhase) ? @battle.pbDisplayPaused(msg) : @battle.pbDisplay(msg)
          end
          return false
        end
      end
    end
    return mag_pbCanChooseMove?(move, commandPhase, showMessages, specialUsage)
  end

alias mag_pbEffectsOnMakingHit pbEffectsOnMakingHit
def pbEffectsOnMakingHit(move, user, target)
    if user.status == :BRITTLE && move.contactMove?
	  user.pbReduceHP(user.totalhp / 8, false) if user.pbHasType?(:STEEL)
	  user.pbReduceHP(user.totalhp / 16, false)
	  @battle.pbDisplay(_INTL("{1} hurt itself from being brittle!", user.pbThis))
	end
    if user.pbOwnSide.effects[PBEffects::RoseField] && move.contactMove? && 
       GameData::Type.exists?(:GRASS)
      bTypes = user.pbTypes(true)
      eff = Effectiveness.calculate(:GRASS, *bTypes)
      if !Effectiveness.ineffective?(eff)
        user.pbReduceHP(user.totalhp * eff / 8, false)
        @battle.pbDisplay(_INTL("{1} was hurt by the thorns in the rose garden!", user.pbThis))
        user.pbItemHPHealCheck
       end
	 end
	return mag_pbEffectsOnMakingHit(move, user, target)
  end 

alias mag_hasMoldBreaker? hasMoldBreaker?
  def hasMoldBreaker?
   mag_hasMoldBreaker?
    return hasActiveAbility?([:FROZENYIN, :FROZENYANG])
  end  

alias mag_pbRemoveItem pbRemoveItem
  def pbRemoveItem(permanent = true)
    @lastRoundMoved = @battle.turnCount   # Done something this round
    if !@effects[PBEffects::ChoiceBand] && hasActiveAbility?(:MONKEYBUSINESS)
      if @lastMoveUsed && pbHasMove?(@lastMoveUsed)
        @effects[PBEffects::ChoiceBand] = @lastMoveUsed
      elsif @lastRegularMoveUsed && pbHasMove?(@lastRegularMoveUsed)
        @effects[PBEffects::ChoiceBand] = @lastRegularMoveUsed
      end
    end
	return mag_pbRemoveItem(permanent = true)
  end

alias mag_pbSpeed pbSpeed  
  def pbSpeed
   mag_pbSpeed
    return 1 if fainted?
    stage = @stages[:SPEED] + STAT_STAGE_MAXIMUM
    speed = @speed * STAT_STAGE_MULTIPLIERS[stage] / STAT_STAGE_DIVISORS[stage]
    speedMult = 1.0
    # Ability effects that alter calculated Speed
    if abilityActive?
      speedMult = Battle::AbilityEffects.triggerSpeedCalc(self.ability, self, speedMult)
    end
    # Item effects that alter calculated Speed
    if itemActive?
      speedMult = Battle::ItemEffects.triggerSpeedCalc(self.item, self, speedMult)
    end
    # Other effects
    speedMult *= 2 if pbOwnSide.effects[PBEffects::Tailwind] > 0
    speedMult /= 2 if pbOwnSide.effects[PBEffects::Swamp] > 0
    # Paralysis
    if status == :PARALYSIS && !hasActiveAbility?(:QUICKFEET)
      speedMult /= (Settings::MECHANICS_GENERATION >= 7) ? 2 : 4
    end
    if status == :DRENCHED
      speedMult /= 2
    end
    # Badge multiplier
    if @battle.internalBattle && pbOwnedByPlayer? &&
       @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_SPEED
      speedMult *= 1.1
    end
    # Calculation
    return [(speed * speedMult).round, 1].max
  end
  
alias mag_trappedInBattle? trappedInBattle?  
  def trappedInBattle?
   mag_trappedInBattle?
    return true if @effects[PBEffects::LimitBreak]
	return true if @effects[PBEffects::VinyHold] > 0
	return true if @effects[PBEffects::Vengence] > 0
    return false
  end
end