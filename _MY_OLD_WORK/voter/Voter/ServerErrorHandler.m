//
//  ServerErrorHandler.m
//  Voter
//
//  Created by Khitryk Artsiom on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerErrorHandler.h"

#define kParamsSectionKey @"result"
#define kErrorCodeKey @"statusCode"
#define kRsKey @"rs"

@implementation ServerErrorHandler

+(VoterServerError*) verifyServerResponseDictionary:(NSDictionary *)params;
{
    VoterServerError* serverError = nil;
    
    id errorCode = [params objectForKey:kErrorCodeKey];
    
    if ([errorCode isKindOfClass:[NSNumber class]])
    {
        if ([errorCode intValue] != 200)
        {
                    serverError = [[[VoterServerError alloc] initWithErrorCode:[errorCode integerValue] andErrorMessage:[params objectForKey:@"statusMsg"]] autorelease];
        }
    }
    return serverError;
}

@end
