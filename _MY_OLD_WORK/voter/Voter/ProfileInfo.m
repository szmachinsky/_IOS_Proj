//
//  ProfileInfo.m
//  Voter
//
//  Created by Khitryk Artsiom on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileInfo.h"

@implementation ProfileInfo
@synthesize name = name_;
@synthesize idProfile = idProfile_;
@synthesize description = description_;
@synthesize site = site_;
@synthesize schedule = schedule_;
@synthesize address = address_;
@synthesize menu = menu_;
@synthesize printMenu = printMenu_;
@synthesize rating = rating_;
@synthesize phone = phone_;
@synthesize contentOfLink = contentOfLink_;

- (id)init
{
    self = [super init];
    if (self)
    {
        contentOfLink_ = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [description_ release];
    [name_ release];
    [schedule_ release];
    [idProfile_ release];
    [site_ release];
    [address_ release];
    [menu_ release];
    [printMenu_ release];
    [rating_ release];
    [phone_ release];
    [contentOfLink_ release];
    
    [super dealloc];
}

@end
