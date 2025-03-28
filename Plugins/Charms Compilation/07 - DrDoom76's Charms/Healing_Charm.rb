#===============================================================================
# * Healing Charm
#===============================================================================

def pbItemRestoreHP(pkmn, restoreHP)
  healingCharmMultiply = DrCharmConfig::HEALING_CHARM_MULTIPLY
  restoreHP *= healingCharmMultiply if $player.activeCharm?(:HEALINGCHARM)
  newHP = pkmn.hp + restoreHP
  newHP = pkmn.totalhp if newHP > pkmn.totalhp
  hpGain = newHP - pkmn.hp
  pkmn.hp = newHP
  return hpGain
end

#Every 35 steps heals 1 hp. Will not work on fainted Pokemon.
# Check if there's at least one Pokémon in the party that needs healing
EventHandlers.add(:on_player_step_taken, :gain_HP,
  proc {
    healingCharmHealOnStep = DrCharmConfig::HEALING_CHARM_HEAL_ON_STEP
    if $player.activeCharm?(:HEALINGCHARM)
      recovery_interval = healingCharmHealOnStep  # Recover 1 health every 35 steps
      steps_taken = $PokemonGlobal.happinessSteps

      # Check if there's at least one Pokémon in the party that needs healing
      if $Trainer.party.any? { |pkmn| pkmn.able? && pkmn.hp < pkmn.totalhp }
        if steps_taken % recovery_interval == 0
           hp_to_recover = steps_taken / recovery_interval
           $Trainer.party.each do |pkmn|
            if pkmn.able? && pkmn.hp < pkmn.totalhp && hp_to_recover > 0
              recovered_hp = [1, hp_to_recover].min  # Ensure we recover at most 1 HP
              pkmn.hp += recovered_hp
              hp_to_recover -= recovered_hp
              pkmn.hp = pkmn.totalhp if pkmn.hp > pkmn.totalhp
            end
          end
        end
      end
    end
  }
)