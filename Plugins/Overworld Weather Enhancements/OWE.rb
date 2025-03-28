#=======================================================
# This section handles the playing of the sound effects 
# associated with the weather condition. All sound
# effects must be placed in the BGS folder, as this is
# how they will play alongside map bgm.
#=======================================================
class Game_Screen
  alias owsfx_weather weather
	
  def weather(type, power, duration)
    owsfx_weather(type, power, duration)
    case @weather_type
      when :Rain        then pbBGSPlay("Rain")
      when :Storm 		then pbBGSPlay("Storm")
      when :Snow        then pbBGSPlay("Snow")
      when :Blizzard    then pbBGSPlay("Blizzard")
      when :Sandstorm   then pbBGSPlay("Sandstorm")
      when :HeavyRain   then pbBGSPlay("HeavyStorm")
      when :Sun         then pbBGSPlay("Sunny")
      when :Fog         then pbBGSPlay("Fog")
      else                   pbBGSFade(duration)
	end
  end
end

#=======================================================
# This section handles the playing of thunder sound
# effects when it is storming. These sound effects must
# be in the SE folder.
#=======================================================
module RPG
  class Weather
    alias owsfx_update update unless method_defined?(:owsfx_update)
    def update
      if @type == :Storm && !@fading && @time_until_flash > 0 && @time_until_flash - Graphics.delta <= 0
        sfx = ["OWThunder1", "OWThunder2", nil].sample
        pbSEPlay(sfx) if sfx
      end
      owsfx_update
    end
  end
end