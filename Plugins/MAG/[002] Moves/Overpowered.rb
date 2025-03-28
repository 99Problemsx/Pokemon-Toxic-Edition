#===============================================================================
	# Spiral Abyss
#===============================================================================
class Battle::Move::OPSpiralAbyss < Battle::Move
	def pbFailsAgainstTarget?(user, target, show_message)
		@statArray = []
		GameData::Stat.each_battle do |s|
			@statArray.push(s.id) if target.pbCanLowerStatStage?(s.id, user, self)
		end
		if @statArray.length == 0
			@battle.pbDisplay(_INTL("{1}'s stats won't go any lower!", target.pbThis)) if show_message
			return true
		end
		return false
	end
	
	def pbEffectAgainstTarget(user, target)
		if @battle.pbRandom(100) < 25
			stat = @statArray[@battle.pbRandom(@statArray.length)]
			target.pbLowerStatStage(stat, 1, user)
		end
	end
	
	def pbAdditionalEffect(user, target)
		return if target.damageState.substitute
		case @battle.pbRandom(5)
			when 0 then target.pbBurn(user) if target.pbCanBurn?(user, false, self)
			when 1 then target.pbFreeze if target.pbCanFreeze?(user, false, self)
			when 2 then target.pbParalyze(user) if target.pbCanParalyze?(user, false, self)
			when 3 then target.pbPoison(user) if target.pbCanPoison?(user, false, self)
			when 4 then target.pbSleep(user) if target.pbCanSleep?(user, false, self)
		end
	end
end
#===============================================================================
	# Enchanting Cone
#===============================================================================
class Battle::Move::OPEnchantingCone < Battle::Move
	def pbAdditionalEffect(user, target)
	return if target.damageState.substitute
    return if target.fainted?
		target.pbAttract(user)
	end
end

#===============================================================================
	# Prohibitory Signboard
#===============================================================================
class Battle::Move::OPProhibitorySignboard < Battle::Move
  def pbDisplayChargeMessage(user)
    user.effects[PBEffects::ProhibitorySignboard] = true
    @battle.pbCommonAnimation("FocusPunch", user)
    @battle.pbDisplay(_INTL("{1} set up a magical barrier!", user.pbThis))
  end

  def pbDisplayUseMessage(user)
    super if !user.effects[PBEffects::ProhibitorySignboard] || !user.tookMoveDamageThisRound
  end

  def pbMoveFailed?(user, targets)
    if user.effects[PBEffects::ProhibitorySignboard] && user.tookMoveDamageThisRound
      @battle.pbDisplay(_INTL("{1} barrier was broken and a curse was placed!", user.pbThis))
      return true
    end
    return false
  end
  
	def pbAdditionalEffect(user, target)
    if target.pbCanParalyze?(user, false, self)
      target.pbParalyze(user)
	end
end
	end
#===============================================================================
	# Walpurgis Night
#===============================================================================
class Battle::Move::OPWalpurgisNight < Battle::Move
  def multiHitMove?; return true; end

  def pbMoveFailed?(user, targets)
    @beatUpList = []
    @battle.eachInTeamFromBattlerIndex(user.index) do |pkmn, i|
      next if pkmn.able?
      @beatUpList.push(i)
    end
    if @beatUpList.length == 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbNumHits(user, targets)
    return @beatUpList.length
  end

  def pbBaseDamage(baseDmg, user, target)
    i = @beatUpList.shift   # First element in array, and removes it from array
    atk = @battle.pbParty(user.index)[i].baseStats[:ATTACK]
    return 5 + (atk / 10)
  end
end


#===============================================================================
	# Creeping Mycelium
#===============================================================================
class Battle::Move::OPCreepingMycelium < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::Miasma] && user.pbOwnSide.effects[PBEffects::Miasma]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
  if user.pbOpposingSide.effects[PBEffects::Miasma] == false
    user.pbOpposingSide.effects[PBEffects::Miasma] = true
    @battle.pbDisplay(_INTL("Magical miasma is in the air around {1}!",
                            user.pbOpposingTeam(true)))
  end
  if user.pbOwnSide.effects[PBEffects::Miasma] == false
    user.pbOwnSide.effects[PBEffects::Miasma] = true
    @battle.pbDisplay(_INTL("Magical miasma is in the air around {1}!",
                            user.pbTeam(true)))
  end
  end
end

#===============================================================================
	# Ultimate Dream
#===============================================================================
class Battle::Move::OPUltimateDream < Battle::Move
  def ignoresSubstitute?(user); return true; end
  def usableWhenAsleep?; return true; end
  def healingMove?; return Settings::MECHANICS_GENERATION >= 6; end

  def pbEffectGeneral(user)
  if !user.asleep?
   if user.effects[PBEffects::Substitute] == 0
	@subLife = [user.totalhp / 4, 1].max
	user.effects[PBEffects::Trapping]     = 0
    user.effects[PBEffects::TrappingMove] = nil
    user.effects[PBEffects::Substitute]   = @subLife
    @battle.pbDisplay(_INTL("{1} put in a substitute!", user.pbThis))
	end
  end
  end

  def pbEffectAgainstTarget(user, target)
  if user.asleep?
    return if target.damageState.hpLost <= 0
    hpGain = (target.damageState.hpLost / 2.0).round
    user.pbRecoverHPFromDrain(hpGain, target)
    user.pbOwnSide.effects[PBEffects::AuroraVeil] = 5
    user.pbOwnSide.effects[PBEffects::AuroraVeil] = 8 if user.hasActiveItem?(:LIGHTCLAY)
    @battle.pbDisplay(_INTL("{1} made {2} stronger against physical and special moves!",
                            @name, user.pbTeam(true)))
  end
  end
  
  def pbCalcDamage(user, target, numTargets = 1)
  if !user.asleep?
    if target.hasRaisedStatStages?
		pbShowAnimation(@id, user, target, 1)   # Stat stage-draining animation
      @battle.pbDisplay(_INTL("{1} stole the target's boosted stats!", user.pbThis))
      showAnim = true
      GameData::Stat.each_battle do |s|
        next if target.stages[s.id] <= 0
        if user.pbCanRaiseStatStage?(s.id, user, self)
          showAnim = false if user.pbRaiseStatStage(s.id, target.stages[s.id], user, showAnim)
        end
        target.statsLoweredThisRound = true
        target.statsDropped = true
        target.stages[s.id] = 0
      end
    end
  end
    super
  end
end

#===============================================================================
	# All the Myriad Dreams of Paradise
#===============================================================================
class Battle::Move::OPAllTheMyraidDreamsOfParadise < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:ATTACK, 2, :DEFENSE, 2, :SPECIAL_ATTACK, 2, :SPECIAL_DEFENSE, 2, :SPEED, 2]
  end
  
   def pbEffectGeneral(user)
  if !user.effects[PBEffects::AquaRing]
    user.effects[PBEffects::AquaRing] = true
    @battle.pbDisplay(_INTL("{1} surrounded itself with a veil of water!", user.pbThis))
  end
  if user.effects[PBEffects::FocusEnergy] == 0
  user.effects[PBEffects::FocusEnergy] = 2
  @battle.pbDisplay(_INTL("{1} is getting pumped!", user.pbThis))
  end
  if !user.effects[PBEffects::Endure]
    user.effects[PBEffects::Endure] = true
	@battle.pbDisplay(_INTL("{1} braced itself!", user.pbThis))
  end
 end
  
end