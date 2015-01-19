package;

import extension.adcolony.AdColony;
import extension.adcolony.IAdColony;
import openfl.events.Event;

import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.Lib;

class Main extends Sprite implements IAdColony
{
	// AdColony ID
	#if android
	public static inline var APP_ID = "app185a7e71e1714831a49ec7";
	//public static inline var ZONE_ID = "vz06e8c32a037749699e7050"; // Interstitial
	public static inline var ZONE_ID = "vz1fd5a8b2bf6841a0a4b826"; // V4VC
	#else
	public static inline var APP_ID = "appbdee68ae27024084bb334a";
	//public static inline var ZONE_ID = "vzf8fb4670a60e4a139d01b5"; // Interstitial
	public static inline var ZONE_ID = "vzf8e4e97704c4445c87504e"; // V4VC
	#end
	
	public var t:TextField;
	
    public function new() 
	{
		super();
		
		trace("TEST!!! 1..2..3..");
		
		graphics.beginFill( 0xFF0000 );
		graphics.drawRect( 0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );
		graphics.endFill();
		
        t = new TextField();
        addChild( t );
		
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
    }
	
	private function addedToStageHandler( event:Event ):Void
	{
		removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		
		AdColony.configure( APP_ID, [ZONE_ID], this );
	}
	
	public function onAdColonyAdStarted():Void
	{
		t.text += "\n" + "Started";
	}
	
	public function onAdColonyAdAttemptFinished( shown:Bool, notShown:Bool, skipped:Bool, canceled:Bool, noFill:Bool ):Void
	{
		t.text += "\n" + "Finished,"+shown+","+notShown+","+skipped+","+canceled+","+noFill;
	}
	
	public function onAdColonyAdAvailabilityChange( available:Bool, name:String ):Void
	{
		t.text += "\n" + "Availability," + available + "," + name;
		
		if ( available )
		{
			AdColony.showV4VCAd( ZONE_ID );
		}
	}
	
	public function onAdColonyV4VCReward( success:Bool, name:String, amount:Float ):Void
	{
		t.text += "\n" + "Reward," + success + "," + name + "," + amount;
	}
}
