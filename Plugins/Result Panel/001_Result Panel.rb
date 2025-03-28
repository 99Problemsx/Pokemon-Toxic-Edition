class ResultPanelScene
  def update
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
       @sprites["bg"].ox -= 1
       @sprites["bg"].oy -= 1
    end
  end

  def pbStartScene(panel_name, title, panel_type, round)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundPlane(@sprites, "bg", "Result Panel/bg", @viewport)
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["background"].setBitmap(Settings::FILEPATH + "Panel_" + panel_type.to_s + "_#{Settings::PANELSTYLE}") if panel_type != 2
    @sprites["background"].setBitmap(Settings::FILEPATH + "PanelDouble_#{Settings::PANELSTYLE}") if panel_type == 2
    @sprites["background"].x = (Graphics.width - @sprites["background"].bitmap.width)/2
    @sprites["background"].y = (Graphics.height - @sprites["background"].bitmap.height)/2

    @sprites["bg"].zoom_x = 2 ; @sprites["bg"].zoom_y = 2
    @sprites["bg"].ox += 6
    @sprites["bg"].oy -= 26
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)

    if Settings::SHOWBUTTONS
	@sprites["cancel"] = IconSprite.new(76, 26, @viewport)
        @sprites["cancel"].setBitmap(Settings::FILEPATH + "Cancel_btn")
        @sprites["cancel"].x = 420 if Settings::PANELSTYLE != 2
        @sprites["cancel"].x = 348 if panel_type == 8 && Settings::PANELSTYLE == 2
        @sprites["cancel"].x = 262 if panel_type == 16 && Settings::PANELSTYLE == 2
        @sprites["cancel"].x = 382 if panel_type == 2 && Settings::PANELSTYLE == 2
        @sprites["cancel"].y = 88 if panel_type == 8 && Settings::PANELSTYLE != 2
        @sprites["cancel"].y = 62 if [2,8].include?(panel_type) && Settings::PANELSTYLE == 2
        @sprites["cancel"].y = 10 if [2,16].include?(panel_type) && Settings::PANELSTYLE != 2
        @sprites["cancel"].y = 356 if panel_type == 16 && Settings::PANELSTYLE == 2
      if Settings::CURSORFUNCTIONS
        @sprites["details"] = IconSprite.new(78, 26, @viewport) 
        @sprites["details"].setBitmap(Settings::FILEPATH + "Details_btn")
        @sprites["details"].x = 14 if Settings::PANELSTYLE != 2
        @sprites["details"].x = 88 if panel_type == 8 && Settings::PANELSTYLE == 2
        @sprites["details"].x = 172 if panel_type == 16 && Settings::PANELSTYLE == 2
        @sprites["details"].x = 54 if panel_type == 2 && Settings::PANELSTYLE == 2
        @sprites["details"].y = 88 if panel_type == 8 && Settings::PANELSTYLE != 2
        @sprites["details"].y = 62 if [2,8].include?(panel_type) && Settings::PANELSTYLE == 2
        @sprites["details"].y = 10 if [2,16].include?(panel_type) && Settings::PANELSTYLE != 2
        @sprites["details"].y = 356 if panel_type == 16 && Settings::PANELSTYLE == 2
      end
    end

    @player_position = 0
    @cursor_position = 0
    @panel_name = panel_name
    @title = title
    @panel_type = panel_type
    @round = round

    @trainers = Settings::RESULTPANEL_8[:"#{@panel_name}"][:Trainers] if @panel_type == 8
    @trainers = Settings::RESULTPANEL_16[:"#{@panel_name}"][:Trainers] if @panel_type == 16
    @trainers = Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Trainers] if @panel_type == 2

    if Settings::CURSORFUNCTIONS
      trainers2 = []
      @tr_types = []
      @tr_form = []
      for i in 0...@trainers.size
        trainers2.push(@trainers[i][0]) if @panel_type != 2
        trainers2.push([@trainers[i][0], @trainers[i][3]]) if @panel_type == 2
        if @trainers[i][0] == "Player" || (@panel_type == 2 && @trainers[i][3] == "Player")
	  @tr_types.push(($player.trainer_type).to_s) if @panel_type != 2
	  @tr_form.push(0) if @panel_type != 2
	  if @panel_type == 2
            @tr_types.push([($player.trainer_type).to_s, @trainers[i][4]]) if @trainers[i][0] == "Player"
            @tr_types.push([@trainers[i][1], ($player.trainer_type).to_s]) if @trainers[i][3] == "Player"
            @tr_form.push([0, @trainers[i][5]]) if @trainers[i][0] == "Player"
            @tr_form.push([@trainers[i][2], 0]) if @trainers[i][3] == "Player"
	  end
        else
          @tr_types.push(@trainers[i][1]) if @panel_type != 2
          @tr_types.push([@trainers[i][1], @trainers[i][4]]) if @panel_type == 2
          @tr_form.push(@trainers[i][2]) if @panel_type != 2
          @tr_form.push([@trainers[i][2], @trainers[i][5]]) if @panel_type == 2
        end
      end
      @trainers = trainers2

      for i in 0...@tr_form.size
        if @panel_type != 2
	  @tr_form[i] = $game_variables[@tr_form[i].to_i].to_i if @tr_form[i].is_a?(String)
        else
	  @tr_form[i][0] = $game_variables[@tr_form[i][0].to_i].to_i if @tr_form[i][0].is_a?(String)
	  @tr_form[i][1] = $game_variables[@tr_form[i][1].to_i].to_i if @tr_form[i][1].is_a?(String)
        end
      end
    end

    for i in 0...@trainers.size
      if @panel_type != 2
        @player_position = i + 1 if (@trainers[i]).to_s == "Player"
        @trainers[i] = $game_variables[@trainers[i]].to_s if @trainers[i].is_a?(Integer)
      else
        @player_position = i + 1 if @trainers[i][0].to_s == "Player" || @trainers[i][1].to_s == "Player"
        @trainers[i][0] = $game_variables[@trainers[i][0]].to_s if @trainers[i][0].is_a?(Integer)
        @trainers[i][1] = $game_variables[@trainers[i][1]].to_s if @trainers[i][1].is_a?(Integer)
      end
    end

    @icons = Settings::RESULTPANEL_8[:"#{@panel_name}"][:Icons] if @panel_type == 8
    @icons = Settings::RESULTPANEL_16[:"#{@panel_name}"][:Icons] if @panel_type == 16
    @icons = Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Icons] if @panel_type == 2

    for i in 0...@icons.size
      @icons[i] = $game_variables[@icons[i].to_i].to_i if @icons[i].is_a?(String)
    end

    @classified = [Settings::RESULTPANEL_8[:"#{@panel_name}"][:Round2],
                  Settings::RESULTPANEL_8[:"#{@panel_name}"][:Round3],
                  Settings::RESULTPANEL_8[:"#{@panel_name}"][:Round4]
    ] if @panel_type == 8

    @classified = [Settings::RESULTPANEL_16[:"#{@panel_name}"][:Round2],
                  Settings::RESULTPANEL_16[:"#{@panel_name}"][:Round3],
                  Settings::RESULTPANEL_16[:"#{@panel_name}"][:Round4],
                  Settings::RESULTPANEL_16[:"#{@panel_name}"][:Round5]
    ] if @panel_type == 16

    @classified = [Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Round2],
                  Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Round3],
                  Settings::RESULTPANEL_DOUBLE[:"#{@panel_name}"][:Round4]
    ] if @panel_type == 2

    if @panel_type == 8 || (@panel_type == 2 && Settings::PANELSTYLE == 2)
      for i in 1...15
        @sprites["bar" + i.to_s] = IconSprite.new(48, 22, @viewport) if [1,3,5,7].include?(i)
        @sprites["bar" + i.to_s] = IconSprite.new(48, 20, @viewport) if [2,4,6,8].include?(i)
        @sprites["bar" + i.to_s] = IconSprite.new(26, 42, @viewport) if i.between?(9, 12)
        @sprites["bar" + i.to_s] = IconSprite.new(50, 16, @viewport) if [13,14].include?(i)
         
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-8_1") if [1,3].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-8_2") if [2,4].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-8_3") if [5,7].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-8_4") if [6,8].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-8_" + (i - 4).to_s) if i >= 9

        @sprites["bar" + i.to_s].x = 144 if i.between?(1, 4)
        @sprites["bar" + i.to_s].x = 320 if i.between?(5, 8)
        @sprites["bar" + i.to_s].x = 182 if [9,10].include?(i)
        @sprites["bar" + i.to_s].x = 304 if [11,12].include?(i)
        @sprites["bar" + i.to_s].x = 198 if i == 13
        @sprites["bar" + i.to_s].x = 264 if i == 14

        @sprites["bar" + i.to_s].y = 138 if [1,5].include?(i)
        @sprites["bar" + i.to_s].y = 176 if [2,6].include?(i)
        @sprites["bar" + i.to_s].y = 222 if [3,7].include?(i)
        @sprites["bar" + i.to_s].y = 260 if [4,8].include?(i)
        @sprites["bar" + i.to_s].y = 160 if [9,11].include?(i)
        @sprites["bar" + i.to_s].y = 218 if [10,12].include?(i)
        @sprites["bar" + i.to_s].y = 202 if [13,14].include?(i)
      end
      @sprites["bar15"] = IconSprite.new(16, 16, @viewport)
      @sprites["bar15"].setBitmap(Settings::FILEPATH + "Bars/Central_icon")
      @sprites["bar15"].x = 248
      @sprites["bar15"].y = 202
    elsif @panel_type == 16
      for i in 1...31
        @sprites["bar" + i.to_s] = IconSprite.new(48, 20, @viewport) if i <= 16
        @sprites["bar" + i.to_s] = IconSprite.new(26, 40, @viewport) if i >= 17 && i <= 24
        @sprites["bar" + i.to_s] = IconSprite.new(26, 80, @viewport) if [25,26,27,28].include?(i)
        @sprites["bar" + i.to_s] = IconSprite.new(34, 16, @viewport) if [29,30].include?(i)

        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_1") if [1,3,5,7].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_2") if [2,4,6,8].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_3") if [9,11,13,15].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_4") if [10,12,14,16].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_5") if [17,19].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_6") if [18,20].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_7") if [21,23].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_8") if [22,24].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_" + (i - 16).to_s) if i >= 25

        @sprites["bar" + i.to_s].x = 144 if i <= 8
        @sprites["bar" + i.to_s].x = 320 if i >= 9 && i <= 16
        @sprites["bar" + i.to_s].x = 182 if [17,18,19,20].include?(i)
        @sprites["bar" + i.to_s].x = 304 if [21,22,23,24].include?(i)
        @sprites["bar" + i.to_s].x = 198 if [25,26].include?(i)
        @sprites["bar" + i.to_s].x = 288 if [27,28].include?(i)
        @sprites["bar" + i.to_s].x = 214 if i == 29
        @sprites["bar" + i.to_s].x = 264 if i == 30

        @sprites["bar" + i.to_s].y = 58 if [1,9].include?(i)
        @sprites["bar" + i.to_s].y = 94 if [2,10].include?(i)
        @sprites["bar" + i.to_s].y = 138 if [3,11].include?(i)
        @sprites["bar" + i.to_s].y = 174 if [4,12].include?(i)
        @sprites["bar" + i.to_s].y = 218 if [5,13].include?(i)
        @sprites["bar" + i.to_s].y = 254 if [6,14].include?(i)
        @sprites["bar" + i.to_s].y = 298 if [7,15].include?(i)
        @sprites["bar" + i.to_s].y = 334 if [8,16].include?(i)

        @sprites["bar" + i.to_s].y = 78 if [17,21].include?(i)
        @sprites["bar" + i.to_s].y = 134 if [18,22].include?(i)
        @sprites["bar" + i.to_s].y = 238 if [19,23].include?(i)
        @sprites["bar" + i.to_s].y = 294 if [20,24].include?(i)
        @sprites["bar" + i.to_s].y = 118 if [25,27].include?(i)
        @sprites["bar" + i.to_s].y = 214 if [26,28].include?(i)
        @sprites["bar" + i.to_s].y = 198 if [29,30].include?(i)
      end
      @sprites["bar31"] = IconSprite.new(16, 16, @viewport)
      @sprites["bar31"].setBitmap(Settings::FILEPATH + "Bars/Central_icon")
      @sprites["bar31"].x = 248
      @sprites["bar31"].y = 198
    else
      for i in 1...15
        @sprites["bar" + i.to_s] = IconSprite.new(48, 40, @viewport) if i.between?(1, 8)
        @sprites["bar" + i.to_s] = IconSprite.new(42, 80, @viewport) if i.between?(9, 12)
        @sprites["bar" + i.to_s] = IconSprite.new(34, 16, @viewport) if i >= 13
         
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-D_1") if [1,3].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-D_2") if [2,4].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-D_3") if [5,7].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-D_4") if [6,8].include?(i)
        @sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-D_" + (i - 4).to_s) if i.between?(9, 12)
	@sprites["bar" + i.to_s].setBitmap(Settings::FILEPATH + "Bars/Bar-16_" + i.to_s) if i >= 13

        @sprites["bar" + i.to_s].x = 144 if i.between?(1, 4)
        @sprites["bar" + i.to_s].x = 320 if i.between?(5, 8)
        @sprites["bar" + i.to_s].x = 182 if [9,10].include?(i)
        @sprites["bar" + i.to_s].x = 288 if [11,12].include?(i)
        @sprites["bar" + i.to_s].x = 214 if i == 13
        @sprites["bar" + i.to_s].x = 264 if i == 14

        @sprites["bar" + i.to_s].y = 78 if [1,5].include?(i)
        @sprites["bar" + i.to_s].y = 134 if [2,6].include?(i)
        @sprites["bar" + i.to_s].y = 238 if [3,7].include?(i)
        @sprites["bar" + i.to_s].y = 294 if [4,8].include?(i)
        @sprites["bar" + i.to_s].y = 118 if [9,11].include?(i)
        @sprites["bar" + i.to_s].y = 214 if [10,12].include?(i)
        @sprites["bar" + i.to_s].y = 198 if [13,14].include?(i)
      end
      @sprites["bar15"] = IconSprite.new(16, 16, @viewport)
      @sprites["bar15"].setBitmap(Settings::FILEPATH + "Bars/Central_icon")
      @sprites["bar15"].x = 248
      @sprites["bar15"].y = 198
    end

    @player = true
    if @round > 1
      for i in 0...@round
        @player = false
        for j in 0...@classified[i - 1].size
          @player = true if @classified[i -1][j] == @player_position
          if i + 1 == 2
            s = 9 if [2,8].include?(@panel_type)
            s = 17 if @panel_type == 16
            for k in 1...s
              @sprites["bar" + k.to_s].visible = false if @classified[i-1][j] == k
            end
          elsif i + 1 == 3
            if [2,8].include?(@panel_type)
              @sprites["bar9"].visible = false if [1,2].include?(@classified[i-1][j])
              @sprites["bar10"].visible = false if [3,4].include?(@classified[i-1][j])
              @sprites["bar11"].visible = false if [5,6].include?(@classified[i-1][j])
              @sprites["bar12"].visible = false if [7,8].include?(@classified[i-1][j])
            else
              @sprites["bar17"].visible = false if [1,2].include?(@classified[i-1][j])
              @sprites["bar18"].visible = false if [3,4].include?(@classified[i-1][j])
              @sprites["bar19"].visible = false if [5,6].include?(@classified[i-1][j])
              @sprites["bar20"].visible = false if [7,8].include?(@classified[i-1][j])
              @sprites["bar21"].visible = false if [9,10].include?(@classified[i-1][j])
              @sprites["bar22"].visible = false if [12,11].include?(@classified[i-1][j])
              @sprites["bar23"].visible = false if [13,14].include?(@classified[i-1][j])
              @sprites["bar24"].visible = false if [15,16].include?(@classified[i-1][j])
            end
          elsif i + 1 == 4
            if [2,8].include?(@panel_type)
              @sprites["bar13"].visible = false if @classified[i-1][j].to_i.between?(1, 4)
              @sprites["bar14"].visible = false if @classified[i-1][j].to_i.between?(5, 8)
              @sprites["bar15"].visible = false
            else
              @sprites["bar25"].visible = false if @classified[i-1][j].to_i.between?(1, 4)
              @sprites["bar26"].visible = false if @classified[i-1][j].to_i.between?(5, 8)
              @sprites["bar27"].visible = false if @classified[i-1][j].to_i.between?(9, 12)
              @sprites["bar28"].visible = false if @classified[i-1][j].to_i.between?(13, 16)
            end
          elsif i + 1 == 5
              @sprites["bar29"].visible = false if @classified[i-1][0] <= 8
              @sprites["bar30"].visible = false if @classified[i-1][0] >= 9
              @sprites["bar31"].visible = false
          end
        end
      end
    end

    @possible_positions = [[138, 134], [138, 174], [138, 218], [138, 258], [346, 134], [346, 174], [346, 218], [346, 258],
			[176, 156], [176, 238], [308, 156], [308, 238], [192, 196], [292, 196], [242, 196]] if @panel_type == 8 || (@panel_type == 2 && Settings::PANELSTYLE == 2)

    @possible_positions = [[138, 54], [138, 92], [138, 134], [138, 172], [138, 214], [138, 252], [138, 294], [138, 332],
 			[346, 54], [346, 92], [346, 134], [346, 172], [346, 214], [346, 252], [346, 294], [346, 332],
 			[176, 74], [176, 152], [176, 234], [176, 312], [308, 74], [308, 152], [308, 234], [308, 312],
 			[192, 114], [192, 272], [292, 114], [292, 272], [208, 192], [276, 192], [242, 192]] if @panel_type == 16

    @possible_positions = [[138, 74], [138, 152], [138, 234], [138, 312], [346, 74], [346, 152], [346, 234], [346, 312],
			[176, 114], [176, 272], [308, 114], [308, 272], [208, 192], [276, 192], [242, 192]] if @panel_type == 2 && Settings::PANELSTYLE != 2

    @cursor_position = @player_position if @round == 1

    if [2,8].include?(@panel_type)
      aux = 1
      if @round == 2
	for i in 9...13
	  @cursor_position = i if [aux, aux + 1].include?(@player_position)
	  aux += 2
        end
      end
      @cursor_position = 13 if @player_position <= 4 && @round == 3
      @cursor_position = 14 if @player_position >= 5 && @round == 3
      @cursor_position = 15 if @round == 4
    else
      aux = 1
      if @round == 2
        for i in 17...25
	  @cursor_position = i if [aux, aux + 1].include?(@player_position)
	  aux += 2
        end
      elsif @round == 3
        for i in 25...29
	  @cursor_position = i if @player_position.between?(aux, aux + 3)
	  aux += 4
	end
      end
      @cursor_position = 29 if @player_position <= 8 && @round == 4
      @cursor_position = 30 if @player_position >= 9 && @round == 4
      @cursor_position = 31 if @round == 5
    end

    @sprites["cursor"] = IconSprite.new(28, 28, @viewport) if @player || Settings::CURSORFUNCTIONS
    @sprites["cursor"].setBitmap(Settings::FILEPATH + "Cursor") if @player || Settings::CURSORFUNCTIONS
    @sprites["cursor"].x = @possible_positions[@cursor_position - 1][0] if @player || Settings::CURSORFUNCTIONS
    @sprites["cursor"].y = @possible_positions[@cursor_position - 1][1] if @player || Settings::CURSORFUNCTIONS

    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbDrawResultPanel
    pbFadeInAndShow(@sprites) { update }
  end

  def pbUpdateCursor(direction)
    aux = @cursor_position
    if direction.to_s == "up"
      @cursor_position -= 1 if [2, 3, 4, 6, 7, 8, 10, 12].include?(@cursor_position) && [2,8].include?(@panel_type)
      @cursor_position -= 1 if (@cursor_position.between?(2, 8) || @cursor_position.between?(10, 16) || [18, 19, 20, 22, 23, 24, 26, 28].include?(@cursor_position)) && @panel_type == 16
    elsif direction.to_s == "down"
      @cursor_position += 1 if [1, 2, 3, 5, 6, 7, 9, 11].include?(@cursor_position) && [2,8].include?(@panel_type)
      @cursor_position += 1 if (@cursor_position.between?(1, 7) || @cursor_position.between?(9, 15) || [17, 18, 19, 21, 22, 23, 25, 27].include?(@cursor_position)) && @panel_type == 16
    elsif direction.to_s == "left"
      if [2,8].include?(@panel_type)
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
      if [2,8].include?(@panel_type)
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
    else
      @sprites["cursor"].x = @possible_positions[@cursor_position - 1][0]
      @sprites["cursor"].y = @possible_positions[@cursor_position - 1][1]
    end

    if aux != @cursor_position
      pbPlayCancelSE
      @sprites["cursor"].x = @possible_positions[@cursor_position - 1][0]
      @sprites["cursor"].y = @possible_positions[@cursor_position - 1][1]
    end
  end

  def pbDrawResultPanel
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base_color = Color.new(248, 248, 248)
    shadow_color = Color.new(72, 80, 88)
    height = 101 if @panel_type == 8 || (@panel_type == 2 && Settings::PANELSTYLE == 2)
    height = 21 if @panel_type == 16 || (@panel_type == 2 && Settings::PANELSTYLE != 2)
    text_positions = [
       [@title,Graphics.width/2,height,2,base_color,shadow_color]
    ]

    if [1,3].include?(Settings::PANELSTYLE)
      for i in 0...@trainers.size
        if Settings::PANELSTYLE == 1
          if @panel_type == 8
            (x = 134; y = 134; z = 1) if i == 0
            (x = 378; y = 134; z = 0) if i == 4
          elsif @panel_type == 16
            (x = 134; y = 56; z = 1) if i == 0
            (x = 378; y = 56; z = 0) if i == 8
          else
            (x = 134; y = 58; z = 1) if i == 0
            (x = 378; y = 58; z = 0) if i == 4
          end
        else
          if @panel_type == 8
            (x = 100; y = 134; z = 1) if i == 0
            (x = 412; y = 134; z = 0) if i == 4
          elsif @panel_type == 16
            (x = 100; y = 56; z = 1) if i == 0
            (x = 412; y = 56; z = 0) if i == 8
	  else
            (x = 100; y = 58; z = 1) if i == 0
            (x = 412; y = 58; z = 0) if i == 4
          end
        end
        if @round > 1
          aux = 0
          for j in 0...@classified[@round - 2].size()
            aux = @classified[@round - 2][j] if @classified[@round - 2][j] == i + 1
          end
	  if @panel_type != 2
            text_positions.push([@trainers[i],x,y,z,Color.new(128, 128, 128),Color.new(72, 72, 72)]) if aux == 0
            text_positions.push([@trainers[i],x,y,z,base_color,shadow_color]) if aux != 0 && i != @player_position - 1
            text_positions.push([@trainers[i],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if aux != 0 && i == @player_position - 1
          else
            text_positions.push([@trainers[i][0],x,y,z,Color.new(128, 128, 128),Color.new(72, 72, 72)]) if aux == 0
            text_positions.push([@trainers[i][0],x,y,z,base_color,shadow_color]) if aux != 0 && @trainers[i][0] != "Player"
            text_positions.push([@trainers[i][0],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if aux != 0 && @trainers[i][0] == "Player"
            y += 34
            text_positions.push([@trainers[i][1],x,y,z,Color.new(128, 128, 128),Color.new(72, 72, 72)]) if aux == 0
            text_positions.push([@trainers[i][1],x,y,z,base_color,shadow_color]) if aux != 0 && @trainers[i][1] != "Player"
            text_positions.push([@trainers[i][1],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if aux != 0 && @trainers[i][1] == "Player"
	  end
        else
	  if @panel_type != 2
            text_positions.push([@trainers[i],x,y,z,base_color,shadow_color]) if i != @player_position - 1
            text_positions.push([@trainers[i],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if i == @player_position - 1
	  else
            text_positions.push([@trainers[i][0],x,y,z,base_color,shadow_color]) if @trainers[i][0] != "Player"
            text_positions.push([@trainers[i][0],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if @trainers[i][0] == "Player"
	    y += 34
            text_positions.push([@trainers[i][1],x,y,z,base_color,shadow_color]) if @trainers[i][0] != "Player"
            text_positions.push([@trainers[i][1],x,y,z,Color.new(248, 160, 96),Color.new(128, 80, 48)]) if @trainers[i][1] == "Player"
	  end
        end
        y += 42 if @panel_type == 8
        y += 40 if @panel_type == 16
        y += 46 if @panel_type == 2
	text_positions[i][0] = $player.name if text_positions[i][0] == "Player" && @panel_type == 2
      end
      text_positions[@player_position][0] = $player.name if @panel_type != 2
    end

    pbDrawTextPositions(overlay, text_positions)

    imagepos=[]

    if [2,3].include?(Settings::PANELSTYLE)
      image_path = Settings::FILEPATH + Settings::TEMPLATENAME
      if @panel_type != 2
        for i in 0...@panel_type
          if @panel_type == 8
            (x = 102; y = 128) if i == 0
            (x = 378; y = 128) if i == 4
          else
            (x = 102; y = 50) if i == 0
            (x = 378; y = 50) if i == 8
          end 
          row = 0
          for l in 0...Settings::TEMPLATEROWS
            column = 0
            for c in 1...9
              if @round > 1
                aux = 0
                for j in 0...@classified[@round - 2].size()
                  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == i+1
                end
                if c + 8 * l == @icons[i] && aux != 0
                  imagepos.push([image_path, x, y, column, row, 32, 32])
                  imagepos.push([image_path, 240, 196 - 50, column, row, 32, 32]) if Settings::SHOWWINER && @panel_type == 8 && @round == 4
                  imagepos.push([image_path, 240, 192 - 50, column, row, 32, 32]) if Settings::SHOWWINER && @panel_type == 16 && @round == 5
                elsif c + 8 * l == @icons[i] && aux == 0
                  imagepos.push([image_path + "_OUT", x, y, column, row, 32, 32])
                end 
              else
                imagepos.push([image_path, x, y, column, row, 32, 32]) if c + 8 * l == @icons[i]
              end
              column += 32
            end
            row += 32
          end
          y += 42 if @panel_type == 8
          y += 40 if @panel_type == 16
        end
      else
        aux2 = 0
        for i in 0...16
          if Settings::PANELSTYLE == 2
            y = 128 if [0, 8].include?(i) 
	    x = 68 if [0, 2, 4, 6].include?(i)
            x = 102 if [1, 3, 5, 7].include?(i)
            x = 378 if [8, 10, 12, 14].include?(i)
	    x = 412 if [9, 11, 13, 15].include?(i)
          else
            (x = 102; y = 52) if i == 0
            (x = 378; y = 52) if i == 8
          end 
          row = 0
          for l in 0...Settings::TEMPLATEROWS
            column = 0
            for c in 1...9
              if @round > 1
                aux = 0
                for j in 0...@classified[@round - 2].size()
                  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 1 && (i + 1 == 1 || i + 1 == 2)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 2 && (i + 1 == 3 || i + 1 == 4)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 3 && (i + 1 == 5 || i + 1 == 6)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 4 && (i + 1 == 7 || i + 1 == 8)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 5 && (i + 1 == 9 || i + 1 == 10)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 6 && (i + 1 == 11 || i + 1 == 12)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 7 && (i + 1 == 13 || i + 1 == 14)
		  aux = @classified[@round - 2][j] if @classified[@round - 2][j] == 8 && (i + 1 == 15 || i + 1 == 16)
                end
                if c + 8 * l == @icons[i] && aux != 0
                  imagepos.push([image_path, x, y, column, row, 32, 32])
		  if aux2 == 0
		    imagepos.push([image_path, 223, 196 - 50, column, row, 32, 32]) if Settings::SHOWWINER && Settings::PANELSTYLE == 2 && @round == 4
                    imagepos.push([image_path, 223, 192 - 110, column, row, 32, 32]) if Settings::SHOWWINER && Settings::PANELSTYLE == 3 && @round == 4
		    aux2 = 1
		  else
		    imagepos.push([image_path, 257, 196 - 50, column, row, 32, 32]) if Settings::SHOWWINER && Settings::PANELSTYLE == 2 && @round == 4
                    imagepos.push([image_path, 257, 192 - 110, column, row, 32, 32]) if Settings::SHOWWINER && Settings::PANELSTYLE == 3 && @round == 4
		  end
                elsif c + 8 * l == @icons[i] && aux == 0
                  imagepos.push([image_path + "_OUT", x, y, column, row, 32, 32])
                end 
              else
                imagepos.push([image_path, x, y, column, row, 32, 32]) if c + 8 * l == @icons[i]
              end
              column += 32
            end
            row += 32
          end
          y += 42 if @panel_type == 2 && Settings::PANELSTYLE == 2 && i %2 == 1
          y += 34 if @panel_type == 2 && Settings::PANELSTYLE != 2 && i %2 == 0
          y += 46 if @panel_type == 2 && Settings::PANELSTYLE != 2 && i %2 == 1
        end
      end

      pbDrawImagePositions(overlay, imagepos)
    end
  end

  def pbMain
    loop do
      Graphics.update
      Input.update
      self.update
      if Input.trigger?(Input::B)
        pbPlayCancelSE
        break
      elsif Input.trigger?(Input::C)
        if Settings::CURSORFUNCTIONS
          pbPlayCancelSE
	  pbFadeOutIn(99999) {
	  @cursor_position = pbDetails(@panel_name, @panel_type, @round, @cursor_position, @trainers, @tr_types, @tr_form, @icons, @classified, @player_position)
	  pbUpdateCursor("")
	  }
	else
          pbPlayCancelSE
          break
	end
      elsif Input.trigger?(Input::UP) && Settings::CURSORFUNCTIONS
        pbUpdateCursor("up")
      elsif Input.trigger?(Input::DOWN) && Settings::CURSORFUNCTIONS
        pbUpdateCursor("down")
      elsif Input.trigger?(Input::LEFT) && Settings::CURSORFUNCTIONS
        pbUpdateCursor("left")
      elsif Input.trigger?(Input::RIGHT) && Settings::CURSORFUNCTIONS
        pbUpdateCursor("right")
      end
    end 
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class ResultPanelScreen
  def initialize(scene)
    @scene=scene
  end

  def pbStartScreen(panel_name, title, panel_type, round)
    @scene.pbStartScene(panel_name, title, panel_type, round)
    @scene.pbMain
    @scene.pbEndScene
  end
end

def pbResultPanel(panel_name=nil, title=nil, panel_type=nil, round=1)
  if (panel_type == 2 || panel_type == 8 || panel_type == 16) && panel_name
    title = _INTL("CONTEST") if !title
    round = 1 if round <= 0 || round > 5
    pbFadeOutIn(99999) {
      scene = ResultPanelScene.new
      screen = ResultPanelScreen.new(scene)
      screen.pbStartScreen(panel_name, title, panel_type, round)
    }
  end
end