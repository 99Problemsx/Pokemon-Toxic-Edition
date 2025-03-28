module RfSettings
    # This allows you to override the default windowskin used for the name window
    # e.g. "Graphics/Windowskins/myskin"
    DEFAULT_WINDOW_SKIN = nil

    # Sprite outline settings
    OUTLINE = true
    DEFAULT_OUTLINE_COLOR = Color.new(255,255,255)

    # This is a fix allowing you to use the portraits on maps with cave darkness.
    # Due to how this fix works it may conflict with scripts that modify cave darkness, so you can disable that fix here.
    PORTRAITS_ENABLE_CAVEOVERLAY_FIX = true

    # This allows you to toggle whether or not portraits close automatically when an event ends
    PORTRAITS_AUTO_CLOSE_ON_EVENT_END = true
end