#include <stdio.h>
#include "MobileDisplay.h"
#include "../iphone/MobileDisplayIPhone.h"


namespace mobiledisplay
{
    void Initialize()
    {
        #ifdef IPHONE
        iphone::InitializeIPhone();
        #endif
    }

    void KeepScreenOn(bool enabled)
    {
        printf("KeepScreenOn (Native): %s\n", (enabled ? "ENABLED" : "DISABLED"));

        // TODO: Implement this for any non-Java platforms as necessary
    }
}
