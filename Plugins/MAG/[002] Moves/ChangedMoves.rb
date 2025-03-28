#===============================================================================
# Gen 1 Hyper Beam
# If the target pokemon is knocked out then the user does not need to recharge.
#===============================================================================
class Battle::Move::AttackAndSkipNextTurn < Battle::Move
  def pbEffectAfterAllHits(user, target)
  if Settings::OLD_HYPERBEAM == true
    return if !target.damageState.fainted
    user.effects[PBEffects::HyperBeam] = 0
    user.currentMove = @id
  else
    user.effects[PBEffects::HyperBeam] = 2
    user.currentMove = @id
    end
  end
end

#===============================================================================
# Gen 1 Explosion
# Halves defense
#===============================================================================
class Battle::Move::UserFaintsExplosive < Battle::Move
  def worksWithNoTargets?;      return true; end
  def pbNumHits(user, targets); return 1;    end

  def pbMoveFailed?(user, targets)
    if !@battle.moldBreaker
      bearer = @battle.pbCheckGlobalAbility(:DAMP)
      if bearer
        @battle.pbShowAbilitySplash(bearer)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("{1} cannot use {2}!", user.pbThis, @name))
        else
          @battle.pbDisplay(_INTL("{1} cannot use {2} because of {3}'s {4}!",
                                  user.pbThis, @name, bearer.pbThis(true), bearer.abilityName))
        end
        @battle.pbHideAbilitySplash(bearer)
        return true
      end
    end
    return false
  end

  def pbSelfKO(user)
    return if user.fainted?
    user.pbReduceHP(user.hp, false)
    user.pbItemHPHealCheck
  end
  
  def pbModifyDamage(damageMult, user, target)
    damageMult *= 2 if Settings::OLD_EXPLOSION == false
    return damageMult
  end
end

################################################################################
# Multi Attack
# Deals an extra 30% damage to Ultra Beasts
################################################################################
class Battle::Move::TypeDependsOnUserMemory < Battle::Move
  def initialize(battle, move)
    super
    @itemTypes = {
      :FIGHTINGMEMORY => :FIGHTING,
      :FLYINGMEMORY   => :FLYING,
      :POISONMEMORY   => :POISON,
      :GROUNDMEMORY   => :GROUND,
      :ROCKMEMORY     => :ROCK,
      :BUGMEMORY      => :BUG,
      :GHOSTMEMORY    => :GHOST,
      :STEELMEMORY    => :STEEL,
      :FIREMEMORY     => :FIRE,
      :WATERMEMORY    => :WATER,
      :GRASSMEMORY    => :GRASS,
      :ELECTRICMEMORY => :ELECTRIC,
      :PSYCHICMEMORY  => :PSYCHIC,
      :ICEMEMORY      => :ICE,
      :DRAGONMEMORY   => :DRAGON,
      :DARKMEMORY     => :DARK,
      :FAIRYMEMORY    => :FAIRY
    }
  end

  def pbBaseType(user)
    ret = :NORMAL
    if user.item_id && user.itemActive?
      typ = @itemTypes[user.item_id]
      ret = typ if typ && GameData::Type.exists?(typ)
    end
    return ret
  end
  
  def pbBaseDamage(baseDmg, user, target)
    baseDmg *= 1.3 if target.pokemon.species_data.has_flag?("UltraBeast") && Settings::MAG_MULTIATTACK == true
    return baseDmg
  end
end

################################################################################
# Fly/Dig/Dive
# Attack the target before they are able to switch
################################################################################
class Battle
alias mag_pbPursuit pbPursuit
  def pbPursuit(idxSwitcher)
    @switching = true
    pbPriority.each do |b|
	  next if Settings::MAG_FLYDIGDIVE == false
      next if b.fainted? || !b.opposes?(idxSwitcher)   # Shouldn't hit an ally
      next if b.movedThisRound? || (!pbChoseMoveFunctionCode?(b.index, "TwoTurnAttackInvulnerableInSky") &&
	                                !pbChoseMoveFunctionCode?(b.index, "TwoTurnAttackInvulnerableUnderground") && 
									!pbChoseMoveFunctionCode?(b.index, "TwoTurnAttackInvulnerableUnderwater"))
      # Check whether Pursuit can be used
      next unless pbMoveCanTarget?(b.index, idxSwitcher, @choices[b.index][2].pbTarget(b))
      next unless pbCanChooseMove?(b.index, @choices[b.index][1], false)
      next if b.status == :SLEEP || b.status == :FROZEN
      next if b.effects[PBEffects::SkyDrop] >= 0
      next if b.hasActiveAbility?(:TRUANT) && b.effects[PBEffects::Truant]
      # Mega Evolve
      if !b.wild?
        owner = pbGetOwnerIndexFromBattlerIndex(b.index)
        pbMegaEvolve(b.index) if @megaEvolution[b.idxOwnSide][owner] == b.index
      end
      # Use Pursuit
      @choices[b.index][3] = idxSwitcher   # Change Pursuit's target
      b.pbProcessTurn(@choices[b.index], false)
      break if @decision > 0 || @battlers[idxSwitcher].fainted?
    end
    @switching = false
  end
end

#===============================================================================
# Tri Attack
# Each hit is it's own attack
#===============================================================================
class Battle::Move::HitThreeTimesTriAttack < Battle::Move
  def multiHitMove?;                   return true; end
  def pbNumHits(user, targets);        return 3; end
  
  def pbEffectWhenDealingDamage(user, target)
    user.effects[PBEffects::Test] += 1
  end
  
def pbCalcTypeModSingle(moveType, defType, user, target)
    ret = super
    if GameData::Type.exists?(:FIRE) && user.effects[PBEffects::Test] == 1
      ret *= Effectiveness.calculate(:FIRE, defType)
	elsif GameData::Type.exists?(:ELECTRIC) && user.effects[PBEffects::Test] == 2
      ret *= Effectiveness.calculate(:ELECTRIC, defType)
	elsif GameData::Type.exists?(:ICE) && user.effects[PBEffects::Test] == 3
      ret *= Effectiveness.calculate(:ICE, defType)
	  end
    return ret
end
   
#   def pbEffectAgainstTarget(user, target)
#   if target.pbCanParalyze?(user, false, self) && user.effects[PBEffects::Test] == 2
#	   target.pbParalyze(user)
#    end
#  end
   
  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    t = pbBaseType(user)
     user.effects[PBEffects::Test] if t == :FIRE   # Type-specific anims
     user.effects[PBEffects::Test] if t == :ELECTRIC
     user.effects[PBEffects::Test] if t == :ICE
    super
  end
end