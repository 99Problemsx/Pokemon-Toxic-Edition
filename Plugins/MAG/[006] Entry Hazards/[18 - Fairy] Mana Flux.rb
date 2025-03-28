#===============================================================================
# Entry hazard. Lays Mana Flux on the opposing side. (Mana Flux)
#===============================================================================
class Battle::Move::AddManaFluxToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::ManaFlux]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::ManaFlux] = true
    @battle.pbDisplay(_INTL("A magical circle appeared under {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
