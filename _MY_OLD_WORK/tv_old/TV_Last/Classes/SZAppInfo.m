//
//  AppInfo.m
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZAppInfo.h"
#import "SZCoreManager.h"
#import "MTVShow.h"
#import "MTVChannel.h"

//#define maxCatNumber 100

static SZAppInfo *_sharedAppInfo=nil;


@interface SZAppInfo ()
- (void)clearCategories;
- (void)addToCategory:(NSInteger)idd;
- (NSInteger)numberOfCategory:(NSInteger)idd;
@end

@implementation SZAppInfo
{
    SZCoreManager *coreManager_;
    __weak NSArray *selChannels_;  
    NSInteger colSelChannels_;
    NSInteger arrCategory_[maxCatNumber];
}


@synthesize coreManager = coreManager_;
//@synthesize bannerManager = bannerManager_;
@synthesize selChannels = selChannels_;
@synthesize colSelChannels = colSelChannels_;
@synthesize stopLoading = stopLoading_;

- (id)init
{
    self = [super init];
    if (self) {
//        selChannels_ = [[NSMutableArray alloc] init];
        [self clearCategories];
        stopLoading_ = NO;
    }
    return self;
}


+ (SZAppInfo*)shared
{// static AppInfo *_sharedAppInfo=nil;
    @synchronized(self) {
        if(_sharedAppInfo == nil) {
            _NSLog(@"-initialize_Shared- AppInfo");
            _sharedAppInfo = [[SZAppInfo alloc] init];
        }
    }    
    return _sharedAppInfo;    
}


+ (void)initialize
{
    _NSLog(@"-initialize_Initialize- AppInfo");
    if(_sharedAppInfo == nil) {
        _sharedAppInfo = [[SZAppInfo alloc] init];
    }    
}


-(SZCoreManager*)createCoreManagerWithDataFile:(NSString*)file Model:(NSString*)model 
{
    if (!coreManager_) {
        coreManager_ = [[SZCoreManager alloc] initWithFile:file Model:model];
    }
    return coreManager_;
}


//------------------------------------------------------------------------------
- (void)clearCategories
{
    for (NSInteger idd = 0; idd < maxCatNumber; idd++) {
        arrCategory_[idd] = 0;
    }
        
}

- (void)addToCategory:(NSInteger)idd
{
    if ((idd >=0 )&&(idd < maxCatNumber)) {
        arrCategory_[idd] = arrCategory_[idd] + 1;        
    }
        
}


- (NSInteger)numberOfCategory:(NSInteger)idd
{
    if ((idd >=0 )&&(idd < maxCatNumber)) {
        return arrCategory_[idd];        
    }
    return 0;
}


@end


