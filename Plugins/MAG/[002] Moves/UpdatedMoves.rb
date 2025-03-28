#===============================================================================
# Feint
# Added new protects to break
#===============================================================================
class Battle::Move::RemoveProtections < Battle::Move
  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::BanefulBunker]          = false
    target.effects[PBEffects::KingsShield]            = false
    target.effects[PBEffects::Obstruct]               = false
    target.effects[PBEffects::Protect]                = false
    target.effects[PBEffects::SpikyShield]            = false
    target.pbOwnSide.effects[PBEffects::CraftyShield] = false
    target.pbOwnSide.effects[PBEffects::MatBlock]     = false
    target.pbOwnSide.effects[PBEffects::QuickGuard]   = false
    target.pbOwnSide.effects[PBEffects::WideGuard]    = false
	#new
	target.pbOwnSide.effects[PBEffects::QueensShield] = false
  end
end

#===============================================================================
# Hyperspace Fury
# Added new protects to break
#===============================================================================
class Battle::Move::HoopaRemoveProtectionsBypassSubstituteLowerUserDef1 < Battle::Move::StatDownMove
  def ignoresSubstitute?(user); return true; end

  def initialize(battle, move)
    super
    @statDown = [:DEFENSE, 1]
  end

  def pbMoveFailed?(user, targets)
    if !user.isSpecies?(:HOOPA)
      @battle.pbDisplay(_INTL("But {1} can't use the move!", user.pbThis(true)))
      return true
    elsif user.form != 1
      @battle.pbDisplay(_INTL("But {1} can't use it the way it is now!", user.pbThis(true)))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    target.effects[PBEffects::BanefulBunker]          = false
    target.effects[PBEffects::KingsShield]            = false
    target.effects[PBEffects::Obstruct]               = false
    target.effects[PBEffects::Protect]                = false
    target.effects[PBEffects::SpikyShield]            = false
    target.pbOwnSide.effects[PBEffects::CraftyShield] = false
    target.pbOwnSide.effects[PBEffects::MatBlock]     = false
    target.pbOwnSide.effects[PBEffects::QuickGuard]   = false
    target.pbOwnSide.effects[PBEffects::WideGuard]    = false
	#new
	target.pbOwnSide.effects[PBEffects::QueensShield] = false
  end
end

#===============================================================================
# User and target swap items. They remain swapped after wild battles.
# (Switcheroo, Trick) #Monkey Business
#===============================================================================
class Battle::Move::UserTargetSwapItems < Battle::Move
  def pbMoveFailed?(user, targets)
    if user.wild?
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user, target, show_message)
    if !user.item && !target.item
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.unlosableItem?(target.item) ||
       target.unlosableItem?(user.item) ||
       user.unlosableItem?(user.item) ||
       user.unlosableItem?(target.item)
      @battle.pbDisplay(_INTL("But it failed!")) if show_message
      return true
    end
    if target.hasActiveAbility?(:STICKYHOLD) && !@battle.moldBreaker
      if show_message
        @battle.pbShowAbilitySplash(target)
        if Battle::Scene::USE_ABILITY_SPLASH
          @battle.pbDisplay(_INTL("But it failed to affect {1}!", target.pbThis(true)))
        else
          @battle.pbDisplay(_INTL("But it failed to affect {1} because of its {2}!",
                                  target.pbThis(true), target.abilityName))
        end
        @battle.pbHideAbilitySplash(target)
      end
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user, target)
    oldUserItem = user.item
    oldUserItemName = user.itemName
    oldTargetItem = target.item
    oldTargetItemName = target.itemName
    user.item                             = oldTargetItem
    user.effects[PBEffects::ChoiceBand]   = nil if !user.hasActiveAbility?(:GORILLATACTICS, :MONKEYBUSINESS)
    user.effects[PBEffects::Unburden]     = (!user.item && oldUserItem) if user.hasActiveAbility?(:UNBURDEN)
    target.item                           = oldUserItem
    target.effects[PBEffects::ChoiceBand] = nil if !target.hasActiveAbility?(:GORILLATACTICS, :MONKEYBUSINESS)
    target.effects[PBEffects::Unburden]   = (!target.item && oldTargetItem) if target.hasActiveAbility?(:UNBURDEN)
    # Permanently steal the item from wild Pokémon
    if target.wild? && !user.initialItem && oldTargetItem == target.initialItem
      user.setInitialItem(oldTargetItem)
    end
    @battle.pbDisplay(_INTL("{1} switched items with its opponent!", user.pbThis))
    @battle.pbDisplay(_INTL("{1} obtained {2}.", user.pbThis, oldTargetItemName)) if oldTargetItem
    @battle.pbDisplay(_INTL("{1} obtained {2}.", target.pbThis, oldUserItemName)) if oldUserItem
    user.pbHeldItemTriggerCheck
    target.pbHeldItemTriggerCheck
  end
end