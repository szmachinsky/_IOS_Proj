//
//  AppData.h
//  MyVisas
//
//  Created by Nnn on 12.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopManager.h"
#import "BannerManager.h"

#define kLocationSettingChanged @"locationSettingChanged"

@interface AppData : NSObject <NSCoding> {
}
@property (nonatomic, assign) BOOL isVisaOnEdit; 

@property (nonatomic, assign) NSInteger nextVisaNum;
@property (nonatomic, retain) NSMutableArray *visas;
@property (nonatomic, retain) NSMutableDictionary *passportInfo;

@property (nonatomic, retain) ShopManager *shopManager;
@property (nonatomic, retain) BannerManager *bannerManager;

// Alerts settings
// [0] - about expiry, [1] - about duration, [2] - about passport
@property (nonatomic, retain) NSMutableArray *showAlerts;
@property (nonatomic, retain) NSMutableArray *alertsBeginDays;
@property (nonatomic, retain) NSMutableArray *repeatDays;
@property (nonatomic, retain) NSMutableArray *alertsTime;

@property (nonatomic, assign) BOOL isLocationOn;
@property (nonatomic, assign) BOOL isInCountry;
@property (nonatomic, retain) NSString *currCountry;
@property (nonatomic, retain) NSDate *lastDateOpened;
@property (nonatomic, retain) NSMutableDictionary *entries;

@property (nonatomic, retain) NSDictionary *lastLocation;
@property (nonatomic, assign) BOOL locationHandled;

@property (nonatomic, assign) BOOL appRated;
@property (nonatomic, assign) BOOL mailToFriendSend;

+ (AppData *)sharedAppData;
- (void)save;

@end
