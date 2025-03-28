#===============================================================================
# Entry hazard. Mind Field on the opposing side. (Mind Field)
#===============================================================================
class Battle::Move::AddMindFieldToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::MineField]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::MineField] = true
    @battle.pbDisplay(_INTL("A field of psychic orbs has been set up around {1}!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
