package org.haxe.extension.mobiledisplay;

import org.haxe.extension.extensionkit.HaxeCallback;

import android.graphics.Rect;
//import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;


public class SoftKeyboardListener 
{
    private boolean m_isSoftKeyboardVisible = false;
    
    public SoftKeyboardListener()
    {        
    }
    
    public void InstallKeyboardListener(final View activityRootView)
    {
        activityRootView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect r = new Rect();
                
                //r will be populated with the coordinates of the view area still visible
                activityRootView.getWindowVisibleDisplayFrame(r);
                int screenWidth = activityRootView.getRootView().getWidth();
                int screenHeight = activityRootView.getRootView().getHeight() - r.top;
                final int heightDiff = screenHeight - (r.bottom - r.top);
                
                //Utils.LogInfo("Rect: left=" + r.left + ", top=" + r.top + ", right=" + r.right + ", bottom=" + r.bottom);
                //Utils.LogInfo("screenHeight: " + screenHeight);
                //Utils.LogInfo("heightDiff: " + heightDiff);
                //Utils.LogInfo("keyboardVisible: " + m_isSoftKeyboardVisible);
                
                if (!m_isSoftKeyboardVisible && heightDiff >= 100)
                {                    
                    m_isSoftKeyboardVisible = true;
                    HaxeCallback.DispatchEventToHaxe(
                        "mobiledisplay.event.MobileKeyboardPopupEvent", 
                        new Object[] {
                            "mobiledisplay_keyboard_activated", 
                            screenWidth,
                            screenHeight,
                            heightDiff
                        });
                }
                else if (m_isSoftKeyboardVisible && heightDiff < 100)
                {
                    m_isSoftKeyboardVisible = false;
                    HaxeCallback.DispatchEventToHaxe(
                            "mobiledisplay.event.MobileKeyboardPopupEvent", 
                            new Object[] {
                                "mobiledisplay_keyboard_deactivated", 
                                screenWidth,
                                screenHeight,
                                heightDiff
                            });
                }
                
                //Utils.LogInfo("newKeyboardVisible: " + m_isSoftKeyboardVisible);
            }
        });
    }
}
