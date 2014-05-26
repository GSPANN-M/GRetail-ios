//
//  BeaconDetailsTableViewCell.h
//  GRetail
//
//  Created by Ram Awadhesh on 23/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *beaconImage;
@property (weak, nonatomic) IBOutlet UILabel *beaconName;
@property (weak, nonatomic) IBOutlet UILabel *RSSIText;
@property (retain, nonatomic) IBOutlet UIProgressView *RSSISignalStrengthBar;
@property (weak, nonatomic) IBOutlet UILabel *RSSIValue;
@end
