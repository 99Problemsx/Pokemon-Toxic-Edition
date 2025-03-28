
#===============================================================================
# Raises all stats by 2 (For limit Break)
#===============================================================================
class Battle::Move::RaiseUserMainStats2 < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:ATTACK, 2, :DEFENSE, 2, :SPECIAL_ATTACK, 2, :SPECIAL_DEFENSE, 2, :SPEED, 2]
  end
end


#===============================================================================
# Limit Breaker
# Raises all stats by 2. Locks the user in and deals 1/8 damage to the user
#===============================================================================
class Battle::Move::RaiseUserMainStats2TrapUserInBattleHurt8th < Battle::Move::RaiseUserMainStats2
  def pbMoveFailed?(user, targets)
    if user.effects[PBEffects::LimitBreak]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return super
  end

  def pbEffectGeneral(user)
    super
    if !user.trappedInBattle?
      user.effects[PBEffects::LimitBreak] = true
      @battle.pbDisplay(_INTL("{1} can no longer escape because it used {2}!", user.pbThis, @name))
    end
  end
end

#===============================================================================
# Gold Hoard
# Sets up Gold Hoard (Boosts Dragon-Type moves)
#===============================================================================
class Battle::Move::SetUpGoldHoard < Battle::Move
  def canSnatch?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOwnSide.effects[PBEffects::GoldHoard] > 0
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOwnSide.effects[PBEffects::GoldHoard] = 5
    @battle.pbDisplay(_INTL("{1} set up a gold hoard, boosting {2}'s Dragon moves!", @name, user.pbTeam(true)))
  end
end