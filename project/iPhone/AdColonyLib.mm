#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AdColony/AdColony.h"

extern "C" void onAdColonyStarted();
extern "C" void onAdColonyAdAttemptFinished( bool shown, bool notShown, bool skipped, bool canceled, bool noFill );
extern "C" void onAdColonyAdAvailabilityChange( bool available, const char* name );
extern "C" void onAdColonyV4VCReward( bool success, const char* name, float amount );

@interface AdColonyLib:NSObject <AdColonyDelegate, AdColonyAdDelegate>
{
	
}
@end

@implementation AdColonyLib

#pragma mark -
#pragma mark AdColony V4VC

// Callback activated when a V4VC currency reward succeeds or fails
// This implementation is designed for client-side virtual currency without a server
// It uses NSUserDefaults for persistent client-side storage of the currency balance
// For applications with a server, contact the server to retrieve an updated currency balance
// On success, posts an NSNotification so the rest of the app can update the UI
// On failure, posts an NSNotification so the rest of the app can disable V4VC UI elements
- ( void ) onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID 
{
	onAdColonyV4VCReward( success, [currencyName UTF8String], amount * 1.0f );
}

#pragma mark -
#pragma mark AdColony ad fill

- ( void ) onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString*) zoneID 
{
	onAdColonyAdAvailabilityChange( available, [zoneID UTF8String] );
}

#pragma mark -
#pragma mark AdColonyAdDelegate

// Is called when AdColony has taken control of the device screen and is about to begin showing an ad
// Apps should implement app-specific code such as pausing a game and turning off app music
- ( void ) onAdColonyAdStartedInZone:( NSString * )zoneID 
{
	onAdColonyStarted();
}

// Is called when AdColony has finished trying to show an ad, either successfully or unsuccessfully
// If shown == YES, an ad was displayed and apps should implement app-specific code such as unpausing a game and restarting app music
- ( void ) onAdColonyAdAttemptFinished:(BOOL)shown inZone:( NSString * )zoneID 
{
	onAdColonyAdAttemptFinished( shown, !shown, false, false, false );
}

@end

namespace adcolony 
{
	NSString *_app;
	NSString *_zone;
	AdColonyLib *_instance;
	
	void Configure( const char* app, const char* zone1, const char* zone2, const char* zone3, const char* zone4 )
	{
		_app = [[NSString alloc] initWithUTF8String:app];
		_zone = [[NSString alloc] initWithUTF8String:zone1];
		
		NSMutableArray * zones = [[NSMutableArray alloc] initWithCapacity: 4];
		[zones addObject: _zone];
		if ( zone2 != 0 ) [zones addObject: [[NSString alloc] initWithUTF8String:zone2]];
		if ( zone3 != 0 ) [zones addObject: [[NSString alloc] initWithUTF8String:zone3]];
		if ( zone4 != 0 ) [zones addObject: [[NSString alloc] initWithUTF8String:zone4]];
		
		_instance = [AdColonyLib alloc];
		[AdColony configureWithAppID:_app zoneIDs:zones delegate:_instance logging:YES];
	}
	
	void ShowAd( const char* id )
	{
		if ( id != 0 )
		{
			_zone = [[NSString alloc] initWithUTF8String:id];
		}
		
		[AdColony playVideoAdForZone:_zone withDelegate:_instance];
	}
	
	void ShowV4VCAd( const char* id )
	{
		if ( id != 0 )
		{
			_zone = [[NSString alloc] initWithUTF8String:id];
		}
		
		[AdColony playVideoAdForZone:_zone withDelegate:_instance withV4VCPrePopup:YES andV4VCPostPopup:YES];
	}
}
