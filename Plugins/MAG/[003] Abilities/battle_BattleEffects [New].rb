module Battle::AbilityEffects
	OnWeatherChange                  = AbilityHandlerHash.new
	
	
	def self.triggerOnWeatherChange(ability, battler, battle, ability_changed)
		OnWeatherChange.trigger(ability, battler, battle, ability_changed)
	end 
end
################################################################################
	# Vampiric Fang
	# The user heals 1/16th of the damage dealt with biting moves
################################################################################
Battle::AbilityEffects::OnDealingHit.add(:VAMPIRICFANG,
	proc { |ability, user, target, move, battle|
		if move.bitingMove? && user.canHeal?
			battle.pbShowAbilitySplash(user)
			user.pbRecoverHP(user.totalhp / 16)
			if Battle::Scene::USE_ABILITY_SPLASH
				battle.pbDisplay(_INTL("{1}'s HP was restored.", user.pbThis))
				else
				battle.pbDisplay(_INTL("{1}'s {2} restored its HP.", user.pbThis, user.abilityName))
			end
			battle.pbHideAbilitySplash(user)
		end
	}
)

################################################################################
	# Warrior Dancer
	# Intimidates the target upon using a dance move
################################################################################
Battle::AbilityEffects::OnEndOfUsingMove.add(:WARRIORDANCER,
	proc { |ability, user, targets, move, battle, battler|
		next if !move.danceMove?
		next if battle.pbAllFainted?(user.idxOpposingSide)
		battle.pbShowAbilitySplash(user)
		battle.allOtherSideBattlers(user.index).each do |b|
			next if !b.near?(user)
			check_item = true
			if b.hasActiveAbility?(:CONTRARY)
				check_item = false if b.statStageAtMax?(:ATTACK)
				elsif b.statStageAtMin?(:ATTACK)
				check_item = false
			end
			check_ability = b.pbLowerAttackStatStageIntimidate(user)
			b.pbAbilitiesOnIntimidated if check_ability
			b.pbItemOnIntimidatedCheck if check_item
		end
		battle.pbHideAbilitySplash(user)
	}
)

################################################################################
	# Cryo Healing
	# Heals the user when they have frostbite by 1/8th HP
################################################################################
class Battle
	alias mag_pbEORStatusProblemDamage pbEORStatusProblemDamage
	def pbEORStatusProblemDamage(priority)
		priority.each do |battler|
			next if battler.status != :FROSTBITE
			if battler.hasActiveAbility?(:CRYOHEALING)
				if battler.canHeal?
					anim_name = GameData::Status.get(:FROSTBITE).animation
					pbCommonAnimation(anim_name, battler) if anim_name
					pbShowAbilitySplash(battler)
					battler.pbRecoverHP(battler.totalhp / 8)
					if Scene::USE_ABILITY_SPLASH
						pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
						else
						pbDisplay(_INTL("{1}'s {2} restored its HP.", battler.pbThis, battler.abilityName))
					end
					pbHideAbilitySplash(battler)
				end
				elsif battler.takesIndirectDamage?
				battler.droppedBelowHalfHP = false
				dmg = battler.totalhp / 16
				battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
				battler.pbItemHPHealCheck
				battler.pbAbilitiesOnDamageTaken
				battler.pbFaint if battler.fainted?
				battler.droppedBelowHalfHP = false
			end
		end
		priority.each do |battler|
			next if battler.fainted?
			next if battler.status != :POISON
			if battler.statusCount > 0
				battler.effects[PBEffects::Toxic] += 1
				battler.effects[PBEffects::Toxic] = 16 if battler.effects[PBEffects::Toxic] > 16
			end
			if battler.hasActiveAbility?(:POISONHEAL)
				if battler.canHeal?
					anim_name = GameData::Status.get(:POISON).animation
					pbCommonAnimation(anim_name, battler) if anim_name
					pbShowAbilitySplash(battler)
					battler.pbRecoverHP(battler.totalhp / 8)
					if Scene::USE_ABILITY_SPLASH
						pbDisplay(_INTL("{1}'s HP was restored.", battler.pbThis))
						else
						pbDisplay(_INTL("{1}'s {2} restored its HP.", battler.pbThis, battler.abilityName))
					end
					pbHideAbilitySplash(battler)
				end
				elsif battler.takesIndirectDamage?
				battler.droppedBelowHalfHP = false
				dmg = battler.totalhp / 8
				dmg = battler.totalhp * battler.effects[PBEffects::Toxic] / 16 if battler.statusCount > 0
				battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
				battler.pbItemHPHealCheck
				battler.pbAbilitiesOnDamageTaken
				battler.pbFaint if battler.fainted?
				battler.droppedBelowHalfHP = false
			end
		end
		# Damage from burn
		priority.each do |battler|
			next if battler.status != :BURN || !battler.takesIndirectDamage?
			battler.droppedBelowHalfHP = false
			dmg = (Settings::MECHANICS_GENERATION >= 7) ? battler.totalhp / 16 : battler.totalhp / 8
			dmg = (dmg / 2.0).round if battler.hasActiveAbility?(:HEATPROOF)
			battler.pbContinueStatus { battler.pbReduceHP(dmg, false) }
			battler.pbItemHPHealCheck
			battler.pbAbilitiesOnDamageTaken
			battler.pbFaint if battler.fainted?
			battler.droppedBelowHalfHP = false
		end
	end
end
################################################################################
	# Menacing
	# Special Attack Intimidate
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:MENACING,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler)
		battle.allOtherSideBattlers(battler.index).each do |b|
			next if !b.near?(battler)
			check_item = true
			if b.hasActiveAbility?(:CONTRARY)
				check_item = false if b.statStageAtMax?(:SPECIAL_ATTACK)
				elsif b.statStageAtMin?(:SPECIAL_ATTACK)
				check_item = false
			end
			check_ability = b.pbLowerSpecialAttackStatStageIntimidate(battler)
			b.pbAbilitiesOnIntimidated if check_ability
			b.pbItemOnIntimidatedCheck if check_item
		end
		battle.pbHideAbilitySplash(battler)
	}
)

################################################################################
	# Extreme Focus
	# Boosts the power of special attacks when under a status condition
	################################################################################
	#Battle::AbilityEffects::DamageCalcFromUser.add(:EXTREMEFOCUS,
	#  proc { |ability, user, target, move, mults, power, type|
	#    if user.pbHasAnyStatus? && move.specialMove?
	#      mults[:attack_multiplier] *= 1.5
	#    end
	#  }
#)

Battle::AbilityEffects::OnSwitchIn.add(:STORMFRONT,
	proc { |ability, battler, battle, switch_in|
		battle.pbStartWeatherAbility(:Rain, battler)
		next if battle.field.terrain == :Electric
		battle.pbShowAbilitySplash(battler)
		battle.pbStartTerrain(battler, :Electric)
	}
)

################################################################################
	# Chloroplast
	# Use can use moves as if sun was active
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:CHLOROPLAST,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler, true)
		battle.pbDisplay(_INTL("{1}'s {2} makes it act like it's in the sun!", battler.pbThis, battler.abilityName))
		battle.pbHideAbilitySplash(battler)
	}
)

#Growth
class Battle::Move::RaiseUserAtkSpAtk1Or2InSun < Battle::Move::MultiStatUpMove
	def initialize(battle, move)
		super
		@statUp = [:ATTACK, 1, :SPECIAL_ATTACK, 1]
	end
	
	def pbOnStartUse(user, targets)
		increment = 1
		increment = 2 if ([:Sun, :HarshSun].include?(user.effectiveWeather)) || user.hasActiveAbility?(:CHLOROPLAST)
		@statUp[1] = @statUp[3] = increment
	end
end

# Solar Beam & Solar Blade
class Battle::Move::TwoTurnAttackOneTurnInSun < Battle::Move::TwoTurnMove
	def pbIsChargingTurn?(user)
		ret = super
		if !user.effects[PBEffects::TwoTurnAttack] &&
			([:Sun, :HarshSun].include?(user.effectiveWeather) || user.hasActiveAbility?(:CHLOROPLAST))
			@powerHerb = false
			@chargingTurn = true
			@damagingTurn = true
			return false
		end
		return ret
	end
	
	def pbChargingTurnMessage(user, targets)
		@battle.pbDisplay(_INTL("{1} took in sunlight!", user.pbThis))
	end
	
	def pbBaseDamageMultiplier(damageMult, user, target)
		damageMult /= 2 if ![:None, :Sun, :HarshSun].include?(user.effectiveWeather)
		return damageMult
	end
end

# Weather Ball
class Battle::Move::TypeAndPowerDependOnWeather < Battle::Move
	def pbBaseDamage(baseDmg, user, target)
		baseDmg *= 2 if user.effectiveWeather != :None
		return baseDmg
	end
	
	def pbBaseType(user)
		ret = :NORMAL
		if user.hasActiveAbility?(:CHLOROPLAST)
			ret = :FIRE if GameData::Type.exists?(:FIRE)
			else
			case user.effectiveWeather
				when :Sun, :HarshSun
				ret = :FIRE if GameData::Type.exists?(:FIRE)
				when :Rain, :HeavyRain
				ret = :WATER if GameData::Type.exists?(:WATER)
				when :Sandstorm
				ret = :ROCK if GameData::Type.exists?(:ROCK)
				when :Hail
				ret = :ICE if GameData::Type.exists?(:ICE)
				when :ShadowSky
				ret = :NONE
			end
			return ret
		end
	end
	
	def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
		t = pbBaseType(user)
		hitNum = 1 if t == :FIRE   # Type-specific anims
		hitNum = 2 if t == :WATER
		hitNum = 3 if t == :ROCK
		hitNum = 4 if t == :ICE
		super
	end
end

# Synthesis, Morning Sun, Moonlight
class Battle::Move::HealUserDependingOnWeather < Battle::Move::HealingMove
	def pbOnStartUse(user, targets)
		if user.hasActiveAbility?(:CHLOROPLAST)
			@healAmount = (user.totalhp * 2 / 3.0).round
			else
			case user.effectiveWeather
				when :Sun, :HarshSun
				@healAmount = (user.totalhp * 2 / 3.0).round
				when :None, :StrongWinds
				@healAmount = (user.totalhp / 2.0).round
				else
				@healAmount = (user.totalhp / 4.0).round
			end
		end
	end
	
	def pbHealAmount(user)
		return @healAmount
	end
end

################################################################################
	# Bonechill
	# The user has a 30% chance to frostbite when direct contact
################################################################################
Battle::AbilityEffects::OnDealingHit.add(:BONECHILL,
	proc { |ability, user, target, move, battle|
		next if !move.contactMove?
		next if battle.pbRandom(100) >= 30
		battle.pbShowAbilitySplash(user)
		if target.hasActiveAbility?(:SHIELDDUST) && !battle.moldBreaker
			battle.pbShowAbilitySplash(target)
			if !Battle::Scene::USE_ABILITY_SPLASH
				battle.pbDisplay(_INTL("{1} is unaffected!", target.pbThis))
			end
			battle.pbHideAbilitySplash(target)
			elsif target.pbCanFrostbite?(user, Battle::Scene::USE_ABILITY_SPLASH)
			msg = nil
			if !Battle::Scene::USE_ABILITY_SPLASH
				msg = _INTL("{1}'s {2} frostbitten {3}!", user.pbThis, user.abilityName, target.pbThis(true))
			end
			target.pbFrostbite(user, msg)
		end
		battle.pbHideAbilitySplash(user)
	}
)

################################################################################
	# Overwhelming Frost
	# Frostbite all pokemon on switch in.
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:OVERWHELMINGFROST,
	proc { |ability, battler, battle, switch_in|
		next if battler.ability_triggered?
		battle.pbSetAbilityTrigger(battler)
		battle.pbShowAbilitySplash(battler, true)
		battle.pbDisplay(_INTL("{1}'s {2} froze everything on the battlefield", battler.pbThis, battler.abilityName))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.pbCanFrostbite?(battler, false, self)
				b.pbFrostbite(battler)
			end
			next if battler.allAllies.none?
			battler.allAllies.each do |m|
				if m.pbCanFrostbite?(battler, false, self)
					m.pbFrostbite(battler)
				end
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

################################################################################
	# Overwhelming Voltage
	# Paralyzes all pokemon on switch in.
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:OVERWHELMINGVOLTAGE,
	proc { |ability, battler, battle, switch_in|
		next if battler.ability_triggered?
		battle.pbSetAbilityTrigger(battler)
		battle.pbShowAbilitySplash(battler, true)
		battle.pbDisplay(_INTL("{1}'s {2} shocked everything on the battlefield", battler.pbThis, battler.abilityName))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.pbCanParalyze?(battler, false, self)
				b.pbParalyze(battler)
			end
			next if battler.allAllies.none?
			battler.allAllies.each do |m|
				if m.pbCanParalyze?(battler, false, self)
					m.pbParalyze(battler)
				end
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

################################################################################
	# Overwhelming Blaze
	# Burns all pokemon on switch in.
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:OVERWHELMINGBLAZE,
	proc { |ability, battler, battle, switch_in|
		next if battler.ability_triggered?
		battle.pbSetAbilityTrigger(battler)
		battle.pbShowAbilitySplash(battler, true)
		battle.pbDisplay(_INTL("{1}'s {2} burned everything on the battlefield", battler.pbThis, battler.abilityName))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.pbCanBurn?(battler, false, self)
				b.pbBurn(battler)
			end
			next if battler.allAllies.none?
			battler.allAllies.each do |m|
				if m.pbCanBurn?(battler, false, self)
					m.pbBurn(battler)
				end
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

################################################################################
	# Sea Diver
	# Raises Speed and give water STAB in rain
################################################################################
Battle::AbilityEffects::SpeedCalc.add(:SEADIVER,
	proc { |ability, battler, mult|
		next mult * 1.5 if [:Rain, :HeavyRain].include?(battler.effectiveWeather)
	}
)

#Battle::AbilityEffects::DamageCalcFromUser.add(:SEADIVER,
	#  proc { |ability, user, target, move, mults, power, type|
	#  if type == :WATER && [:Rain, :HeavyRain].include?(battler.effectiveWeather)
	#    mults[:attack_multiplier] *= 1.5
	#  end
	#  }
#)

################################################################################
	# Tangling Roots
	# Leech Seeds the the opposing side & ingrain.
################################################################################
Battle::AbilityEffects::OnSwitchIn.add(:TANGLINGROOTS,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler, true)
		battler.effects[PBEffects::Ingrain] = true
		battle.pbDisplay(_INTL("{1} planted its roots!", battler.pbThis))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.effects[PBEffects::LeechSeed] >= 0 || b.pbHasType?(:GRASS)
				battle.pbDisplay(_INTL("It doesn't affect {1}...", b.pbThis))
				else
				b.effects[PBEffects::LeechSeed] = battler.index
				battle.pbDisplay(_INTL("{1} was seeded!", b.pbThis))  
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

################################################################################
	# Fuelled Blaze
	# Always crit if the target burnt
################################################################################
Battle::AbilityEffects::CriticalCalcFromUser.add(:FUELLEDBLAZE,
	proc { |ability, user, target, c|
		next 99 if target.burned?
	}
)

#===============================================================================
	# Hell's Blaze
	# Gale Wings but for Fire-Types
#===============================================================================
Battle::AbilityEffects::PriorityChange.add(:HELLSBLAZE,
	proc { |ability, battler, move, pri|
		if Settings::MAG_GALEWINGS  == 0
			next pri + 1 if (Settings::MECHANICS_GENERATION <= 6 || battler.hp == battler.totalhp) &&
			move.type == :FIRE
		end
		if Settings::MAG_GALEWINGS == 1
			next pri + 1 if (battler.hp >= battler.totalhp * 0.5) &&
			move.type == :FIRE
		end
		if Settings::MAG_GALEWINGS == 2
			next pri + 1 if (battler.hp >= battler.totalhp * 0.75) &&
			move.type == :FIRE
		end
	}
)

#===============================================================================
	# Power Surge
	# If Electric-Type move is used it deals a burst damage.
#===============================================================================
Battle::AbilityEffects::OnDealingHit.add(:POWERSURGE,
	proc { |ability, user, target, move, battle|
		next if move.calcType != :ELECTRIC
		next if move.pbTarget(user).num_targets > 1
		battle.pbShowAbilitySplash(user, true)
		hitAlly = []
		target.allAllies.each do |b|
			next if !b.near?(target.index)
			next if !b.takesIndirectDamage?
			hitAlly.push([b.index, b.hp])
			b.pbReduceHP(b.totalhp / 16, false)
			battle.pbDisplay(_INTL("Small electric shock came from the attack hitting {1}!", b.pbThis))
		end
		battle.pbHideAbilitySplash(user)
	}
)


################################################################################
	# Joat
	# Jack Of All Trades. The user has no STAB but has all of it's moves powered up.
################################################################################
Battle::AbilityEffects::DamageCalcFromUser.add(:JOAT,
	proc { |ability, user, target, move, mults, power, type|
		mults[:power_multiplier] *= 1.3
	}
)


#===============================================================================
	# Cat-astrophe
	# Dark moves get powered up by 75% but -1 priority (Excludes Sucker Punch)
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:CATASTROPHE,
	proc { |ability, user, target, move, mults, power, type|
		mults[:attack_multiplier] *= 1.75 if type == :DARK
	}
)

Battle::AbilityEffects::PriorityChange.add(:CATASTROPHE,
	proc { |ability, battler, move, pri|
		next pri - 1 if move.type == :DARK
	}
)

#===============================================================================
	# Shallowness
#===============================================================================
Battle::AbilityEffects::StatusCure.copy(:OBLIVIOUS, :SHALLOWNESS)

#===============================================================================
	# Dual Weild
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:DUALWIELD,
	proc { |ability, user, target, move, mults, baseDmg, type|
		mults[:power_multiplier] *= Settings::MAG_DUALWIELD if move.slicingMove? || move.pulseMove?
	}
)

class Battle::Move
	alias mag_pbNumHits pbNumHits
	def pbNumHits(user, targets)
		mag_pbNumHits(user, targets)
		if slicingMove? || pulseMove?
			if user.hasActiveAbility?(:DUALWIELD) && pbDamagingMove? &&
				!chargingTurnMove? && targets.length == 1
				# Record that Parental Bond applies, to weaken the second attack
				user.effects[PBEffects::ParentalBond] = 3
				return 2
			end
		end
		# Double Cross
		if battle.pbRandom(100) < 30
			if user.hasActiveAbility?(:DOUBLECROSS) && pbDamagingMove? &&
				!chargingTurnMove? && targets.length == 1
				battle.pbShowAbilitySplash(user)
				battle.pbHideAbilitySplash(user)
				# Record that Parental Bond applies, to weaken the second attack
				user.effects[PBEffects::ParentalBond] = 3
				return 2
			end
		end
		return 1
	end
end

#===============================================================================
	# Vengence
	# User gets +1 in all stats, traps self, -2 after KOing a mon
#===============================================================================

Battle::AbilityEffects::OnSwitchIn.add(:VENGENCE,
	proc { |ability, battler, battle, switch_in|
		if battler.pbOwnSide.effects[PBEffects::FaintedLast] > 0 && battler.effects[PBEffects::Vengence] == 0
			battle.pbShowAbilitySplash(battler)
			battle.pbDisplay(_INTL("{1} is enraged at its fallen ally!", battler.pbThis))
			showAnim = true
			[:ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED].each do |raise|
				next if !battler.pbCanRaiseStatStage?(raise, battler, nil, true)
				if battler.pbRaiseStatStage(raise, 1, battler, showAnim)
					showAnim = false
				end
			end
			battle.pbDisplay(_INTL("{1} won't leave until it has won!", battler.pbThis))
			battler.effects[PBEffects::Vengence] = 1
		end
		battle.pbHideAbilitySplash(battler)
	}
)

Battle::AbilityEffects::OnEndOfUsingMove.add(:VENGENCE,
	proc { |ability, user, targets, move, battle|
		if user.effects[PBEffects::Vengence] == 1
			next if battle.pbAllFainted?(user.idxOpposingSide)
			numFainted = 0
			targets.each { |b| numFainted += 1 if b.damageState.fainted }
			next if numFainted == 0
			battle.pbShowAbilitySplash(user)
			battle.pbDisplay(_INTL("{1} is no longer vengeful!", user.pbThis))
			showAnim = true
			[:ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED].each do |lower|
				next if !user.pbCanLowerStatStage?(lower, user, nil, true)
				if user.pbLowerStatStage(lower, 2, user, showAnim)
					showAnim = false
				end
			end
			battle.pbHideAbilitySplash(user)
			battler.effects[PBEffects::Vengence] = 2
		end
		
	}
)

#===============================================================================
	# Frozen Yin
	# Combo of Overwhelmin Frost and Teravolt
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:FROZENYIN,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler)
		if Settings::MAG_TERAVOLT == true && !battler.pbHasType?(:ELECTRIC)
			battler.effects[PBEffects::ExtraType] = :ELECTRIC
			typeName = GameData::Type.get(:ELECTRIC).name
			battle.pbDisplay(_INTL("{1} is radiating a bursting aura, gaining the {2} type!", battler.pbThis, typeName))
			else
			battle.pbDisplay(_INTL("{1} is radiating a bursting aura!", battler.pbThis))
		end
		next if battler.ability_triggered?
		battle.pbSetAbilityTrigger(battler)
		battle.pbDisplay(_INTL("{1}'s {2} froze everything on the battlefield", battler.pbThis, battler.abilityName))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.pbCanFrostbite?(battler, false, self)
				b.pbFrostbite(battler)
			end
			next if battler.allAllies.none?
			battler.allAllies.each do |m|
				if m.pbCanFrostbite?(battler, false, self)
					m.pbFrostbite(battler)
				end
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

#===============================================================================
	# Frozen Yang
	# Combo of Overwhelmin Frost and Teravolt
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:FROZENYANG,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler)
		if Settings::MAG_TERAVOLT == true && !battler.pbHasType?(:FIRE)
			battler.effects[PBEffects::ExtraType] = :FIRE
			typeName = GameData::Type.get(:FIRE).name
			battle.pbDisplay(_INTL("{1} is radiating a blazing aura, gaining the {2} type!", battler.pbThis, typeName))
			else
			battle.pbDisplay(_INTL("{1} is radiating a blazing aura", battler.pbThis))
		end
		next if battler.ability_triggered?
		battle.pbSetAbilityTrigger(battler)
		battle.pbDisplay(_INTL("{1}'s {2} froze everything on the battlefield", battler.pbThis, battler.abilityName))
		battle.allOtherSideBattlers(battler.index).each do |b|
			if b.pbCanFrostbite?(battler, false, self)
				b.pbFrostbite(battler)
			end
			next if battler.allAllies.none?
			battler.allAllies.each do |m|
				if m.pbCanFrostbite?(battler, false, self)
					m.pbFrostbite(battler)
				end
			end
		end
		battle.pbHideAbilitySplash(battler)
	}
)

#===============================================================================
	# Poison Absorb
	# Gain HP after getting hit by a Poison type move.
#===============================================================================
Battle::AbilityEffects::MoveImmunity.add(:POISONABSORB,
	proc { |ability, user, target, move, type, battle, show_message|
		next target.pbMoveImmunityHealingAbility(user, move, type, :POISON, show_message)
	}
)

#===============================================================================
	# Crystallize
	# Rock-types become Ice-types and gain a 50% boost
#===============================================================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:CRYSTALLIZE,
	proc { |ability, user, move, type|
		next if type != :ROCK || !GameData::Type.exists?(:ICE)
		move.powerBoost = true
		next :ICE
	}
)

Battle::AbilityEffects::DamageCalcFromUser.add(:CRYSTALLIZE,
	proc { |ability, user, target, move, mults, power, type|
		mults[:power_multiplier] *= 1.5 if move.powerBoost
	}
)

#===============================================================================
	# Flame Wing
	# Flying-types become Fire-types and gain a 20% boost
#===============================================================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:FLAMEWING,
	proc { |ability, user, move, type|
		next if type != :FLYING || !GameData::Type.exists?(:FIRE)
		move.powerBoost = true
		next :FIRE
	}
)
Battle::AbilityEffects::DamageCalcFromUser.copy(:AERILATE, :FLAMEWING)

#===============================================================================
	# Arcane Mage
	# Boosts the damage of Fire-type, Ice-type, and Electric-type moves.Dark-types are immune to them.
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:ARCANEMAGE,
	proc { |ability, user, target, move, mults, power, type|
		if type == :FIRE || type == :ICE || type == :ELECTRIC 
			mults[:attack_multiplier] *= 1.3
		end
	}
)

#===============================================================================
	# Fiery Spirit
	# Gain the Fire-Type on switch in
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:FIERYSPIRIT,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler)
		if !battler.pbHasType?(:FIRE)
			battler.effects[PBEffects::ExtraType] = :FIRE
			typeName = GameData::Type.get(:FIRE).name
			battle.pbDisplay(_INTL("{1}'s spirit ignited giving it the {2} type!", battler.pbThis, typeName))
		end
	}
)

#===============================================================================
	# Sky Force
	# Doubles the power of Flying moves
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:SKYFORCE,
	proc { |ability, user, target, move, mults, power, type|
		mults[:power_multiplier] *= 2 if move.type == :FLYING
	}
)

#===============================================================================
	# Under Weather
	# Badly Poison the user in weather. Doubles damage if badly poison.
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:UNDERWEATHER,
	proc { |ability, battler, battle, switch_in|
		next if battle.field.weather == :None
		Battle::AbilityEffects.triggerOnWeatherChange(ability, battler, battle, false)
	}
)

Battle::AbilityEffects::OnWeatherChange.add(:UNDERWEATHER,
	proc { |ability, battler, battle, ability_changed|
		next if battle.field.weather == :None
	    if battler.pbCanPoison?(battler, Battle::Scene::USE_ABILITY_SPLASH)
			battle.pbShowAbilitySplash(battler)
			battler.pbPoison(nil, _INTL("{1} is feeling very sick due to the weather!", battler.pbThis), true)
			battle.pbHideAbilitySplash(battler)
		end
	}
)

Battle::AbilityEffects::DamageCalcFromUser.add(:UNDERWEATHER,
	proc { |ability, user, target, move, mults, power, type|
		mults[:attack_multiplier] *= 2 if user.poisoned?
	}
)

#===============================================================================
	# Potent Poison
	# Badly poisons the target instead of poison.
#===============================================================================
class Battle::Move::PoisonTarget < Battle::Move
	def canMagicCoat?; return true; end
	
	def initialize(battle, move)
		super
		@toxic = false
	end
	
	def pbFailsAgainstTarget?(user, target, show_message)
		return false if damagingMove?
		return !target.pbCanPoison?(user, show_message, self)
	end
	
	def pbEffectAgainstTarget(user, target)
		return if damagingMove?
		if [:POTENTPOISON].include?(user.ability_id)
			@toxic = true
			else
			@toxic = false
		end
		target.pbPoison(user, nil, @toxic)
	end
	
	def pbAdditionalEffect(user, target)
		return if target.damageState.substitute
		if [:POTENTPOISON].include?(user.ability_id)
			@toxic = true
			else
			@toxic = false
		end
		target.pbPoison(user, nil, @toxic) if target.pbCanPoison?(user, false, self)
	end
end

#===============================================================================
	# Faulty Receiver
	# Immune to aura and pulse moves.
#===============================================================================
Battle::AbilityEffects::MoveImmunity.add(:FAULTYRECEIVER,
	proc { |ability, user, target, move, type, battle, show_message|
		next false if !move.pulseMove?
		if show_message
			battle.pbShowAbilitySplash(target)
			if Battle::Scene::USE_ABILITY_SPLASH
				battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
				else
				battle.pbDisplay(_INTL("{1}'s {2} made {3} ineffective!",
				target.pbThis, target.abilityName, move.name))
			end
			battle.pbHideAbilitySplash(target)
		end
		next true
	}
)

#===============================================================================
	# Under Handed
	# Turns Fighting-type moves into Dark and gives a power boost
#===============================================================================
Battle::AbilityEffects::ModifyMoveBaseType.add(:UNDERHANDED,
	proc { |ability, user, move, type|
		next if type != :FIGHTING || !GameData::Type.exists?(:DARK)
		move.powerBoost = true
		next :DARK
	}
)

Battle::AbilityEffects::DamageCalcFromUser.add(:UNDERHANDED,
	proc { |ability, user, target, move, mults, power, type|
		mults[:power_multiplier] *= 1.2 if move.powerBoost
	}
)

#===============================================================================
	# Monkey Business
	# Boosts special moves but locks in one move.
#===============================================================================
Battle::AbilityEffects::DamageCalcFromUser.add(:MONKEYBUSINESS,
	proc { |ability, user, target, move, mults, power, type|
		mults[:attack_multiplier] *= 1.5 if move.specialMove?
	}
)

#===============================================================================
	# Monkey Business
	# Boosts special moves but locks in one move.
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:SPECTRALIZE,
	proc { |ability, battler, battle, switch_in|
		battle.pbShowAbilitySplash(battler, true)
		battle.pbDisplay(_INTL("{1}'s {2} made the field spooky!", battler.pbThis, battler.abilityName))
		battle.pbHideAbilitySplash(battler)
		battle.allOtherSideBattlers(battler.index).each do |b|
			if !b.pbHasType?(:GHOST)
				b.effects[PBEffects::ExtraType] = :GHOST
				typeName = GameData::Type.get(:GHOST).name
			    battle.pbDisplay(_INTL("{1} gained the {2} type!", b.pbThis, typeName))
			end
		end
		battle.allSameSideBattlers(battler.index).each do |b|
			if !b.pbHasType?(:GHOST)
				b.effects[PBEffects::ExtraType] = :GHOST
				typeName = GameData::Type.get(:GHOST).name
			    battle.pbDisplay(_INTL("{1} gained the {2} type!", b.pbThis, typeName))
			end
		end
		
	}
)