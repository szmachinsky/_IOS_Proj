//
//  RequestsManager.m
//  Voter
//
//  Created by Khitryk Artsiom on 20.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "RequestsManager.h"
#import "SBJson.h"
#import "VoterServerError.h"
#import "ServerErrorHandler.h"

static RequestsManager* instance = nil;

#define kUserApiUrlString @"http://192.168.12.110/api/user.json?"
#define kBusinessApiUrlString @"http://192.168.12.110/api/business.json?"
#define kCategoriesApiUrlString @"http://192.168.12.110/api/categories.json?"
#define kSubcatgoriesApiUrlString @"http://192.168.12.110/api/subcategories.json?"
#define kReviewApiUrlString @"http://192.168.12.110/api/review.json?"
#define kShareOptionsApiUrlString @"http://192.168.12.110/api/shareoptions.json?"

#define MaxConcurrentOpreationCount 2

//USER
#define kRegisterUserMethod @"registerUser"
#define kGetUserProfileMethod @"getUserProfile"
#define kSignInMethod @"singIn"
#define kForgotPasswordMethod @"forgotPassword"
#define kEditUserMethod @"editUser"
#define kReportUserMethod @"reportUser"
//BUSINESS
#define kGetBusinessMethod @"getBusiness"
#define kGetBusinessesMethod @"getBusinesses"
#define kSearchMethod @"search"
//CATEGORIES
#define kGetCategoriesMethod @"getCategories"
//SUBCATEGORIES
#define kGetSubCategoriesMethod @"subCategories"
//REVIEW
#define kGetReviewsmethod @"getReviews"
#define kReportReviewMethod @"reportReview"
#define kWriteReviewMethod @"writeReview"
//SHAREOPTIONS
#define kGetShareOptionsMethod @"getShareOptions"
#define kSetShareOptionsMethod @"setShareOptions"

#define kProtocolVersion @"2.0"
#define kJsonRpcKey @"jsonrpc"
#define kMethodKey @"method"
#define kParamsKey @"params"
#define kIdKey @"id"

#define kPOST @"POST"
#define kGET @"GET"
#define kDELETE @"DELETE"
#define kPUT @"PUT"

@interface RequestsManager()

- (void)_addRequest:(VoterRequest*) request toRequestsDictionaryWithKey:(NSString*) key;
- (VoterRequest*)_voterRequestToController:(NSString*)controllerName
                                withMethodName:(NSString*) methodName
                                params:(NSMutableDictionary*) params
                              delegate:(id) delegate
                          doneSelector:(SEL) doneSelector
                          failSelector:(SEL) failSelector
                             andHTTPMethod:(NSString*) httpMethod;
- (NSData*)_bodyDataWithParams:(NSDictionary*) params andMethodName:(NSString*) methodName;

@end

@implementation RequestsManager
@synthesize apiUrlString = _apiUrlString;

#pragma mark - Singletone pattern
+ (RequestsManager*)sharedInstance
{
    if (!instance)
    {
        @synchronized(self)
        {
            instance = [[RequestsManager alloc] init];
        }
    }
    return instance;
}

#pragma mark - Initialization methods
- (id)init
{
    self = [super init];
    
    if (self)
    {
        operationQueue_ = [[NSOperationQueue alloc] init];
        [operationQueue_ setMaxConcurrentOperationCount:MaxConcurrentOpreationCount];
        
        requests_ = [[NSMutableDictionary alloc] init];
        asyncJSONQueue_ = dispatch_queue_create("com.Voter.requestmanager.JSONProcessingQueue", 0);
    }
    
    return self;
}

#pragma mark - Memory management methods
- (void)dealloc
{
    dispatch_sync(asyncJSONQueue_, ^
    {
#ifdef DEBUG
        NSLog(@"Stopping Async Queue..."); 
#endif
    });
    dispatch_release(asyncJSONQueue_);
    asyncJSONQueue_ = NULL;
    [requests_ release];
    [_apiUrlString release];
    [super dealloc];
}

#pragma mark - API methods -
#pragma mark USER API

- (void)registerUserWithParams:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kUserApiUrlString withMethodName:kRegisterUserMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kPOST];
    [request startAsyncRequest];
}

- (void)getUserProfile:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kUserApiUrlString withMethodName:kGetUserProfileMethod params:params delegate:delegate doneSelector:doneSelector failSelector:doneSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)signIn:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kUserApiUrlString withMethodName:kSignInMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)forgotPassword:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kUserApiUrlString withMethodName:kForgotPasswordMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)editUser:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    NSString* apiString;
    
    apiString = [NSString stringWithFormat:@"%@token=%@",kUserApiUrlString,[params objectForKey:@"token"]];
    
    VoterRequest* request = [self _voterRequestToController:apiString withMethodName:kEditUserMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kPUT];
    [request startAsyncRequest];
}

- (void)reportUser:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    NSString* apiString;
    
    apiString = [NSString stringWithFormat:@"%@token=%@",kUserApiUrlString,[params objectForKey:@"token"]];
    
    VoterRequest* request = [self _voterRequestToController:apiString withMethodName:kReportUserMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kDELETE];
    [request startAsyncRequest];
}

#pragma mark - BUSINESS API

- (void)getBusiness:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kBusinessApiUrlString withMethodName:kGetBusinessMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)getBusinesses:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kBusinessApiUrlString withMethodName:kGetBusinessesMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)search:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kBusinessApiUrlString withMethodName:kSearchMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kPOST];
    [request startAsyncRequest];
}

#pragma mark - CATEGORIES API

- (void)getCategories:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    
    VoterRequest* request = [self _voterRequestToController:kCategoriesApiUrlString withMethodName:kGetCategoriesMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

#pragma mark - SUBCATEGORIES API

- (void)getSubcategories:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kSubcatgoriesApiUrlString withMethodName:kGetSubCategoriesMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

#pragma mark - REVIEWS API

- (void)getReviews:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kReviewApiUrlString withMethodName:kGetReviewsmethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)reportReview:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector 
{
    VoterRequest* request = [self _voterRequestToController:kReviewApiUrlString withMethodName:kReportReviewMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)writeReview:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector 
{
    NSString* apiString;
    
    apiString = [NSString stringWithFormat:@"%@token=%@",kReviewApiUrlString,[params objectForKey:@"token"]];
    
    VoterRequest* request = [self _voterRequestToController:apiString withMethodName:kWriteReviewMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kPOST];
    [request startAsyncRequest];
}

#pragma mark - SHARE OPTIONS API

- (void)getShareOptions:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    VoterRequest* request = [self _voterRequestToController:kShareOptionsApiUrlString withMethodName:kGetShareOptionsMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kGET];
    [request startAsyncRequest];
}

- (void)setShareOptions:(NSMutableDictionary *)params andDelegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector
{
    NSString* apiString;
    
    apiString = [NSString stringWithFormat:@"%@token=%@",kUserApiUrlString,[params objectForKey:@"token"]];
    
    VoterRequest* request = [self _voterRequestToController:apiString withMethodName:kSetShareOptionsMethod params:params delegate:delegate doneSelector:doneSelector failSelector:failSelector andHTTPMethod:kPOST];
    [request startAsyncRequest];
}

- (void)_addRequest:(VoterRequest*) request toRequestsDictionaryWithKey:(NSString*) key
{
    VoterRequest* activeRequest = [requests_ objectForKey:key];
    if (activeRequest)
    {
        [activeRequest cancelRequest];
        [requests_ removeObjectForKey:key];
    }
    
    @synchronized(requests_)
    {
        [requests_ setObject:request forKey:key];
    }
}


 -(VoterRequest*)_voterRequestToController:(NSString *)controllerName withMethodName:(NSString *)methodName params:(NSMutableDictionary *)params delegate:(id)delegate doneSelector:(SEL)doneSelector failSelector:(SEL)failSelector andHTTPMethod:(NSString *)httpMethod
{

    NSInteger isNilParams = [[params allKeys]count];
    
    if ([httpMethod isEqual:kGET])
    {
        if (isNilParams != 0)
        {
            controllerName = [NSString stringWithFormat:@"%@%@",controllerName,[params stringWithGetParams]];
        }
    }
    
    VoterRequest* request = [[VoterRequest alloc]initWithApiUrlString:controllerName withHTTPMethod:httpMethod];
    request.requestKey = methodName;
    request.requestManager = self;
    request.delegate = delegate;
    request.doneSelector = doneSelector;
    request.failSelector = failSelector;
    
    //
    if ([httpMethod isEqual:kPOST] || [httpMethod isEqual:kPUT] || [httpMethod isEqual:kDELETE])
    {
        if (([params objectForKey:@"token"] != nil || [[params objectForKey:@"token"]isEqual:@""]))
        {
            [params removeObjectForKey:@"token"]; 
        }

    }
    
    [self _addRequest:request toRequestsDictionaryWithKey:request.requestKey];
    
    
    if ([httpMethod isEqual:kPOST] || [httpMethod isEqual:kPUT] || [httpMethod isEqual:kDELETE])
    {
        NSData* bodyData = [self _bodyDataWithParams:params andMethodName:methodName];
        [request setBodyData:bodyData];
    }

    
    return [request autorelease];
    
}

- (NSData*)_bodyDataWithParams:(NSDictionary*) params andMethodName:(NSString*) methodName;
{
    NSString* paramsString;
    
    if (params != nil)
    {
        paramsString = [params stringWithGetParams];
    }
    
    NSData* bodyData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    return bodyData;
}

#pragma mark - EICRequestDelegate methods
- (void)voterRequest:(VoterRequest *)request didFailWithError:(NSError *)error
{
    id senderOfRequest = request.delegate;
    SEL failSelector = request.failSelector;
    
    @synchronized(requests_)
    {
        NSString* requestKey = request.requestKey;
        [requests_ removeObjectForKey:requestKey];
    }
    
    if ([senderOfRequest respondsToSelector:failSelector]) {
        [senderOfRequest performSelector:failSelector withObject:error];
    }
}

- (void)voterRequest:(VoterRequest *)request didFinishLoadingData:(NSData *)receivedData withErrorCode:(NSInteger)errorCode
{
    id senderOfRequest = request.delegate;
    SEL doneSelector = request.doneSelector;
    NSInteger error = errorCode;
    dispatch_async(asyncJSONQueue_, ^{
        SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
        NSDictionary* receivedDictionary = (NSDictionary*) [jsonParser objectWithData:receivedData];
#if DEBUG
        NSLog(@"%@",receivedDictionary);
#endif
        
        id result;
        if (error == 200)
        {
            result = receivedDictionary;
            if ([senderOfRequest respondsToSelector:doneSelector])
            {
                [senderOfRequest performSelectorOnMainThread:doneSelector withObject:result waitUntilDone:NO];
            } 
        }
        else
        {
            VoterServerError* voterServerError = [ServerErrorHandler verifyServerResponseDictionary:receivedDictionary];
            if (voterServerError == nil)
                result = receivedDictionary;
            else
                result = voterServerError;
            
            if ([senderOfRequest respondsToSelector:doneSelector])
            {
                [senderOfRequest performSelectorOnMainThread:doneSelector withObject:result waitUntilDone:NO];
            }   
        }
     
        [jsonParser release];      
        
    });
    
    @synchronized(requests_)
    {
        NSString* requestKey = request.requestKey;
        [requests_ removeObjectForKey:requestKey];
    }    
}
@end
