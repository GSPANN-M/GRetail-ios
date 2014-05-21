//
//  ViewController.m
//  GRetail
//
//  Created by Ram Awadhesh on 13/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"

@interface HomeViewController ()

@property (nonatomic) FYXVisitManager *visitManager;

@end

@implementation HomeViewController

@synthesize urlToOpen;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.contentConnector = [[QLContentConnector alloc] init];
    self.contentConnector.delegate = self;
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(handleLocalNotifications:) name:@"handleLocalNotifications" object:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
                localNotification.alertAction = communicationContent.title;
                localNotification.alertBody = [NSString stringWithFormat:@"%@\n%@",communicationContent.contentDescription, communicationContent.contentUrl];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                
                // Request to reload table view data
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
            }
        }
    } failure:^(NSError *error) {
        // Failed to retrieve content
        NSLog(@"error is this:%@", error);
    }];
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    NSLog(@"I received a sighting!!! %@", visit.transmitter.name);
}

- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
}

-(void) didReceiveNotification: (QLContentNotification *)notification
                      appState: (QLNotificationAppState)appState
{
    // do something with notification.
    // You can fetch detailed content information, using contentId. Refer to Section 7.2.4
}

-(void) handleLocalNotifications : (NSNotification *)notification{
    
    
    
    UILocalNotification *notificationObject = [[notification userInfo] objectForKey:@"userInfo"];
    NSArray *notificationBodyParts = [notificationObject.alertBody componentsSeparatedByString:@"\n"];
    NSLog(@"notification parts:%@", notificationBodyParts);
    self.urlToOpen = [notificationBodyParts objectAtIndex:1];
    NSLog(@"URL TO open:%@", self.urlToOpen);
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    //if (state == UIApplicationStateActive) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notificationObject.alertAction
                                                    message:notificationObject.alertBody
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Goto Link", nil];
    [alert show];
    //}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Inside alert callback");
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Goto Link"])
    {
        NSLog(@"Inside alert callback:%@",self.urlToOpen);
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlToOpen]];
        WebViewController* objWebVC = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
        [objWebVC setUrlforWebView:[NSURL URLWithString:self.urlToOpen]];
        
        //objWebVC.urlforWebView=[NSURL URLWithString:self.urlToOpen];
        NSLog(@"Inside alert callback 2:%@",[objWebVC urlforWebView]);
        [self.navigationController pushViewController:objWebVC animated:YES];
    }
}

@end