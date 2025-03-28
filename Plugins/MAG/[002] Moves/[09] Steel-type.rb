#===============================================================================
# Lance Thrust
# Damage is based off of speed.
#===============================================================================
class Battle::Move::UseUserSpeedInsteadOfUserAttack < Battle::Move
  def pbGetAttackStats(user, target)
    return user.speed, user.stages[:SPEED] + Battle::Battler::STAT_STAGE_MAXIMUM
  end
end

#===============================================================================
# Excalibur
# Super effective against Dragon-Types
#===============================================================================
class Battle::Move::SuperEffectiveAgainstDragon < Battle::Move
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if defType == :DRAGON
    return super
  end
end

#===============================================================================
# Decompress
# Removes Tailwind and Rooms
#===============================================================================
class Battle::Move::RemoveRoomsAndTailwind < Battle::Move
  
  def pbMoveFailed?(user, targets)
    if user.pbOwnSide.effects[PBEffects::Tailwind] == 0 && user.pbOpposingSide.effects[PBEffects::Tailwind] == 0 && @battle.field.effects[PBEffects::TrickRoom] == 0 &&
	  @battle.field.effects[PBEffects::WonderRoom] == 0 && @battle.field.effects[PBEffects::MagicRoom] == 0 
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end 
  
  def pbEffectGeneral(user)
        if user.pbOwnSide.effects[PBEffects::Tailwind] > 0 
		user.pbOwnSide.effects[PBEffects::Tailwind] = 0 
		@battle.pbDisplay(_INTL("{1} snuffed out its Tailwind!", user.pbThis))
		end
		if user.pbOpposingSide.effects[PBEffects::Tailwind] > 0 
		user.pbOpposingSide.effects[PBEffects::Tailwind] = 0 
		@battle.pbDisplay(_INTL("{1} snuffed out the foe's Tailwind!", user.pbThis))
		end
		if @battle.field.effects[PBEffects::TrickRoom] > 0
		@battle.field.effects[PBEffects::TrickRoom] = 0 
		@battle.pbDisplay(_INTL("{1} shattered the Trick Room!", user.pbThis))
		end
		if @battle.field.effects[PBEffects::WonderRoom] > 0
		@battle.field.effects[PBEffects::WonderRoom] = 0 
		@battle.pbDisplay(_INTL("{1} shattered the Wonder Room!", user.pbThis))
		end
		if @battle.field.effects[PBEffects::MagicRoom] > 0
		@battle.field.effects[PBEffects::MagicRoom] = 0 
		@battle.pbDisplay(_INTL("{1} shattered the Magic Room!", user.pbThis))
	end
  end 
end