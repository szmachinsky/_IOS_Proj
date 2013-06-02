//
//  VoterServerError.h
//  Voter
//
//  Created by Khitryk Artsiom on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define ObjectIsVoterServerError(o) ([o isMemberOfClass:[VoterServerError class]])

#import <Foundation/Foundation.h>

@interface VoterServerError : NSObject
{
@private
    
    NSInteger _errorCode;
    NSString* _errorMessage;
}

@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, readonly) NSString* errorMessage;

- (id)initWithErrorCode:(NSInteger) errorCode andErrorMessage:(NSString*) message;

@end
