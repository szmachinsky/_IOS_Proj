//
//  GuideViewController.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>

#import "WPBannerView.h"
//#import "WPBannerInfo.h"


//@protocol WPBannerViewDelegate <NSObject>
//- (void) bannerViewPressed:(WPBannerView *) bannerView;
//@optional
//- (void) bannerViewInfoLoaded:(WPBannerView *) bannerView;
//- (void) bannerViewDidHide:(WPBannerView *) bannerView;
//- (void) bannerViewMinimizedStateChanged:(WPBannerView *) bannerView;
//@end

@class SZTVTableViewController; //zs
@class UpView;
@class TimeScrollingController;
@class DaySelectionController;

//@interface GuideViewController : UIViewController <ADBannerViewDelegate> {
@interface GuideViewController : UIViewController <ADBannerViewDelegate, WPBannerViewDelegate > 
{
    UpView *headerView;
    SZTVTableViewController *tableController; //zs
    TimeScrollingController *timeScrolling;
    DaySelectionController *daySelection;
    
    UITableView *tableView;
  
    
    BOOL adViewVisible;
    ADBannerView *bannerView;
    
    BOOL wpViewVisible;
    UIView *viewForWpBanner;
    WPBannerView *wpBannerView;

}

- (id)initWithTabBar;
- (void)updateTVProgram;
//- (void)channelIsSelected:(NSString *)channel chID:(NSInteger)chId;

@end
