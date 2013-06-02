//
//  ChannelListOperation.m
//  TVProgram
//
//  Created by Irina on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChannelListOperation.h"
//#import "SBJSON.h"
#import "Channel.h"
#import "TVDataSingelton.h"

#import "SZCoreManager.h" //zs
#import "CreateChannels.h"//zs

@implementation ChannelListOperation
- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start {
    // Always check for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}
/*
    1. Download list of channels
    2. Parse file and store data about channels
    3. Download and store icons for each channel
 */
-(void)main
{
    @autoreleasepool {
    //parse file
        NSString *docDir = [SZUtils pathDocDirectory];
        NSString *filePath = [NSString stringWithFormat:@"%@/index.json", docDir];
/*        
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
        SBJsonParser *parser = [[SBJsonParser alloc] init];  
        NSDictionary *data = (NSDictionary *) [parser objectWithString:fileContent error:nil];
*/        
        NSError *err;
        NSData *dat = [[NSData alloc] initWithContentsOfFile:filePath];
        NSDictionary *data = nil;
        if (dat) {
            data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];
            _NSLog(@"parced %d records  err:%@",[data count],err);
        }
        
        BOOL isFirstTime = YES;
        if ([[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels] != 0) {
            isFirstTime = NO;
        }
        
//---zs---    
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
        
        if ( (data) && [data count]>100 ) {
            
            NSManagedObjectContext *_context = [[[SZAppInfo shared] coreManager] createContext];
           // [SZCoreManager saveForContext:_context]; //save old context            
            NSDictionary *sel = [SZCoreManager deleteAllObjectsWithSaveIn:@"MTVChannel" forContext:_context]; //delete all data
            
            CreateChannels *ch = [[CreateChannels alloc] init];    
            ch.managedObjectContext = _context;
            [ch parseFile:@"index.json" mergeDict:sel]; 
            
            ch.managedObjectContext = nil;                        
            [SZCoreManager saveForContext:_context]; //save new context
            _context = nil;    
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
        }
//--------        
        NSEnumerator *enumerator = [data objectEnumerator];
        id value;
        while (![self isCancelled] && (value = [enumerator nextObject])) {
            /* code that acts on the dictionary’s values */
            NSString *name = [value objectForKey:@"name"];
            NSString * chId = [value objectForKey:@"id"];
            NSString * iconName = [value objectForKey:@"logo"];
            NSArray * dataUrl = [value objectForKey:@"url"];
            NSString * updated = [value objectForKey:@"updated"];
            
            //int n = [[TVDataSingelton sharedTVDataInstance] getNumberOfChannels]; //zs
            //check if channel already exist
            Channel *channel = [[TVDataSingelton sharedTVDataInstance] getChannel:[[name lowercaseString] capitalizedString]];
            if (channel == nil) {
                channel = [[Channel alloc] init];
                channel.name = [[name lowercaseString] capitalizedString];
//                _NSLog(@"new channel:(%@)=(%@)  id=%@",name,channel.name,chId);
                [[TVDataSingelton sharedTVDataInstance] addChanel:channel];
            }
            channel.iconName = iconName;
            channel.chId = chId;
            [channel setUrlsToData:dataUrl];
            [channel setUpdatedDate:updated];
            
            //n = [[TVDataSingelton sharedTVDataInstance] getNumberOfChannels]; //zs

        }
        [[TVDataSingelton sharedTVDataInstance] setChannels];
                
        //int n = [[TVDataSingelton sharedTVDataInstance] getNumberOfChannels]; //zs

///        if (isFirstTime == YES) {
///        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectChannels" object:nil]];
///        }
///        else
///        {
        [TVDataSingelton sharedTVDataInstance].currentState = eIndexParse;
///        }

        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        
        executing = NO;
        finished = YES;
        // if list is received first time hide update popup to let user select channels
        if (isFirstTime) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectChannels" object:nil]];
        } else {
///            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];  //zs!!!           
        }
        
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
        
        _NSLog(@"------Channel List loaded-------");
    }
}

@end
