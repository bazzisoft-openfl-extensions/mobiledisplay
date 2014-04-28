#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include "MobileDisplayIPhone.h"
#include "ExtensionKit.h"


//
// Converts a CGRect specified in points & without accounting for device
// orientation into a new CGRect in pixels and in the correct orientation.
//
static CGRect ConvertCGRectToPixelsAndOrientation(const CGRect& rect)
{
    UIWindow* topWindow = [[UIApplication sharedApplication] keyWindow];
    UIView* topView = topWindow.rootViewController.view;
    CGFloat scaleFactor = topView.contentScaleFactor;
    CGRect resultRect;

    if (UIInterfaceOrientationIsPortrait(topWindow.rootViewController.interfaceOrientation))
    {
        resultRect.origin.x = rect.origin.x * scaleFactor;
        resultRect.origin.y = rect.origin.y * scaleFactor;
        resultRect.size.width = rect.size.width * scaleFactor;
        resultRect.size.height = rect.size.height * scaleFactor;
    }
    else if (UIInterfaceOrientationIsLandscape(topWindow.rootViewController.interfaceOrientation))
    {
        resultRect.origin.x = rect.origin.y * scaleFactor;
        resultRect.origin.y = rect.origin.x * scaleFactor;
        resultRect.size.width = rect.size.height * scaleFactor;
        resultRect.size.height = rect.size.width * scaleFactor;
    }

    return resultRect;
}


//
// This class receives notifications from the iOS system.
//

@interface NotificationObserver : NSObject
{
}
- (void)UIKeyboardWillShow:(NSNotification *)notification;
- (void)UIKeyboardWillHide:(NSNotification *)notification;
@end


@implementation NotificationObserver

- (void)UIKeyboardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];

    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = ConvertCGRectToPixelsAndOrientation(keyboardRect);

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect = ConvertCGRectToPixelsAndOrientation(screenRect);

    // Trigger a MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED event
    extensionkit::DispatchEventToHaxe("mobiledisplay.event.MobileKeyboardPopupEvent",
                                      extensionkit::CSTRING, "mobiledisplay_keyboard_activated",
                                      extensionkit::CINT, (int)(screenRect.size.width + 0.5),
                                      extensionkit::CINT, (int)(screenRect.size.height + 0.5),
                                      extensionkit::CINT, (int)(keyboardRect.size.height + 0.5),
                                      extensionkit::CEND);
}

- (void)UIKeyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];

    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = ConvertCGRectToPixelsAndOrientation(keyboardRect);

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect = ConvertCGRectToPixelsAndOrientation(screenRect);

    // Trigger a MobileKeyboardPopupEvent.KEYBOARD_DEACTIVATED event
    extensionkit::DispatchEventToHaxe("mobiledisplay.event.MobileKeyboardPopupEvent",
                                      extensionkit::CSTRING, "mobiledisplay_keyboard_deactivated",
                                      extensionkit::CINT, (int)(screenRect.size.width + 0.5),
                                      extensionkit::CINT, (int)(screenRect.size.height + 0.5),
                                      extensionkit::CINT, 0,
                                      extensionkit::CEND);
}

@end


namespace mobiledisplay
{
    namespace iphone
    {
        void InitializeIPhone()
        {
            // Request notifications of UI changes caused by keyboard

            NotificationObserver* notificationObserver = [[NotificationObserver alloc] init];

            [[NSNotificationCenter defaultCenter] addObserver:notificationObserver
                selector:@selector(UIKeyboardWillShow:)
                name:UIKeyboardWillShowNotification
                object:nil];

            [[NSNotificationCenter defaultCenter] addObserver:notificationObserver
                selector:@selector(UIKeyboardWillHide:)
                name:UIKeyboardWillHideNotification
                object:nil];
        }
    }
}