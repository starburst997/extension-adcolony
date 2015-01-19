package adcolony;

import com.jirbo.adcolony.*;

import android.app.*;
import android.content.pm.ActivityInfo;
import android.os.*; 
import android.util.Log;
import android.view.*;  
import android.webkit.ValueCallback;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.*;

import org.haxe.lime.HaxeObject;
import org.haxe.lime.GameActivity;
import org.haxe.extension.Extension;

public class AdColonyLib extends Extension implements AdColonyAdListener, AdColonyV4VCListener, AdColonyAdAvailabilityListener
{
	public static String APP_ID = "app185a7e71e1714831a49ec7";
	public static String ZONE_ID = "vz1fd5a8b2bf6841a0a4b826";
	public static String STORE = "google";
	
	public static String[] ZONES = null;
	
	public static AdColonyLib instance = null;
	public static HaxeObject callback = null;
	
	public static boolean configured = false;
	
	// Keep vars for callback
	private AdColonyV4VCReward _reward;
	private AdColonyAd _ad;
	private boolean _available;
	private String _zone_id;
	
	// Configure AdColony
	public static void configure( String app, String[] zones, String store, HaxeObject handler )
	{
		Log.d("AdColony", "Configure called!");
		
		AdColonyLib.APP_ID = app;
		AdColonyLib.ZONES = zones;
		AdColonyLib.STORE = store;
		AdColonyLib.configured = true;
		AdColonyLib.callback = handler;
		
		if ( AdColonyLib.instance != null ) AdColonyLib.instance._configure();
    }
	
	// Callback AdColony.configure
	public void _configure()
	{
		Extension.callbackHandler.post (new Runnable ()
		{
			@Override public void run () 
			{
				// Ok this is ugly, if someone can provide a better way, go ahead
				if ( AdColonyLib.ZONES.length == 1 )
				{
					AdColony.configure( mainActivity, 
						"version:1.0,store:" + STORE, 
						//   version - arbitrary application version
						//   store   - google or amazon
						APP_ID, 
						AdColonyLib.ZONES[0]
					);
				}
				else if ( AdColonyLib.ZONES.length == 2 )
				{
					AdColony.configure( mainActivity, "version:1.0,store:" + STORE,APP_ID, 
						AdColonyLib.ZONES[0], AdColonyLib.ZONES[1]
					);
				}
				else if ( AdColonyLib.ZONES.length == 3 )
				{
					AdColony.configure( mainActivity, "version:1.0,store:" + STORE,APP_ID, 
						AdColonyLib.ZONES[0], AdColonyLib.ZONES[1], AdColonyLib.ZONES[2]
					);
				}
				else if ( AdColonyLib.ZONES.length == 4 )
				{
					AdColony.configure( mainActivity, "version:1.0,store:" + STORE,APP_ID, 
						AdColonyLib.ZONES[0], AdColonyLib.ZONES[1], AdColonyLib.ZONES[2], AdColonyLib.ZONES[3]
					);
				}
				
				AdColonyLib.ZONE_ID = AdColonyLib.ZONES[0];
				
				AdColony.addV4VCListener( AdColonyLib.instance );
				AdColony.addAdAvailabilityListener( AdColonyLib.instance );
			}
		});
	}
	
	// Show Ads
	public static void showAd()
	{
		showAd( AdColonyLib.ZONE_ID );
	}
	public static void showAd( String id )
	{
		Log.d("AdColony", "ShowAd called!");
		
		if ( AdColonyLib.instance != null ) AdColonyLib.instance._showAd( id );
	}
	
	// Show V4VCAds
	public static void showV4VCAd()
	{
		showV4VCAd( AdColonyLib.ZONE_ID );
	}
	public static void showV4VCAd( String id )
	{
		Log.d("AdColony", "ShowV4VCAd called!");
		
		if ( AdColonyLib.instance != null ) AdColonyLib.instance._showV4VCAd( id );
	}
	
	// Show Ads
	public void _showAd( String id )
	{
		AdColonyLib.ZONE_ID = id;
		
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyVideoAd ad = new AdColonyVideoAd( ZONE_ID ).withListener( AdColonyLib.instance );
				ad.show();
			}
		});
	}
	
	// Show V4VC Ads
	public void _showV4VCAd( String id )
	{
		AdColonyLib.ZONE_ID = id;
		
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyV4VCAd ad = new AdColonyV4VCAd( ZONE_ID ).withListener( AdColonyLib.instance )
					.withConfirmationDialog()
					.withResultsDialog();
				
				ad.show();
			}
		});
	}
	
	/* AdColony Events */
	
	// Reward Callback
	public void onAdColonyV4VCReward( AdColonyV4VCReward reward )
	{
		Log.d("AdColony", "onAdColonyV4VCReward");
		
		_reward = reward;
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyLib.callback.call( "onAdColonyV4VCReward", new Object[] { 
					_reward.success(),
					_reward.name(),
					_reward.amount()
				});
				
				_reward = null;
			}
		});
	}
	
	// Ad Started Callback - called only when an ad successfully starts playing
	public void onAdColonyAdStarted( AdColonyAd ad )
	{
		Log.d("AdColony", "onAdColonyAdStarted");
		
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyLib.callback.call( "onAdColonyAdStarted", new Object[] {} );
			}
		});
	}
	
	// Ad Attempt Finished Callback - called at the end of any ad attempt - successful or not.
	public void onAdColonyAdAttemptFinished( AdColonyAd ad )
	{
		// You can ping the AdColonyAd object here for more information:
		// ad.shown() - returns true if the ad was successfully shown.
		// ad.notShown() - returns true if the ad was not shown at all (i.e. if onAdColonyAdStarted was never triggered)
		// ad.skipped() - returns true if the ad was skipped due to an interval play setting
		// ad.canceled() - returns true if the ad was cancelled (either programmatically or by the user)
		// ad.noFill() - returns true if the ad was not shown due to no ad fill.

		Log.d("AdColony", "onAdColonyAdAttemptFinished");
		
		_ad = ad;
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyLib.callback.call( "onAdColonyAdAttemptFinished", new Object[] { 
					_ad.shown(),
					_ad.notShown(),
					_ad.skipped(),
					_ad.canceled(),
					_ad.noFill()
				});
				
				_ad = null;
			}
		});
	}
	
	// Ad Availability Change Callback - update button text
	public void onAdColonyAdAvailabilityChange( boolean available, String zone_id ) 
	{
		Log.d("AdColony", "onAdColonyAdAvailabilityChange, " + available + ", " + zone_id);
		
		_available = available;
		_zone_id = zone_id;
		Extension.callbackHandler.post (new Runnable()
		{
			@Override public void run () 
			{
				AdColonyLib.callback.call("onAdColonyAdAvailabilityChange", new Object[] { 
					_available,
					_zone_id
				});
			}
		});
	}
	
	/* Java Events */
	
	public void onCreate ( Bundle savedInstanceState ) 
	{
		AdColonyLib.instance = this;
		if ( AdColonyLib.configured ) _configure();
	}
	
	public void onPause()
	{
		AdColony.pause();
	}
	
	public void onResume()
	{
		AdColony.resume( mainActivity );
	}
}
