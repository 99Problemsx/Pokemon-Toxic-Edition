#===============================================================================
# Coral Cascade
# This move deals both Water & Rock Type damage
#===============================================================================
class Battle::Move::EffectivenessIncludesRockTypeChancetoHeal < Battle::Move
def healingMove?; return true; end

  def pbCalcTypeModSingle(moveType, defType, user, target)
    ret = super
    if GameData::Type.exists?(:ROCK)
      ret *= Effectiveness.calculate(:ROCK, defType)
    end
    return ret
  end
  
  def pbAdditionalEffect(user, target)
    user.pbRecoverHP(user.totalhp / 8)
    @battle.pbDisplay(_INTL("{1}'s HP was restored.", user.pbThis))
    user.allAllies.each do |b|
    b.pbRecoverHP(b.totalhp / 8)
    @battle.pbDisplay(_INTL("{1}'s HP was restored.", b.pbThis))
    end
  end
end