#===============================================================================
# Entry hazard. Ice Ring on the opposing side. (Ice Ring)
#===============================================================================
class Battle::Move::AddIceRingToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::IceRing]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::IceRing] = true
    @battle.pbDisplay(_INTL("An ice ring has been frozen over at {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
