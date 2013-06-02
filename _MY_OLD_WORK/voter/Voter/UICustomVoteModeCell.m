//
//  UICustomVoteModeCell.m
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UICustomVoteModeCell.h"

@implementation UICustomVoteModeCell
@synthesize imageView = imageView_;
@synthesize voteButton = voteButton_;
@synthesize nominationLabel = nominationLabel_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) dealloc
{
    [imageView_ release];
    [voteButton_ release];
    [nominationLabel_ release];
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
