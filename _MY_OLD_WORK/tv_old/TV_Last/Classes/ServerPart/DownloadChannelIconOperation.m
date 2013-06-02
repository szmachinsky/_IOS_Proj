//
//  DownloadOperation.m
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadChannelIconOperation.h"
#import "TVDataSingelton.h"
#import "Channel.h"
#import "TVProgramAppDelegate.h"

//static NSInteger scLoadImages = 0;

@interface DownloadChannelIconOperation ()
- (void)dataLoaded:(NSData*)data;

@end

@implementation DownloadChannelIconOperation
@synthesize requestUrl;
@synthesize imData,chId,chName;
@synthesize toLOAD;

- (id)initWithString:(NSString *)str
{
    //TODO set correct request
    self = [super init];
    requestUrl = [str copy];
    toLOAD = NO;
    return self;
}


//-------------------------------------------------------------------------------------


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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{ 
    if ([(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate shouldHandleError:error.code]) {    // no internet connection
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
        
        // stop all operations in queue
        NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
        [currQueue setSuspended:YES];
        finishedWithError = YES;
        [TVDataSingelton sharedTVDataInstance].currentState = eChannelsDownloadError;

    } 
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{ 
    imData = [NSData dataWithData:receivedData_];
    [self dataLoaded:imData];    
} 



-(void)asyncLoad
{
    chIconName = [requestUrl lastPathComponent];
    self->receivedData_ = [[NSMutableData alloc] init]; 
    NSMutableURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];// retain];         
//    self->connection_ = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES]; 
    self->connection_ = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connection_ start];
}

//-------------------------------------------------------------------------------------

- (void)dataLoaded:(NSData*)data
{
    UIImage *image = [[UIImage alloc] initWithData:data];        
    if (image != nil) 
    {
        ///------zs-------        
        chName = [chIconName substringToIndex:[chIconName rangeOfString:@"."].location];
        chId = [chName integerValue];   
        //          _NSLog(@">update Image chan(%@) id=%d  (%@)",chName,chId,chIconName); 
        //            if ((++scLoadImages % 10) == 1)                 
        //                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CDMNewImage" object:self]]; 
        //------
    }
}

- (void)main {
    
    if ([SZAppInfo shared].stopLoading) {
//        _NSLog1(@"!-stop loading image");
        return;
    }
    
//    [self asyncLoad];
//    return;
    
    //channel icon file download
    chIconName = [requestUrl lastPathComponent];
    //NSLog(@"%@", chIconName);
///del    NSString *docDir = [SZUtils papathTmpDirectorythDocDir];
       
///del    NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@", docDir, chIconName];
    
//zs    if (![[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath]) 
//    {
        //download logo and save it
        // Get an image from the URL below
        NSError *error = nil;
   
//    NSMutableURLRequest *req1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];      
//    NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];  
//    NSMutableURLRequest *req3 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] 
//                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad 
//                                                   timeoutInterval:30];      

//    imData = [NSURLConnection sendSynchronousRequest:req1 returningResponse:nil error:&error];
    
//  imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl]]; 
    imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingUncached error:&error];
//  imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingMappedIfSafe error:&error];
    
    if (imData == nil || error != nil) {
        if ([(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate shouldHandleError:error.code]) {    // no internet connection
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
            
            // stop all operations in queue
            NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
            [currQueue setSuspended:YES];
            finishedWithError = YES;
            [TVDataSingelton sharedTVDataInstance].currentState = eChannelsDownloadError;
        }
        return;
    }
    [self dataLoaded:imData];
    return;
        
//    imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl]];     
//    imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingUncached error:&error];
//    imData = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingMappedIfSafe error:&error];
    
    UIImage *image = [[UIImage alloc] initWithData:imData];        
////    _NSLog(@"Saving PNG: %@ size: %f,%f",requestUrl, image.size.width,image.size.height);
///     _NSLog(@">>>>>Download Image (%@)->(%@)", requestUrl,jpegFilePath); ///
//        _NSLog(@">>>>>Download Image (%@)->(%@)", requestUrl,chIconName); ///

        if (image != nil && error == nil) {
/////del            NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
/////del zs!!!      [data2 writeToFile:jpegFilePath atomically:YES];
            
//            NSString *docDir = [SZUtils pathDocDirectory];
/*            NSString *docDir = [SZUtils pathTmpDir];
            NSString *jpegFilePath1 = [NSString stringWithFormat:@"%@/%@", docDir, chIconName];
            NSString *jpegFilePath2 = [NSString stringWithFormat:@"%@/%@.jpg", docDir, chIconName];
            NSString *jpegFilePath3 = [NSString stringWithFormat:@"%@/%@.png", docDir, chIconName];
            [imData writeToFile:jpegFilePath1 atomically:YES];
            NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
            [data2 writeToFile:jpegFilePath2 atomically:YES];
            NSData *data3 = [NSData dataWithData:UIImagePNGRepresentation(image)];//1.0f = 100% quality
            [data3 writeToFile:jpegFilePath3 atomically:YES];
*/            
            
        ///------zs-------        
            chName = [chIconName substringToIndex:[chIconName rangeOfString:@"."].location];
            chId = [chName integerValue];   
//          _NSLog(@">update Image chan(%@) id=%d  (%@)",chName,chId,chIconName); 
            

//            if ((++scLoadImages % 10) == 1)                 
//                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CDMNewImage" object:self]]; 
        //------
        }
        else {
            if ([(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate shouldHandleError:error.code]) {    // no internet connection
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
                
                // stop all operations in queue
                NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
                [currQueue setSuspended:YES];
                finishedWithError = YES;
                [TVDataSingelton sharedTVDataInstance].currentState = eChannelsDownloadError;
            }
        }
//    }
}

- (void)waitUntilFinished
{
    _NSLog(@"waitUntilFinished");
}

- (BOOL)isFinished {
    if (finishedWithError) {
        NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
        DownloadChannelIconOperation *downloadOp = [[DownloadChannelIconOperation alloc] initWithString:requestUrl];
        [currQueue addOperation:downloadOp];
    }
    finishedWithError = NO;
    return YES;
}

@end
