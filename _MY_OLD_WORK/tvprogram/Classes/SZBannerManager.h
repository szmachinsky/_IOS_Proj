//
//  BannerManager.h
//  MyVisas
//
//  Created by Alexei Slizh on 5/18/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define WillShowWpBanner
//#define WillShowAdBanner

@class  WPBannerView;

@interface SZBannerManager : NSObject
{

}

+ (WPBannerView *)wpBanner;
+ (WPBannerView *)wpBannerToView:(UIView*)view;

+(BOOL)isEnglishLocale;
+(BOOL)hasConnectivity;

@end
