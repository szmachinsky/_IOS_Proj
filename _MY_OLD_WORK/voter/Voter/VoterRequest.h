//
//  VoterRequest.h
//  Voter
//
//  Created by Khitryk Artsiom on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestsManager;
@protocol VoterRequestDelegate;


@interface VoterRequest : NSObject
{
@private
    
    id delegate_;
    SEL doneSelector_;
    SEL failSelector_;

    NSInteger errorCode_;
    
    NSString* requestKey_;
    RequestsManager* requestManager_;
    
    NSMutableData* receivedData_;
    NSURLConnection* urlConnection_;
    NSMutableURLRequest* urlRequest_;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, readwrite) SEL doneSelector;
@property (nonatomic, readwrite) SEL failSelector;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, copy) NSString* requestKey;
@property (nonatomic, assign) RequestsManager* requestManager;


- (id)initWithApiUrlString:(NSString*) apiUrlString withHTTPMethod:(NSString*)httpMethod;
- (void)startAsyncRequest;
- (void)setBodyData:(NSData*) bodyData;
- (void)cancelRequest;

@end

@protocol VoterRequestDelegate
@required

-(void) voterRequest:(VoterRequest*) request didFinishLoadingData:(NSData*) receivedData withErrorCode:(NSInteger)errorCode;
-(void) voterRequest:(VoterRequest*) request didFailWithError:(NSError*) error;

@end