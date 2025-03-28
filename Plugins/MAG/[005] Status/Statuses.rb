class Battle::Battler

alias mag_pbCanInflictStatus? pbCanInflictStatus?
def pbCanInflictStatus?(newStatus, user, showMessages, move = nil, ignoreStatus = false)
    originalStatus = newStatus
    return false if fainted?
	if [:FATIGUE, :WINDED, :VERTIGO, :SPINTERS, :PESTER, :SCARED, :BRITTLE,
	    :DRENCHED, :ALLERGIES, :MIGRAINE, :OPULENT, :BLINDED, :IDOLIZE].include?(newStatus)
    self_inflicted = (user && user.index == @index)   # Rest and Flame Orb/Toxic Orb only
    # Already have that status problem
    if self.status == newStatus && !ignoreStatus
      if showMessages
        msg = ""
        case self.status
        when :FATIGUE     then msg = _INTL("{1} is already fatigue!", pbThis)
        when :WINDED      then msg = _INTL("{1} is already winded!", pbThis)
        when :VERTIGO     then msg = _INTL("{1} already has vertigo!", pbThis)
        when :SPLINTER    then msg = _INTL("{1} already has splinters!", pbThis)
        when :PESTER      then msg = _INTL("{1} is already being pestered!", pbThis)
        when :SCARED      then msg = _INTL("{1} is already scared!", pbThis)
        when :BRITTLE     then msg = _INTL("{1} is already brittle!", pbThis)
        when :DRENCHED    then msg = _INTL("{1} is already drenched!", pbThis)
        when :ALLERGIES   then msg = _INTL("{1} already has allergies!", pbThis)
        when :MIGRAINE    then msg = _INTL("{1} already has a migraine!", pbThis)
        when :OPULENT     then msg = _INTL("{1} is already being greedy!", pbThis)
        when :BLINDED     then msg = _INTL("{1} is already blinded!", pbThis)
        when :IDOLIZE     then msg = _INTL("{1} is already infatuated!", pbThis)
        end
        @battle.pbDisplay(msg)
      end
      return false
    end

    if self.status != :NONE && !ignoreStatus && !(self_inflicted && move)   # Rest can replace a status problem
      @battle.pbDisplay(_INTL("It doesn't affect {1}...", pbThis(true))) if showMessages
      return false
    end	

    if @effects[PBEffects::Substitute] > 0 && !(move && move.ignoresSubstitute?(user)) &&
       !self_inflicted
      @battle.pbDisplay(_INTL("It doesn't affect {1}...", pbThis(true))) if showMessages
      return false
    end

    # Type immunities
    hasImmuneType = false
    case newStatus
    when :FATIGUE
    when :WINDED
    when :VERTIGO
    when :SPLINTER
    when :PESTER
	  hasImmuneType |= pbHasType?(:BUG)
    when :SCARED
	  hasImmuneType |= pbHasType?(:GHOST)
    when :BRITTLE
    when :DRENCHED
	  hasImmuneType |= pbHasType?(:WATER)
    when :ALLERGIES
	  hasImmuneType |= pbHasType?(:GRASS)
    when :MIGRAINE
    when :OPULENT
    when :BLINDED
    when :IDOLIZE
    end
    if hasImmuneType
      @battle.pbDisplay(_INTL("It doesn't affect {1}...", pbThis(true))) if showMessages
      return false
    end
    # Ability immunity
    immuneByAbility = false
    immAlly = nil
    if Battle::AbilityEffects.triggerStatusImmunityNonIgnorable(self.ability, self, newStatus)
      immuneByAbility = true
    elsif self_inflicted || !@battle.moldBreaker
      if abilityActive? && Battle::AbilityEffects.triggerStatusImmunity(self.ability, self, newStatus)
        immuneByAbility = true
      else
        allAllies.each do |b|
          next if !b.abilityActive?
          next if !Battle::AbilityEffects.triggerStatusImmunityFromAlly(b.ability, self, newStatus)
          immuneByAbility = true
          immAlly = b
          break
        end
      end
    end
    if immuneByAbility
      if showMessages
        @battle.pbShowAbilitySplash(immAlly || self)
        msg = ""
        if Battle::Scene::USE_ABILITY_SPLASH
          case newStatus
          when :FATIGUE   then msg = _INTL("{1} cannot get fatigued!", pbThis)
          when :WINDED    then msg = _INTL("{1} cannot be winded!", pbThis)
          when :VERTIGO   then msg = _INTL("{1} keeps its balance!", pbThis)
          when :SPLINTER  then msg = _INTL("{1} cannot get splinters!", pbThis)
          when :PESTER    then msg = _INTL("{1} cannot be pestered!", pbThis)
          when :SCARED    then msg = _INTL("{1} cannot get scared!", pbThis)
          when :BRITTLE   then msg = _INTL("{1} cannot be brittle!", pbThis)
          when :DRENCHED  then msg = _INTL("{1} cannot be drenched!", pbThis)
          when :ALLERGIES then msg = _INTL("{1} cannot get allergies!", pbThis)
          when :MIGRAINE  then msg = _INTL("{1} cannot get migraines!", pbThis)
          when :OPULENT   then msg = _INTL("{1} cannot get greedy!", pbThis)
          when :BLINDED   then msg = _INTL("{1} cannot get blinded!", pbThis)
          when :IDOLIZE   then msg = _INTL("{1} cannot idolize the opponent!", pbThis)
          end
        elsif immAlly
          case newStatus
          when :FATIGUE
            msg = _INTL("{1} isn't fatigued because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :WINDED
            msg = _INTL("{1} cannot be winded because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :VERTIGO
            msg = _INTL("{1} kept its balance because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :SPLINTER
            msg = _INTL("{1} cannot get splinters because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :PESTER
            msg = _INTL("{1} cannot be pestered because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :SCARED
            msg = _INTL("{1} cannot get scared because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :BRITTLE
            msg = _INTL("{1} cannot be brittle because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :DRENCHED
            msg = _INTL("{1} cannot get drenched because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :ALLERGIES
            msg = _INTL("{1} cannot get allergies because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :MIGRAINE
            msg = _INTL("{1} cannot get migraines because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :OPULENT
            msg = _INTL("{1} cannot get greedy because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :BLINDED
            msg = _INTL("{1} cannot get blinded because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          when :IDOLIZE
            msg = _INTL("{1} cannot idolize because of {2}'s {3}!",
                        pbThis, immAlly.pbThis(true), immAlly.abilityName)
          end
        else
          case newStatus
          when :FATIGUE    then msg = _INTL("{1}'s {2} prevents fatigue!", pbThis, abilityName)
          when :WINDED     then msg = _INTL("{1}'s {2} prevents getting winded!", pbThis, abilityName)
          when :VERTIGO    then msg = _INTL("{1}'s {2} prevents vertigo!", pbThis, abilityName)
          when :SPLINTER   then msg = _INTL("{1}'s {2} prevents splinters!", pbThis, abilityName)
          when :PESTER     then msg = _INTL("{1}'s {2} prevents pestering!", pbThis, abilityName)
          when :SCARED     then msg = _INTL("{1}'s {2} prevents getting scared!", pbThis, abilityName)
          when :BRITTLE    then msg = _INTL("{1}'s {2} prevents getting brittle!", pbThis, abilityName)
          when :DRENCHED   then msg = _INTL("{1}'s {2} prevents getting drecnhed!", pbThis, abilityName)
          when :ALLERGIES  then msg = _INTL("{1}'s {2} prevents allergies!", pbThis, abilityName)
          when :MIGRAINE   then msg = _INTL("{1}'s {2} prevents migraine!", pbThis, abilityName)
          when :OPULENT    then msg = _INTL("{1}'s {2} prevents greed!", pbThis, abilityName)
          when :BLINDED    then msg = _INTL("{1}'s {2} prevents blinding!", pbThis, abilityName)
          when :IDOLIZE    then msg = _INTL("{1}'s {2} prevents idolization!", pbThis, abilityName)
          end
        end
        @battle.pbDisplay(msg)
        @battle.pbHideAbilitySplash(immAlly || self)
      end
      return false
    end
    # Safeguard immunity
    if pbOwnSide.effects[PBEffects::Safeguard] > 0 && !self_inflicted && move &&
       !(user && user.hasActiveAbility?(:INFILTRATOR))
      @battle.pbDisplay(_INTL("{1}'s team is protected by Safeguard!", pbThis)) if showMessages
      return false
    end
    return true
   else	
	return mag_pbCanInflictStatus?(newStatus, user, showMessages, move, ignoreStatus)
  end
end
	
alias mag_pbInflictStatus pbInflictStatus 
  def pbInflictStatus(newStatus, newStatusCount = 0, msg = nil, user = nil)
      self.status      = newStatus
      self.statusCount = newStatusCount
	  msg = ""
      @effects[PBEffects::Toxic] = 0
      anim_name = GameData::Status.get(newStatus).animation
      @battle.pbCommonAnimation(anim_name, self) if anim_name
      if msg && !msg.empty?
        @battle.pbDisplay(msg)
      else
      case newStatus
      when :FATIGUE
        @battle.pbDisplay(_INTL("{1} feels fatigued!", pbThis))
      when :WINDED
	    @battle.pbDisplay(_INTL("{1} had the wind knocked out of it!", pbThis))
      when :VERTIGO
	    @battle.pbDisplay(_INTL("{1} cannot stand up straight!", pbThis))
      when :SPLINTER
        @battle.pbDisplay(_INTL("Stoney splinters have dug into {1}!", pbThis))
      when :PESTER
	    @battle.pbDisplay(_INTL("{1} is feeling very itchy!", pbThis))
      when :SCARED
	    @battle.pbDisplay(_INTL("{1} cannot stand up straight!", pbThis))
      when :BRITTLE
        @battle.pbDisplay(_INTL("{1} joints feel very brittle!", pbThis))
      when :DRENCHED
	    @battle.pbDisplay(_INTL("{1} got drenched!", pbThis))
      when :ALLERGIES
	    @battle.pbDisplay(_INTL("{1} is starting to sneeze due to allergies!", pbThis))
      when :MIGRAINE
        @battle.pbDisplay(_INTL("{1} started to have a migraine!", pbThis))
      when :OPULENT
	    @battle.pbDisplay(_INTL("{1} is getting too greedy and leaking power!", pbThis))
      when :BLINDED
	    @battle.pbDisplay(_INTL("{1} has lost it's sight and cannot see!", pbThis))
      when :IDOLIZE
	    @battle.pbDisplay(_INTL("{1} began to idolize the opponent's team!", pbThis))
      end
    PBDebug.log("[Status change] #{pbThis}'s winded count is #{newStatusCount}") if newStatus == :WINDED
    # Form change check
    pbCheckFormOnStatusChange
    # Synchronize
    if abilityActive?
      Battle::AbilityEffects.triggerOnStatusInflicted(self.ability, self, user, newStatus)
    end
    # Status cures
    pbItemStatusCureCheck
    pbAbilityStatusCureCheck
	mag_pbInflictStatus(newStatus, newStatusCount, msg, user)
   end
 end
#-----------------------------------------------------------------
 # Fatigue
#-----------------------------------------------------------------
  def fatigue?
    return pbHasStatus?(:FATIGUE)
  end

  def pbCanFatigue?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:FATIGUE, user, showMessages, move)
  end

  def pbCanFatigueSynchronize?(target)
    return pbCanSynchronizeStatus?(:FATIGUE, target)
  end

  def pbFatigue(user = nil, msg = nil)
    pbInflictStatus(:FATIGUE, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Winded
#-----------------------------------------------------------------
  def winded?
    return pbHasStatus?(:WINDED)
  end

  def pbCanWinded?(user, showMessages, move = nil, ignoreStatus = false)
    return pbCanInflictStatus?(:WINDED, user, showMessages, move, ignoreStatus)
  end

  def pbCanWindedSynchronize?(target)
    return pbCanSynchronizeStatus?(:WINDED, target)
  end

  def pbWinded(msg = nil)
    pbInflictStatus(:WINDED, pbWindedDuration, msg)
  end
  
  def pbWindedDuration(duration = -1)
    duration = 2 + @battle.pbRandom(3) if duration <= 0
	return duration
  end
#-----------------------------------------------------------------
 # Vertigo
#-----------------------------------------------------------------
  def vertigo?
    return pbHasStatus?(:VERTIGO)
  end

  def pbCanVertigo?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:VERTIGO, user, showMessages, move)
  end

  def pbCanVertigoSynchronize?(target)
    return pbCanSynchronizeStatus?(:VERTIGO, target)
  end

  def pbVertigo(user = nil, msg = nil)
    pbInflictStatus(:VERTIGO, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Splinter
#-----------------------------------------------------------------
  def splinter?
    return pbHasStatus?(:SPLINTER)
  end

  def pbCanSplinter?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:SPLINTER, user, showMessages, move)
  end

  def pbCanSplinterSynchronize?(target)
    return pbCanSynchronizeStatus?(:SPLINTER, target)
  end

  def pbSplinter(user = nil, msg = nil)
    pbInflictStatus(:SPLINTER, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Pester
#-----------------------------------------------------------------
  def pester?
    return pbHasStatus?(:PESTER)
  end

  def pbCanPester?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:PESTER, user, showMessages, move)
  end

  def pbCanPesterSynchronize?(target)
    return pbCanSynchronizeStatus?(:PESTER, target)
  end

  def pbPester(user = nil, msg = nil)
    pbInflictStatus(:PESTER, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Scared
#-----------------------------------------------------------------
  def scared?
    return pbHasStatus?(:SCARED)
  end

  def pbCanScared?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:SCARED, user, showMessages, move)
  end

  def pbCanScaredSynchronize?(target)
    return pbCanSynchronizeStatus?(:SCARED, target)
  end

  def pbScared(user = nil, msg = nil)
    pbInflictStatus(:SCARED, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Brittle
#-----------------------------------------------------------------
  def brittle?
    return pbHasStatus?(:BRITTLE)
  end

  def pbCanBrittle?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:BRITTLE, user, showMessages, move)
  end

  def pbCanBrittleSynchronize?(target)
    return pbCanSynchronizeStatus?(:BRITTLE, target)
  end

  def pbBrittle(user = nil, msg = nil)
    pbInflictStatus(:BRITTLE, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Drenched
#-----------------------------------------------------------------
  def drenched?
    return pbHasStatus?(:DRENCHED)
  end

  def pbCanDrenched?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:DRENCHED, user, showMessages, move)
  end

  def pbCanDrenchedSynchronize?(target)
    return pbCanSynchronizeStatus?(:DRENCHED, target)
  end

  def pbDrenched(user = nil, msg = nil)
    pbInflictStatus(:DRENCHED, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Allergies
#-----------------------------------------------------------------
  def allergies?
    return pbHasStatus?(:ALLERGIES)
  end

  def pbCanAllergies?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:ALLERGIES, user, showMessages, move)
  end

  def pbCanAllergiesSynchronize?(target)
    return pbCanSynchronizeStatus?(:ALLERGIES, target)
  end

  def pbAllergies(user = nil, msg = nil)
    pbInflictStatus(:ALLERGIES, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Migraine
#-----------------------------------------------------------------
  def migraine?
    return pbHasStatus?(:MIGRAINE)
  end

  def pbCanMigraine?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:MIGRAINE, user, showMessages, move)
  end

  def pbCanMigraineSynchronize?(target)
    return pbCanSynchronizeStatus?(:MIGRAINE, target)
  end

  def pbMigraine(user = nil, msg = nil)
    pbInflictStatus(:MIGRAINE, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Opulent
#-----------------------------------------------------------------
  def opulent?
    return pbHasStatus?(:OPULENT)
  end

  def pbCanOpulent?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:OPULENT, user, showMessages, move)
  end

  def pbCanOpulentSynchronize?(target)
    return pbCanSynchronizeStatus?(:OPULENT, target)
  end

  def pbOpulent(user = nil, msg = nil)
    pbInflictStatus(:OPULENT, 0, msg, user)
  end
#-----------------------------------------------------------------
 # Blinded
#-----------------------------------------------------------------
  def blinded?
    return pbHasStatus?(:BLINDED)
  end

  def pbCanBlinded?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:BLINDED, user, showMessages, move)
  end

  def pbCanBlindedSynchronize?(target)
    return pbCanSynchronizeStatus?(:BLINDED, target)
  end

  def pbBlinded(user = nil, msg = nil)
    pbInflictStatus(:BLINDED, pbBlindedDuration, msg, user)
  end
  
  def pbBlindedDuration(duration = -1)
    duration = 2 + @battle.pbRandom(3) if duration <= 0
    return duration
  end
#-----------------------------------------------------------------
 # Idolize
#-----------------------------------------------------------------
  def idolize?
    return pbHasStatus?(:IDOLIZE)
  end

  def pbCanIdolize?(user, showMessages, move = nil)
    return pbCanInflictStatus?(:IDOLIZE, user, showMessages, move)
  end

  def pbCanIdolizeSynchronize?(target)
    return pbCanSynchronizeStatus?(:IDOLIZE, target)
  end

  def pbIdolize(user = nil, msg = nil)
    pbInflictStatus(:IDOLIZE, 0, msg, user)
  end

#-----------------------------------------------------------------
 # Cure Status
#-----------------------------------------------------------------
alias mag_pbCureStatus pbCureStatus
  def pbCureStatus(showMessages = true)
  if [:FATIGUE, :WINDED, :VERTIGO, :SPINTERS, :PESTER, :SCARED, :BRITTLE,
      :DRENCHED, :ALLERGIES, :MIGRAINE, :OPULENT, :BLINDED, :IDOLIZE].include?(self.status)
    oldStatus = status
    self.status = :NONE
    if showMessages
      case oldStatus
      when :FATIGUE       then @battle.pbDisplay(_INTL("{1}'s fatigue has worn off!", pbThis))
      when :WINDED        then @battle.pbDisplay(_INTL("{1} got its breath back.", pbThis))
      when :VERTIGO       then @battle.pbDisplay(_INTL("{1} got its balance!", pbThis))
      when :SPLINTER      then @battle.pbDisplay(_INTL("{1} removed its splinters.", pbThis))
      when :PESTER        then @battle.pbDisplay(_INTL("{1} is no longer itchy.", pbThis))
	  when :SCARED        then @battle.pbDisplay(_INTL("{1} is no longer scared!", pbThis))
      when :BRITTLE       then @battle.pbDisplay(_INTL("{1} feels strong again!", pbThis))
      when :DRENCHED      then @battle.pbDisplay(_INTL("{1} has finally dried off!", pbThis))
      when :ALLERGIES     then @battle.pbDisplay(_INTL("{1} got over its allergies!", pbThis))
	  when :MIGRAINE      then @battle.pbDisplay(_INTL("{1} recovered from its migraine.", pbThis))
      when :OPULENT       then @battle.pbDisplay(_INTL("{1} got over its greed.", pbThis))
      when :BLINDED       then @battle.pbDisplay(_INTL("{1} can see again!", pbThis))
      when :IDOLIZE       then @battle.pbDisplay(_INTL("{1} got over the other team!", pbThis))
      end
    end
    PBDebug.log("[Status change] #{pbThis}'s status was cured") if !showMessages
	else
	mag_pbCureStatus(showMessages)
  end
end  

#-----------------------------------------------------------------
 # Continue Status
#-----------------------------------------------------------------
alias mag_pbContinueStatus pbContinueStatus
  def pbContinueStatus
    if self.status == :POISON && @statusCount > 0
      @battle.pbCommonAnimation("Toxic", self)
    else
      anim_name = GameData::Status.get(self.status).animation
      @battle.pbCommonAnimation(anim_name, self) if anim_name
    end
    yield if block_given?
    case self.status
    when :FATIGUE
      @battle.pbDisplay(_INTL("{1} is still tired from being fatigued!", pbThis))
    when :WINDED
      @battle.pbDisplay(_INTL("{1} is winded and is catching its breath!", pbThis))
	  PBDebug.log("[Status continues] #{pbThis}'s winded count is #{@statusCount}")
    when :VERTIGO
      @battle.pbDisplay(_INTL("{1} still can't get its balance!", pbThis))
    when :SPLINTER
      @battle.pbDisplay(_INTL("{1} was hurt by its splinters!", pbThis))
    when :PESTER
      @battle.pbDisplay(_INTL("{1} was hurt due to itching too hard!", pbThis))
    when :SCARED
      @battle.pbDisplay(_INTL("{1} got too scared and switched out!", pbThis))
    when :BRITTLE
      @battle.pbDisplay(_INTL("{1} was too brittle to defend!", pbThis))
    when :DRENCHED
      @battle.pbDisplay(_INTL("{1} was hurt due to being drenched!", pbThis))
    when :ALLERGIES
      @battle.pbDisplay(_INTL("{1} is szeezing due to allergies!", pbThis))
    when :MIGRAINE
      @battle.pbDisplay(_INTL("{1} was hurt due to it's migraine!", pbThis))
    when :OPULENT
      @battle.pbDisplay(_INTL("{1} is still leaking power!", pbThis))
    when :BLINDED
      @battle.pbDisplay(_INTL("{1} still can't see!", pbThis))
    when :IDOLIZE
      @battle.pbDisplay(_INTL("{1} is too busy idolizing!", pbThis))
    end
	mag_pbContinueStatus
   end  
  end
  
class Battle  
alias mag_pbEORStatusProblemDamage pbEORStatusProblemDamage
  def pbEORStatusProblemDamage(priority)
    mag_pbEORStatusProblemDamage(priority)
    priority.each do |battler|
      next if battler.status != :SPLINTER || battler.status != :PESTER || !battler.takesIndirectDamage? 
      battler.droppedBelowHalfHP = false
      dmg = battler.totalhp / 16
      battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
      battler.pbItemHPHealCheck
      battler.pbAbilitiesOnDamageTaken
      battler.pbFaint if battler.fainted?
      battler.droppedBelowHalfHP = false
    end
    priority.each do |battler|
      next if battler.status != :PESTER || !battler.takesIndirectDamage? 
      battler.droppedBelowHalfHP = false
      dmg = battler.totalhp / 16
      battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
      battler.pbItemHPHealCheck
      battler.pbAbilitiesOnDamageTaken
      battler.pbFaint if battler.fainted?
      battler.droppedBelowHalfHP = false
    end
  end
end