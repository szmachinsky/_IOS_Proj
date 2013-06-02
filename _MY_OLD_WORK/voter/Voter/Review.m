//
//  Review.m
//  Voter
//
//  Created by Khitryk Artsiom on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Review.h"

@implementation Review
@synthesize userName = userName_, review = review_, photo = photo_, mark = mark_, idUser = idUser_;

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
    [userName_ release];
    [review_ release];
    [photo_ release];
    [mark_ release];
    [idUser_ release];
    
    [super dealloc];
}
@end
