//
//  AppDelegate.m
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <ContextCore/QLContextCoreConnector.h>
#import <ContextCore/QLPushNotificationsConnector.h>
#import <FYX/FYXLogging.h>
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FYX setAppId:@"c7306011981e8ddf043c74571d2368554c30e72c3e6c442e478a47785a4817b6" appSecret:@"dc6bf16bbd09701ae368e5258c3a1a883dfe84e89b28a05802261f280574fdf3" callbackUrl:@"comgspanngretail://authcode"];
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_INFO];
    //[FYX startServiceAndAuthorizeWithViewController:self.window.rootViewController delegate:self];
    [FYX startService:self];
    
    QLContextCoreConnector *connector = [QLContextCoreConnector new];
    [connector enableFromViewController:self.window.rootViewController success:^
     {
         NSLog(@"Gimbal enabled");
     } failure:^(NSError *error) {
         NSLog(@"Failed to initialize gimbal %@", error);
     }];
    
    [QLPushNotificationsConnector didFinishLaunchingWithOptions:launchOptions];
    [QLPushNotificationsConnector registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}

- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}

#pragma mark - Gimbal SDK related Methods
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [QLPushNotificationsConnector didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [QLPushNotificationsConnector didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:notification forKey:@"userInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLocalNotifications" object:Nil userInfo:userInfo];
}

@end