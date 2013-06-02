//
//  DownloadOperation.h
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadChannelIconOperation : NSOperation {
    NSString * requestUrl;
    NSMutableData *responseData;
    NSURLConnection *connection;
    
    BOOL finishedWithError;
    BOOL toLOAD;
    
    NSString *chName;
    NSInteger chId;
    NSData *imData;  
    
    NSString *chIconName;
    NSURLConnection *connection_;
    NSMutableData *receivedData_;
}

@property (nonatomic, assign) BOOL toLOAD;

@property (readonly) NSString * requestUrl;

@property (readonly,retain) NSString *chName;
@property (readonly)  NSInteger chId;
@property (readonly,retain)  NSData *imData;

- (id)initWithString:(NSString *)str;


@end
