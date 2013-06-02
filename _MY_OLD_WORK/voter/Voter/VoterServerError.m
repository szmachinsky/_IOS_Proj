//
//  VoterServerError.m
//  Voter
//
//  Created by Khitryk Artsiom on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoterServerError.h"

@implementation VoterServerError
@synthesize errorCode = _errorCode;
@synthesize errorMessage = _errorMessage;

- (id)initWithErrorCode:(NSInteger) errorCode andErrorMessage:(NSString*) message
{
    self = [super init];
    if (self)
    {
        _errorCode = errorCode;
        _errorMessage = [message retain];
    }
    return self;
}

- (void)dealloc
{
    [_errorMessage release];
    [super dealloc];
}

@end
