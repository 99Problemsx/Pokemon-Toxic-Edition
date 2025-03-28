#===============================================================================
# Entry hazard. Lays Debris on the opposing side. (Terrain Smash)
#===============================================================================
class Battle::Move::AddTerrainSmashToFoeSide < Battle::Move
  def canMagicCoat?; return true; end

  def pbMoveFailed?(user, targets)
    if user.pbOpposingSide.effects[PBEffects::TerrainSmash]
      @battle.pbDisplay(_INTL("But it failed!"))
	elsif @battle.field.terrain != :None
	  @battle.pbDisplay(_INTL("The terrain is too strong for {1} to smash it!", user.pbThis))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::TerrainSmash] = true
    @battle.pbDisplay(_INTL("The terrain was smashed and debris now covers {1}'s feet!",
                            user.pbOpposingTeam(true)))
  end
end

#=============================================================================
# Terrain
#=============================================================================
class Battle
alias mag_pbStartTerrain pbStartTerrain
  def pbStartTerrain(user, newTerrain, fixedDuration = true)
    if user.pbOwnSide.effects[PBEffects::TerrainSmash]
      pbDisplay(_INTL("The terrain is too smashed to set up the terrain!"))
	  pbHideAbilitySplash(user) if user
      return
    end
    return if @field.terrain == newTerrain
    @field.terrain = newTerrain
    duration = (fixedDuration) ? 5 : -1
    if duration > 0 && user && user.itemActive?
      duration = Battle::ItemEffects.triggerTerrainExtender(user.item, newTerrain,
                                                            duration, user, self)
    end
    @field.terrainDuration = duration
    terrain_data = GameData::BattleTerrain.try_get(@field.terrain)
    pbCommonAnimation(terrain_data.animation) if terrain_data
    pbHideAbilitySplash(user) if user
    case @field.terrain
    when :Electric
      pbDisplay(_INTL("An electric current runs across the battlefield!"))
    when :Grassy
      pbDisplay(_INTL("Grass grew to cover the battlefield!"))
    when :Misty
      pbDisplay(_INTL("Mist swirled about the battlefield!"))
    when :Psychic
      pbDisplay(_INTL("The battlefield got weird!"))
    end
    # Check for abilities/items that trigger upon the terrain changing
    allBattlers.each { |b| b.pbAbilityOnTerrainChange }
    allBattlers.each { |b| b.pbItemTerrainStatBoostCheck }
  end
end