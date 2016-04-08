#import <Foundation/Foundation.h>
#import "LBSEventType.h"

@interface LBSEvent : NSObject

@property(nonatomic) NSString * name;
@property(nonatomic) NSString * eventDecription DEPRECATED_MSG_ATTRIBUTE("Use property eventDescription instead.");
@property(nonatomic) NSString * eventDescription;
@property(nonatomic) enum LBSEventType type;
@property(nonatomic) NSMutableSet * content;

@end
