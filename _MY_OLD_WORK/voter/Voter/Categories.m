//
//  Categories.m
//  Voter
//
//  Created by Khitryk Artsiom on 27.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Categories.h"

@implementation Categories
@synthesize image = image_, nameOfCategory = nameOfCategory_, percent = percent_, idCategory = idCategory_;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    [nameOfCategory_ release];
    [image_ release];
    [percent_ release];
    [idCategory_ release];
    
    [super dealloc];
}

@end
