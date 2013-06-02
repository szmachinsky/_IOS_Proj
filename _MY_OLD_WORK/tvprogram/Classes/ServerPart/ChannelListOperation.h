//
//  ChannelListOperation.h
//  TVProgram
//
//  Created by Irina on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelListOperation : NSOperation {
    BOOL        executing;
    BOOL        finished;
}

- (id)init;

@end
