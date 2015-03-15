MobileDisplay
=============

### Manage the mobile display & detect virtual keyboard appearance

- Lets you keep the screen on indefinitely.

- Detects and triggers events when the virtual keyboard pops up & down.

- Simulates a soft keyboard display element for non-mobile devices.


Acknowledgements
----------------

- Android keyboard detection code modified from [http://stackoverflow.com/questions/2150078/how-to-check-visibility-of-software-keyboard-in-android](http://stackoverflow.com/questions/2150078/how-to-check-visibility-of-software-keyboard-in-android).


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

    <include path="/path/to/extensionkit" />
    <include path="/path/to/mobiledisplay" />


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
