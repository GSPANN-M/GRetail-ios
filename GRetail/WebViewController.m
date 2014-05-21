//
//  WebViewController.m
//  GRetail
//
//  Created by Ram Awadhesh on 20/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webViewForCommunicationURL;
@synthesize urlforWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.webViewForCommunicationURL = [[UIWebView alloc]init];
    self.webViewForCommunicationURL.delegate = self;
    NSLog(@"URL TO LOAD:%@", self.urlforWebView);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.urlforWebView];
    [self.webViewForCommunicationURL loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) webViewDidStartLoad:(UIWebView *)webView{
    
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"Error:%@",error.description);
}

@end
