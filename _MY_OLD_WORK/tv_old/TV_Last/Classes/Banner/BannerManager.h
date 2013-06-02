//
//  BannerManager.h
//  MyVisas
//
//  Created by Alexei Slizh on 5/18/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

//zs #import "WPBannerView.h"
#import <iAd/ADBannerView.h>

//zs @interface BannerManager : UIViewController <WPBannerViewDelegate, ADBannerViewDelegate>{
@interface BannerManager : UIViewController < ADBannerViewDelegate>{
//    WPBannerView *wpBannerView1;
//    WPBannerView *wpBannerView2;
    
    ADBannerView *adBannerView1;
    ADBannerView *adBannerView2;
    //BOOL isBannerVisible;
    
    UITableView *wpTableView;
    UITableView *adTableView;
}
//@property (nonatomic, retain) WPBannerView *wpBannerView1;
//@property (nonatomic, retain) WPBannerView *wpBannerView2;

@property (nonatomic, retain) ADBannerView *adBannerView1;
@property (nonatomic, retain) ADBannerView *adBannerView2;

-(void)addWPBannerToView:(UIView*)view markedByNumber:(int)number;
-(void)addWPBannerToTableView:(UITableView*)tView markedByNumber:(int)number;

-(void)addAdBannerToView:(UIView*)view markedByNumber:(int)number;
-(void)addAdBannerToTableView:(UITableView*)tView markedByNumber:(int)number;

-(void)removeBannersFromViews;
+(BOOL)isEnglishLocale;

+(BOOL)hasConnectivity;

@end
