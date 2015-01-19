package extension.adcolony;

/**
 * Interface for AdColony extension
 */
interface IAdColony
{
	function onAdColonyAdStarted():Void;
	function onAdColonyAdAttemptFinished( shown:Bool, notShown:Bool, skipped:Bool, canceled:Bool, noFill:Bool ):Void;
	function onAdColonyAdAvailabilityChange( available:Bool, name:String ):Void;
	function onAdColonyV4VCReward( success:Bool, name:String, amount:Float ):Void;
}