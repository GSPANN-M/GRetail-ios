//
//  WebViewController.h
//  GRetail
//
//  Created by Ram Awadhesh on 20/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewForCommunicationURL;
@property (retain, nonatomic) NSURL *urlforWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@end
