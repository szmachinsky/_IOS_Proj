//
//  NewLabelButtonCell.m
//  VoterTest
//
//  Created by User on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLabelButtonCell.h"

@implementation NewLabelButtonCell
@synthesize cellLabel = cellLabel_, cellButton = cellButton_,cellImage = cellImage_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        cellButton_.layer.cornerRadius = 8;
//        cellButton_.layer.backgroundColor = [[UIColor redColor] CGColor];
//        cellButton_.layer.co
        
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
    [cellButton_ release];
    [cellImage_ release];
    [super dealloc];
}
@end
