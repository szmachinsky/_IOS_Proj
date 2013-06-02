//
//  UICustomReviewsCell.m
//  Voter
//
//  Created by Khitryk Artsiom on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UICustomReviewsCell.h"

@implementation UICustomReviewsCell
@synthesize imageView = imageView_, nameButton = nameButton_, descriptionLabel = descriptionLabel_, nameLabel = nameLabel_, dateLabel = dateLabel_, repotrButton = reportButon_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)dealloc
{
    [imageView_ release];
    [descriptionLabel_ release];
    [nameButton_ release];
    [nameLabel_ release];
    [dateLabel_ release];
    [reportButon_ release];
    
    [super dealloc];
}
@end
