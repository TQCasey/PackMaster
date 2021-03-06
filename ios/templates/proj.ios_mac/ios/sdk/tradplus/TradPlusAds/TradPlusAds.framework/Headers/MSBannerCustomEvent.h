//
//  MSBannerCustomEvent.h
//  AdExpress
//
//  Copyright (c) 2012 TradPlusAd, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBannerCustomEventDelegate.h"

/**
 * The TradPlusAd iOS SDK mediates third party Ad Networks using custom events.  The custom events are
 * responsible for instantiating and manipulating objects in the third party SDK and translating
 * and communicating events from those objects back to the TradPlusAd SDK by notifying a delegate.
 *
 * `MSBannerCustomEvent` is a base class for custom events that support banners. By implementing
 * subclasses of `MSBannerCustomEvent` you can enable the TradPlusAd SDK to natively support a wide
 * variety of third-party ad networks.
 *
 * At runtime, the TradPlusAd SDK will find and instantiate an `MSBannerCustomEvent` subclass as needed and
 * invoke its `-requestAdWithSize:customEventInfo:` method.
 */

@interface MSBannerCustomEvent : NSObject

/** @name Requesting a Banner Ad */

/**
 * Called when the TradPlusAd SDK requires a new banner ad.
 *
 * When the TradPlusAd SDK receives a response indicating it should load a custom event, it will send
 * this message to your custom event class. Your implementation of this method can either load a
 * banner ad from a third-party ad network, or execute any application code. It must also notify the
 * `MSBannerCustomEventDelegate` of certain lifecycle events.
 *
 * @param size The current size of the parent `MSAdView`.  You should use this information to create
 * and request a banner of the appropriate size.
 *
 * @param info A  dictionary containing additional custom data associated with a given custom event
 * request. This data is configurable on the TradPlusAd website, and may be used to pass dynamic information, such as publisher IDs.
 */
- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info;

/** @name Callbacks */

/**
 * Called when a banner rotation should occur.
 *
 * If you call `-rotateToOrientation` on an `MSAdView`, it will forward the message to its custom event.
 * You can implement this method for third-party ad networks that have special behavior when
 * orientation changes happen.
 *
 * @param newOrientation The `UIInterfaceOrientation` passed to the `MSAdView`'s `rotateToOrientation` method.
 *
 */
- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation;

/**
 * Calld when the banner is presented on screen.
 *
 * If you decide to [opt out of automatic impression tracking](enableAutomaticImpressionAndClickTracking), you should place your
 * manual calls to [-trackImpression]([MSBannerCustomEventDelegate trackImpression]) in this method to ensure correct metrics.
 */
- (void)didDisplayAd;

/** @name Impression and Click Tracking */

/**
 * Override to opt out of automatic impression and click tracking.
 *
 * By default, the  MSBannerCustomEventDelegate will automatically record impressions and clicks in
 * response to the appropriate callbacks. You may override this behavior by implementing this method
 * to return `NO`.
 *
 * @warning **Important**: If you do this, you are responsible for calling the `[-trackImpression]([MSBannerCustomEventDelegate trackImpression])` and
 * `[-trackClick]([MSBannerCustomEventDelegate trackClick])` methods on the custom event delegate. Additionally, you should make sure that these
 * methods are only called **once** per ad.
 *
 */
- (BOOL)enableAutomaticImpressionAndClickTracking;

/** @name Communicating with the TradPlusAd SDK */

/**
 * The `MSBannerCustomEventDelegate` to send messages to as events occur.
 *
 * The `delegate` object defines several methods that you should call in order to inform both TradPlusAd
 * and your `MSAdView`'s delegate of the progress of your custom event.
 *
 */
@property (nonatomic, weak) id<MSBannerCustomEventDelegate> delegate;

@end
