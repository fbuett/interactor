#import <Foundation/Foundation.h>

@interface LBSBeacon : NSObject <NSCopying>

@property(nonatomic) NSUUID *uuid;
@property(nonatomic) NSInteger major;
@property(nonatomic) NSInteger minor;

+ (LBSBeacon*)initWithWithUUID:(NSUUID *)uuid major:(NSInteger)major minor:(NSInteger)minor;

@end
