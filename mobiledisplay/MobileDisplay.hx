package mobiledisplay;
import flash.display.Sprite;
import extensionkit.ExtensionKit;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if android
import lime.system.JNI;
#end


class MobileDisplay
{
    private static var s_initialized:Bool = false;

    #if cpp
    private static var mobiledisplay_keep_screen_on = null;
    #end

    #if android
    private static var mobiledisplay_keep_screen_on_jni = null;
    #end

    public static function Initialize() : Void
    {
        if (s_initialized)
        {
            return;
        }

        s_initialized = true;
        ExtensionKit.Initialize();

        #if cpp
        mobiledisplay_keep_screen_on = Lib.load("mobiledisplay", "mobiledisplay_keep_screen_on", 1);
        #end

        #if android
        mobiledisplay_keep_screen_on_jni = JNI.createStaticMethod("org.haxe.extension.mobiledisplay.MobileDisplay", "KeepScreenOn", "(Z)V");
        #end
    }

    public static function KeepScreenOn(enabled:Bool) : Void
    {
        #if android
        mobiledisplay_keep_screen_on_jni(enabled);
        #elseif cpp
        mobiledisplay_keep_screen_on(enabled);
        #end
    }
}