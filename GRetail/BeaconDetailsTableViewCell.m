//
//  BeaconDetailsTableViewCell.m
//  GRetail
//
//  Created by Ram Awadhesh on 23/05/14.
//  Copyright (c) 2014 GSPANN Technologies. All rights reserved.
//

#import "BeaconDetailsTableViewCell.h"

@implementation BeaconDetailsTableViewCell

@synthesize beaconImage, beaconName, RSSIText, RSSISignalStrengthBar, RSSIValue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
