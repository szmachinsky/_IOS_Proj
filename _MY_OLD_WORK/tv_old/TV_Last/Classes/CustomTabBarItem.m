//
//  CustomTabBarItem.m
//  TVProgram
//
//  Created by Irisha on 13.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarItem.h"


@implementation CustomTabBarItem

@synthesize customHighlightedImage;

-(id) init
{
    self = [super init];
    return self;
}


-(UIImage *)selectedImage {
    return self.customHighlightedImage;
}

@end
