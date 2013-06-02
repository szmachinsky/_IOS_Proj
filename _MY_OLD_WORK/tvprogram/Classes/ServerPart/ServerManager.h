//
//  ServerManager.h
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface ServerManager : NSObject <UIAlertViewDelegate> {
    Reachability* internetReach;
    NSOperationQueue* aQueue;
    NSTimer *myTicker;
    
    UIAlertView *currAlert;
    
    //if data is downloading because settings have been changed
    BOOL isFromSettings;
    NSMutableArray *prevSelectedChannelNames;
    
    NSArray *maskForDateLoading_;
    NSInteger filesNumber;
    NSInteger prevFilesNumber;
    float initFilesNumber;
    
    uint64_t t1,t2;
}

@property(nonatomic,strong) NSArray *maskForDateLoading;

+(ServerManager*)sharedManager;

-(void) start:(BOOL)wifiOnly;
-(void) updateChannelsData;
-(void) downloadAllChannelsData:(BOOL)afterNewChannelsSelection;

-(BOOL) ifDataShouldBeDownloaded;

@end
