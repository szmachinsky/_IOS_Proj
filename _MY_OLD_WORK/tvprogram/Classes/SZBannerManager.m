//
//  BannerManager.m
//  MyVisas
//
//  Created by Alexei Slizh on 5/18/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import "SZBannerManager.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>


//#include "WPBannerInfo.h"
#import "WPBannerView.h"



@implementation SZBannerManager

-(id)init
{
    self = [super init];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBannersFromViews) name:@"bannerRemoving" object:nil];    
    return self;
}



+ (WPBannerView *)wpBanner
{
    WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:6504];   
//    WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:TEST_APPLICATION_ID];
    WPBannerView *wpBannerView = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo]; 
    wpBannerView.showCloseButton = NO;
    wpBannerView.autoupdateTimeout = kWpAutoupdateTimeout;
//    wpBannerView.delegate = self;
//    wpBannerView.hideWhenEmpty = YES;
    wpBannerView.isMinimized = NO;    
    wpBannerView.disableAutoDetectLocation = YES;    
//    [wpBannerView reloadBanner];
    return wpBannerView;    
}

+ (WPBannerView *)wpBannerToView:(UIView*)view
{
    WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:6504];    
    WPBannerView *wpBannerView = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo]; 
    wpBannerView.showCloseButton = NO;
    wpBannerView.autoupdateTimeout = kWpAutoupdateTimeout;
    //    wpBannerView.delegate = self;
//    wpBannerView.hideWhenEmpty = YES;
    wpBannerView.isMinimized = NO;    
    wpBannerView.disableAutoDetectLocation = YES;    
    //    [wpBannerView reloadBanner];
    [view addSubview:wpBannerView];
    return wpBannerView;    
}


/*
bottomBannerView = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo];
bottomBannerView.showCloseButton = NO;
bottomBannerView.autoupdateTimeout = UPDATE_BANNER_TIMEOUT;
bottomBannerView.delegate = self;
bottomBannerView.isMinimized = YES;
[bottomBannerView reloadBanner];
*/

+(BOOL)isEnglishLocale
{
    if ([[[[NSLocale currentLocale] localeIdentifier] substringToIndex:2] isEqualToString:@"en"])
    {
        return YES;
    }
    return NO;
}

+(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

@end
