//
//  FileDownloader.m
//  Test_1
//
//  Created by svp on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileDownloader.h"
#import "UserTool.h"

//****************************************** FileDownloader *******************************************************
@implementation FileDownloader {
@protected
    NSURLRequest *request_;
    NSURLConnection *connection_;
    NSMutableData *receivedData_;
    
}
@synthesize connection = connection_;
@synthesize receivedData = receivedData_;


- (id) initWithRequest:(NSURLRequest*)req 
{ 
    self = [super init]; 
    if (self) 
    { 
        self->request_ = [req copy]; 
        self->connection_ = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO]; 
        self->receivedData_ = [[NSMutableData alloc] init]; 
    } 
    return self; 
} 

- (id) initWithString:(NSString*)str 
{ 
    self = [super init]; 
    if (self) 
    { 
        NSURL* url = [NSURL URLWithString:str]; 
//      self->request_ = [[NSURLRequest requestWithURL:url] retain];         
        self->request_ = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];// retain];         
        self->connection_ = [[NSURLConnection alloc] initWithRequest:self->request_ delegate:self startImmediately:NO]; 
        self->receivedData_ = [[NSMutableData alloc] init]; 
    } 
    return self; 
} 


- (void) dealloc 
{ 
//    [request_ release]; 
//    [connection_ release]; 
//    [receivedData_ release];     
//    [super dealloc]; 
} 

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{ 
    [receivedData_ setLength:0]; 
    NSLog(@"  >>response: (%@) (%lld) (%@)", [response MIMEType], [response expectedContentLength], [response suggestedFilename] );   
} 

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{ 
    [receivedData_ appendData:data]; 
    NSLog(@"  >>added %d bytes", [data length]);   
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err 
{ 
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:kFileDownloadNote object:self 
                 userInfo:[NSDictionary dictionaryWithObject:err forKey:@"error"]]; 
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{ 
    [[NSNotificationCenter defaultCenter] postNotificationName:kFileDownloadNote object:self]; 
} 

@end

//****************************************** ImageDownloader *******************************************************
@implementation ImageDownloader
{
    UIImage *image_;
    int imSize_;
}
@synthesize imSize = imSize_;


- (UIImage*)image 
{ 
    if (image_) 
        return image_; 
    [self.connection start]; 
    return nil; // or a placeholder 
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)err 
{ 
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:kImageDownloadNote object:self 
                 userInfo:[NSDictionary dictionaryWithObject:err forKey:@"error"]]; 
    
//    [self->connection_ release]; //recreate connection for next attempt
    self->connection_ = [[NSURLConnection alloc] initWithRequest:self->request_ 
                                                       delegate:self startImmediately:NO];     
} 


- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{ 
    UIImage* im = [UIImage imageWithData:self->receivedData_]; 
    if (im) { 
        if (imSize_ > 0)
            im = [UserTool thumbnailFromImage:im forSize:imSize_ Radius:0]; //make thumbnail
//        self->image_ = [im retain];
        self->image_ = im;
//        [self->receivedData_ release]; 
        self->receivedData_ = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageDownloadNote object:self]; 
    }         
}        


- (void)dealloc
{
//    [image_ release];
//    [super dealloc];
}


@end


