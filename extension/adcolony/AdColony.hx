package extension.adcolony;

#if android
import openfl.utils.JNI;
#end

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

class AdColony 
{
	#if android
	private static var __configure:String->Array<String>->String->Dynamic->Void = JNI.createStaticMethod("adcolony/AdColonyLib", "configure", "(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Lorg/haxe/lime/HaxeObject;)V");
	private static var __showAd:String->Void = JNI.createStaticMethod("adcolony/AdColonyLib", "showAd", "(Ljava/lang/String;)V");
	private static var __showV4VCAd:String->Void = JNI.createStaticMethod("adcolony/AdColonyLib", "showV4VCAd", "(Ljava/lang/String;)V");
	#elseif ios
	private static var __handlers:Dynamic = Lib.load("adcolony", "adcolony_handlers", 4);
	private static var __configure:Dynamic = Lib.load("adcolony", "adcolony_configure", 5);
	private static var __showAd:Dynamic = Lib.load("adcolony", "adcolony_showAd", 1);
	private static var __showV4VCAd:Dynamic = Lib.load("adcolony", "adcolony_showV4VCAd", 1);
	#else
	private static var __handlers:Dynamic = null;
	private static var __configure:String->Array<String>->String->Void = null;
	private static var __showAd:String->Void = null;
	private static var __showV4VCAd:String->Void = null;
	#end
	
    public static function configure( app:String, zones:Array<String>, handler:IAdColony, store:String = "google" ):Void 
	{
		if ( __configure != null ) 
		{
			#if android
			__configure( app, zones, store, handler );
			#elseif ios
			__handlers( handler.onAdColonyAdStarted, handler.onAdColonyAdAttemptFinished, handler.onAdColonyAdAvailabilityChange, handler.onAdColonyV4VCReward );
			
			if ( zones.length == 1 )
				__configure( app, zones[0], null, null, null );
			else if ( zones.length == 2 )
				__configure( app, zones[0], zones[1], null, null );
			else if ( zones.length == 3 )
				__configure( app, zones[0], zones[1], zones[2], null );
			else if ( zones.length == 4 )
				__configure( app, zones[0], zones[1], zones[2], zones[3] );
			#end
		}
    }
	
	public static function showAd( zone:String ):Void 
	{
        if ( __showAd != null ) __showAd( zone );
    }
	
	public static function showV4VCAd( zone:String ):Void 
	{
        if ( __showV4VCAd != null ) __showV4VCAd( zone );
    }
	
	public static inline function isAvailable():Bool 
	{
		#if (android || ios)
		return true;
		#else
		return false;
		#end
    }
}