module ChallengeModes
  module_function

  # Erzwungene Regeln für den Nuzlocke-Modus
  FORCED_RULES = [:PERMAFAINT, :ONE_CAPTURE, :SHINY_CLAUSE, :DUPS_CLAUSE, :FORCE_NICKNAME, :FORCE_SET_BATTLES, :NO_TRAINER_BATTLE_ITEMS]

  # Flag für erzwungene Regeln
  @@use_forced_rules = false

  #-----------------------------------------------------------------------------
  # Methode zur Aktivierung der erzwungenen Regeln
  #-----------------------------------------------------------------------------
  def use_forced_rules(flag)
    @@use_forced_rules = flag
  end

  #-----------------------------------------------------------------------------
  # Methode zur Festlegung der erzwungenen Regeln
  #-----------------------------------------------------------------------------
  def set_forced_rules(rules)
    FORCED_RULES.replace(rules)
  end

  #-----------------------------------------------------------------------------
  # Startet den Challenge-Modus mit den entsprechenden Regeln
  #-----------------------------------------------------------------------------
  def start
    if @@use_forced_rules
      $PokemonGlobal.challenge_rules = FORCED_RULES
    else
      $PokemonGlobal.challenge_rules = select_mode
    end
    return if $PokemonGlobal.challenge_rules.empty?
    $PokemonGlobal.challenge_qued  = true
    $PokemonGlobal.challenge_encs  = {}
    return if !$bag
    GameData::Item.each do |item|
      next if !item.is_poke_ball? || !$bag.has?(item)
      begin_challenge
      pbMessage(_INTL("Your Challenge has begun! Good Luck!"))
      return
    end
  end

  #-----------------------------------------------------------------------------
  # Select rules for challenge mode
  #-----------------------------------------------------------------------------
  def select_mode
    selected_rules = []
    loop do
      selected_rules = select_custom_rules
      if selected_rules.empty?
        next if pbMessage(_INTL("Would you like to play the game without any challenge modifiers?"), [_INTL("Yes"), _INTL("No")]) != 0
      else
        display_rules(selected_rules)
        next if pbMessage(_INTL("Would you like to play the game with your selected modifiers?"), [_INTL("Yes"), _INTL("No")]) != 0
      end
      break
    end
    return selected_rules
  end

  #-----------------------------------------------------------------------------
  # Select custom ruleset for challenge
  #-----------------------------------------------------------------------------
  def select_custom_rules
    selected_rules = []
    catch_clauses  = [:SHINY_CLAUSE, :DUPS_CLAUSE, :GIFT_CLAUSE]
    vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
    infowindow = Window_AdvancedTextPokemon.newWithSize("", 0, Graphics.height - 96, Graphics.width, 96, vp)
    infowindow.setSkin(MessageConfig.pbGetSystemFrame)
    cmdwindow = Window_CommandPokemon_Challenge.new([])
    cmdwindow.viewport = vp
    cmdwindow.y = 64
    text = _INTL("Challenge Options")
    titlewindow = Window_UnformattedTextPokemon.newWithSize(
      text, 0, 0, Graphics.width, 64, vp)
    need_refresh = true
    rules = RULES.keys.clone
    rules.sort! { |a, b| RULES[a][:order] <=> RULES[b][:order] }
    pbSetNarrowFont(infowindow.contents)
    infowindow.text = _INTL(RULES[rules.first][:desc])
    defaultskin = MessageConfig.pbGetSystemFrame.gsub("Graphics/Windowskins/", "")
    loop do
      if need_refresh
        commands = []
        rules.each do |rule|
          toggle = selected_rules.include?(rule) ? 1 : 0
          commands.push([RULES[rule][:name], toggle])
        end
        commands.push(_INTL("Confirm"))
        cmdwindow.commands = commands
        cmdwindow.width = Graphics.width
        cmdwindow.height = Graphics.height - 160
        need_refresh = false
      end
      Graphics.update
      Input.update
      old_index = cmdwindow.index
      cmdwindow.update
      infowindow.update
      pbUpdateSceneMap
      if old_index != cmdwindow.index
        text = ""
        if cmdwindow.index == cmdwindow.commands.length - 1
          text = _INTL("Confirm the following selection of modifiers.") 
        else
          text = RULES[rules[cmdwindow.index]][:desc]
        end
        infowindow.text = _INTL(text) 
        old_index = cmdwindow.index
      end
      if Input.trigger?(Input::BACK)
        infowindow.visible = false
        break if selected_rules.empty?
        selected_rules.clear if pbConfirmMessage(_INTL("\\w[{1}]Clear current selection of modifiers?", defaultskin))
        infowindow.visible = true
        need_refresh = true
      elsif Input.trigger?(Input::USE)
        command = cmdwindow.index
        break if command == ChallengeModes::RULES.values.length
        rule = rules[command]
        updated = false
        if selected_rules.include?(rule)
          selected_rules.delete(rule)
          catch_clauses.each { |r| selected_rules.delete(r) } if rule == :ONE_CAPTURE
          selected_rules.push(:GAME_OVER_WHITEOUT) if !selected_rules.include?(:PERMAFAINT) && !selected_rules.include?(:GAME_OVER_WHITEOUT)
          selected_rules.delete(:GAME_OVER_WHITEOUT) if selected_rules.first == :GAME_OVER_WHITEOUT && selected_rules.length == 1
          updated = true
        elsif (selected_rules.include?(:ONE_CAPTURE) && catch_clauses.include?(rule)) || 
              (selected_rules.include?(:PERMAFAINT) && rule == :GAME_OVER_WHITEOUT) ||
              !(catch_clauses + [:GAME_OVER_WHITEOUT]).include?(rule)
          selected_rules.push(rule)
          selected_rules.push(:GAME_OVER_WHITEOUT) if !selected_rules.include?(:PERMAFAINT) && !selected_rules.include?(:GAME_OVER_WHITEOUT)
          updated = true
        end
        if !updated
          pbPlayBuzzerSE
        else
          pbPlayCursorSE
          selected_rules.sort! { |a, b| RULES[a][:order] <=> RULES[b][:order] }
          need_refresh = true
        end
      end
    end
    cmdwindow.dispose
    infowindow.dispose
    titlewindow.dispose
    vp.dispose
    return selected_rules
  end

  def display_rules(rules)
    vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
    infowindow = Window_AdvancedTextPokemon.newWithSize("", 0, 0, Graphics.width, Graphics.height, vp)
    infowindow.setSkin(MessageConfig.pbGetSystemFrame)
    infowindow.letterbyletter = true
    infowindow.lineHeight = 28
    rule_text  = ""
    rules.each_with_index do |rule, i| 
      next if rule == :GAME_OVER_WHITEOUT
      rule_text += "- " + _INTL(ChallengeModes::RULES[rule][:desc])
      rule_text += "\n" if i != rules.length - (rules.include?(:GAME_OVER_WHITEOUT) ? 2 : 1)
    end
    pbSetSmallFont(infowindow.contents)
    infowindow.text = rule_text
    infowindow.resizeHeightToFit(rule_text)
    infowindow.height = Graphics.height if infowindow.height > Graphics.height
    infowindow.y = (Graphics.height - infowindow.height) / 2
    pbPlayDecisionSE
    loop do
      Graphics.update
      Input.update
      infowindow.update
      pbUpdateSceneMap
      if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        if infowindow.busy?
          pbPlayDecisionSE if infowindow.pausing?
          infowindow.resume
        else
          break
        end
      end
    end
    rule_text  = ""
    if rules.include?(:GAME_OVER_WHITEOUT) || !rules.include?(:PERMAFAINT)
      rule_text += "- " + _INTL(ChallengeModes::RULES[:GAME_OVER_WHITEOUT][:desc])
    else
      rule_text += "- " + _INTL("If all your party Pokémon faint in battle, you will be allowed to continue the challenge with unfainted Pokémon from your PC.")
      rule_text += "\n- " + _INTL("If all the Pokémon in your Party and PC faint, you will lose the challenge.")
    end
    rule_text += "\n"
    rule_text += "- " + _INTL("The challenge begins after you have obtained your first Pokéball.")
    pbSetSmallFont(infowindow.contents)
    infowindow.text = rule_text
    infowindow.resizeHeightToFit(rule_text)
    infowindow.height = Graphics.height if infowindow.height > Graphics.height
    infowindow.y = (Graphics.height - infowindow.height) / 2
    pbPlayDecisionSE
    loop do
      Graphics.update
      Input.update
      infowindow.update
      pbUpdateSceneMap
      if Input.trigger?(Input::USE) || Input.trigger?(Input::BACK)
        if infowindow.busy?
          pbPlayDecisionSE if infowindow.pausing?
          infowindow.resume
        else
          break
        end
      end
    end
    infowindow.dispose
    vp.dispose
  end
end

class Window_CommandPokemon_Challenge < Window_CommandPokemon
  def initialize(commands, width = nil)
    @text_key = []
    commands.each_with_index do |command, i|
      next if !command.is_a?(Array)
      commands[i]  = command[0]
      @text_key[i] = command[1]
    end
    super(commands, width)
  end

  def drawItem(index, count, rect)
    pbSetSystemFont(self.contents)
    rect = drawCursor(index, rect)
    base   = self.baseColor
    shadow = self.shadowColor
    x_pos = rect.x 
    y_pos = rect.y 
    pbDrawShadowText(self.contents, x_pos + 4, y_pos + (self.contents.text_offset_y || 0), 
      rect.width, rect.height, @commands[index], base, shadow)
    return if !@text_key[index]
    text = _INTL("OFF")
    base   = Color.new(232, 32, 16)
    shadow = Color.new(248, 168, 184)
    if @text_key[index] == 1
      text = _INTL("ON")
      base   = Color.new(0, 112, 248)
      shadow = Color.new(120, 184, 232)
    end
    text = "[#{text}]"
    option_width = rect.width / 2
    x_pos += rect.width - option_width
    pbSetSystemFont(self.contents)
    pbDrawShadowText(self.contents, x_pos, rect.y + (self.contents.text_offset_y || 0),
      option_width, rect.height, text, base, shadow, 1)
  end

  def commands=(commands)
    @text_key = []
    commands.each_with_index do |command, i|
      next if !command.is_a?(Array)
      commands[i]  = command[0]
      @text_key[i] = command[1]
    end
    @commands = commands
  end
end