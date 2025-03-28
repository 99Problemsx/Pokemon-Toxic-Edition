class ButtonSprite < IconSprite
  attr_reader :highlighted, :command
  
  def initialize(parent=nil,text=nil,bitmap=nil,bitmap_hover=nil,click_proc=nil,x=0,y=0,viewport=nil,command=nil)
    super(x,y,viewport)
    self.setBitmap(bitmap) if bitmap
    @parent = parent
    @bitmaps = [bitmap, bitmap_hover]
    @click_proc = click_proc
    @text = text
    @command = command
    @highlighted = false
    @text_base_color = Color.new(248,248,248)
    @text_shadow_color = Color.new(64,64,64)
    @text_highlight_base_color = nil
    @text_highlight_shadow_color = nil
    @text_offset = [0,0]
    @text_bitmap = BitmapSprite.new(self.width, self.height, viewport)
    pbSetSystemFont(@text_bitmap.bitmap)
    redrawText
  end

  def setTextColor(base,shadow)
    @text_base_color = base
    @text_shadow_color = shadow
    redrawText
  end

  def setTextHighlightColor(base,shadow)
    @text_highlight_base_color = base
    @text_highlight_shadow_color = shadow
    redrawText
  end  

  def setTextOffset(x,y)
    @text_offset = [x,y]
    redrawText
  end

  def text=(value)
    @text = value
    redrawText
  end

  def redrawText
    return if !@text_bitmap || @text_bitmap.disposed?
    @text_bitmap.bitmap.clear
    if @text
      base = (@highlighted && @text_highlight_base_color) ? @text_highlight_base_color : @text_base_color
      shadow = (@highlighted && @text_highlight_shadow_color) ? @text_highlight_shadow_color : @text_shadow_color
      pbDrawTextPositions(@text_bitmap.bitmap,
        [[@text, self.width/2 + @text_offset[0], @text_offset[1], 2, base, shadow]])
    end
  end

  def update
    super
    old_highlighted = @highlighted
    @highlighted = checkSelected
    if @highlighted != old_highlighted
      if @bitmaps[@highlighted ? 1 : 0]
        new_bitmap = @bitmaps[@highlighted ? 1 : 0]
        self.bitmap = new_bitmap.is_a?(Bitmap) ? new_bitmap : Bitmap.new(new_bitmap)
      end
      redrawText
    end
    @text_bitmap.x = self.x if @text_bitmap
    @text_bitmap.y = self.y if @text_bitmap
    @text_bitmap.visible = self.visible if @text_bitmap
  end

  def dispose
    @text_bitmap.dispose if @text_bitmap
    super
  end

  def checkSelected 
    @highlighted = Mouse.over?(self)
    return @highlighted
  end

  def mouse_click?
    return Mouse.click?(:left) && @highlighted
  end

  def click
    if @click_proc
      if @click_proc.arity == 2
        @click_proc.call(@parent, @command)
      else
        @click_proc.call(@parent)
      end
    end
  end
end

class PartySprite < ButtonSprite
  SLIDE_SPEED = 32

  def initialize(pokemon=nil,parent=nil,text=nil,bitmap=nil,bitmap_hover=nil,click_proc=nil,x=0,y=0,viewport=nil,command=nil)
    @pokemon = pokemon
    @pokesprite = PokemonIconSprite.new(@pokemon, viewport)
    @pokesprite.x = x
    @pokesprite.y = y
    @pokesprite.active = true
    @show_options = false
    @hpsprite = IconSprite.new(x+2, y+68, viewport)
    @hpsprite.setBitmap("Graphics/Pictures/Active HUD/hp")
    @expsprite = IconSprite.new(x+4, y+82, viewport)
    @expsprite.setBitmap("Graphics/Pictures/Active HUD/exp")
    @itemsprite = IconSprite.new(x+8, y+94, viewport)
    @shinyicon = IconSprite.new(x+48, y+44, viewport)
    @shinyicon.setBitmap("Graphics/Pictures/shiny")
    @statusicon = IconSprite.new(x+4, y+4, viewport)
    @statusicon.setBitmap("Graphics/Pictures/Active HUD/status")
    super(parent,text,bitmap,bitmap_hover,click_proc,x,y,viewport,command)
    pbSetSmallFont(@text_bitmap.bitmap)
  end

  def pokemon=(value)
    @pokemon = value
    @pokesprite.pokemon = @pokemon
  end

  def update
    @show_options = self.y == 384
    if @highlighted
      if self.y <= 384
        self.y = 384
      else
        self.y -= SLIDE_SPEED
      end
    elsif self.y < 512
      self.y += SLIDE_SPEED
    end
    
    @pokesprite.selected = @highlighted
    @pokesprite.x = self.x
    @pokesprite.y = self.y
    @pokesprite.z = self.z + 1
    @hpsprite.x = self.x + 2
    @hpsprite.y = self.y + 68
    @hpsprite.z = self.z + 1
    hprect = Rect.new(0,0,0,0)
    exprect = Rect.new(0,0,0,0)
    statusrect = Rect.new(0,0,0,0)
    itembmp = ""
    isShiny = false
    if @pokemon.is_a?(Pokemon)
      hppos = 0
      hppos = 12 if @pokemon.hp < @pokemon.totalhp/2
      hppos = 24 if @pokemon.hp < @pokemon.totalhp/4
      hprect = Rect.new(0,hppos,60*@pokemon.hp/@pokemon.totalhp,12)
      minexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level)
      currexp = @pokemon.exp - minexp
      maxexp = @pokemon.growth_rate.minimum_exp_for_level(@pokemon.level + 1) - minexp - 1
      exprect = Rect.new(0,0,56*currexp/maxexp,8)
      itembmp = (@pokemon.item.nil? ? "" : GameData::Item.icon_filename(@pokemon.item))
      isShiny = @pokemon.shiny?
      if @pokemon.status!=:NONE
        statuspos = GameData::Status.get(@pokemon.status).icon_position*16
        statusrect = Rect.new(0,statuspos,8,16)
      elsif @pokemon.fainted?
        statusrect = Rect.new(0,80,8,16)
      end
    end
    @hpsprite.src_rect = hprect
    @expsprite.x = self.x + 4
    @expsprite.y = self.y + 82
    @expsprite.z = self.z + 1
    @expsprite.src_rect = exprect
    @itemsprite.x = self.x + 8
    @itemsprite.y = self.y + 94
    @itemsprite.z = self.z + 1
    @itemsprite.setBitmap(itembmp)
    @shinyicon.x = self.x + 48
    @shinyicon.y = self.y + 44
    @shinyicon.z = self.z + 1
    @shinyicon.visible = isShiny && self.visible
    @statusicon.x = self.x + 4
    @statusicon.y = self.y + 4
    @statusicon.z = self.z + 1
    @statusicon.src_rect = statusrect
    @pokesprite.update
    @statusicon.update
    @shinyicon.update
    @expsprite.update
    @itemsprite.update
    @hpsprite.update
    super
  end

  def visible=(value)
    @pokesprite.visible = value
    @hpsprite.visible = value
    @expsprite.visible = value
    @itemsprite.visible = value
    @statusicon.visible = value
    @shinyicon.visible = false if !value
    super
  end
end