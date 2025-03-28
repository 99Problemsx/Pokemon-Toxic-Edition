#===============================================================================
# All effects that apply to one side of the field are swapped to the opposite
# side. (Court Change)
#===============================================================================
class Battle::Move::SwapSideEffects < Battle::Move
  attr_reader :number_effects, :boolean_effects

  def initialize(battle, move)
    super
    @number_effects = [
      PBEffects::AuroraVeil,
      PBEffects::LightScreen,
      PBEffects::Mist,
      PBEffects::Rainbow,
      PBEffects::Reflect,
      PBEffects::Safeguard,
      PBEffects::SeaOfFire,
      PBEffects::Spikes,
      PBEffects::Swamp,
      PBEffects::Tailwind,
      PBEffects::ToxicSpikes
    ]
    @boolean_effects = [
      PBEffects::StealthRock,
      PBEffects::StickyWeb, 
	  PBEffects::TerrainSmash,
      PBEffects::RestictiveWinds,
      PBEffects::HauntedOrbs,
	  PBEffects::CopperJacks,
      PBEffects::BurningDebris,
      PBEffects::WaterChannel,
      PBEffects::RoseField,
      PBEffects::ProtonOverload,
      PBEffects::MindField,
      PBEffects::IceRing,
      PBEffects::DraconicRift,
      PBEffects::DarkMist,
      PBEffects::ManaFlux
    ]
  end

  def pbMoveFailed?(user, targets)
    has_effect = false
    2.times do |side|
      effects = @battle.sides[side].effects
      @number_effects.each do |e|
        next if effects[e] == 0
        has_effect = true
        break
      end
      break if has_effect
      @boolean_effects.each do |e|
        next if !effects[e]
        has_effect = true
        break
      end
      break if has_effect
    end
    if !has_effect
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    side0 = @battle.sides[0]
    side1 = @battle.sides[1]
    @number_effects.each do |e|
      side0.effects[e], side1.effects[e] = side1.effects[e], side0.effects[e]
    end
    @boolean_effects.each do |e|
      side0.effects[e], side1.effects[e] = side1.effects[e], side0.effects[e]
    end
    @battle.pbDisplay(_INTL("{1} swapped the battle effects affecting each side of the field!", user.pbThis))
  end
end

#===============================================================================
# Removes trapping moves, entry hazards and Leech Seed on user/user's side.
# Raises user's Speed by 1 stage (Gen 8+). (Rapid Spin)
#===============================================================================
class Battle::Move::RemoveUserBindingAndEntryHazards < Battle::Move::StatUpMove
  def initialize(battle, move)
    super
    @statUp = [:SPEED, 1]
  end

  def pbEffectAfterAllHits(user, target)
    return if user.fainted? || target.damageState.unaffected
    if user.effects[PBEffects::Trapping] > 0
      trapMove = GameData::Move.get(user.effects[PBEffects::TrappingMove]).name
      trapUser = @battle.battlers[user.effects[PBEffects::TrappingUser]]
      @battle.pbDisplay(_INTL("{1} got free of {2}'s {3}!", user.pbThis, trapUser.pbThis(true), trapMove))
      user.effects[PBEffects::Trapping]     = 0
      user.effects[PBEffects::TrappingMove] = nil
      user.effects[PBEffects::TrappingUser] = -1
    end
    if user.effects[PBEffects::LeechSeed] >= 0
      user.effects[PBEffects::LeechSeed] = -1
      @battle.pbDisplay(_INTL("{1} shed Leech Seed!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock]
      user.pbOwnSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::Spikes] > 0
      user.pbOwnSide.effects[PBEffects::Spikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StickyWeb]
      user.pbOwnSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::TerrainSmash]
      user.pbOwnSide.effects[PBEffects::TerrainSmash] = false
      @battle.pbDisplay(_INTL("{1} blew away the damaged terrain!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::RestictiveWinds]
      user.pbOwnSide.effects[PBEffects::RestictiveWinds] = false
      @battle.pbDisplay(_INTL("{1} blew away restictive winds!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::HauntedOrbs]
      user.pbOwnSide.effects[PBEffects::HauntedOrbs] = false
      @battle.pbDisplay(_INTL("{1} blew away haunted orbs!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::BurningDebris]
      user.pbOwnSide.effects[PBEffects::BurningDebris] = false
      @battle.pbDisplay(_INTL("{1} blew away burning debris!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::WaterChannel]
      user.pbOwnSide.effects[PBEffects::WaterChannel] = false
      @battle.pbDisplay(_INTL("{1} blew away water channel!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::RoseField]
      user.pbOwnSide.effects[PBEffects::RoseField] = false
      @battle.pbDisplay(_INTL("{1} blew away rose field!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ProtonOverload]
      user.pbOwnSide.effects[PBEffects::ProtonOverload] = false
      @battle.pbDisplay(_INTL("{1} blew away the electric charge!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::MindField]
      user.pbOwnSide.effects[PBEffects::MindField] = false
      @battle.pbDisplay(_INTL("{1} blew away mind field!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::IceRing]
      user.pbOwnSide.effects[PBEffects::IceRing] = false
      @battle.pbDisplay(_INTL("{1} blew away ice ring!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::DraconicRift]
      user.pbOwnSide.effects[PBEffects::DraconicRift] = false
      @battle.pbDisplay(_INTL("{1} sealed away the Dragon Force!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::DarkMist]
      user.pbOwnSide.effects[PBEffects::DarkMist] = false
      @battle.pbDisplay(_INTL("{1} blew away dark mist!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ManaFlux]
      user.pbOwnSide.effects[PBEffects::ManaFlux] = false
      @battle.pbDisplay(_INTL("{1} blew away mana flux!", user.pbThis))
    end
  end

  def pbAdditionalEffect(user, target)
    super if Settings::MECHANICS_GENERATION >= 8
  end
end

#===============================================================================
# Decreases the target's evasion by 1 stage. Ends all barriers and entry
# hazards for the target's side OR on both sides. (Defog)
#===============================================================================
class Battle::Move::LowerTargetEvasion1RemoveSideEffects < Battle::Move::TargetStatDownMove
  def ignoresSubstitute?(user); return true; end

  def initialize(battle, move)
    super
    @statDown = [:EVASION, 1]
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    targetSide = target.pbOwnSide
    targetOpposingSide = target.pbOpposingSide
    return false if targetSide.effects[PBEffects::AuroraVeil] > 0 ||
                    targetSide.effects[PBEffects::LightScreen] > 0 ||
                    targetSide.effects[PBEffects::Reflect] > 0 ||
                    targetSide.effects[PBEffects::Mist] > 0 ||
                    targetSide.effects[PBEffects::Safeguard] > 0
    return false if targetSide.effects[PBEffects::StealthRock] ||
                    targetSide.effects[PBEffects::Spikes] > 0 ||
                    targetSide.effects[PBEffects::ToxicSpikes] > 0 ||
                    targetSide.effects[PBEffects::StickyWeb]
    return false if Settings::MECHANICS_GENERATION >= 6 &&
                    (targetOpposingSide.effects[PBEffects::StealthRock] ||
                    targetOpposingSide.effects[PBEffects::Spikes] > 0 ||
                    targetOpposingSide.effects[PBEffects::ToxicSpikes] > 0 ||
                    targetOpposingSide.effects[PBEffects::StickyWeb])
    return false if Settings::MECHANICS_GENERATION >= 8 && @battle.field.terrain != :None
    return super
  end

  def pbEffectAgainstTarget(user, target)
    if target.pbCanLowerStatStage?(@statDown[0], user, self)
      target.pbLowerStatStage(@statDown[0], @statDown[1], user)
    end
    if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
      target.pbOwnSide.effects[PBEffects::AuroraVeil] = 0
      @battle.pbDisplay(_INTL("{1}'s Aurora Veil wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::LightScreen] > 0
      target.pbOwnSide.effects[PBEffects::LightScreen] = 0
      @battle.pbDisplay(_INTL("{1}'s Light Screen wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Reflect] > 0
      target.pbOwnSide.effects[PBEffects::Reflect] = 0
      @battle.pbDisplay(_INTL("{1}'s Reflect wore off!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Mist] > 0
      target.pbOwnSide.effects[PBEffects::Mist] = 0
      @battle.pbDisplay(_INTL("{1}'s Mist faded!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Safeguard] > 0
      target.pbOwnSide.effects[PBEffects::Safeguard] = 0
      @battle.pbDisplay(_INTL("{1} is no longer protected by Safeguard!!", target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::StealthRock] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StealthRock])
      target.pbOwnSide.effects[PBEffects::StealthRock]      = false
      target.pbOpposingSide.effects[PBEffects::StealthRock] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::Spikes] > 0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::Spikes] > 0)
      target.pbOwnSide.effects[PBEffects::Spikes]      = 0
      target.pbOpposingSide.effects[PBEffects::Spikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::ToxicSpikes] > 0)
      target.pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      target.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::StickyWeb] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StickyWeb])
      target.pbOwnSide.effects[PBEffects::StickyWeb]      = false
      target.pbOpposingSide.effects[PBEffects::StickyWeb] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::TerrainSmash] || target.pbOpposingSide.effects[PBEffects::TerrainSmash]
      target.pbOwnSide.effects[PBEffects::TerrainSmash] = false
      target.pbOpposingSide.effects[PBEffects::TerrainSmash] = false
      @battle.pbDisplay(_INTL("{1} blew away the damaged terrain!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::RestictiveWinds] || target.pbOpposingSide.effects[PBEffects::RestictiveWinds]
      target.pbOwnSide.effects[PBEffects::RestictiveWinds] = false
      target.pbOpposingSide.effects[PBEffects::RestictiveWinds] = false
      @battle.pbDisplay(_INTL("{1} blew away restictive winds!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::HauntedOrbs] || target.pbOpposingSide.effects[PBEffects::HauntedOrbs]
      target.pbOwnSide.effects[PBEffects::HauntedOrbs] = false
      target.pbOpposingSide.effects[PBEffects::HauntedOrbs] = false
      @battle.pbDisplay(_INTL("{1} blew away haunted orbs!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::BurningDebris] || target.pbOpposingSide.effects[PBEffects::BurningDebris]
      target.pbOwnSide.effects[PBEffects::BurningDebris] = false
      target.pbOpposingSide.effects[PBEffects::BurningDebris] = false
      @battle.pbDisplay(_INTL("{1} blew away burning debris!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::WaterChannel] || target.pbOpposingSide.effects[PBEffects::WaterChannel]
      target.pbOwnSide.effects[PBEffects::WaterChannel] = false
      target.pbOpposingSide.effects[PBEffects::WaterChannel] = false
      @battle.pbDisplay(_INTL("{1} blew away water channel!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::RoseField] || target.pbOpposingSide.effects[PBEffects::RoseField]
      target.pbOwnSide.effects[PBEffects::RoseField] = false
      target.pbOpposingSide.effects[PBEffects::RoseField] = false
      @battle.pbDisplay(_INTL("{1} blew away rose field!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ProtonOverload] || target.pbOpposingSide.effects[PBEffects::ProtonOverload]
      target.pbOwnSide.effects[PBEffects::ProtonOverload] = false
      target.pbOpposingSide.effects[PBEffects::ProtonOverload] = false
      @battle.pbDisplay(_INTL("{1} blew away the electric charge!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::MindField] || target.pbOpposingSide.effects[PBEffects::MindField]
      target.pbOwnSide.effects[PBEffects::MindField] = false
      target.pbOpposingSide.effects[PBEffects::MindField] = false
      @battle.pbDisplay(_INTL("{1} blew away mind field!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::IceRing] || target.pbOpposingSide.effects[PBEffects::IceRing]
      target.pbOwnSide.effects[PBEffects::IceRing] = false
      target.pbOpposingSide.effects[PBEffects::IceRing] = false
      @battle.pbDisplay(_INTL("{1} blew away ice ring!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::DraconicRift] || target.pbOpposingSide.effects[PBEffects::DraconicRift]
      target.pbOwnSide.effects[PBEffects::DraconicRift] = false
      target.pbOpposingSide.effects[PBEffects::DraconicRift] = false
      @battle.pbDisplay(_INTL("{1} sealed away the Dragon Force!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::DarkMist] || target.pbOpposingSide.effects[PBEffects::DarkMist]
      target.pbOwnSide.effects[PBEffects::DarkMist] = false
      target.pbOpposingSide.effects[PBEffects::DarkMist] = false
      @battle.pbDisplay(_INTL("{1} blew away dark mist!", user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ManaFlux] || target.pbOpposingSide.effects[PBEffects::ManaFlux]
      target.pbOwnSide.effects[PBEffects::ManaFlux] = false
      target.pbOpposingSide.effects[PBEffects::ManaFlux] = false
      @battle.pbDisplay(_INTL("{1} blew away mana flux!", user.pbThis))
    end
    if Settings::MECHANICS_GENERATION >= 8 && @battle.field.terrain != :None
      case @battle.field.terrain
      when :Electric
        @battle.pbDisplay(_INTL("The electricity disappeared from the battlefield."))
      when :Grassy
        @battle.pbDisplay(_INTL("The grass disappeared from the battlefield."))
      when :Misty
        @battle.pbDisplay(_INTL("The mist disappeared from the battlefield."))
      when :Psychic
        @battle.pbDisplay(_INTL("The weirdness disappeared from the battlefield."))
      end
      @battle.field.terrain = :None
    end
  end
end


#===============================================================================
# Tidy Up (Credit to the Gen 9 scripts)
#===============================================================================
# Increases the user's Attack and Speed by 1 stage each.
# Clears all entry hazards and substitutes on both sides.
#-------------------------------------------------------------------------------
class Battle::Move::RaiseUserAtkSpd1RemoveHazardsSubstitutes < Battle::Move::MultiStatUpMove
  def initialize(battle, move)
    super
    @statUp = [:ATTACK, 1, :SPEED, 1]
  end
  
  def pbMoveFailed?(user, targets)
    failed = true
    2.times do |i|
      side = (i == 0) ? user.pbOwnSide : user.pbOpposingSide
      next unless side.effects[PBEffects::Spikes] > 0 ||
                  side.effects[PBEffects::ToxicSpikes] > 0 ||
                  side.effects[PBEffects::StealthRock] ||
                  side.effects[PBEffects::StickyWeb] ||
                  defined?(PBEffects::Steelsurge) && side.effects[PBEffects::Steelsurge] ||
				  side.effects[PBEffects::TerrainSmash] ||
	              side.effects[PBEffects::RestictiveWinds] ||
	              side.effects[PBEffects::HauntedOrbs] ||
	              side.effects[PBEffects::SharpSteel] ||
	              side.effects[PBEffects::BurningDebris] ||
	              side.effects[PBEffects::WaterChannel] ||
	              side.effects[PBEffects::RoseField] ||
	              side.effects[PBEffects::ProtonOverload] ||
	              side.effects[PBEffects::MindField] ||
	              side.effects[PBEffects::IceRing] ||
	              side.effects[PBEffects::DraconicRift] ||
	              side.effects[PBEffects::DarkMist] ||
	              side.effects[PBEffects::ManaFlux]
      failed = false
      break
    end
    @battle.allBattlers.each do |b|
      next if b.effects[PBEffects::Substitute] == 0
        failed = false
      break
    end
    failed2 = true
    (@statUp.length / 2).times do |i|
      next if !user.pbCanRaiseStatStage?(@statUp[i * 2], user, self)
      failed2 = false
      break
    end
    if failed && failed2
      @battle.pbDisplay(_INTL("But it failed!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    showMsg = false
    2.times do |i|
      side = (i == 0) ? user.pbOwnSide : user.pbOpposingSide
      team = (i == 0) ? user.pbTeam(true) : user.pbOpposingTeam(true)
      if side.effects[PBEffects::StealthRock]
        side.effects[PBEffects::StealthRock] = false
        @battle.pbDisplay(_INTL("The pointed stones disappeared from around {1}!", team))
        showMsg = true
      end
      if defined?(PBEffects::Steelsurge) && side.effects[PBEffects::Steelsurge]
        side.effects[PBEffects::Steelsurge] = false
        @battle.pbDisplay(_INTL("The pointed steel disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::Spikes] > 0
        side.effects[PBEffects::Spikes] = 0
        @battle.pbDisplay(_INTL("The spikes disappeared from the ground around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::ToxicSpikes] > 0
        side.effects[PBEffects::ToxicSpikes] = 0
        @battle.pbDisplay(_INTL("The poison spikes disappeared from the ground around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::StickyWeb]
        side.effects[PBEffects::StickyWeb] = false
        @battle.pbDisplay(_INTL("The sticky web has disappeared from the ground around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::TerrainSmash]
        side.effects[PBEffects::TerrainSmash] = false
        @battle.pbDisplay(_INTL("The terrain debris disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::RestictiveWinds]
        side.effects[PBEffects::RestictiveWinds] = false
        @battle.pbDisplay(_INTL("The harsh wind disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::HauntedOrbs]
        side.effects[PBEffects::HauntedOrbs] = false
        @battle.pbDisplay(_INTL("The haunted orbs disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::SharpSteel]
        side.effects[PBEffects::SharpSteel] = false
        @battle.pbDisplay(_INTL("The pointed steel disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::BurningDebris]
        side.effects[PBEffects::BurningDebris] = false
        @battle.pbDisplay(_INTL("The burning debris disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::WaterChannel]
        side.effects[PBEffects::WaterChannel] = false
        @battle.pbDisplay(_INTL("The haunted orbs disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::RoseField]
        side.effects[PBEffects::RoseField] = false
        @battle.pbDisplay(_INTL("The rose field disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::ProtonOverload]
        side.effects[PBEffects::ProtonOverload] = false
        @battle.pbDisplay(_INTL("The electric charge disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::MindField]
        side.effects[PBEffects::MindField] = false
        @battle.pbDisplay(_INTL("The mind field disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::IceRing]
        side.effects[PBEffects::IceRing] = false
        @battle.pbDisplay(_INTL("The ice ring disappeared from around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::DraconicRift]
        side.effects[PBEffects::DraconicRift] = false
        @battle.pbDisplay(_INTL("The Dragon Forze was sealed around {1}!", team))
        showMsg = true
      end
      if side.effects[PBEffects::DarkMist]
        side.effects[PBEffects::DarkMist] = false
        @battle.pbDisplay(_INTL("The dark mist disappeared from around {1}!", team))
        showMsg = true
      end	
      if side.effects[PBEffects::ManaFlux]
        side.effects[PBEffects::ManaFlux] = false
        @battle.pbDisplay(_INTL("The mana flux disappeared from around {1}!", team))
        showMsg = true
      end	  
    end
    @battle.allBattlers.each do |b|
      next if b.effects[PBEffects::Substitute] == 0
      b.effects[PBEffects::Substitute] = 0
      showMsg = true
    end
    @battle.pbDisplay(_INTL("Tidying up complete!")) if showMsg
    super
  end
end


#===============================================================================
# Mortal Spin
#===============================================================================
# Removes trapping moves, entry hazards and Leech Seed on user/user's side.
# Poisons the target.
#-------------------------------------------------------------------------------
class Battle::Move::RemoveUserBindingAndEntryHazardsPoisonTarget < Battle::Move::PoisonTarget
  def pbEffectAfterAllHits(user, target)
    return if user.fainted? || target.damageState.unaffected
    if user.effects[PBEffects::Trapping] > 0
      trapMove = GameData::Move.get(user.effects[PBEffects::TrappingMove]).name
      trapUser = @battle.battlers[user.effects[PBEffects::TrappingUser]]
      @battle.pbDisplay(_INTL("{1} got free of {2}'s {3}!", user.pbThis, trapUser.pbThis(true), trapMove))
      user.effects[PBEffects::Trapping]     = 0
      user.effects[PBEffects::TrappingMove] = nil
      user.effects[PBEffects::TrappingUser] = -1
    end
    if user.effects[PBEffects::LeechSeed] >= 0
      user.effects[PBEffects::LeechSeed] = -1
      @battle.pbDisplay(_INTL("{1} shed Leech Seed!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StealthRock]
      user.pbOwnSide.effects[PBEffects::StealthRock] = false
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!", user.pbThis))
    end
    if defined?(PBEffects::Steelsurge) && user.pbOwnSide.effects[PBEffects::Steelsurge]
      user.pbOwnSide.effects[PBEffects::Steelsurge] = false
      @battle.pbDisplay(_INTL("{1} blew away the pointed steel!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::Spikes] > 0
      user.pbOwnSide.effects[PBEffects::Spikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
      user.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::StickyWeb]
      user.pbOwnSide.effects[PBEffects::StickyWeb] = false
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::TerrainSmash]
      user.pbOwnSide.effects[PBEffects::TerrainSmash] = false
      @battle.pbDisplay(_INTL("{1} blew away the damaged terrain!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::RestictiveWinds]
      user.pbOwnSide.effects[PBEffects::RestictiveWinds] = false
      @battle.pbDisplay(_INTL("{1} blew away restictive winds!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::HauntedOrbs]
      user.pbOwnSide.effects[PBEffects::HauntedOrbs] = false
      @battle.pbDisplay(_INTL("{1} blew away haunted orbs!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::BurningDebris]
      user.pbOwnSide.effects[PBEffects::BurningDebris] = false
      @battle.pbDisplay(_INTL("{1} blew away burning debris!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::WaterChannel]
      user.pbOwnSide.effects[PBEffects::WaterChannel] = false
      @battle.pbDisplay(_INTL("{1} blew away water channel!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::RoseField]
      user.pbOwnSide.effects[PBEffects::RoseField] = false
      @battle.pbDisplay(_INTL("{1} blew away rose field!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ProtonOverload]
      user.pbOwnSide.effects[PBEffects::ProtonOverload] = false
      @battle.pbDisplay(_INTL("{1} blew away the electric charge!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::MindField]
      user.pbOwnSide.effects[PBEffects::MindField] = false
      @battle.pbDisplay(_INTL("{1} blew away mind field!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::IceRing]
      user.pbOwnSide.effects[PBEffects::IceRing] = false
      @battle.pbDisplay(_INTL("{1} blew away ice ring!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::DraconicRift]
      user.pbOwnSide.effects[PBEffects::DraconicRift] = false
      @battle.pbDisplay(_INTL("{1} sealed away the Dragon Force!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::DarkMist]
      user.pbOwnSide.effects[PBEffects::DarkMist] = false
      @battle.pbDisplay(_INTL("{1} blew away dark mist!", user.pbThis))
    end
    if user.pbOwnSide.effects[PBEffects::ManaFlux]
      user.pbOwnSide.effects[PBEffects::ManaFlux] = false
      @battle.pbDisplay(_INTL("{1} blew away mana flux!", user.pbThis))
    end
  end
end

#===============================================================================
# Abilities that remove
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:VOLTABSORB,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::ProtonOverload]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::ProtonOverload] = false
	battler.pbRecoverHP(battler.totalhp / 8)
    battle.pbDisplay(_INTL("{1} absorbed the electric charge!", battler.pbThis))
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:LIGHTNINGROD,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::ProtonOverload]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::ProtonOverload] = false
    battle.pbDisplay(_INTL("{1} absorbed the electric charge!", battler.pbThis))
    if battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler, self)
      battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler)
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:MOTORDRIVE,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::ProtonOverload]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::ProtonOverload] = false
    battle.pbDisplay(_INTL("{1} absorbed the electric charge!", battler.pbThis))
    if battler.pbCanRaiseStatStage?(:SPEED, battler, self)
      battler.pbRaiseStatStage(:SPEED, 1, battler)
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:WATERABSORB,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::WaterChannel]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::WaterChannel] = false
	battler.pbRecoverHP(battler.totalhp / 8)
    battle.pbDisplay(_INTL("{1} absorbed the crashing waves!", battler.pbThis))
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:DRYSKIN,
  proc { |ability, battler, battle, switch_in|
    if battler.pbOwnSide.effects[PBEffects::BurningDebris]
	battle.pbShowAbilitySplash(battler)
	battler.pbReduceHP(battler.totalhp / 4)
    battle.pbDisplay(_INTL("{1} was hurt due to its dry skin!", battler.pbThis))
    if battler.pbOwnSide.effects[PBEffects::WaterChannel]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::WaterChannel] = false
	battler.pbRecoverHP(battler.totalhp / 4)
	if battler.status == :BURN
    battler.pbCureStatus
	end
    battle.pbDisplay(_INTL("{1} absorbed the crashing waves!", battler.pbThis))
	  end
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:STORMDRAIN,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::WaterChannel]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::WaterChannel] = false
    battle.pbDisplay(_INTL("{1} absorbed the crashing waves!", battler.pbThis))
    if battler.pbCanRaiseStatStage?(:SPECIAL_ATTACK, battler, self)
      battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler)
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:FLASHFIRE,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::BurningDebris]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::BurningDebris] = false
	battle.pbDisplay(_INTL("{1} absorbed the burning debris!", battler.pbThis))
	battler.effects[PBEffects::FlashFire] = true
    battle.pbDisplay(_INTL("The power of {1}'s Fire-type moves rose!", battler.pbThis))
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:THERMALEXCHANGE,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::BurningDebris]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::BurningDebris] = false
    battle.pbDisplay(_INTL("{1} absorbed the burning debris!", battler.pbThis))
    if battler.pbCanRaiseStatStage?(:ATTACK, battler, self)
      battler.pbRaiseStatStage(:ATTACK, 1, battler)
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:SAPSIPPER,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::RoseField]
	battle.pbShowAbilitySplash(battler)
	battler.pbOwnSide.effects[PBEffects::RoseField] = false
    battle.pbDisplay(_INTL("{1} ate the rose field!", battler.pbThis))
    if battler.pbCanRaiseStatStage?(:ATTACK, battler, self)
      battler.pbRaiseStatStage(:ATTACK, 1, battler)
	end
	battle.pbHideAbilitySplash(battler)
  }
)

Battle::AbilityEffects::OnSwitchIn.add(:POISONABSORB,
  proc { |ability, battler, battle, switch_in|
    next if !battler.pbOwnSide.effects[PBEffects::ToxicSpikes] > 0
    battle.pbShowAbilitySplash(battler)
	if battler.pbOwnSide.effects[PBEffects::ToxicSpikes] == 2
	battler.pbRecoverHP(battler.totalhp / 6)
    battle.pbDisplay(_INTL("{1} absorbed a large amount of poison spikes!", battler.pbThis))	
	else
	battler.pbRecoverHP(battler.totalhp / 8)
    battle.pbDisplay(_INTL("{1} absorbed the poison spikes!", battler.pbThis))	
    end	
	battler.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
	battle.pbHideAbilitySplash(battler)
  }
)			