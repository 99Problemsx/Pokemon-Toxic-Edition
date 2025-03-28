#===============================================================================
# Entry hazard. Restictive Winds on the opposing side. (Restictive Winds)
#===============================================================================
class Battle::Move::AddRestrictiveWindsToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::RestictiveWinds]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::RestictiveWinds] = true
    @battle.pbDisplay(_INTL("A harsh wind now restricts {1}'s movements!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
