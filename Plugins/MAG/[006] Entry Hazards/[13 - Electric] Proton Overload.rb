#===============================================================================
# Entry hazard. Proton Overload on the opposing side. (Proton Overload)
#===============================================================================
class Battle::Move::AddProtonOverloadToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::ProtonOverload]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::ProtonOverload] = true
    @battle.pbDisplay(_INTL("An electric charge has been set on {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
