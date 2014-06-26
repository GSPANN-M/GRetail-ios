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
#import <ContextLocation/QLContextPlaceConnector.h>
#import <ContextLocation/QLPlaceEvent.h>
#import <ContextLocation/QLPlace.h>

@interface HomeViewController : UIViewController<UIApplicationDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIWebViewDelegate, FYXiBeaconVisitDelegate, FYXVisitDelegate, QLContextPlaceConnectorDelegate>

@property (nonatomic) QLContentConnector *contentConnector;
@property (nonatomic) QLContextPlaceConnector *placeConnector;
@property (strong, nonatomic) NSString *urlToOpen;
//@property (weak, nonatomic) IBOutlet UITableView *beaconsTableView;
//@property (weak, nonatomic) IBOutlet UITextView *consoleTxtView;
//@property (weak, nonatomic) IBOutlet UIView *clearButtonView;
//@property (weak, nonatomic) IBOutlet UILabel *lblNoBeacons;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorNoBeacons;
@property (weak, nonatomic) IBOutlet UIWebView *webViewForCommunicationURL;
@property (retain, nonatomic) NSURL *urlforWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
-(void)handleLocalNotifications : (NSNotification *)notification;

@end
