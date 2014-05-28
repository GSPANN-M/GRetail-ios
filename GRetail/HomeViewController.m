//
//  ViewController.m
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "Beacon.h"
#import "BeaconDetailsTableViewCell.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSMutableArray *beacons;
@property (nonatomic) FYXVisitManager *visitManager;

@end

@implementation HomeViewController

@synthesize urlToOpen;
@synthesize beaconsTableView;
@synthesize beacons;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"GSPANN Retail App";
    
    [self initializeTransmitters];
    
    self.contentConnector = [[QLContentConnector alloc] init];
    self.contentConnector.delegate = self;
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    
    NSMutableDictionary *options = [NSMutableDictionary new];
//    [options setObject:[NSNumber numberWithInt:5] forKey:FYXVisitOptionDepartureIntervalInSecondsKey];
//    [options setObject:[NSNumber numberWithInt:FYXSightingOptionSignalStrengthWindowNone] forKey:FYXSightingOptionSignalStrengthWindowKey];
    [options setObject:[NSNumber numberWithInt:-60] forKey:FYXVisitOptionArrivalRSSIKey];
    [options setObject:[NSNumber numberWithInt:-70] forKey:FYXVisitOptionDepartureRSSIKey];
    
    [self.visitManager startWithOptions:options];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(handleLocalNotifications:) name:@"handleLocalNotifications" object:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Transmitters manipulation

- (void)initializeTransmitters {
    // Re-create the transmitters container array
    //[self showNoTransmittersView];
    @synchronized(self.beacons){
        if (self.beacons == nil) {
            self.beacons = [NSMutableArray new];
        }
        // Always reload the table (even if the transmitter list didn't change)
        [self.beaconsTableView reloadData];
    }
}

- (Beacon *)beaconForID:(NSString *)ID {
    for (Beacon *beacon in self.beacons) {
        if ([beacon.identifier isEqualToString:ID]) {
            return beacon;
        }
    }
    return nil;
}

- (void)addBeacon: (Beacon *)beacon{
    @synchronized(self.beacons){
        [self.beacons addObject:beacon];
    }
}

- (BOOL)shouldUpdateBeaconCell:(FYXVisit *)visit withBeacon:(Beacon *)beacon RSSI:(NSNumber *)rssi{
    if (![beacon.rssi isEqual:rssi] || ![beacon.batteryLevel isEqualToNumber:visit.transmitter.battery]
        || ![beacon.temperature isEqualToNumber:visit.transmitter.temperature]){
        return YES;
    }
    else {
        return NO;
    }
}

- (void)updateBeacon:(Beacon *)beacon withVisit:(FYXVisit *)visit RSSI:(NSNumber *)rssi {
    beacon.previousRSSI = beacon.rssi;
    beacon.rssi = rssi;
    beacon.batteryLevel = visit.transmitter.battery;
    beacon.temperature = visit.transmitter.temperature;
}

- (void)updateSightingsCell:(BeaconDetailsTableViewCell *)beaconDetailsTableViewCell withBeacon:(Beacon *)beacon {
    
    if (beaconDetailsTableViewCell && beacon) {
        dispatch_async(dispatch_get_main_queue(), ^{
            beaconDetailsTableViewCell.contentView.alpha = 1.0f;
            
//            float oldBarWidth = [self barWidthForRSSI:beacon.previousRSSI];
//            float newBarWidth = [self barWidthForRSSI:beacon.rssi];
//            NSLog(@"Old bar width:%f", oldBarWidth);
//            NSLog(@"New bar width:%f", newBarWidth);
//            CGRect tempFrame = beaconDetailsTableViewCell.beaconImage.frame;
//            CGRect oldFrame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, oldBarWidth, tempFrame.size.height);
//            CGRect newFrame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, newBarWidth, tempFrame.size.height);
//            
            // Animate updating the RSSI indicator bar
//            beaconDetailsTableViewCell.RSSISignalStrengthBar.progress = oldBarWidth;
//            [UIView animateWithDuration:1.0f animations:^{
//                beaconDetailsTableViewCell.RSSISignalStrengthBar.progress = newBarWidth;
//            }];
//            beaconDetailsTableViewCell.isGrayedOut = NO;
//            UIImage *batteryImage = [self getBatteryImageForLevel:transmitter.batteryLevel];
//            [beaconDetailsTableViewCell.batteryImageView setImage:batteryImage];
//            beaconDetailsTableViewCell.temperature.text = [NSString stringWithFormat:@"%@%@", transmitter.temperature,
//                                              [NSString stringWithUTF8String:"\xC2\xB0 F" ]];
            beaconDetailsTableViewCell.RSSIValue.text = [NSString stringWithFormat:@"%@", beacon.rssi];
            
        });
    }
}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);
    
    QLQueryForAnyAttributes *queryForAnyAttributes = [[QLQueryForAnyAttributes alloc] init];
    [queryForAnyAttributes whereKey:visit.transmitter.name containsStringValue:visit.transmitter.name];
    
    [self.contentConnector contentsWithQuery:queryForAnyAttributes success:^(NSArray *contents) {
        //                                         // If the transmitter.name matches "mybeacon", the contents parameter will contain the communication
        QLContent *communicationContent = [contents firstObject];
        
        if (communicationContent) {
            
            //if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
                localNotification.alertAction = communicationContent.title;
                localNotification.alertBody = [NSString stringWithFormat:@"%@\n%@",communicationContent.contentDescription, communicationContent.contentUrl];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                
                // Request to reload table view data
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
            }
//        }
    } failure:^(NSError *error) {
        // Failed to retrieve content
        NSLog(@"error is this:%@", error);
    }];
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    //NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
    Beacon *beacon = [self beaconForID:visit.transmitter.identifier];
    if (!beacon) {
        NSString *beaconName = visit.transmitter.identifier;
        if(visit.transmitter.name){
            beaconName = visit.transmitter.name;
        }
        beacon = [Beacon new];
        beacon.identifier = visit.transmitter.identifier;
        beacon.name = beaconName;
        beacon.lastSighted = [NSDate dateWithTimeIntervalSince1970:0];
        beacon.rssi = [NSNumber numberWithInt:-100];
        beacon.previousRSSI = beacon.rssi;
        beacon.batteryLevel = 0;
        beacon.temperature = 0;
        [self addBeacon:beacon];
        [self.beaconsTableView reloadData];
        
//        NSString *beaconImageURL = visit.transmitter.iconUrl;
        
    }
    beacon.lastSighted = updateTime;
    if([self shouldUpdateBeaconCell:visit withBeacon:beacon RSSI:RSSI]){
        [self updateBeacon:beacon withVisit:visit  RSSI:RSSI];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.beacons indexOfObject:beacon] inSection:0];
        for (UITableViewCell *cell in self.beaconsTableView.visibleCells) {
            if ([[self.beaconsTableView indexPathForCell:cell] isEqual:indexPath]) {
                BeaconDetailsTableViewCell *beaconDetailsTableViewCell = (BeaconDetailsTableViewCell *)cell;
                
//                beaconDetailsTableViewCell.RSSISignalStrengthBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//                beaconDetailsTableViewCell.RSSISignalStrengthBar.tintColor = [UIColor blueColor];
                
//                CALayer *tempLayer = [beaconDetailsTableViewCell.RSSISignalStrengthBar.layer presentationLayer];
//                beacon.previousRSSI =  [self rssiForBarWidth:beaconDetailsTableViewCell.RSSISignalStrengthBar.progress];
                
                [self updateSightingsCell:beaconDetailsTableViewCell withBeacon:beacon];
            }
        }
    }
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
    [self.beacons removeAllObjects];
    [self.beaconsTableView reloadData];
}

-(void) didReceiveNotification: (QLContentNotification *)notification
                      appState: (QLNotificationAppState)appState
{
    // do something with notification.
    // You can fetch detailed content information, using contentId. Refer to Section 7.2.4
}

-(void) handleLocalNotifications : (NSNotification *)notification{
    
    if([UIApplication sharedApplication].enabledRemoteNotificationTypes  == UIRemoteNotificationTypeAlert){
        NSLog(@"Inside test notification types");
    }
    else{
    UILocalNotification *notificationObject = [[notification userInfo] objectForKey:@"userInfo"];
    NSArray *notificationBodyParts = [notificationObject.alertBody componentsSeparatedByString:@"\n"];
    self.urlToOpen = [notificationBodyParts objectAtIndex:1];
    //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    //if (state == UIApplicationStateActive) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notificationObject.alertAction
                                                    message:[notificationBodyParts objectAtIndex:0]
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Goto Link", nil];
    [alert show];
    //}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Goto Link"])
    {
        WebViewController* objWebVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
        [objWebVC setUrlforWebView:[NSURL URLWithString:self.urlToOpen]];
        [self.navigationController pushViewController:objWebVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BeaconsCell";
    BeaconDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell != nil) {
        Beacon *beacon = [self.beacons objectAtIndex:indexPath.row];
        
        // Update the transmitter text
        cell.beaconName.text = beacon.name;
        
        // Update the transmitter avatar (icon image)
//        NSInteger avatarID = [UserSettingsRepository getAvatarIDForTransmitterID:transmitter.identifier];
        NSString *imageFilename = [NSString stringWithFormat:@"%@.jpg", beacon.name];
        UIImage *imageBeacon=[UIImage imageNamed:imageFilename];
        
        CGImageRef cgref = [imageBeacon CGImage];
        CIImage *cim = [imageBeacon CIImage];
        
        if (cim == nil && cgref == NULL)
        {
            cell.beaconImage.image = [UIImage imageNamed:@"avatar_01.png"];
        } else {
            cell.beaconImage.image = [UIImage imageNamed:imageFilename];
        }
//        if ([self isTransmitterAgedOut:transmitter]) {
//            [self grayOutSightingsCell:cell];
//        } else {
            [self updateSightingsCell:cell withBeacon:beacon];
//        }
    }
    return cell;
}

@end