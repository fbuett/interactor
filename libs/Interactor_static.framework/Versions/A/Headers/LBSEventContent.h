#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LBSEventContentType) {
    TEXT, IMAGE, URL, CUSTOM, LBSEventContentTypeUnknown
};

@interface LBSEventContent : NSObject

@property(nonatomic) NSString * key;
@property(nonatomic) NSString * value;
@property(nonatomic) LBSEventContentType type;


@end
