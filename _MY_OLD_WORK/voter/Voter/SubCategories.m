//
//  SubCategories.m
//  Voter
//
//  Created by Khitryk Artsiom on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubCategories.h"

@implementation SubCategories
@synthesize isCheck = isCheck_, image = image_, nameOfsubCategory = nameOfSubCategory_, idSubCategory = idSubCategory_, tag = tag_;

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
    [nameOfSubCategory_ release];
    [image_ release];
    [idSubCategory_ release];
    
    [super dealloc];
}
@end
