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
#import "KHDaySliderView.h"
#import "KHDaySliderBar.h"


@class SZTVTableViewController; //zs
@class UpView;
@class TimeScrollingController;
@class DaySelectionController;
@class MTVShow;

//@interface GuideViewController : UIViewController <ADBannerViewDelegate> {
@interface GuideViewController : UIViewController <ADBannerViewDelegate, WPBannerViewDelegate,KHDaySliderViewDelegate > 
{
    UpView *headerView;
    SZTVTableViewController *tableController; //zs
    TimeScrollingController *timeScrolling;
    DaySelectionController *daySelection;
    
    KHDaySliderView *slider;
    KHDaySliderBar *sliderBar;
    CGRect tableFrame, sliderFrame;
    
    UITableView *tableView;
  
    
    BOOL adViewVisible;
    ADBannerView *bannerView;
    
    BOOL wpViewVisible;
    UIView *viewForWpBanner;
    WPBannerView *wpBannerView;

}
@property (assign) KHDaySliderView *slider;

- (id)initWithTabBar;
- (void)updateTVProgram;
//- (void)channelIsSelected:(NSString *)channel chID:(NSInteger)chId;

- (void)categorySelected:(int)cat;
- (void) programIsSelectedMTV:(MTVShow*)show;

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value;

@end
