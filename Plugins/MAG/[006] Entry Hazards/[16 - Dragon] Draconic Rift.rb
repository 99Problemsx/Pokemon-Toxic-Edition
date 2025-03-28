#===============================================================================
# Entry hazard. Draconic Rift on the opposing side. (Draconic Rift)
#===============================================================================
class Battle::Move::AddDraconicRiftToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::DraconicRift]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::DraconicRift] = true
    @battle.pbDisplay(_INTL("The Dragon Force opened up under {1}!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
