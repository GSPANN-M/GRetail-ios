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
//@synthesize beaconsTableView;
@synthesize beacons;
//@synthesize consoleTxtView, clearButtonView;
//@synthesize lblNoBeacons;
//@synthesize activityIndicatorNoBeacons;
@synthesize webViewForCommunicationURL;
@synthesize activityIndicatorView;
@synthesize urlforWebView;

const CGFloat MAX_RSSI_NUMBER = -20;
const CGFloat MIN_RSSI_NUMBER = -70;
const CGFloat MAX_PROGRESSBAR_VALUE = 1;
const CGFloat EXTRAPOLATION_FACTOR = MAX_PROGRESSBAR_VALUE/(MAX_RSSI_NUMBER-MIN_RSSI_NUMBER);

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"GSPANN Retail";
    
    self.webViewForCommunicationURL.delegate = self;
    self.urlforWebView = [NSURL URLWithString:@"http://ec2-54-213-80-60.us-west-2.compute.amazonaws.com/gretail/theme-a/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.urlforWebView];
    [self.webViewForCommunicationURL loadRequest:urlRequest];
    
//    UIButton *clearTextViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [clearTextViewButton setTitle:@"Clear" forState:UIControlStateNormal];
//    [clearTextViewButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    clearTextViewButton.titleLabel.font = [UIFont fontWithName: @"Helvetica" size: 10];
//    clearTextViewButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    [clearTextViewButton setBackgroundColor:[UIColor whiteColor]];
//    clearTextViewButton.clipsToBounds = YES;
//    [clearTextViewButton.layer setCornerRadius:6.0f];
//    clearTextViewButton.frame = CGRectMake((self.clearButtonView.frame.size.width - 30), 3, 27, 14);
//    
//    [clearTextViewButton addTarget:self action:@selector(clearConsoleView:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.clearButtonView addSubview:clearTextViewButton];
    
//    [self initializeTransmitters];
    
    self.placeConnector = [[QLContextPlaceConnector alloc] init];
    self.placeConnector.delegate = self;
    
    self.contentConnector = [[QLContentConnector alloc] init];
    self.contentConnector.delegate = self;
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:[NSNumber numberWithInt:-70] forKey:FYXVisitOptionArrivalRSSIKey];
    [options setObject:[NSNumber numberWithInt:-75] forKey:FYXVisitOptionDepartureRSSIKey];
    [options setObject:[NSNumber numberWithInt:3] forKey:FYXVisitOptionDepartureIntervalInSecondsKey];
    [options setObject:[NSNumber numberWithInt:FYXSightingOptionSignalStrengthWindowNone] forKey:FYXSightingOptionSignalStrengthWindowKey];
    [self.visitManager startWithOptions:options];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(handleLocalNotifications:) name:@"handleLocalNotifications" object:Nil];
}

//-(void) clearConsoleView:(id) sender{
//    
//    [self.consoleTxtView setText:@""];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.beacons count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"BeaconsCell";
//    BeaconDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell != nil) {
//        Beacon *beacon = [self.beacons objectAtIndex:indexPath.row];
//        
//        // Update the transmitter text
//        cell.beaconName.text = beacon.name;
//        
//        NSString *imageFilename = [NSString stringWithFormat:@"%@.jpg", beacon.name];
//        UIImage *imageBeacon=[UIImage imageNamed:imageFilename];
//        
//        CGImageRef cgref = [imageBeacon CGImage];
//        CIImage *cim = [imageBeacon CIImage];
//        
//        if (cim == nil && cgref == NULL)
//        {
//            cell.beaconImage.image = [UIImage imageNamed:@"avatar_01.png"];
//        } else {
//            cell.beaconImage.image = [UIImage imageNamed:imageFilename];
//        }
//        [self updateSightingsCell:cell withBeacon:beacon];
//    }
//    return cell;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    return view;
//}

//#pragma mark - Transmitters manipulation
//
//- (void)initializeTransmitters {
//    // Re-create the transmitters container array
//    [self showNoTransmittersView];
//    @synchronized(self.beacons){
//        if (self.beacons == nil) {
//            self.beacons = [NSMutableArray new];
//        }
//        // Always reload the table (even if the transmitter list didn't change)
//        [self.beaconsTableView reloadData];
//    }
//}
//
//- (void)showNoTransmittersView {
//    
//    [self.lblNoBeacons setHidden:NO];
//    [self.activityIndicatorNoBeacons startAnimating];
//}
//
//- (void)hideNoBeaconsView {
//    
//    [self.lblNoBeacons setHidden:YES];
//    [self.activityIndicatorNoBeacons stopAnimating];
//}
//
//- (Beacon *)beaconForID:(NSString *)ID {
//    for (Beacon *beacon in self.beacons) {
//        if ([beacon.identifier isEqualToString:ID]) {
//            return beacon;
//        }
//    }
//    return nil;
//}
//
//- (void)addBeacon: (Beacon *)beacon{
//    @synchronized(self.beacons){
//        [self.beacons addObject:beacon];
//        if([self.beacons count] == 1){
//            [self hideNoBeaconsView];
//        }
//    }
//}
//
//- (BOOL)shouldUpdateBeaconCell:(FYXVisit *)visit withBeacon:(Beacon *)beacon RSSI:(NSNumber *)rssi{
//    if (![beacon.rssi isEqual:rssi] || ![beacon.batteryLevel isEqualToNumber:visit.transmitter.battery]
//        || ![beacon.temperature isEqualToNumber:visit.transmitter.temperature]){
//        return YES;
//    }
//    else {
//        return NO;
//    }
//}
//
//- (void)updateBeacon:(Beacon *)beacon withVisit:(FYXVisit *)visit RSSI:(NSNumber *)rssi {
//    beacon.previousRSSI = beacon.rssi;
//    beacon.rssi = rssi;
//    beacon.batteryLevel = visit.transmitter.battery;
//    beacon.temperature = visit.transmitter.temperature;
//}
//
//- (void)updateSightingsCell:(BeaconDetailsTableViewCell *)beaconDetailsTableViewCell withBeacon:(Beacon *)beacon {
//    
//    if (beaconDetailsTableViewCell && beacon) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            beaconDetailsTableViewCell.contentView.alpha = 1.0f;
//            beaconDetailsTableViewCell.RSSIValue.text = [NSString stringWithFormat:@"%@", beacon.rssi];
//            beaconDetailsTableViewCell.RSSISignalStrengthBar.progress = (([beacon.rssi floatValue]-(MAX_RSSI_NUMBER))*EXTRAPOLATION_FACTOR) + MAX_PROGRESSBAR_VALUE;
//        });
//    }
//}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
//    [self.consoleTxtView setText:[self.consoleTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@:Arrived at Gimbal Beacon - %@\n", [NSDate date], visit.transmitter.name]]];
//    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);
    
    QLQueryForAnyAttributes *queryForAnyAttributes = [[QLQueryForAnyAttributes alloc] init];
    [queryForAnyAttributes whereKey:visit.transmitter.name containsStringValue:visit.transmitter.name];
    
    [self.contentConnector contentsWithQuery:queryForAnyAttributes success:^(NSArray *contents) {
        QLContent *communicationContent = [contents firstObject];
        if (communicationContent) {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
            localNotification.alertAction = communicationContent.title;
            localNotification.alertBody = [NSString stringWithFormat:@"%@\n%@",communicationContent.contentDescription, communicationContent.contentUrl];
//            localNotification.alertBody = [NSString stringWithFormat:@"%@",communicationContent.contentDescription];
            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            NSDictionary *notificationDirectory = [NSDictionary dictionaryWithObject:@"Communication" forKey:@"NotificationType"];
            [localNotification setUserInfo:notificationDirectory];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
            
            // Request to reload table view data
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        }
    } failure:^(NSError *error) {
        // Failed to retrieve content
        NSLog(@"error is this:%@", error);
    }];
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    //NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
//    Beacon *beacon = [self beaconForID:visit.transmitter.identifier];
//    if (!beacon) {
//        NSString *beaconName = visit.transmitter.identifier;
//        if(visit.transmitter.name){
//            beaconName = visit.transmitter.name;
//        }
//        beacon = [Beacon new];
//        beacon.identifier = visit.transmitter.identifier;
//        beacon.name = beaconName;
//        beacon.lastSighted = [NSDate dateWithTimeIntervalSince1970:0];
//        beacon.rssi = [NSNumber numberWithInt:-100];
//        beacon.previousRSSI = beacon.rssi;
//        beacon.batteryLevel = 0;
//        beacon.temperature = 0;
//        [self addBeacon:beacon];
//        [self.beaconsTableView reloadData];
//        //        NSString *beaconImageURL = visit.transmitter.iconUrl;
//    }
//    beacon.lastSighted = updateTime;
//    if([self shouldUpdateBeaconCell:visit withBeacon:beacon RSSI:RSSI]){
//        [self updateBeacon:beacon withVisit:visit  RSSI:RSSI];
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.beacons indexOfObject:beacon] inSection:0];
//        for (UITableViewCell *cell in self.beaconsTableView.visibleCells) {
//            if ([[self.beaconsTableView indexPathForCell:cell] isEqual:indexPath]) {
//                BeaconDetailsTableViewCell *beaconDetailsTableViewCell = (BeaconDetailsTableViewCell *)cell;
//                [self updateSightingsCell:beaconDetailsTableViewCell withBeacon:beacon];
//            }
//        }
//    }
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
//    [self.consoleTxtView setText:[self.consoleTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@:Left Gimbal Beacon - %@\nBeacon was in proximity for %f seconds\n", [NSDate date], visit.transmitter.name, visit.dwellTime]]];
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
//    [self.beacons removeAllObjects];
//    [self.beaconsTableView reloadData];
//    if ([self.beacons count] == 0) {
//        [self showNoTransmittersView];
//    }
}

-(void) didReceiveNotification: (QLContentNotification *)notification
                      appState: (QLNotificationAppState)appState
{
    // do something with notification.
    // You can fetch detailed content information, using contentId. Refer to Section 7.2.4
}

-(void) handleLocalNotifications : (NSNotification *)notification{
    
    UILocalNotification *notificationObject = [[notification userInfo] objectForKey:@"userInfo"];
    if ([[notificationObject userInfo] objectForKey:@"NotificationType"]) {
        NSString *notificationType = [[notificationObject userInfo] objectForKey:@"NotificationType"];
        if ([notificationType isEqualToString:@"Communication"]) {
            NSArray *notificationBodyParts = [notificationObject.alertBody componentsSeparatedByString:@"\n"];
            self.urlToOpen = [notificationBodyParts objectAtIndex:1];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notificationObject.alertAction
                                                            message:[notificationBodyParts objectAtIndex:0]
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Goto Link", nil];
            [alert show];
        } else if ([notificationType isEqualToString:@"Geofence"]) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:notificationObject.alertAction message:notificationObject.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Goto Link"])
    {
//        WebViewController* objWebVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
//        [objWebVC setUrlforWebView:[NSURL URLWithString:self.urlToOpen]];
//        [self.navigationController pushViewController:objWebVC animated:YES];
        self.urlforWebView = [NSURL URLWithString:self.urlToOpen];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.urlforWebView];
        [self.webViewForCommunicationURL loadRequest:urlRequest];
    }
}

- (void)didGetPlaceEvent:(QLPlaceEvent *)placeEvent
{
    NSLog(@"did get place event %@", [placeEvent place].name);
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:1];
    if ([placeEvent eventType] == QLPlaceEventTypeAt) {
//        [self.consoleTxtView setText:[self.consoleTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@:Arrived at Place - %@\n", [NSDate date], [placeEvent place].name]]];
        localNotification.alertAction = [NSString stringWithFormat:@"Welcome to %@", [placeEvent place].name];
        localNotification.alertBody = @"Check out our latest collection and enjoy exclusive discounts";
    } else if ([placeEvent eventType] == QLPlaceEventTypeLeft){
//        [self.consoleTxtView setText:[self.consoleTxtView.text stringByAppendingString:[NSString stringWithFormat:@"%@:Left Place - %@\n", [NSDate date], [placeEvent place].name]]];
        localNotification.alertAction = @"Thanks!!";
        localNotification.alertBody = @"Thanks for visiting us today.";
    }
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSDictionary *notificationDirectory = [NSDictionary dictionaryWithObject:@"Geofence" forKey:@"NotificationType"];
    [localNotification setUserInfo:notificationDirectory];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    
    [self.activityIndicatorView startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.activityIndicatorView stopAnimating];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    //NSLog(@"Errorwa hai:%@",error.description);
}

@end