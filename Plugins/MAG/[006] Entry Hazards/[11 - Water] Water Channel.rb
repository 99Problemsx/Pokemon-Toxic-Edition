#===============================================================================
# Entry hazard. Rose Field on the opposing side. (Rose Field)
#===============================================================================
class Battle::Move::AddWaterChannelToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::WaterChannel]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::WaterChannel] = true
    @battle.pbDisplay(_INTL("A wave channel appeared on {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
