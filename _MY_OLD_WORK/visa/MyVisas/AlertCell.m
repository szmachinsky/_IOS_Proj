//
//  AlertCell.m
//  MyVisas
//
//  Created by Nnn on 21.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell
@synthesize titleLabel, settingsLabel, repeatsLabel, descriptionLabel;

- (void)dealloc {
    self.titleLabel = nil;
    self.settingsLabel = nil;
    self.repeatsLabel = nil;
    self.descriptionLabel = nil;
    [super dealloc];
}

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
