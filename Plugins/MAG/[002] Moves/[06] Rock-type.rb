#===============================================================================
# Flicked Pebble
# The first turn the user enters battle, flinch target. +1 accuracy.
#===============================================================================
 class Battle::Move::FlinchTarget1AccuracyFailsIfNotUserFirstTurn < Battle::Move
  def flinchingMove?; return true; end
  
def pbMoveFailed?(user, targets)
    if user.turnCount > 1
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
  
  def pbAdditionalEffect(user, target)
  target.pbFlinch(user)
  return if !user.pbCanRaiseStatStage?(:ACCURACY, user, self)
    user.pbRaiseStatStage(:ACCURACY, 1, user)
  end
end