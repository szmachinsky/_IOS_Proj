//
//  RequestsManager.h
//  Voter
//
//  Created by Khitryk Artsiom on 20.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoterRequest.h"
#import "NSDictionary+URLParams.h"

typedef void(^RequestManagerDoneBlock)(NSData *data);

@interface RequestsManager : NSObject <VoterRequestDelegate>
{
@private
    
    NSMutableDictionary* requests_;
    NSOperationQueue* operationQueue_;
    dispatch_queue_t asyncJSONQueue_;
}

@property (nonatomic, copy) NSString* apiUrlString;

+ (RequestsManager*)sharedInstance;


//- (void)retrieveDataAtURL:(NSURL *)URL doneBlock:(RequestManagerDoneBlock)doneBlock;// for image


//USER
- (void)registerUserWithParams:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)getUserProfile:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)signIn:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)forgotPassword:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)editUser:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)reportUser:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

//BUSINESS
- (void)getBusiness:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)getBusinesses:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector;
- (void)search:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

//CATEGORIES
- (void)getCategories:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

//SUBCATEGORIES
- (void)getSubcategories:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

//REVIEW
- (void)getReviews:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)reportReview:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)writeReview:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

//SHARE OPTIONS
- (void)getShareOptions:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;
- (void)setShareOptions:(NSMutableDictionary*) params andDelegate:(id) delegate doneSelector:(SEL) doneSelector failSelector:(SEL) failSelector;

@end
