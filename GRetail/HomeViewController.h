//
//  ViewController.h
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXTransmitter.h>
#import <ContextCore/QLQueryForAnyAttributes.h>
#import <ContextCore/QLContentConnector.h>
#import <ContextCore/QLContent.h>

@interface HomeViewController : UIViewController<UIApplicationDelegate, UIAlertViewDelegate, FYXiBeaconVisitDelegate, FYXVisitDelegate>

@property (nonatomic) QLContentConnector *contentConnector;
@property (strong, nonatomic) NSString *urlToOpen;
-(void)handleLocalNotifications : (NSNotification *)notification;

@end
