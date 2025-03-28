class DetailsScene
  def update
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
       @sprites["bg"].oy += 1
    end
  end

  def pbStartScene(panel_name, panel_type, round, cursor_position, trainers, tr_types, tr_form, icons, classified, player_position)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundPlane(@sprites, "bg", "Result Panel/bg_1", @viewport) if ([8, 2].include?(panel_type) && cursor_position <= 8) || (panel_type == 16 && cursor_position <= 16)  
    addBackgroundPlane(@sprites, "bg", "Result Panel/bg_2", @viewport) if ([8, 2].include?(panel_type) && cursor_position >= 9) || (panel_type == 16 && cursor_position >= 17)
    @sprites["background"] = IconSprite.new(448, 288, @viewport)
    @sprites["background"].setBitmap(Settings::FILEPATH + "Competitor_back") if ([8, 2].include?(panel_type) && cursor_position <= 8) || (panel_type == 16 && cursor_position <= 16)
    @sprites["background"].setBitmap(Settings::FILEPATH + "VS_back") if ([8, 2].include?(panel_type) && cursor_position >= 9) || (panel_type == 16 && cursor_position >= 17)
    @sprites["background"].x = (Graphics.width - @sprites["background"].bitmap.width)/2
    @sprites["background"].y = (Graphics.height - @sprites["background"].bitmap.height)/2

    @sprites["bg"].zoom_x = 2 ; @sprites["bg"].zoom_y = 2
    @sprites["bg"].oy += 26
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)

    @cursor_position = cursor_position
    @panel_name = panel_name
    @panel_type = panel_type
    @round = round
    @trainers = trainers
    @tr_types = tr_types
    @tr_form = tr_form
    @player_position = player_position
    @icons = icons
    @classified = classified

    if @panel_type == 2
      @teams = Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Teams]

      for i in 0...@teams.size
        @teams[i] = $game_variables[@teams[i]].to_s if @teams[i].is_a?(Integer)
      end
    end

    @sprites["arrowdown"] = AnimatedSprite.new("Graphics/UI/down_arrow",8, 28, 40, 2, @viewport)
    @sprites["arrowdown"].x = Graphics.width/2 - 14
    @sprites["arrowdown"].y = 324
    @sprites["arrowdown"].play
    @sprites["arrowup"] = AnimatedSprite.new("Graphics/UI/up_arrow",8, 28, 40, 2, @viewport)
    @sprites["arrowup"].x = Graphics.width/2 - 14
    @sprites["arrowup"].y = 20
    @sprites["arrowup"].play
    @sprites["arrowleft"] = AnimatedSprite.new("Graphics/UI/left_arrow", 8, 40, 28, 2, @viewport)
    @sprites["arrowleft"].x = 4
    @sprites["arrowleft"].y = Graphics.height/2 - 14
    @sprites["arrowleft"].play
    @sprites["arrowright"] = AnimatedSprite.new("Graphics/UI/right_arrow", 8, 40, 28, 2, @viewport)
    @sprites["arrowright"].x = 468
    @sprites["arrowright"].y = Graphics.height/2 - 14
    @sprites["arrowright"].play

    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbUpdateTrainerInfo
    pbUpdateArrows
    pbFadeInAndShow(@sprites) { update }
  end

  def pbUpdatePage(direction)
    aux = @cursor_position
    if direction.to_s == "up"
      @cursor_position -= 1 if [2, 3, 4, 6, 7, 8, 10, 12].include?(@cursor_position) && [8, 2].include?(@panel_type)
      @cursor_position -= 1 if (@cursor_position.between?(2, 8) || @cursor_position.between?(10, 16) || [18, 19, 20, 22, 23, 24, 26, 28].include?(@cursor_position)) && @panel_type == 16
    elsif direction.to_s == "down"
      @cursor_position += 1 if [1, 2, 3, 5, 6, 7, 9, 11].include?(@cursor_position) && [8, 2].include?(@panel_type)
      @cursor_position += 1 if (@cursor_position.between?(1, 7) || @cursor_position.between?(9, 15) || [17, 18, 19, 21, 22, 23, 25, 27].include?(@cursor_position)) && @panel_type == 16
    elsif direction.to_s == "left"
      if [8, 2].include?(@panel_type)
        @cursor_position -= 4 if @cursor_position >=5 && @round == 1
	@cursor_position = 1 if @cursor_position == 9 && @round > 1
	@cursor_position = 3 if @cursor_position == 10 && @round > 1
	@cursor_position = 9 if @cursor_position == 11 && @round == 2
	@cursor_position = 10 if @cursor_position == 12 && @round == 2
	@cursor_position = 9 if @cursor_position == 13 && @round > 2
	@cursor_position = 13 if @cursor_position == 14 && @round == 3
	@cursor_position = 13 if @cursor_position == 15 && @round > 3
	@cursor_position = 15 if @cursor_position == 14 && @round > 3
	@cursor_position = 14 if [11, 12].include?(@cursor_position) && @round > 2
	@cursor_position = 11 if [5, 6].include?(@cursor_position) && @round > 1
	@cursor_position = 12 if [7, 8].include?(@cursor_position) && @round > 1
      elsif @panel_type == 16
	@cursor_position -= 8 if @cursor_position >=9 && @round == 1
	@cursor_position = 1 if @cursor_position == 17 && @round > 1
	@cursor_position = 3 if @cursor_position == 18 && @round > 1
	@cursor_position = 5 if @cursor_position == 19 && @round > 1
	@cursor_position = 7 if @cursor_position == 20 && @round > 1
	@cursor_position = 17 if @cursor_position == 21 && @round == 2
	@cursor_position = 18 if @cursor_position == 22 && @round == 2
	@cursor_position = 19 if @cursor_position == 23 && @round == 2
	@cursor_position = 20 if @cursor_position == 24 && @round == 2
	@cursor_position = 17 if @cursor_position == 25 && @round > 2
	@cursor_position = 19 if @cursor_position == 26 && @round > 2
	@cursor_position = 25 if @cursor_position == 27 && @round == 3
	@cursor_position = 26 if @cursor_position == 28 && @round == 3
	@cursor_position = 25 if @cursor_position == 29 && @round > 3
	@cursor_position = 29 if @cursor_position == 30 && @round == 4
	@cursor_position = 29 if @cursor_position == 31 && @round > 4
	@cursor_position = 31 if @cursor_position == 30 && @round > 4
	@cursor_position = 30 if [27, 28].include?(@cursor_position) && @round > 3
	@cursor_position = 27 if [21, 22].include?(@cursor_position) && @round > 2
	@cursor_position = 28 if [23, 24].include?(@cursor_position) && @round > 2
	@cursor_position = 21 if [9, 10].include?(@cursor_position) && @round > 1
	@cursor_position = 22 if [11, 12].include?(@cursor_position) && @round > 1
	@cursor_position = 23 if [13, 14].include?(@cursor_position) && @round > 1
	@cursor_position = 24 if [15, 16].include?(@cursor_position) && @round > 1
      end
    elsif direction.to_s == "right"
      if [8, 2].include?(@panel_type)
        @cursor_position += 4 if @cursor_position <=4 && @round == 1
	@cursor_position = 5 if @cursor_position == 11 && @round > 1
	@cursor_position = 7 if @cursor_position == 12 && @round > 1
	@cursor_position = 11 if @cursor_position == 9 && @round == 2
	@cursor_position = 12 if @cursor_position == 10 && @round == 2
	@cursor_position = 11 if @cursor_position == 14 && @round > 2
	@cursor_position = 14 if @cursor_position == 13 && @round == 3
	@cursor_position = 14 if @cursor_position == 15 && @round > 3
	@cursor_position = 15 if @cursor_position == 13 && @round > 3
	@cursor_position = 13 if [9, 10].include?(@cursor_position) && @round > 2
	@cursor_position = 10 if [3, 4].include?(@cursor_position) && @round > 1
	@cursor_position = 9 if [1, 2].include?(@cursor_position) && @round > 1
      elsif @panel_type == 16
	@cursor_position += 8 if @cursor_position <=8 && @round == 1
	@cursor_position = 9 if @cursor_position == 21 && @round > 1
	@cursor_position = 11 if @cursor_position == 22 && @round > 1
	@cursor_position = 13 if @cursor_position == 23 && @round > 1
	@cursor_position = 15 if @cursor_position == 24 && @round > 1
	@cursor_position = 21 if @cursor_position == 17 && @round == 2
	@cursor_position = 22 if @cursor_position == 18 && @round == 2
	@cursor_position = 23 if @cursor_position == 19 && @round == 2
	@cursor_position = 24 if @cursor_position == 20 && @round == 2
	@cursor_position = 21 if @cursor_position == 27 && @round > 2
	@cursor_position = 23 if @cursor_position == 28 && @round > 2
	@cursor_position = 27 if @cursor_position == 25 && @round == 3
	@cursor_position = 28 if @cursor_position == 26 && @round == 3
	@cursor_position = 27 if @cursor_position == 30 && @round > 3
	@cursor_position = 30 if @cursor_position == 29 && @round == 4
	@cursor_position = 30 if @cursor_position == 31 && @round > 4
	@cursor_position = 31 if @cursor_position == 29 && @round > 4
	@cursor_position = 29 if [25, 26].include?(@cursor_position) && @round > 3
	@cursor_position = 25 if [17, 18].include?(@cursor_position) && @round > 2
	@cursor_position = 26 if [19, 20].include?(@cursor_position) && @round > 2
	@cursor_position = 17 if [1, 2].include?(@cursor_position) && @round > 1
	@cursor_position = 18 if [3, 4].include?(@cursor_position) && @round > 1
	@cursor_position = 19 if [5, 6].include?(@cursor_position) && @round > 1
	@cursor_position = 20 if [7, 8].include?(@cursor_position) && @round > 1
      end
    end
    if aux != @cursor_position
      pbPlayCancelSE
      pbFadeOutIn(99999) {
	aux = 0
        @sprites["trainer"].dispose if @sprites["trainer"]
        @sprites["trainer1"].dispose if @sprites["trainer1"]
        @sprites["trainer2"].dispose if @sprites["trainer2"]
        @sprites["trainer3"].dispose if @sprites["trainer3"]
        @sprites["trainer4"].dispose if @sprites["trainer4"]
	@sprites["background"].setBitmap(Settings::FILEPATH + "Competitor_back") if ([8, 2].include?(@panel_type) && @cursor_position <= 8) || (@panel_type == 16 && @cursor_position <= 16)
	@sprites["background"].setBitmap(Settings::FILEPATH + "VS_back") if ([8, 2].include?(@panel_type) && @cursor_position >= 9) || (@panel_type == 16 && @cursor_position >= 17)
	@sprites["bg"].setBitmap(Settings::FILEPATH + "bg_1") if ([8, 2].include?(@panel_type) && @cursor_position <= 8) || (@panel_type == 16 && @cursor_position <= 16)
	@sprites["bg"].setBitmap(Settings::FILEPATH + "bg_2") if ([8, 2].include?(@panel_type) && @cursor_position >= 9) || (@panel_type == 16 && @cursor_position >= 17)
        for pokemon in $player.party
          aux += 1
      	  @sprites["pokemon" + aux.to_s].dispose if @sprites["pokemon" + aux.to_s]
      	  @sprites["pokemon" + (aux + 3).to_s].dispose if @sprites["pokemon" + (aux + 3).to_s]
        end
        pbUpdateTrainerInfo
        pbUpdateArrows
      }
    end
  end

  def pbUpdateArrows
    if [8, 2].include?(@panel_type)
      [4, 8, 10, 12, 13, 14, 15].include?(@cursor_position) ? @sprites["arrowdown"].visible = false : @sprites["arrowdown"].visible = true
      [1, 5, 9, 11, 13, 14, 15].include?(@cursor_position) ? @sprites["arrowup"].visible = false : @sprites["arrowup"].visible = true
      @cursor_position.between?(5, 8) ? @sprites["arrowright"].visible = false : @sprites["arrowright"].visible = true
      @cursor_position <= 4 ? @sprites["arrowleft"].visible = false : @sprites["arrowleft"].visible = true
    else
      [8, 16, 20, 24, 26, 28, 29, 30, 31].include?(@cursor_position) ? @sprites["arrowdown"].visible = false : @sprites["arrowdown"].visible = true
      [1, 9, 17, 21, 25, 27, 29, 30, 31].include?(@cursor_position) ? @sprites["arrowup"].visible = false : @sprites["arrowup"].visible = true
      @cursor_position.between?(9, 16) ? @sprites["arrowright"].visible = false : @sprites["arrowright"].visible = true
      @cursor_position <= 8 ? @sprites["arrowleft"].visible = false : @sprites["arrowleft"].visible = true
    end
  end

  def pbTeamStyle(pkmn_stat)
    result = "Emphasizes "
    possibilities = ["HP", "ATTACK", "DEFENSE", "SP. ATTACK", "SP. DEFENSE", "SPEED"]
    result += possibilities[pkmn_stat[0]] + "." if pkmn_stat.size == 1
    result += possibilities[pkmn_stat[0]] + " and " + possibilities[pkmn_stat[1]] + "." if pkmn_stat.size == 2
    return "Raises POKÉMON in a well-balanced way." if pkmn_stat.size > 2
    return result
  end

  def pbUpdateTrainerInfo
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base_color = Color.new(248, 248, 248) #9 = 3; 10 = 7; 11 = 11; 12 = 15
    shadow_color = Color.new(72, 80, 88)
    text_positions = []

    if ([8, 2].include?(@panel_type) && @cursor_position >= 9) || (@panel_type == 16 && @cursor_position >= 17)

      text_positions.push(["",Graphics.width/2,68,2,base_color,shadow_color])
      text_positions.push(["", 136, 112, 2, base_color,shadow_color])
      text_positions.push(["", 376, 112, 2, base_color,shadow_color])
      text_positions.push(["", Graphics.width/2, 300, 2, base_color,shadow_color])

      if @panel_type != 2
        if Settings::TRAINERSTYLE == 1
          @sprites["trainer1"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer1"].x = 74
          @sprites["trainer1"].y = 154
          @sprites["trainer2"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer2"].x = 298
          @sprites["trainer2"].y = 154
	else
          @sprites["trainer1"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer1"].x = 64
          @sprites["trainer1"].y = 130
          @sprites["trainer2"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer2"].x = 288
          @sprites["trainer2"].y = 130
	end
      else
        if Settings::TRAINERSTYLE == 1
          @sprites["trainer1"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer1"].x = 32
          @sprites["trainer1"].y = 154
          @sprites["trainer2"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer2"].x = 106
          @sprites["trainer2"].y = 154
          @sprites["trainer3"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer3"].x = 266
          @sprites["trainer3"].y = 154
          @sprites["trainer4"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer4"].x = 340
          @sprites["trainer4"].y = 154
	else
          @sprites["trainer1"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer1"].x = 22
          @sprites["trainer1"].y = 130
          @sprites["trainer2"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer2"].x = 96
          @sprites["trainer2"].y = 130
          @sprites["trainer3"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer3"].x = 256
          @sprites["trainer3"].y = 130
          @sprites["trainer4"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer4"].x = 330
          @sprites["trainer4"].y = 130
	end
      end

      if @panel_type == 8
        aux = 0
        for i in 9...16
	  if @cursor_position == i && @cursor_position <= 12
	    text_positions[0][0] = @classified[0][4]
	    text_positions[1][0] = @trainers[aux].upcase
	    text_positions[2][0] = @trainers[aux + 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[0][i-9] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[aux])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[aux + 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux)
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux + 1)

	    break
	  elsif @cursor_position == i && @cursor_position.between?(13,14)
	    text_positions[0][0] = @classified[1][2]
	    text_positions[1][0] = @trainers[@classified[0][aux] - 1].upcase
	    text_positions[2][0] = @trainers[@classified[0][aux + 1] - 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[1][i-13] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux] - 1])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux + 1] - 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux + 1])

	    break
	  elsif @cursor_position == 15
	    text_positions[0][0] = @classified[2][1]
	    text_positions[1][0] = @trainers[@classified[1][0] - 1].upcase
	    text_positions[2][0] = @trainers[@classified[1][1] - 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[2][0] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][0] - 1])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][1] - 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][0])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][1])
	  end
	  aux += 2
	  aux = 0 if i == 12
        end
      elsif @panel_type == 2
	aux = 0
        for i in 9...16
	  if @cursor_position == i && @cursor_position <= 12
	    text_positions[0][0] = @classified[0][4]
	    text_positions[1][0] = @teams[aux]
	    text_positions[2][0] = @teams[aux + 1]
	    text_positions[3][0] = "The winner is " + @teams[@classified[0][i-9] - 1] + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[aux][0])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[aux][1])
	    @sprites["trainer3"].setBitmap("Graphics/Trainers/" + @tr_types[aux + 1][0])
	    @sprites["trainer4"].setBitmap("Graphics/Trainers/" + @tr_types[aux + 1][1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux)
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux)
	    @sprites["trainer3"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux + 1)
	    @sprites["trainer4"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-9] - 1 == aux + 1)
	    break
	  elsif @cursor_position == i && @cursor_position.between?(13,14)
	    text_positions[0][0] = @classified[1][2]
	    text_positions[1][0] = @teams[@classified[0][aux] - 1]
	    text_positions[2][0] = @teams[@classified[0][aux + 1] - 1]
	    text_positions[3][0] = "The winner is " + @teams[@classified[1][i-13] - 1] + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux] - 1][0])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux] - 1][1])
	    @sprites["trainer3"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux + 1] - 1][0])
	    @sprites["trainer4"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux + 1] - 1][1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux])
	    @sprites["trainer3"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux + 1])
	    @sprites["trainer4"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-13] == @classified[0][aux + 1])

	    break
	  elsif @cursor_position == 15
	    text_positions[0][0] = @classified[2][1]
	    text_positions[1][0] = @teams[@classified[1][0] - 1]
	    text_positions[2][0] = @teams[@classified[1][1] - 1]
	    text_positions[3][0] = "The winner is " + @teams[@classified[2][0] - 1] + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][0] - 1][0])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][0] - 1][1])
	    @sprites["trainer3"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][1] - 1][0])
	    @sprites["trainer4"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][1] - 1][1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][0])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][0])
	    @sprites["trainer3"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][1])
	    @sprites["trainer4"].tone = Tone.new(0,0,0,255) if !(@classified[2][0] == @classified[1][1])
	  end
	  aux += 2
	  aux = 0 if i == 12
        end
      elsif @panel_type == 16
        aux = 0
        for i in 17...32
	  if @cursor_position == i && @cursor_position <= 24
	    text_positions[0][0] = @classified[0][8]
	    text_positions[1][0] = @trainers[aux].upcase
	    text_positions[2][0] = @trainers[aux + 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[0][i-17] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[aux])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[aux + 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-17] - 1 == aux)
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[0][i-17] - 1 == aux + 1)

	    break
	  elsif @cursor_position == i && @cursor_position.between?(25,28)
	    text_positions[0][0] = @classified[1][4]
	    text_positions[1][0] = @trainers[@classified[0][aux] - 1].upcase
	    text_positions[2][0] = @trainers[@classified[0][aux + 1] - 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[1][i-25] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux] - 1])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[0][aux + 1] - 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-25] == @classified[0][aux])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[1][i-25] == @classified[0][aux + 1])

	    break
          elsif @cursor_position == i && @cursor_position.between?(29,30)
	    text_positions[0][0] = @classified[2][2]
	    text_positions[1][0] = @trainers[@classified[1][aux] - 1].upcase
	    text_positions[2][0] = @trainers[@classified[1][aux + 1] - 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[2][i-29] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][aux] - 1])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[1][aux + 1] - 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[2][i-29] == @classified[1][aux])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[2][i-29] == @classified[1][aux + 1])

	    break
	  elsif @cursor_position == 31
	    text_positions[0][0] = @classified[3][1]
	    text_positions[1][0] = @trainers[@classified[2][0] - 1].upcase
	    text_positions[2][0] = @trainers[@classified[2][1] - 1].upcase
	    text_positions[3][0] = "The winner is " + @trainers[@classified[3][0] - 1].upcase + "!"

	    @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[2][0] - 1])
	    @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@classified[2][1] - 1])
	    @sprites["trainer1"].tone = Tone.new(0,0,0,255) if !(@classified[3][0] == @classified[2][0])
	    @sprites["trainer2"].tone = Tone.new(0,0,0,255) if !(@classified[3][0] == @classified[2][1])
	  end
	  aux += 2
	  aux = 0 if [24, 28].include?(i)
        end
      end
      text_positions[1][0] = $player.name.upcase if text_positions[1][0] == "PLAYER"
      text_positions[2][0] = $player.name.upcase if text_positions[2][0] == "PLAYER"
      text_positions[3][0] = "The winner is " + $player.name.upcase + "!" if text_positions[3][0] == "The winner is PLAYER!"

    elsif ([8, 2].include?(@panel_type) && @cursor_position <= 8) || (@panel_type == 16 && @cursor_position <= 16)
      if @panel_type != 2
	if GameData::TrainerType.exists?(:"#{@tr_types[@cursor_position - 1]}")
          text_positions.push([GameData::TrainerType.get(:"#{@tr_types[@cursor_position - 1]}").name.upcase + " ",Graphics.width/2,66,2,base_color,shadow_color])
	else
	  text_positions.push(["TRAINER ",Graphics.width/2,66,2,base_color,shadow_color])
	end

	if @cursor_position == @player_position
	  text_positions[0][0] += $player.name.upcase
	  text_positions.push([Settings::PHRASES[0][4], Graphics.width/2, 268, 2, base_color,shadow_color])
	else
	  text_positions[0][0] += @trainers[@cursor_position - 1].upcase
	  text_positions.push([Settings::PHRASES[0][0], Graphics.width/2, 268, 2, base_color,shadow_color])

	  cs = 4 if @panel_type == 16
	  cs = 3 if @panel_type == 8

	  for i in 0...cs
	    for j in 0...@classified[i].size
	      text_positions[1][0] = Settings::PHRASES[0][i + 1] if @classified[i][j] == @cursor_position && i < 3
	      text_positions[1][0] = Settings::PHRASES[0][i] if @classified[i][j] == @cursor_position && i == 3
	    end
	  end
	end

	if Settings::TRAINERSTYLE == 1
          @sprites["trainer"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1])
          @sprites["trainer"].x = 60
          @sprites["trainer"].y = 116
	else
          @sprites["trainer"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1])
          @sprites["trainer"].x = 44
          @sprites["trainer"].y = 98
	end

      else
        @trainers[@cursor_position - 1][0].upcase == "PLAYER" ? t1 = $player.name.upcase : t1 = @trainers[@cursor_position - 1][0].upcase
        @trainers[@cursor_position - 1][1].upcase == "PLAYER" ? t2 = $player.name.upcase : t2 = @trainers[@cursor_position - 1][1].upcase

        text_positions.push([@teams[@cursor_position - 1] + " : " + t1 + " & " + t2,Graphics.width/2,66,2,base_color,shadow_color])

	if @cursor_position == @player_position
	  text_positions.push([Settings::PHRASES[1][4], Graphics.width/2, 268, 2, base_color,shadow_color])
	else
	  text_positions.push([Settings::PHRASES[1][0], Graphics.width/2, 268, 2, base_color,shadow_color])

	  for i in 0...3
	    for j in 0...@classified[i].size - 1
	      text_positions[1][0] = Settings::PHRASES[1][i + 1] if @teams[@classified[i][j] - 1] == @teams[@cursor_position - 1]
	    end
	  end
	end

	if Settings::TRAINERSTYLE == 1
          @sprites["trainer1"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1][0])
          @sprites["trainer1"].x = 22
          @sprites["trainer1"].y = 116
          @sprites["trainer2"] = IconSprite.new(128, 128, @viewport)
          @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1][1])
          @sprites["trainer2"].x = 96
          @sprites["trainer2"].y = 116
	else
          @sprites["trainer1"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer1"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1][0])
          @sprites["trainer1"].x = 2
          @sprites["trainer1"].y = 98
          @sprites["trainer2"] = IconSprite.new(160, 160, @viewport)
          @sprites["trainer2"].setBitmap("Graphics/Trainers/" + @tr_types[@cursor_position - 1][1])
          @sprites["trainer2"].x = 76
          @sprites["trainer2"].y = 98
	end
      end

      aux = 0
      tr_data = $player.party
      @pkmn_stats = [0, 0, 0, 0, 0, 0]

      if @panel_type != 2
	if @cursor_position != @player_position
	  if GameData::Trainer.exists?(:"#{@tr_types[@cursor_position - 1]}", @trainers[@cursor_position - 1], @tr_form[@cursor_position - 1])
            tr_data = GameData::Trainer.get(:"#{@tr_types[@cursor_position - 1]}", @trainers[@cursor_position - 1], @tr_form[@cursor_position - 1]).pokemon
          else
	    unknow = true
          end
	end

	for pokemon in tr_data
          aux += 1
	  if aux <= $player.party.size
	    pkmn = pokemon
	    if !unknow
              if tr_data != $player.party
	        species = GameData::Species.get(pokemon[:species]).species
	        pkmn = Pokemon.new(species, pokemon[:level], tr_data, false)
	      end
	      @pkmn_stats[0] += pkmn.baseStats[:HP]
              @pkmn_stats[1] += pkmn.baseStats[:ATTACK]
              @pkmn_stats[2] += pkmn.baseStats[:DEFENSE]
              @pkmn_stats[3] += pkmn.baseStats[:SPECIAL_ATTACK]
              @pkmn_stats[4] += pkmn.baseStats[:SPECIAL_DEFENSE]
              @pkmn_stats[5] += pkmn.baseStats[:SPEED]
	    end

	    if unknow || (Settings::HIDETEAMSROUND1 && @round == 1 && @cursor_position != @player_position)
      	      @sprites["pokemon" + aux.to_s] = AnimatedSprite.new("Graphics/Pokemon/Icons/000", 2, 64, 64, 2, @viewport)
	    else
      	      @sprites["pokemon" + aux.to_s] = PokemonIconSprite.new(pkmn, @viewport)
	    end

      	    @sprites["pokemon" + aux.to_s].x = 236 if [1, 4].include?(aux)
      	    @sprites["pokemon" + aux.to_s].x = 312 if [2, 5].include?(aux)
	    @sprites["pokemon" + aux.to_s].x = 388 if [3, 6].include?(aux)
      	    @sprites["pokemon" + aux.to_s].y = 114 if [1, 2, 3].include?(aux)
	    @sprites["pokemon" + aux.to_s].y = 174 if [4, 5, 6].include?(aux)
	  else
	    break
	  end
	end
      else
        for i in 0...2
	  unknow = false
	  aux = 0
	  tr_data = $player.party
	  if @cursor_position != @player_position || @trainers[@cursor_position - 1][i] != "Player"
	    if GameData::Trainer.exists?(:"#{@tr_types[@cursor_position - 1][i]}", @trainers[@cursor_position - 1][i], @tr_form[@cursor_position - 1][i])
              tr_data = GameData::Trainer.get(:"#{@tr_types[@cursor_position - 1][i]}", @trainers[@cursor_position - 1][i], @tr_form[@cursor_position - 1][i]).pokemon
            else
	      unknow = true
            end
	  end
	  for pokemon in tr_data
	    aux += 1
	    if aux <= 3 && aux <= $player.party.size
	      pkmn = pokemon
	      if !unknow
                if tr_data != $player.party
	          species = GameData::Species.get(pokemon[:species]).species
	          pkmn = Pokemon.new(species, pokemon[:level], tr_data, false)
	        end
	        @pkmn_stats[0] += pkmn.baseStats[:HP]
                @pkmn_stats[1] += pkmn.baseStats[:ATTACK]
                @pkmn_stats[2] += pkmn.baseStats[:DEFENSE]
                @pkmn_stats[3] += pkmn.baseStats[:SPECIAL_ATTACK]
                @pkmn_stats[4] += pkmn.baseStats[:SPECIAL_DEFENSE]
                @pkmn_stats[5] += pkmn.baseStats[:SPEED]
	      end

	      if unknow || (Settings::HIDETEAMSROUND1 && @round == 1 && @cursor_position != @player_position)
		@sprites["pokemon" + (aux + i * 3).to_s] = AnimatedSprite.new("Graphics/Pokemon/Icons/000", 2, 64, 64, 2, @viewport) 
	      else
		@sprites["pokemon" + (aux + i * 3).to_s] = PokemonIconSprite.new(pkmn, @viewport)
	      end
      	      @sprites["pokemon" + (aux + i * 3).to_s].x = 236 if [1, 4].include?(aux + i * 3)
      	      @sprites["pokemon" + (aux + i * 3).to_s].x = 312 if [2, 5].include?(aux + i * 3)
	      @sprites["pokemon" + (aux + i * 3).to_s].x = 388 if [3, 6].include?(aux + i * 3)
      	      @sprites["pokemon" + (aux + i * 3).to_s].y = 114 if [1, 2, 3].include?(aux + i * 3)
	      @sprites["pokemon" + (aux + i * 3).to_s].y = 174 if [4, 5, 6].include?(aux + i * 3)
	    else
	      break
            end
          end
        end

      end
    text_positions.push([pbTeamStyle(@pkmn_stats.each_index.select{|x| @pkmn_stats[x] == @pkmn_stats.max()}), Graphics.width/2, 300, 2, base_color,shadow_color])
    end
    pbDrawTextPositions(overlay, text_positions)
  end

  def pbMain
    loop do
      Graphics.update
      Input.update
      self.update
      if Input.trigger?(Input::B) || Input.trigger?(Input::C)
        pbPlayCancelSE
        break
      elsif Input.trigger?(Input::UP)
        pbUpdatePage("up")
      elsif Input.trigger?(Input::DOWN)
        pbUpdatePage("down")
      elsif Input.trigger?(Input::LEFT)
        pbUpdatePage("left")
      elsif Input.trigger?(Input::RIGHT)
        pbUpdatePage("right")
      end
    end 
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    return @cursor_position
  end
end

class DetailsScreen
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(panel_name, panel_type, round, cursor_position, trainers, tr_types, tr_form, icons, classified, player_position)
    @scene.pbStartScene(panel_name, panel_type, round, cursor_position, trainers, tr_types, tr_form, icons, classified, player_position)
    @scene.pbMain
    @cursor_position = @scene.pbEndScene
    return @cursor_position
  end
end

def pbDetails(panel_name=nil, panel_type=nil, round=1, cursor_position=1, trainers=nil, tr_types=nil, tr_form=nil, icons=nil, classified=nil, player_position=1)
  scene = DetailsScene.new
  screen = DetailsScreen.new(scene)
  @cursor_position = screen.pbStartScreen(panel_name, panel_type, round, cursor_position, trainers, tr_types, tr_form, icons, classified, player_position)
  return @cursor_position
end