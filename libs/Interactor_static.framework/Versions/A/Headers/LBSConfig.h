

#import <Foundation/Foundation.h>

@interface LBSConfig : NSObject

@property (nonatomic) NSString * apiKey;
@property (nonatomic) NSString * server;

/**
 *  logging
 *
 *  Default: NO
 */
@property (nonatomic) BOOL logging;


/**
 *  checkBluetoothAccess: Bluetooth has to be turned on for proper functionality
 *
 *  Set to NO if Interactor shall not handle Bluetooth accessability
 *
 *  Default: YES
 */
@property (nonatomic) BOOL checkBluetoothAccess;


/**
 *  checkLocationAccess : For proper functionality Interactor needs <requestAlwaysAuthorization>
 *
 *  Set to NO if Interactor shall not handle Location accessability
 *
 *  Default: YES
 */
@property (nonatomic) BOOL checkLocationAccess;

@end
