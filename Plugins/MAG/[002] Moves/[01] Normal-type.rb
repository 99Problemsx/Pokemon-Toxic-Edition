#===============================================================================
# First Strike
# On first turn in, Attack for super effective
#===============================================================================
class Battle::Move::CategoryDependsOnHigherDamageSuperEffective1stTurn < Battle::Move
  def initialize(battle, move)
    super
    @calcCategory = 1
  end

  def physicalMove?(thisType = nil); return (@calcCategory == 0); end
  def specialMove?(thisType = nil);  return (@calcCategory == 1); end
  def contactMove?;                  return physicalMove?;        end

  def pbOnStartUse(user, targets)
    target = targets[0]
    return if !target
    max_stage = Battle::Battler::STAT_STAGE_MAXIMUM
    stageMul = Battle::Battler::STAT_STAGE_MULTIPLIERS
    stageDiv = Battle::Battler::STAT_STAGE_DIVISORS
    # Calculate user's effective attacking values
    attack_stage         = user.stages[:ATTACK] + max_stage
    real_attack          = (user.attack.to_f * stageMul[attack_stage] / stageDiv[attack_stage]).floor
    special_attack_stage = user.stages[:SPECIAL_ATTACK] + max_stage
    real_special_attack  = (user.spatk.to_f * stageMul[special_attack_stage] / stageDiv[special_attack_stage]).floor
    # Calculate target's effective defending values
    defense_stage         = target.stages[:DEFENSE] + max_stage
    real_defense          = (target.defense.to_f * stageMul[defense_stage] / stageDiv[defense_stage]).floor
    special_defense_stage = target.stages[:SPECIAL_DEFENSE] + max_stage
    real_special_defense  = (target.spdef.to_f * stageMul[special_defense_stage] / stageDiv[special_defense_stage]).floor
    # Perform simple damage calculation
    physical_damage = real_attack.to_f / real_defense
    special_damage = real_special_attack.to_f / real_special_defense
    # Determine move's category
    if physical_damage == special_damage
      @calcCategory = (@battle.command_phase) ? rand(2) : @battle.pbRandom(2)
    else
      @calcCategory = (physical_damage > special_damage) ? 0 : 1
    end
  end
  
  def pbCalcTypeModSingle(moveType, defType, user, target)
    return Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if moveType == :NORMAL && user.turnCount <= 1
    return super
  end

  def pbShowAnimation(id, user, targets, hitNum = 0, showAnimation = true)
    hitNum = 1 if physicalMove?
    super
  end
end


  
