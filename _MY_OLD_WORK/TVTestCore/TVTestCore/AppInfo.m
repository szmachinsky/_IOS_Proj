//
//  AppInfo.m
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppInfo.h"
#import "SZCoreManager.h"

static AppInfo *_sharedAppInfo=nil;

@implementation AppInfo

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


+ (AppInfo*)shared
{// static AppInfo *_sharedAppInfo=nil;
    @synchronized(self) {
        if(_sharedAppInfo == nil) {
            NSLog(@"-initialize_Shared- AppInfo");
            _sharedAppInfo = [[AppInfo alloc] init];
        }
    }    
    return _sharedAppInfo;    
}


+ (void)initialize
{
    NSLog(@"-initialize_Initialize- AppInfo");
    if(_sharedAppInfo == nil) {
        _sharedAppInfo = [[AppInfo alloc] init];
    }    
}


-(SZCoreManager*)createCoreManagerWithDataFile:(NSString*)file Model:(NSString*)model 
{
    if (!coreManager_) {
        coreManager_ = [[SZCoreManager alloc] initWithFile:file Model:model];
    }
    return coreManager_;
}



@end


