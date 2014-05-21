//
//  AppDelegate.h
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FYX/FYX.h>
#import <ContextLocation/QLContextPlaceConnector.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, FYXServiceDelegate, QLContextPlaceConnectorDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) QLContextPlaceConnector *placeConnector;

@end
