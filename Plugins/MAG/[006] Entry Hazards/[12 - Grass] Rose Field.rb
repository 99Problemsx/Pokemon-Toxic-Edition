#===============================================================================
# Entry hazard. Rose Field on the opposing side. (Rose Field)
#===============================================================================
class Battle::Move::AddRoseFieldToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::RoseField]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::RoseField] = true
    @battle.pbDisplay(_INTL("A beautiful rose garden grew at {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
