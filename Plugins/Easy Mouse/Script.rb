#===============================================================================
#  Easy Mouse System
#   by Luka S.J
#
#  Adds easy to use mouse functionality for your Essentials code
#===============================================================================
module Mouse
  CLICK_TIMEOUT = 0.25
  #-----------------------------------------------------------------------------
  #  mouse button input map
  #-----------------------------------------------------------------------------
  INPUTS = {
    left: Input::MOUSELEFT,
    right: Input::MOUSERIGHT,
    middle: Input::MOUSEMIDDLE
  }

  class << self
    #---------------------------------------------------------------------------
    #  sets up mouse variables initially
    #---------------------------------------------------------------------------
    def start
      Graphics.show_cursor = false
      @static_x = 0
      @static_y = 0
      @inactivity_timer = 0
      @input_map = {
        left: Input::MOUSELEFT,
        right: Input::MOUSERIGHT,
        middle: Input::MOUSEMIDDLE
      }
      @hold = 0
      @drag = nil
      @object_x = 0
      @object_y = 0
      @object_ox = 0
      @object_oy = 0
      @rect_x = nil
      @rect_y = nil
      @viewport = Viewport.new(0, 0, Settings::SCREEN_WIDTH, Settings::SCREEN_HEIGHT)
      @viewport.z = 100000
      @mouse_bitmap = IconSprite.new(0, 0, @viewport)
      @mouse_bitmap.setBitmap("Graphics/Pictures/mouseCursor")
      @mouse_bitmap.ox = 4
      @mouse_bitmap.oy = 10
    end
    #---------------------------------------------------------------------------
    #  checks if mouse is in game window
    #---------------------------------------------------------------------------
    def active?
      Input.mouse_in_window?
    end
    #---------------------------------------------------------------------------
    #  show mouse cursor in game window
    #---------------------------------------------------------------------------
    def show
      Graphics.show_cursor = true
    end
    #---------------------------------------------------------------------------
    #  hide mouse cursor in game window
    #---------------------------------------------------------------------------
    def hide
      Graphics.show_cursor = false
    end
    #---------------------------------------------------------------------------
    #  standard mouse input checks
    #---------------------------------------------------------------------------
    def click?(button = :left)
      # Check for click only on release after a short press
      if press?(button)
        @hold ||= 0
        @hold += 1
        return false
      end
      
      return false if !@hold  # Must have been pressing
      was_click = @hold < (CLICK_TIMEOUT * Graphics.frame_rate)
      @hold = nil
      return was_click
    end

    def press?(button = :left)
      Input.press?(INPUTS[button])
    end

    def release?(button = :left)
      Input.release?(INPUTS[button])
    end

    def repeat?(button = :left)
      Input.repeat?(INPUTS[button])
    end

    def hold?(button)
      press?(button) && Input.time?(INPUTS[button]) > CLICK_TIMEOUT * 1_000_000
    end
    #---------------------------------------------------------------------------
    #  mouse scroll checks
    #---------------------------------------------------------------------------
    def scroll_up?
      Input.scroll_v > 0
    end

    def scroll_down?
      Input.scroll_v < 0
    end
    #---------------------------------------------------------------------------
    #  mouse coordinate methods
    #---------------------------------------------------------------------------
    def x
      Input.mouse_x
    end
    
    def y
      Input.mouse_y
    end
    
    def pos
      [x, y]
    end
    
    #---------------------------------------------------------------------------
    #  check if mouse is over supported object
    #---------------------------------------------------------------------------
    def over?(object)
      return false if !object
      if object.is_a?(Sprite) || object.is_a?(Window)
        return mouse_over_sprite?(object)
      elsif object.is_a?(Rect)
        return mouse_over_rect?(object)
      end
      return false
    end
    
    def mouse_over_sprite?(sprite)
      return false if !sprite || sprite.disposed?
      x = sprite.x - (sprite.ox * sprite.zoom_x)
      y = sprite.y - (sprite.oy * sprite.zoom_y)
      w = sprite.width * sprite.zoom_x
      h = sprite.height * sprite.zoom_y
      return Mouse.x.between?(x, x + w) && Mouse.y.between?(y, y + h)
    end

    def mouse_over_rect?(rect) 
      return Mouse.x.between?(rect.x, rect.x + rect.width) && 
             Mouse.y.between?(rect.y, rect.y + rect.height)
    end
    #---------------------------------------------------------------------------
    #  check if mouse is in specified area
    #---------------------------------------------------------------------------
    def over_area?(arx, ary, arw, arh)
      Rect.new(arx, ary, arw, arh).over?
    end
    #---------------------------------------------------------------------------
    #  create rectangle from mouse drag selection
    #---------------------------------------------------------------------------
    def create_rect(button = :left)
      if press?(button)
        @rect_x ||= x
        @rect_y ||= y

        rx = x < @rect_x ? x : @rect_x
        ry = y < @rect_y ? y : @rect_y
        rw = x < @rect_x ? @rect_x - x : x - @rect_x
        rh = y < @rect_y ? @rect_y - y : y - @rect_y

        return Rect.new(rx, ry, rw, rh)
      end

      @rect_x = nil
      @rect_y = nil
      Rect.new(0, 0, 0, 0)
    end
    #---------------------------------------------------------------------------
    #  checks if object is being dragged with mouse
    #---------------------------------------------------------------------------
    def dragging?(object, button = :left)
      unless (over?(object) && press?(button)) || (press?(button) && @drag.eql?(object))
        @drag = nil
        @object_ox = 0
        @object_oy = 0
        return false
      end

      @drag = [Input.mouse_x, Input.mouse_y] if @drag.nil?
      if @drag.is_a?(Array) && !(@drag[0].eql?(Input.mouse_x) && @drag[1].eql?(Input.mouse_y))
        @drag = object
        @object_ox = Input.mouse_x - object.x
        @object_oy = Input.mouse_y - object.y
      end

      true
    end
    #---------------------------------------------------------------------------
    #  method to drag object using mouse
    #    - `lock` argument decides which axis to lock the dragging on
    #    - `rect` parameter creates a maximum dragging area
    #---------------------------------------------------------------------------
    def drag_object(object, button = :left, rect = nil, lock = nil)
      return false unless dragging?(object, button) && @drag.eql?(object)

      object.x = Input.mouse_x - (@object_ox || 0) unless lock.eql?(:vertical)
      object.y = Input.mouse_y - (@object_oy || 0) unless lock.eql?(:horizontal)
      return unless rect.is_a?(Rect)

      rx, ry, rw, rh = object_params(rect)
      _ox, _oy, ow, oh = object_params(object)
      object.x = rx if object.x < rx && !lock.eql?(:vertical)
      object.y = ry if object.y < ry && !lock.eql?(:horizontal)
      object.x = rx + rw - ow if object.x > rx + rw - ow && !lock.eql?(:vertical)
      object.y = ry + rh - oh if object.y > ry + rh - oh && !lock.eql?(:horizontal)
    end
    #---------------------------------------------------------------------------
    #  method to drag object only on the X axis
    #---------------------------------------------------------------------------
    def drag_object_x(object, button = :left, rect = nil)
      drag_object(object, button, rect, :horizontal)
    end
    #---------------------------------------------------------------------------
    #  method to drag object only on the Y axis
    #---------------------------------------------------------------------------
    def drag_object_y(object, button = :left, rect = nil)
      drag_object(object, button, rect, :vertical)
    end

    def update
      # Update mouse state
      if press?(:left)
        @hold ||= 0
        @hold += 1
      elsif !press?(:left) && @hold
        # Reset if released
        @hold = nil if @hold >= (CLICK_TIMEOUT * Graphics.frame_rate)
      end
    end
  end # Add this missing end for class << self

  #-----------------------------------------------------------------------------
  #  sprite extensions
  #-----------------------------------------------------------------------------
  module Sprite
    def mouse_params
      ox = x - self.ox + (viewport ? viewport.rect.x : 0)
      oy = y - self.oy + (viewport ? viewport.rect.y : 0)
      ow = bitmap ? bitmap.width * zoom_x : 0
      oh = bitmap ? bitmap.height * zoom_y : 0

      if src_rect
        ow = src_rect.width * zoom_x unless src_rect.width.eql?(ow)
        oh = src_rect.height * zoom_y unless src_rect.height.eql?(oh)
      end

      [ox, oy, ow, oh]
    end

    def over_pixel?
      return false unless over? && bitmap

      ox, oy = mouse_params

      bitmap.get_pixel(x - ox, y - oy).alpha.positive?
    end
  end
  #-----------------------------------------------------------------------------
  #  viewport extensions
  #-----------------------------------------------------------------------------
  module Viewport
    def mouse_params
      [rect.x, rect.y, rect.width, rect.height]
    end
  end
  #-----------------------------------------------------------------------------
  #  shared extensions
  #-----------------------------------------------------------------------------
  module Extensions
    def click?
      over? && Mouse.click?
    end

    def over?
      Mouse.over?(self)
    end

    def mouse_drag
      Mouse.drag_object(self)
    end

    def mouse_over?
      Mouse.over?(self)
    end
    
    def mouse_click?
      mouse_over? && Mouse.click?
    end
    
    def mouse_press?
      mouse_over? && Mouse.press? 
    end
    
    def mouse_release?
      mouse_over? && Mouse.release?
    end
  end
end
#-------------------------------------------------------------------------------
#  add mouse functionality to sprite class
#-------------------------------------------------------------------------------
class ::Sprite
  include Mouse::Extensions
  include Mouse::Sprite
end
#-------------------------------------------------------------------------------
#  add mouse functionality to rect class
#-------------------------------------------------------------------------------
class ::Rect
  include Mouse::Extensions
end
#-------------------------------------------------------------------------------
#  add mouse functionality to viewport class
#-------------------------------------------------------------------------------
class ::Viewport
  include Mouse::Extensions
  include Mouse::Viewport
end
