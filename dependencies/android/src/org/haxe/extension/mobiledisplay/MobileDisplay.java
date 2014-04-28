package org.haxe.extension.mobiledisplay;

import org.haxe.extension.extensionkit.Trace;

import android.os.Bundle;


public class MobileDisplay extends org.haxe.extension.Extension
{
    private SoftKeyboardListener m_softKeyboardListener;
    
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
        m_softKeyboardListener = new SoftKeyboardListener();
	    m_softKeyboardListener.InstallKeyboardListener(mainView);
	}
	
    public static void KeepScreenOn(final boolean enabled)
    {
        Trace.Warning("KeepScreenOn (JNI): " + (enabled ? "ENABLED" : "DISABLED"));
        
        mainActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mainView.setKeepScreenOn(enabled);
            }
        });
    }	
}