#===============================================================================
# Pokemon Hunting
#===============================================================================
# Script
# Main script for this plugin, using all the parameters from the settings,
# doing all the coversation with the hunter.
#===============================================================================
module Pokemon_Hunting
    @pokemon = nil
    @hunted_pokemon = []

    def self.generate_target
        Random_Pokemon_Selector.change_parameter(:baby_pokemon,Pokemon_Hunting_Settings::BABY_POKEMON)
        Random_Pokemon_Selector.change_parameter(:base_form,Pokemon_Hunting_Settings::BASE_FORM)
        Random_Pokemon_Selector.change_parameter(:have_evolution,Pokemon_Hunting_Settings::HAVE_EVOLUTION)
        Random_Pokemon_Selector.change_parameter(:only_type,Pokemon_Hunting_Settings::ONLY_TYPE)
        Random_Pokemon_Selector.change_parameter(:seen,Pokemon_Hunting_Settings::SEEN)
        Random_Pokemon_Selector.change_parameter(:caught,Pokemon_Hunting_Settings::CAUGHT)
        Random_Pokemon_Selector.change_parameter(:generation,Pokemon_Hunting_Settings::GENERATION)
        Random_Pokemon_Selector.set_black_list(@hunted_pokemon) if Pokemon_Hunting_Settings::USE_HUNTED
        pokemon_list = Random_Pokemon_Selector.get_pokemon_list
        return false if !(pokemon_list.length > 0)
        @pokemon = pokemon_list.sample.id
    end

    def self.get_pokemon
        return GameData::Species.try_get(@pokemon)
    end

    def self.get_pokemon_id
        return @pokemon
    end

    def self.get_pokemon_name
        return GameData::Species.try_get(@pokemon).name
    end

    def self.add_hunted_pokemon(pokemon)
        specie = GameData::Species.try_get(pokemon)
        if !specie
            raise _INTL("This function requires a pokemon, but {2} was provided.", pokemon)
        end
        @hunted_pokemon.push(specie.id)
    end

    def self.got_target
        Pokemon_Hunting.add_hunted_pokemon(@pokemon)
        @pokemon = nil
    end

    def self.talk(name = "")
        name = "#{name}: " if name.length > 0
        if !@pokemon.nil?
            pokemon_name = Pokemon_Hunting.get_pokemon_name
            temp_text = "{1}" + Pokemon_Hunting_Settings::ASKING_FOR_CAUGHT.gsub(/\{pokemon\}/, '{2}')
            if pbConfirmMessage(_INTL(temp_text, name, pokemon_name))
                pbChoosePokemonForTrade(1,3,@pokemon)
                if !(pbGet(1) < 0)
                    reward = Pokemon_Hunting.get_reward_by_pokemon($player.party[pbGet(1)])
                    $player.remove_pokemon_at_index(pbGet(1))
                    Pokemon_Hunting.got_target
                    temp_text = "{1}" + Pokemon_Hunting_Settings::AFTER_CAUGHT.gsub(/\{pokemon\}/, '{2}')
                    pbMessage(_INTL(temp_text, name, pokemon_name))
                    if !reward.nil?
                        temp_text = "{1}" + Pokemon_Hunting_Settings::REWARD_GIVING.gsub(/\{pokemon\}/, '{2}')
                        pbMessage(_INTL(temp_text, name, pokemon_name))
                        pbReceiveItem(reward)
                    end
                else
                    temp_text = "{1}" + Pokemon_Hunting_Settings::CATCH_COMMAND.gsub(/\{pokemon\}/, '{2}')
                    pbMessage(_INTL(temp_text, name, pokemon_name))
                end
            else
                temp_text = "{1}" + Pokemon_Hunting_Settings::CATCH_COMMAND.gsub(/\{pokemon\}/, '{2}')
                pbMessage(_INTL(temp_text, name, pokemon_name))
            end
        else
            Pokemon_Hunting.generate_target if @pokemon.nil?
            if !@pokemon
                temp_text = "{1}" + Pokemon_Hunting_Settings::NO_MORE_TARGETS.gsub(/\{pokemon\}/, '{2}')
                pbMessage(_INTL(temp_text, name, pokemon_name))
            else
                pokemon_name = Pokemon_Hunting.get_pokemon_name
                temp_text = "{1}" + Pokemon_Hunting_Settings::NEW_TARGET.gsub(/\{pokemon\}/, '{2}')
                pbMessage(_INTL(temp_text, name, pokemon_name))
            end
        end
    end

    def self.get_reward_by_pokemon(pokemon)
        if Pokemon_Hunting_Settings::SCALED_REWARD
            pokemon_price = (pokemon.level / 5).to_i * (265 - GameData::Species.try_get(pokemon.species).catch_rate)
            item_list = []
            Pokemon_Hunting_Settings::REWARDS.each do |item_id|
                price = GameData::Item.try_get(item_id).price
                item_temp = {
                    :item  => item_id,
                    :price => price
                }
                item_list.push(item_temp)
            end
            item_list.select { |item| item[:price] < pokemon_price }
            item_list.sort_by { |item| -item[:price] }
            return nil if item_list.empty?
            return item_list[0][:item]
        else
            item = Pokemon_Hunting_Settings::REWARDS.sample
            return nil if !GameData::Item.try_get(item)
            return item
        end
    end
end
#===============================================================================
# Pokemon Hunting
#===============================================================================
def pbPokemonHunter(name = "")
    Pokemon_Hunting.talk(name)
end