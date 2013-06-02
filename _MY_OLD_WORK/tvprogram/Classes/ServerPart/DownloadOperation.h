//
//  DownloadOperation.h
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadOperation : NSOperation {
    NSString * requestString;
    NSMutableData *responseData;
    NSURLConnection *connection;
    BOOL        executing;
    BOOL        finished;
}

- (id)initWithString:(NSString *)str;

@property (readonly) NSString * requestString;
@end
