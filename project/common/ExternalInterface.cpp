#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "MobileDisplay.h"


using namespace mobiledisplay;



static void mobiledisplay_keep_screen_on(value enabledValue)
{
	KeepScreenOn(val_bool(enabledValue));
}
DEFINE_PRIM(mobiledisplay_keep_screen_on, 1);



extern "C" void mobiledisplay_main()
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT(mobiledisplay_main);



extern "C" int mobiledisplay_register_prims()
{
    Initialize();
    return 0;
}