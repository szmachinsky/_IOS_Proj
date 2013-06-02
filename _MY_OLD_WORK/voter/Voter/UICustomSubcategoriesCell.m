//
//  UICustomSubcategoriesCell.m
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UICustomSubcategoriesCell.h"

@implementation UICustomSubcategoriesCell
@synthesize subCategoryLabel = subCategoryLabel_;
@synthesize imageView = imageView_;
@synthesize checkButton = checkButton_;


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

-(void) dealloc
{
    [subCategoryLabel_ release];
    [imageView_ release];
    [checkButton_ release];
    
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
