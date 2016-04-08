//
//  AppDelegate.swift
//  InteractorSwift

import UIKit
import Moscapsule
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EventListener {

    var window: UIWindow?
    var mqttClient: MQTTClient?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
       
        if(UIApplication.instancesRespondToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))))
        {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))  // types are UIUserNotificationType members
        }
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        
        // set Interactor credentials
        let config = LBSConfig()
        config.apiKey="aca947d3-2af4-4221-b700-688fee598631"
        config.server="https://interactor.swisscom.ch"
        config.logging = false
        
        let interactor = Interactor.sharedInteractor()
        interactor.configureWithConfig(config)
        interactor.startInteractor()

        interactor.registerEventListener(self)
        
        let appId:String = interactor.queryParameter("APP_ID")
        NSLog("App id: %@", appId);
        
        let clientID = valueForAPIKey("clientID")
        let host = valueForAPIKey("host")
        
        // set MQTT Client Configuration
        let mqttConfig = MQTTConfig(clientId: clientID, host: host, port: 1883, keepAlive: 60)
        
        let username = valueForAPIKey("username")
        let password = valueForAPIKey("password")
        
        // set username and password
        mqttConfig.mqttAuthOpts = MQTTAuthOpts(username:username, password: password)
        
        // register some callbacl function for logging purpose
        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        mqttConfig.onConnectCallback = { returnCode in
            NSLog("connected: returnCode=\(returnCode)")
        }
        
        // create new MQTT Connection
        mqttClient = MQTT.newConnection(mqttConfig, connectImmediately:true)
        
        return true
    }
    
    func eventTriggered(event: LBSEvent!) {
        var mqtttopic = String()
        
        // send local push message
        self.notify(event.name)
        
        // set MQTT topic
        if event.type == ZONE_ENTRY {
            mqtttopic = String("iot-2/evt/Entry/fmt/json")
        }
        else if event.type == ZONE_EXIT {
            mqtttopic = String("iot-2/evt/Exit/fmt/json")
        }
        
        // set eventName (configured in Interactor) in JSON message
        let jsonObject: AnyObject = ["d":["zoneName": (event.name)]]
        
        // JSONinfy (might not be required at all)
        let jsonString = JSONStringify(jsonObject)
        
        // publish MQTT message
        mqttClient?.publishString(jsonString, topic: mqtttopic, qos: 0, retain: false)
    }
    
    func notify(text: String) {
        let localNotification = UILocalNotification();
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1);
        localNotification.alertBody = text;
        localNotification.timeZone = NSTimeZone.defaultTimeZone();
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification);

    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background {
            self.notify("Background fetch triggered: \(NSDate())")
            self.synchroniseInteractorData()
            completionHandler(UIBackgroundFetchResult.NewData)
        }
        else {
            completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    
    func synchroniseInteractorData() {
        Interactor.sharedInteractor().synchroniseData()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        
        
        if NSJSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    func valueForAPIKey(keyname:String) -> String {
        let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        
        let value:String = plist?.objectForKey(keyname) as! String
        return value
    }
    
}

