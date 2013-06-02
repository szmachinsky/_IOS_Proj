//
//  AppInfo.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZBannerManager.h"

@class SZCoreManager;
@class SZBannerManager;

#define maxCatNumber 12


@interface SZAppInfo : NSObject 

@property (weak) NSArray *selChannels;
@property (assign) NSInteger colSelChannels;
@property (readonly, nonatomic, retain) SZCoreManager *coreManager;
//@property (nonatomic, retain) SZBannerManager *bannerManager;
@property (assign) BOOL stopLoading;


+ (SZAppInfo*)shared;
- (SZCoreManager*)createCoreManagerWithDataFile:(NSString*)file Model:(NSString*)model;

//- (void)clearCategories;
//- (void)addToCategory:(NSInteger)idd;
//- (NSInteger)numberOfCategory:(NSInteger)idd;

@end
