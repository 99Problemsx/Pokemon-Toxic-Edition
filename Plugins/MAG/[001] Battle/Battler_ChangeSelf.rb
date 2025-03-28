class Battle::Battler
alias mag_pbFaint pbFaint
  def pbFaint(showMessage = true)
    pbOwnSide.effects[PBEffects::FaintedLast] = 2
	mag_pbFaint(showMessage = true)
  end 
end