//
//  DownloadOperation.m
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadOperation.h"
#import "BZFile.h"
#import "TVDataSingelton.h"

@implementation DownloadOperation
@synthesize requestString;

static NSInteger numOfAttempts = 0;

- (id)initWithString:(NSString *)str
{
    //TODO set correct request
    if (![super init]) return nil;
    self = [super init];
    requestString = [str copy];
    return self;
}

-(void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    NSURL* url = [[NSURL alloc] initWithString:requestString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]; // ivar
    // Here is the trick
    
    NSPort *port = [NSPort port];
    NSRunLoop* rl = [NSRunLoop currentRunLoop]; // Get the runloop
    [rl addPort:port forMode:NSDefaultRunLoopMode];
    [connection scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
    [connection start];
    [rl runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response 
{
    //NSLog(@"didReceiveResponse");
    responseData = [[NSMutableData alloc] init];
    [responseData setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    //NSLog(@"didReceiveData");
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    _NSLog(@"downloading index.json didFailWithError %@", error);
    if (numOfAttempts < 3) {
        [self start];
        numOfAttempts++;
    }
    else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Проблема с соединением." message:@"Возникли проблемы с поключением к серверу или интернет соединением. Попробуйте повторить попытку обновить данные позже." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
        numOfAttempts = 0;
        [TVDataSingelton sharedTVDataInstance].currentState = eIndexDownloadError;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection 
{
    //NSLog(@"connectionDidFinishLoading");
    [connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	connection = nil;

    NSString *docDir = [SZUtils pathDocDirectory];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/index.json.bz2", docDir];
    [responseData writeToFile:filePath atomically:YES];
    
 _NSLog(@">got file:(%@)",filePath);  //zs  
    BZFile *bzFile = [[BZFile alloc] initWithFileName:[docDir stringByAppendingPathComponent:@"index.json.bz2"]];
    [bzFile bzOpen];
    [bzFile decompressFile:[docDir stringByAppendingPathComponent:@"index.json"]];
 _NSLog(@">decompress to index.json");  //zs  
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    [TVDataSingelton sharedTVDataInstance].currentState = eIndexDownload;
    
    numOfAttempts = 0;
}


@end
