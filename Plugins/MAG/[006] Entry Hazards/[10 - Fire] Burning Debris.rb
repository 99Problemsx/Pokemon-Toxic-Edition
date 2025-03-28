#===============================================================================
# Entry hazard. Burning Rocks on the opposing side. (Burning Debris)
#===============================================================================
class Battle::Move::AddBurningDebrisToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::BurningDebris]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::BurningDebris] = true
    @battle.pbDisplay(_INTL("Burning rocks and charcol were scattered around {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
