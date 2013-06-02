//
//  DownloadOperation.h
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadChannelDataOperation : NSOperation {
    NSString * requestUrl;
    NSMutableData *responseData;
    NSURLConnection *connection;
    
    BOOL finishedWithError;
    BOOL toLOAD;
    
    NSString *chName;
    NSInteger chId;
    NSString *chDay;
    NSArray *resData;
}

@property (nonatomic, assign) BOOL toLOAD;

@property (readonly,retain) NSString *chName;
@property (readonly,retain) NSString *chDay;
@property (readonly)  NSInteger chId;
@property (readonly,retain)  NSArray *resData;



- (id)initWithString:(NSString *)str;

@property (readonly) NSString * requestUrl;
@end
