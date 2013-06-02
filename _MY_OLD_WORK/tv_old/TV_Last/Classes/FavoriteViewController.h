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

@class FavTableViewController;
@class UpView;
@class TimeScrollingController;
@class SelectChannelsController;
@class DaySelectionController;


@interface FavoriteViewController : UIViewController <ADBannerViewDelegate, WPBannerViewDelegate> 
{
    UpView *headerView;
    FavTableViewController * tableController;
    TimeScrollingController *timeScrolling;
    SelectChannelsController *channelSelection;
    DaySelectionController *daySelection;
    
    UITableView *tableView;
    BOOL adViewVisible;
    ADBannerView *bannerView;  
        
    BOOL wpViewVisible;
    UIView *viewForWpBanner;
    WPBannerView *wpBannerView;
}

@property (strong) FavTableViewController * tableController;

-(id)initWithTabBar;

-(void)updateTVProgram;

@end
