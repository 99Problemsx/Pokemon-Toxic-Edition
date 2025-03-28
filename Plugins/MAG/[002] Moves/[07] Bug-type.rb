#===============================================================================
# Pollen Blast
#===============================================================================
class Battle::Move::LeechSeedGrassSpeed < Battle::Move
  
  def pbFailsAgainstTarget?(user, target, show_message)
    if target.pbHasType?(:GRASS)
      @battle.pbDisplay(_INTL("{1} feels energised after being pollenised!", target.pbThis(true))) if show_message
	       if target.pbCanRaiseStatStage?(:SPEED, user, self)
        target.pbRaiseStatStage(:SPEED, 2, user)
	       end
    return true
    end
    return false
  end
  
  def pbAdditionalEffect(user, target)
  return if target.effects[PBEffects::LeechSeed] >= 0
    target.effects[PBEffects::LeechSeed] = user.index
    @battle.pbDisplay(_INTL("{1} was seeded!", target.pbThis))
	end
  end
#===============================================================================
# Beetle Armor
#=============================================================================== 
class Battle::Move::RaiseUserDefSDef1LowerSpeed1 < Battle::Move
  attr_reader :statUp, :statDown

  def canSnatch?; return true; end

  def initialize(battle, move)
    super
    @statDown = [:SPEED, 1]
    @statUp   = [:DEFENSE, 1, :SPECIAL_DEFENSE, 1]
  end

  def pbMoveFailed?(user, targets)
    failed = true
    (@statUp.length / 2).times do |i|
      if user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
        failed = false
        break
      end
    end
    (@statDown.length / 2).times do |i|
      if user.pbCanLowerStatStage?(@statDown[i * 2], user, self)
        failed = false
        break
      end
    end
    if failed
      @battle.pbDisplay(_INTL("{1}'s stats can't be changed further!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    showAnim = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      if user.pbRaiseStatStage(@statUp[i * 2], @statUp[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
    showAnim = true
    (@statDown.length / 2).times do |i|
      next if !user.pbCanLowerStatStage?(@statDown[i * 2], user, self)
      if user.pbLowerStatStage(@statDown[i * 2], @statDown[(i * 2) + 1], user, showAnim)
        showAnim = false
      end
    end
  end
end
