//
//  ServerErrorHandler.h
//  Voter
//
//  Created by Khitryk Artsiom on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoterServerError.h"

@interface ServerErrorHandler : NSObject

+ (VoterServerError*)verifyServerResponseDictionary:(NSDictionary *)params;

@end
