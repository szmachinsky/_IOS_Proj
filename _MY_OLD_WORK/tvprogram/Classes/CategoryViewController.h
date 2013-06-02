//
//  ChannelsViewController.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WPBannerView.h"
//#import "WPBannerInfo.h"

@class WaitView;

//@interface CategoryViewController : UITableViewController <ADBannerViewDelegate> 
@interface CategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
                                                        ADBannerViewDelegate, WPBannerViewDelegate> 
{
    NSArray *tabData_;
    NSDictionary *tableDict_;
    NSDictionary *todayDict_;
    NSArray *selArrays_;
    NSManagedObjectContext *context_;
    
//    UITableView *tableView;
    UITableView *mytableView;
    
    CGRect tableFrame,lineFrame;
    
    BOOL adViewVisible;
    ADBannerView *bannerView;   
    
    BOOL wpViewVisible;
    UIView *viewForWpBanner;
    WPBannerView *wpBannerView; 
    
    UIImageView *topImage, *bottomImage;
}
//@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *tabData; //zs
@property (strong, nonatomic) NSDictionary *tableDict; //zs
@property (strong, nonatomic) NSManagedObjectContext *context; //zs
@property (strong, nonatomic) NSArray *selArrays; //zs 
@property (readonly, strong, nonatomic) WaitView *waitView;  //zs 


-(id)initWithTabBar;

@end
