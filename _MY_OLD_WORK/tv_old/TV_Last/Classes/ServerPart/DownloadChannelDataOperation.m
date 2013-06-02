//
//  DownloadOperation.m
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadChannelDataOperation.h"
#import "BZFile.h"
#import "TVDataSingelton.h"
#import "Channel.h"
#import "TVProgramAppDelegate.h"

@implementation DownloadChannelDataOperation
@synthesize requestUrl;
@synthesize chName,chId,resData,chDay;//zs
@synthesize toLOAD; //zs

//static NSInteger scLoad = 0;

- (id)initWithString:(NSString *)str
{
    //TODO set correct request
    self = [super init];
    requestUrl = [str copy];
    toLOAD = NO;
    return self;
}

- (void)main {
    responseData = [NSMutableData data];
    
    if ([SZAppInfo shared].stopLoading) {
 //       _NSLog1(@"!-stop loading data");
        return;
    }
        
    NSError *error = nil;
    
//    NSMutableURLRequest *req1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];  
//    NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];  
//    NSMutableURLRequest *req3 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] 
//                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad 
//                                                   timeoutInterval:30];  
    
//    NSData *data = [NSURLConnection sendSynchronousRequest:req1 returningResponse:nil error:&error];

//  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl]];   
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingUncached error:&error];
//  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestUrl] options:NSDataReadingMappedIfSafe error:&error];
    
//zss!    NSString *docDir = [SZUtils pathTmpDirectory];
    
    NSString *channelName = [requestUrl lastPathComponent];

    if (data != nil && error == nil) {    
/*zss!        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, channelName];
        [data writeToFile:filePath atomically:YES];
        
        BZFile *bzFile = [[BZFile alloc] initWithFileName:[docDir stringByAppendingPathComponent:channelName]];
        [bzFile bzOpen];
        NSString *resFilePath = [channelName stringByDeletingPathExtension];
        NSString *targetFile = [docDir stringByAppendingPathComponent:resFilePath]; //zs
        [bzFile decompressFile:targetFile];
        
        [[TVDataSingelton sharedTVDataInstance] setLastUpdateDate:[NSDate date] forChannel:channelName];
        
//      _NSLog(@">>>Download chanel(%@) (%@)->(%@)", channelName,filePath,resFilePath); ///
//      _NSLog(@">>>Download chanel(%@) ->(%@)", channelName,resFilePath); ///
        
        //remove bz file
        NSString *bzFilePath = [NSString stringWithFormat:@"%@/%@", docDir, channelName]; 
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:bzFilePath error:NULL];
*/        
///------zs-------    
        NSArray *aStr = [channelName componentsSeparatedByString:@"_"];
        if ([aStr count] >=2) {
            chName = [aStr objectAtIndex:0];
            NSString *ss = [aStr objectAtIndex:1];
            chDay = [ss substringToIndex:[ss rangeOfString:@"."].location];
        } else {
            chName = [channelName substringToIndex:[channelName rangeOfString:@"_"].location];
            chDay = nil;
        }        
        chName = [channelName substringToIndex:[channelName rangeOfString:@"_"].location];
        chId = [chName integerValue];        
//        _NSLog(@">update Data chan(%@) id=%d",chName,chId);
//        _NSLog(@">(%@) (%@) (%@) (%@)",channelName,aStr, chName,chDay);

        NSError *err;
//zss!        NSData *dat = [[NSData alloc] initWithContentsOfFile:targetFile];
        
        NSData *dat = [BZFile decompressData:data]; 
//        _NSLog(@" %d == %d",[dat length], [dt length]); 
        
        resData = nil;
        if (dat)
            resData = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err]; 
        if (resData) {
//            _NSLog(@">load array with %d dict",[data count]);

//            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CDMNewData" object:self]];                            
        }
//----------------        
//zss!        [fileManager removeItemAtPath:targetFile error:NULL]; //delete json-file!
        
    }   
    else {
        
        _NSLog(@"ERROR downloading for (%@) data:%d(%@)", channelName, error.code, [error localizedDescription]);
        // TODO: check error code
        if ([(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate shouldHandleError:error.code]) {    // no internet connection
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
            
            // stop all operations in queue
            NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
            [currQueue setSuspended:YES];
            finishedWithError = YES;
            [TVDataSingelton sharedTVDataInstance].currentState = eChannelsDownloadError;
        }
    }
//    _NSLog(@"::finished::(%@) id=%d",chName,chId);
}

- (BOOL)isFinished {
    if (finishedWithError) {
        NSOperationQueue *currQueue = [NSOperationQueue currentQueue];
        DownloadChannelDataOperation *downloadOp = [[DownloadChannelDataOperation alloc] initWithString:requestUrl];
        [currQueue addOperation:downloadOp];
    }
    finishedWithError = NO;
//    _NSLog(@"::finished::(%@) id=%d",chName,chId);
    return YES;
}

@end
