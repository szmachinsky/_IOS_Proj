//
//  NewLabelImageCell.m
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLabelImageCell.h"

@implementation NewLabelImageCell
@synthesize cellLabel = cellLabel_, cellImage = cellImage_;


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

- (void)dealloc {
    [cellLabel_ release];
    [cellImage_ release];
    [super dealloc];
}
@end
