//
//  ShowDescriptionWithNameCell.m
//  TVProgram
//
//  Created by Admin on 18.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowDescriptionWithNameCell.h"

@implementation ShowDescriptionWithNameCell
@synthesize channelImage;
@synthesize descriptionText;
@synthesize timeLabel;
@synthesize channelNameLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
