#===============================================================================
# Entry hazard. Lays Haunted Orbs on the opposing side. (Haunted Orbs)
#===============================================================================
class Battle::Move::AddHauntedOrbsToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::HauntedOrbs]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::HauntedOrbs] = true
    @battle.pbDisplay(_INTL("Haunted Orbs are know haunting {1}'s side!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
