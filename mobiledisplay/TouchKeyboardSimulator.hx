package mobiledisplay;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import mobiledisplay.event.MobileKeyboardPopupEvent;
import openfl.Assets;


/**
 * Add this to your display hierarchy to simulate a soft keyboard.
 */
class TouchKeyboardSimulator extends Sprite
{
    public static inline var IPHONE_KEYBOARD_HEIGHT_PORTRAIT = 432;
    public static inline var IPHONE_KEYBOARD_HEIGHT_LANDSCAPE = 324;

    private static inline var ANIMATION_TIME:Float = 0.2;

    public var keyboardIsOpen(default, null) : Bool;

    private var m_screenWidth:Int;
    private var m_screenHeight:Int;
    private var m_keyboardIcon:Sprite;
    private var m_keyboard:Sprite;
    private var m_isAnimating:Bool;
    private var m_animationTargetY:Float;
    private var m_animationPixelsPerFrame:Int;

    public function new(screenWidth:Int, screenHeight:Int, ?keyboardHeight:Int)
    {
        super();

        var isPortrait = (screenWidth < screenHeight);
        var keyboardAsset = "mobiledisplay/img/soft-keyboard/keyboard-" + (isPortrait ? "portrait" : "landscape") + ".png";

        if (keyboardHeight == null)
        {
            keyboardHeight = (isPortrait ? IPHONE_KEYBOARD_HEIGHT_PORTRAIT : IPHONE_KEYBOARD_HEIGHT_LANDSCAPE);
        }

        this.keyboardIsOpen = false;
        m_screenWidth = screenWidth;
        m_screenHeight = screenHeight;
        m_isAnimating = false;
        m_animationTargetY = 0;

        m_keyboardIcon = CreateButtonSprite("mobiledisplay/img/soft-keyboard/keyboard-icon.png");
        m_keyboardIcon.x = screenWidth - m_keyboardIcon.width;
        m_keyboardIcon.y = screenHeight - m_keyboardIcon.height;
        m_keyboardIcon.addEventListener(MouseEvent.CLICK, HandleKeyboardIconClickAndOpen);
        addChild(m_keyboardIcon);

        m_keyboard = CreateButtonSprite(keyboardAsset);
        m_keyboard.x = 0;
        m_keyboard.y = KeyboardClosedYPosition();
        m_keyboard.width = screenWidth;
        m_keyboard.height = keyboardHeight;
        m_keyboard.addEventListener(MouseEvent.CLICK, HandleKeyboardClickAndClose);
    }

    private function HandleKeyboardIconClickAndOpen(e:MouseEvent) : Void
    {
        if (!keyboardIsOpen)
        {
            keyboardIsOpen = true;
            stage.dispatchEvent(new MobileKeyboardPopupEvent(MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED, m_screenWidth, m_screenHeight, Std.int(m_keyboard.height)));
            AnimateKeyboard(KeyboardOpenYPosition(), -AnimationPixelsPerSecond());
        }
    }

    private function HandleKeyboardClickAndClose(e:MouseEvent) : Void
    {
        if (keyboardIsOpen)
        {
            keyboardIsOpen = false;
            stage.dispatchEvent(new MobileKeyboardPopupEvent(MobileKeyboardPopupEvent.KEYBOARD_DEACTIVATED, m_screenWidth, m_screenHeight, 0));
            AnimateKeyboard(KeyboardClosedYPosition(), AnimationPixelsPerSecond());
        }
    }

    private function AnimateKeyboard(animationTargetY:Float, pixelsPerFrame:Int) : Void
    {
        m_animationTargetY = animationTargetY;
        m_animationPixelsPerFrame = pixelsPerFrame;

        if (!m_isAnimating)
        {
            if (!contains(m_keyboard))
            {
                addChild(m_keyboard);
            }

            m_isAnimating = true;
            addEventListener(Event.ENTER_FRAME, HandleEnterFrame);
        }
    }

    private function HandleEnterFrame(e:Event) : Void
    {
        m_keyboard.y += m_animationPixelsPerFrame;
        if ((m_animationPixelsPerFrame < 0 && m_keyboard.y <= m_animationTargetY) ||
            (m_animationPixelsPerFrame > 0 && m_keyboard.y >= m_animationTargetY))
        {
            m_keyboard.y = m_animationTargetY;
            m_isAnimating = false;
            removeEventListener(Event.ENTER_FRAME, HandleEnterFrame);

            if (m_keyboard.y >= m_screenHeight && contains(m_keyboard))
            {
                removeChild(m_keyboard);
            }
        }
    }

    private function CreateButtonSprite(asset:String) : Sprite
    {
        var bitmapData = Assets.getBitmapData(asset);
        var bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
        bitmap.smoothing = true;

        var sprite = new Sprite();
        sprite.addChild(bitmap);
        sprite.buttonMode = true;

        return sprite;
    }

    private inline function KeyboardOpenYPosition() : Float
    {
        return m_screenHeight - m_keyboard.height;
    }

    private inline function KeyboardClosedYPosition() : Float
    {
        return m_screenHeight + 1;
    }

    private function ProportionOfKeyboardShowing() : Float
    {
        var pixelsShowing = m_screenHeight - m_keyboard.y;
        var percentShowing = pixelsShowing / m_keyboard.height;
        return percentShowing;
    }

    private inline function AnimationPixelsPerSecond() : Int
    {
        return Math.round(m_keyboard.height / (ANIMATION_TIME * stage.frameRate));
    }
}