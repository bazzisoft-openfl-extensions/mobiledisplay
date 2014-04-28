package mobiledisplay.event;
import flash.events.Event;


class MobileKeyboardPopupEvent extends Event
{
    public static inline var KEYBOARD_ACTIVATED = "mobiledisplay_keyboard_activated";
    public static inline var KEYBOARD_DEACTIVATED = "mobiledisplay_keyboard_deactivated";

    public var screenWidth(default, null) : Int;
    public var screenHeight(default, null) : Int;
    public var keyboardHeight(default, null) : Int;
    public var availableScreenHeight(get, never) : Int;

    public function new(type:String, screenWidth:Int, screenHeight:Int, keyboardHeight:Int)
    {
        super(type, true, true);

        this.screenWidth = screenWidth;
        this.screenHeight = screenHeight;
        this.keyboardHeight = keyboardHeight;
    }

	public override function clone() : Event
    {
		return new MobileKeyboardPopupEvent(type, screenWidth, screenHeight, keyboardHeight);
	}

	public override function toString() : String
    {
		return "[MobileKeyboardPopupEvent type=" + type + " screenWidth=" + screenWidth + " screenHeight=" + screenHeight + " keyboardHeight=" + keyboardHeight + "]";
	}

    private function get_availableScreenHeight() : Int
    {
        return this.screenHeight - this.keyboardHeight;
    }
}