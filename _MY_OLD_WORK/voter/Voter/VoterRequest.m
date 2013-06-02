//
//  VoterRequest.m
//  Voter
//
//  Created by Khitryk Artsiom on 17.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kTimeoutInterval 15
#define kContentLengthKey @"Content-Length"
#define kContentTypeKey @"Content-Type"
#define kContentType @"application/json"

#import "VoterRequest.h"
#import "RequestsManager.h"

@implementation VoterRequest
@synthesize delegate = delegate_;
@synthesize doneSelector = doneSelector_, failSelector = failSelector_;
@synthesize requestKey = requestKey_;
@synthesize requestManager = requestManager_;
@synthesize errorCode = errorCode_;

- (id)initWithApiUrlString:(NSString *)apiUrlString withHTTPMethod:(NSString *)httpMethod
{
    self = [super init];
    
    if (self)
    {
        receivedData_ = [[NSMutableData alloc] init];
        urlRequest_ = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: apiUrlString]
                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData
                                               timeoutInterval:kTimeoutInterval];
        [urlRequest_ setHTTPMethod:httpMethod];
    }
    
    return self;
}

#pragma mark - Action methods

- (void)startAsyncRequest
{
    urlConnection_ = [[NSURLConnection alloc] initWithRequest:urlRequest_
                                                     delegate:self
                                             startImmediately:YES]; 
}

- (void)setBodyData:(NSData *)bodyData
{
    NSString* lengthOfContentString = [[NSNumber numberWithInt:bodyData.length] stringValue];
    
    [urlRequest_ setValue:lengthOfContentString forHTTPHeaderField:kContentLengthKey];
    [urlRequest_ setValue:kContentType forHTTPHeaderField:kContentTypeKey];
    [urlRequest_ setHTTPBody:bodyData];// для POST
}

- (void)cancelRequest
{
    [urlConnection_ cancel];
}

#pragma mark dealloc

- (void)dealloc
{
    [receivedData_ release];
    [urlRequest_ release];
    [urlConnection_ release];
    [requestKey_ release];
    [delegate_ release];
    
    [super dealloc];
}

#pragma mark - NSURLConnection delegate methods

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    self.errorCode = [httpResponse statusCode];
    
    NSLog(@"%d", [httpResponse statusCode]);
    /*
    NSLog(@"%@",[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    
	if ([response respondsToSelector:@selector(allHeaderFields)])
    {
		NSDictionary *dictionary = [httpResponse allHeaderFields];
		NSLog(@"%@", dictionary.description);
	}
    */
    if (receivedData_)
        [receivedData_ setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData_ appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData* receivedData = [NSData dataWithData:receivedData_];
    if (self.requestManager)
        [self.requestManager voterRequest:self didFinishLoadingData:receivedData withErrorCode:self.errorCode];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"Request did fail with error: %@",error);
#endif
    if (self.requestManager)
        [self.requestManager voterRequest:self didFailWithError:error];
}

@end
