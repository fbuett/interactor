#import <Foundation/Foundation.h>
#import "LBSBeacon.h"
#import <CoreLocation/CoreLocation.h>

@interface LBSBeaconEvent : NSObject<NSCopying>

@property(nonatomic) LBSBeacon *beacon;
@property(nonatomic) NSInteger rssi;
@property(nonatomic) CLLocationAccuracy distance;
@property(nonatomic) CLProximity range;


+ (LBSBeaconEvent *)initWithWithBeacon:(LBSBeacon *)beacon rssi:(NSInteger)rssi distance:(CLLocationAccuracy)distance andRange:(CLProximity)range;

@end
