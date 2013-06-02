//
//  FavoriteViewController.h
//  TVProgram
//
//  Created by User1 on 25.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPBannerView.h"
//#import "WPBannerInfo.h"
#import "KHDaySliderView.h"
#import "KHDaySliderBar.h"


@class FavTableViewController;
@class UpView;
@class TimeScrollingController;
@class SelectChannelsController;
@class DaySelectionController;
@class SZTVTableViewController;
@class MTVShow;


@interface FavoriteViewController : UIViewController <ADBannerViewDelegate, WPBannerViewDelegate,KHDaySliderViewDelegate> 
{
    UpView *headerView;
//    FavTableViewController * _tableController;
    SZTVTableViewController *tableController;
    TimeScrollingController *timeScrolling;
    SelectChannelsController *channelSelection;
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

//@property (strong) FavTableViewController * tableController;
@property (strong) SZTVTableViewController * tableController;

-(id)initWithTabBar;

-(void)updateTVProgram;

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value;

- (void)categorySelected:(int)cat;
- (void)programIsSelectedMTV:(MTVShow*)show;


@end
