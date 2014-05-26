//
//  Beacon.h
//  GRetail
//
//  Created by Ram Awadhesh on 23/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSNumber *rssi;
@property (nonatomic, strong) NSNumber *previousRSSI;
@property (nonatomic, strong) NSDate *lastSighted;
@property (nonatomic, strong) NSNumber *batteryLevel;
@property (nonatomic, strong) NSNumber *temperature;

@end
