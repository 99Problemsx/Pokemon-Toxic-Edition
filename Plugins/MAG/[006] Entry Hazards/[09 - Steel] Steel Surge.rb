#===============================================================================
# Entry hazard. Sharp Steel on the opposing side. (Sharp Steel)
#===============================================================================
class Battle::Move::AddSharpSteelToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::SharpSteel] || defined?(PBEffects::Steelsurge) && side.effects[PBEffects::Steelsurge]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::SharpSteel] = true
    @battle.pbDisplay(_INTL("Sharp steel start floating around {1}!",
                            user.pbOpposingTeam(true)))
  end
end

#===============================================================================
