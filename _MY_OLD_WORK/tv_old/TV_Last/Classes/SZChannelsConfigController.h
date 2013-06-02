//
//  SelectChannelsController.h
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"


#import "WPBannerView.h"
//#import "WPBannerInfo.h"


@interface SZChannelsConfigController : UITableViewController  <NSFetchedResultsControllerDelegate, 
                                                                ADBannerViewDelegate, UISearchBarDelegate,
                                                                WPBannerViewDelegate> 
{
    UITableView *mytableView;
//    SettingsViewController *__unsafe_unretained delegate;
    
//    NSMutableArray *arrayOfCharacters;
//    NSMutableDictionary *objectsForCharacters;
    
    UIButton *selectAllButton;
    BOOL isUnCheckButton;
    BOOL isChanged;
    
    UITableView *tableView_;
    BOOL adViewVisible;
    ADBannerView *bannerView;   
    
    BOOL wpViewVisible;
    UIView *viewForWpBanner;
    WPBannerView *wpBannerView;
    
    UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    NSString *searchString;
    
    CGRect tableViewFrame;
}

//@property (nonatomic, unsafe_unretained) UITableViewController *delegate;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, assign) BOOL isChanged;

//zs-------
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (assign, nonatomic) id delegate;


@end
