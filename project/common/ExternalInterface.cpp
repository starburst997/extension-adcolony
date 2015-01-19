#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "Utils.h"

using namespace adcolony;

// Configure
AutoGCRoot* adStartedHandle = 0;
AutoGCRoot* adAttemptFinishedHandle = 0;
AutoGCRoot* adAvailabilityChangeHandle = 0;
AutoGCRoot* v4vcRewardHandle = 0;

static void adcolony_handlers( value adStartedHandler, value adAttemptFinishedHandler, value adAvailabilityChangeHandler, value v4vcRewardHandler )
{
	adStartedHandle = new AutoGCRoot(adStartedHandler);
	adAttemptFinishedHandle = new AutoGCRoot(adAttemptFinishedHandler);
	adAvailabilityChangeHandle = new AutoGCRoot(adAvailabilityChangeHandler);
	v4vcRewardHandle = new AutoGCRoot(v4vcRewardHandler);
}
DEFINE_PRIM( adcolony_handlers, 4 )

static void adcolony_configure( value app, value zone1, value zone2, value zone3, value zone4 )
{
    const char* appStr = val_get_string(app);
	const char* zoneStr1 = val_get_string(zone1);
	const char* zoneStr2 = zone2 == 0 ? 0 : val_get_string(zone2);
	const char* zoneStr3 = zone3 == 0 ? 0 : val_get_string(zone3);
	const char* zoneStr4 = zone4 == 0 ? 0 : val_get_string(zone4);
	
    adcolony::Configure( appStr, zoneStr1, zoneStr2, zoneStr3, zoneStr4 );
}
DEFINE_PRIM( adcolony_configure, 5 )

// ShowAd
static void adcolony_showAd( value zone )
{
	const char* zoneStr = zone == 0 ? 0 : val_get_string(zone);
    adcolony::ShowAd( zoneStr );
}
DEFINE_PRIM( adcolony_showAd, 1 )

// ShowV4VCAd
static void adcolony_showV4VCAd( value zone )
{
	const char* zoneStr = zone == 0 ? 0 : val_get_string(zone);
    adcolony::ShowV4VCAd( zoneStr );
}
DEFINE_PRIM( adcolony_showV4VCAd, 1 )

// Externs
extern "C" void adcolony_main () {}
DEFINE_ENTRY_POINT (adcolony_main);

extern "C" int adcolony_register_prims () { return 0; }

// Events
extern "C" void onAdColonyStarted()
{
    val_call0( adStartedHandle->get() );
}

extern "C" void onAdColonyAdAttemptFinished( bool shown, bool notShown, bool skipped, bool canceled, bool noFill )
{
	value args[] = {alloc_bool(shown), alloc_bool(notShown), alloc_bool(skipped), alloc_bool(canceled), alloc_bool(noFill)};
	
    val_callN( adAttemptFinishedHandle->get(), args, 5 );
}

extern "C" void onAdColonyAdAvailabilityChange( bool available, const char* name )
{
    val_call2( adAvailabilityChangeHandle->get(), alloc_bool(available), alloc_string(name) );
}

extern "C" void onAdColonyV4VCReward( bool success, const char* name, float amount )
{
    val_call3( v4vcRewardHandle->get(), alloc_bool(success), alloc_string(name), alloc_float(amount) );
}