//
//  ViewController.h
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FYX/FYX.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXTransmitter.h>
#import <FYX/FYXVisit.h>
#import <FYX/FYXTransmitterManager.h>
#import <ContextCore/QLQueryForAnyAttributes.h>
#import <ContextCore/QLContentConnector.h>
#import <ContextCore/QLContent.h>
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate, FYXiBeaconVisitDelegate, FYXVisitDelegate>

@property (nonatomic) QLContentConnector *contentConnector;
@property (strong, nonatomic) NSString *urlToOpen;
@property (weak, nonatomic) IBOutlet UITableView *beaconsTableView;
-(void)handleLocalNotifications : (NSNotification *)notification;

@end
