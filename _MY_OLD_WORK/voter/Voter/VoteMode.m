//
//  VoteMode.m
//  Voter
//
//  Created by Khitryk Artsiom on 29.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoteMode.h"

@implementation VoteMode
@synthesize image = image_, idVoteMode = idVoteMode_, nameOfVote = nameOfVote_;

- (id)init
{
    self = [super init];
    if (self)
    {
        nameOfVote_ = @"";
        idVoteMode_ = @"";
        image_ = @"";
    }
    return self;
}

- (void)dealloc
{
    [image_ release];
    [idVoteMode_ release];
    [nameOfVote_ release];
    
    [super dealloc];
}

@end
