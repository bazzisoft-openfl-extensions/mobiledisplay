MobileDisplay
=============

This extension provides functionality for managing the display of mobile devices. Currently this includes:

- Keeping the screen on indefinitely.
- Detecting and triggering events when the virtual keyboard pops up & down.
- Simulating a soft keyboard display element for non-mobile devices.


Dependencies
------------

- This extension implicitly includes `extensionkit` which must be available in a folder
  beside this one.


Installation
------------

    git clone https://github.com/bazzisoft-openfl-extensions/extensionkit
    git clone https://github.com/bazzisoft-openfl-extensions/mobiledisplay
    lime rebuild extensionkit [linux|windows|mac|android|ios]
    lime rebuild mobiledisplay [linux|windows|mac|android|ios]


Usage
-----

### project.xml

    <include path="/path/to/mobiledisplay-0.1" />


### Haxe

    class Main extends Sprite
    {
    	public function new()
        {
    		super();

            MobileDisplay.Initialize();

            stage.addEventListener(MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED, function(e) { trace(e); } );
            stage.addEventListener(MobileKeyboardPopupEvent.KEYBOARD_DEACTIVATED, function(e) { trace(e); } );

            MobileDisplay.KeepScreenOn(true);

            #if !mobile
            addChild(new TouchKeyboardSimulator(stage.stageWidth, stage.stageHeight));
            #end

            ...
        }
    }
