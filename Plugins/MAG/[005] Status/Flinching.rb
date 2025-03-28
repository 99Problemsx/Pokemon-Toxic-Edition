class Battle::Battler
alias mag_pbFlinch pbFlinch
  def pbFlinch(_user = nil)
    return if hasActiveAbility?(:INNERFOCUS) && hasActiveAbility?(:SHALLOWNESS) && !@battle.moldBreaker
    @effects[PBEffects::Flinch] = true
  end
end