//
//  NewLabelCell.m
//  VoterTest
//
//  Created by User on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewLabelTextCell.h"

@implementation NewLabelTextCell
@synthesize cellText = cellText_, cellLabel = cellLabel_;

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
    [cellText_ release];
    [super dealloc];
}

- (void)setFields:(NSString *)labelStr editString:(NSString *)editStr Delegate:(id)delegate Tag:(int)tag Pos:(int)position 
{
    cellLabel_.text = labelStr;
    cellText_.text = editStr;
    [cellText_ setDelegate:delegate];  
    cellText_.tag = tag;
    
    float h=self.contentView.frame.size.width - 25;
    
    CGRect frame = cellLabel_.frame;    
    frame.size.width = position - 12;
    cellLabel_.frame = frame;
    
    frame = cellText_.frame;
    frame.origin.x = position;
    frame.size.width = h - position - 12;
    cellText_.frame = frame;
    
}


@end
