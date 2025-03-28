#===============================================================================
# Entry hazard. Lays dark smog on the opposing side. (Dark Mist)
#===============================================================================
class Battle::Move::AddDarkMistToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::DarkMist]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::DarkMist] = true
    @battle.pbDisplay(_INTL("A dark smog now surrounds {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
