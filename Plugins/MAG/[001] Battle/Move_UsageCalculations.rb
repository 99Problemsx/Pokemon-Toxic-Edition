class Battle::Move
	
	alias mag_pbCalcTypeModSingle pbCalcTypeModSingle
	def pbCalcTypeModSingle(moveType, defType, user, target)
		ret = mag_pbCalcTypeModSingle(moveType, defType, user, target)
		if Effectiveness.normal_type?(moveType, defType)
			if target.hasActiveAbility?(:UNPREDICTABLE) && moveType == :PSYCHIC
				ret = Effectiveness::NOT_VERY_EFFECTIVE_MULTIPLIER
				elsif user.hasActiveAbility?(:UNPREDICTABLE) &&  user.pbHasType?(moveType) && defType == :PSYCHIC
				ret = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER
			end
			elsif Effectiveness.not_very_effective_type?(moveType, defType)
			if user.hasActiveAbility?(:UNPREDICTABLE) &&  user.pbHasType?(moveType) && defType == :PSYCHIC
				ret = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER
			end
		end
		return ret
	end
	
	alias mag_pbCalcDamageMultipliers pbCalcDamageMultipliers
	def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
		# Gold Hoard
		if user.pbOwnSide.effects[PBEffects::GoldHoard] > 0 && type == :DRAGON
			multipliers[:power_multiplier] *= 1.3
		end
		# STAB
		if type && user.pbHasType?(type)
			if user.hasActiveAbility?(:ADAPTABILITY)
				multipliers[:final_damage_multiplier] *= 2
				else
				multipliers[:final_damage_multiplier] *= 1.5 
			end
		end
		# Frostbite
		if user.status == :FROSTBITE && specialMove? &&
			!user.hasActiveAbility?(:EXTREMEFOCUS)
			multipliers[:final_damage_multiplier] /= 2
		end
        # Splinter
        if target.status == :SPLINTER && physicalMove?
            multipliers[:final_damage_multiplier] /= 2
        end
		# Brittle
        if target.status == :BRITTLE && physicalMove?
            multipliers[:final_damage_multiplier] *= 2
        end
		multipliers[:final_damage_multiplier] *= 1 if user.hasActiveAbility?(:JOAT)
		mag_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
	end

alias mag_pbCalcAccuracyModifiers pbCalcAccuracyModifiers
  def pbCalcAccuracyModifiers(user, target, modifiers)
	if user.status == :BLINDED
	modifiers[:accuracy_multiplier] *= 0.80
	end
	return mag_pbCalcAccuracyModifiers(user, target, modifiers)
  end
end