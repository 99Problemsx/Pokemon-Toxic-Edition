module Battle::DebugMixin

  def pbBattleDebugBattlerInfo(battler)
    ret = ""
    return ret if battler.nil?
    # Battler index, name
    ret += sprintf("[%d] %s", battler.index, battler.pbThis)
    ret += "\n"
    # Species
    ret += _INTL("Species: {1}", GameData::Species.get(battler.species).name)
    ret += "\n"
    # Form number
    ret += _INTL("Form: {1}", battler.form)
    ret += "\n"
    # Level, gender, shininess
    ret += _INTL("Level {1}, {2}", battler.level,
                 (battler.pokemon.male?) ? "♂" : (battler.pokemon.female?) ? "♀" : _INTL("genderless"))
    ret += ", " + _INTL("shiny") if battler.pokemon.shiny?
    ret += "\n"
    # HP
    ret += _INTL("HP: {1}/{2} ({3}%)", battler.hp, battler.totalhp, (100.0 * battler.hp / battler.totalhp).to_i)
    ret += "\n"
    # Status
    ret += _INTL("Status: {1}", GameData::Status.get(battler.status).name)
    case battler.status
    when :SLEEP
      ret += " " + _INTL("({1} rounds left)", battler.statusCount)
    when :WINDED
      ret += " " + _INTL("({1} rounds left)", battler.statusCount)
	when :BLINDED
      ret += " " + _INTL("({1} rounds left)", battler.statusCount)
    when :POISON
      if battler.statusCount > 0
        ret += " " + _INTL("(toxic, {1}/16)", battler.effects[PBEffects::Toxic])
      end
    end
    ret += "\n"
    # Stat stages
    stages = []
    GameData::Stat.each_battle do |stat|
      next if battler.stages[stat.id] == 0
      stage_text = ""
      stage_text += "+" if battler.stages[stat.id] > 0
      stage_text += battler.stages[stat.id].to_s
      stage_text += " " + stat.name_brief
      stages.push(stage_text)
    end
    ret += _INTL("Stat stages: {1}", (stages.empty?) ? "-" : stages.join(", "))
    ret += "\n"
    # Ability
    ret += _INTL("Ability: {1}", (battler.ability) ? battler.abilityName : "-")
    ret += "\n"
    # Held item
    ret += _INTL("Item: {1}", (battler.item) ? battler.itemName : "-")
    return ret
  end
  
  def pbBattleDebugPokemonInfo(pkmn)
    ret = ""
    return ret if pkmn.nil?
    sp_data = pkmn.species_data
    # Name, species
    ret += sprintf("%s (%s)", pkmn.name, sp_data.name)
    ret += "\n"
    # Form number
    ret += _INTL("Form: {1}", sp_data.form)
    ret += "\n"
    # Level, gender, shininess
    ret += _INTL("Level {1}, {2}", pkmn.level,
                 (pkmn.male?) ? "♂" : (pkmn.female?) ? "♀" : _INTL("genderless"))
    ret += ", " + _INTL("shiny") if pkmn.shiny?
    ret += "\n"
    # HP
    ret += _INTL("HP: {1}/{2} ({3}%)", pkmn.hp, pkmn.totalhp, (100.0 * pkmn.hp / pkmn.totalhp).to_i)
    ret += "\n"
    # Status
    ret += _INTL("Status: {1}", GameData::Status.get(pkmn.status).name)
    case pkmn.status
    when :SLEEP
      ret += " " + _INTL("({1} rounds left)", pkmn.statusCount)
	when :WINDED
      ret += " " + _INTL("({1} rounds left)", pkmn.statusCount)
	when :BLINDED
      ret += " " + _INTL("({1} rounds left)", pkmn.statusCount)
    when :POISON
      ret += " " + _INTL("(toxic)") if pkmn.statusCount > 0
    end
    ret += "\n"
    # Ability
    ret += _INTL("Ability: {1}", pkmn.ability&.name || "-")
    ret += "\n"
    # Held item
    ret += _INTL("Item: {1}", pkmn.item&.name || "-")
    return ret
  end
end


MenuHandlers.add(:pokemon_debug_menu, :set_status, {
  "name"   => _INTL("Set status"),
  "parent" => :hp_status_menu,
  "effect" => proc { |pkmn, pkmnid, heldpoke, settingUpBattle, screen|
    if pkmn.egg?
      screen.pbDisplay(_INTL("{1} is an egg.", pkmn.name))
    elsif pkmn.hp <= 0
      screen.pbDisplay(_INTL("{1} is fainted, can't change status.", pkmn.name))
    else
      cmd = 0
      commands = [_INTL("[Cure]")]
      ids = [:NONE]
      GameData::Status.each do |s|
        next if s.id == :NONE
        commands.push(_INTL("Set {1}", s.name))
        ids.push(s.id)
      end
      loop do
        msg = _INTL("Current status: {1}", GameData::Status.get(pkmn.status).name)
        if pkmn.status == :SLEEP
          msg = _INTL("Current status: {1} (turns: {2})",
                      GameData::Status.get(pkmn.status).name, pkmn.statusCount)
        end
        cmd = screen.pbShowCommands(msg, commands, cmd)
        break if cmd < 0
        case cmd
        when 0
          pkmn.heal_status
          screen.pbRefreshSingle(pkmnid)
        else
          count = 0
          cancel = false
          if [:SLEEP, :DROWSY].include?(ids[cmd]) 
            params = ChooseNumberParams.new
            params.setRange(0, 9)
            params.setDefaultValue(3)
			status = (ids[cmd] == :SLEEP) ? "sleep" : "drowsy"
            count = pbMessageChooseNumber(
              _INTL("Set the Pokémon's #{status} count."), params
            ) { screen.pbUpdate }
            cancel = true if count <= 0
          end
		  if ids[cmd] == :WINDED
            params = ChooseNumberParams.new
            params.setRange(0, 9)
            params.setDefaultValue(3)
            count = pbMessageChooseNumber(
              _INTL("Set the Pokémon's winded count."), params
            ) { screen.pbUpdate }
            cancel = true if count <= 0
          end
		  if ids[cmd] == :BLINDED
            params = ChooseNumberParams.new
            params.setRange(0, 9)
            params.setDefaultValue(3)
            count = pbMessageChooseNumber(
              _INTL("Set the Pokémon's blinded count."), params
            ) { screen.pbUpdate }
            cancel = true if count <= 0
          end
          if !cancel
            pkmn.status      = ids[cmd]
            pkmn.statusCount = count
            screen.pbRefreshSingle(pkmnid)
          end
        end
      end
    end
    next false
  }
})

#-------------------------------------------------------------------------------
MenuHandlers.add(:battle_pokemon_debug_menu, :set_status, {
  "name"   => _INTL("Set status"),
  "parent" => :hp_status_menu,
  "usage"  => :both,
  "effect" => proc { |pkmn, battler, battle|
    if pkmn.egg?
      pbMessage("\\ts[]" + _INTL("{1} is an egg.", pkmn.name))
      next
    elsif pkmn.hp <= 0
      pbMessage("\\ts[]" + _INTL("{1} is fainted, can't change status.", pkmn.name))
      next
    end
    cmd = 0
    commands = [_INTL("[Cure]")]
    ids = [:NONE]
    GameData::Status.each do |s|
      next if s.id == :NONE
      commands.push(_INTL("Set {1}", s.name))
      ids.push(s.id)
    end
    loop do
      msg = _INTL("Current status: {1}", GameData::Status.get(pkmn.status).name)
      if pkmn.status == :WINDED
        msg += " " + _INTL("(turns: {1})", pkmn.statusCount)
      elsif pkmn.status == :SLEEP
        msg += " " + _INTL("(turns: {1})", pkmn.statusCount)
      elsif pkmn.status == :POISON && pkmn.statusCount > 0
        if battler
          msg += " " + _INTL("(toxic, count: {1})", battler.effects[PBEffects::Toxic])
        else
          msg += " " + _INTL("(toxic)")
        end
      end
      cmd = pbMessage("\\ts[]" + msg, commands, -1, nil, cmd)
      break if cmd < 0
      case cmd
      when 0   # Cure
        if battler
          battler.status = :NONE
        else
          pkmn.heal_status
        end
      else   # Give status problem
        pkmn_name = (battler) ? battler.pbThis(true) : pkmn.name
        case ids[cmd]
		when :WINDED
          params = ChooseNumberParams.new
          params.setRange(0, 99)
          params.setDefaultValue((pkmn.status == :WINDED) ? pkmn.statusCount : 3)
          params.setCancelValue(-1)
          count = pbMessageChooseNumber("\\ts[]" + _INTL("Set {1}'s winded count (0-99).", pkmn_name), params)
          next if count < 0
          (battler || pkmn).statusCount = count
		when :BLINDED
          params = ChooseNumberParams.new
          params.setRange(0, 99)
          params.setDefaultValue((pkmn.status == :BLINDED) ? pkmn.statusCount : 3)
          params.setCancelValue(-1)
          count = pbMessageChooseNumber("\\ts[]" + _INTL("Set {1}'s blinded count (0-99).", pkmn_name), params)
          next if count < 0
          (battler || pkmn).statusCount = count
        when :SLEEP, :DROWSY
          params = ChooseNumberParams.new
          params.setRange(0, 99)
          params.setDefaultValue((pkmn.status == :SLEEP) ? pkmn.statusCount : 3)
          params.setCancelValue(-1)
		  status = (ids[cmd] == :SLEEP) ? "sleep" : "drowsy"
          count = pbMessageChooseNumber("\\ts[]" + _INTL("Set {1}'s #{status} count (0-99).", pkmn_name), params)
          next if count < 0
          (battler || pkmn).statusCount = count
        when :POISON
          if pbConfirmMessage("\\ts[]" + _INTL("Make {1} badly poisoned (toxic)?", pkmn_name))
            if battler
              params = ChooseNumberParams.new
              params.setRange(0, 16)
              params.setDefaultValue(battler.effects[PBEffects::Toxic])
              params.setCancelValue(-1)
              count = pbMessageChooseNumber(
                "\\ts[]" + _INTL("Set {1}'s toxic count (0-16).", pkmn_name), params
              )
              next if count < 0
              battler.statusCount = 1
              battler.effects[PBEffects::Toxic] = count
            else
              pkmn.statusCount = 1
            end
          else
            (battler || pkmn).statusCount = 0
          end
        end
        (battler || pkmn).status = ids[cmd]
      end
    end
  }
})
