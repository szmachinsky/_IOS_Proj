//
//  EntryCell.m
//  MyVisas
//
//  Created by Natalia Tsybulenko on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryCell.h"

@implementation EntryCell
@synthesize entryDateLabel, departureDateLabel, daysLabel, daysTextLabel, countryLabel;
@synthesize entryImage, departureImage, daysImage, line;

- (void)dealloc {
    self.entryDateLabel = nil;
    self.departureDateLabel = nil;
    self.daysLabel = nil;
    self.daysTextLabel = nil;
    self.countryLabel = nil;
    self.entryImage = nil;
    self.departureImage = nil;
    self.daysImage = nil;
    self.line = nil;
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
