//
//  FavoriteViewController.m
//  TVProgram
//
//  Created by User1 on 25.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVProgramAppDelegate.h"
#import "FavoriteViewController.h"
#import "UpView.h"
#import "DaySelectionController.h"
#import "TimeScrollingController.h"
//#import "SearchController.h"
#import "CustomTabBarItem.h"
#import "CommonFunctions.h"

#import "TVDataSingelton.h"
#import "ProgrammByChannelController.h"

#import "FavTableViewController.h"
#import "SelectChannelsController.h"

#import "WaitView.h"

@implementation FavoriteViewController
@synthesize tableController;


-(void)updateTVProgram
{
    NSDictionary *currTime = getCurrentTime();
    int curHour = [[currTime objectForKey:@"hour"] intValue];
    int curMin  = [[currTime objectForKey:@"min"] intValue];
    NSString *curDay = [[TVDataSingelton sharedTVDataInstance] getCurrentDate];
    [headerView setDate:curDay];
    [tableController updateProgramToDate:curDay];
    [tableController setTime:curHour minutes:curMin];
//    [tableController update];
    [timeScrolling setTime:curHour forMin:curMin];
}


- (void) dayIsSelected:(NSString *)day
{
    [headerView setDate:day];
    [tableController updateProgramToDate:day];
}

- (void)createDatePicker
{
    if (tableView.hidden == YES)
        return;          
    daySelection = [[DaySelectionController alloc] init ];
    daySelection.view.frame = [[UIScreen mainScreen] applicationFrame];
    [daySelection setSelectedDate:[headerView currentDate]];
    [daySelection show:[[TVDataSingelton sharedTVDataInstance] getDates]];
    daySelection.delegate = self;
    
    [[(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:daySelection.view];
}

- (void)updateChannels:(NSNotification *)notification
{
    [tableController reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateChannelsViewSwitcherooNotification" object:nil];
}

- (void)updateData
{
    [tableController reloadData]; //update after reloading
}


-(void) changeChannels
{
    channelSelection = [[SelectChannelsController alloc] init ];
    channelSelection.view.frame = [[UIScreen mainScreen] applicationFrame];
    channelSelection.hidesBottomBarWhenPushed = YES; //hide tab bar!
    [self.navigationController pushViewController:channelSelection animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannels:) name:@"UpdateChannelsViewSwitcherooNotification" object:nil];
}

- (void) updateTime:(int)hour minutes:(int)min
{
    [tableController setTime:hour minutes:min];
}

- (void) channelIsSelected:(NSString *)channel
{  
    ProgrammByChannelController *channelController = [[ProgrammByChannelController alloc] init];
    [channelController setChannelName:channel initialDay:[headerView currentDate] isFavor:YES];
    
//    channelController.modalTransitionStyle = kModTranStyle;
//    channelController.titleForBackButton = @"Любимые";   
//    [self presentModalViewController:channelController animated:YES];
    
    channelController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:channelController animated:YES]; //zs    
}

-(id) initWithTabBar {
    self = [super init];
	if (self) {
		self.tabBarItem.title = @"Любимые";
		self.tabBarItem.image = [UIImage imageNamed:@"favorite.png"];
        
        headerView = [[UpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.0f)];
        self.navigationItem.titleView = headerView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"DownloadingDataHasCompleted" object:nil];    
	}
	return self;
}


-(void)goToSelectChannels
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectChannels" object:nil]];
}


- (void)loadView {
    self.navigationItem.title=@"Любимые";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];//[UIColor redColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
    
    self.view.backgroundColor = [SZUtils color02]; //[UIColor blackColor];
    
    UILabel *initLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 110.0f, CGRectGetWidth(self.view.frame) - 40.0f, 80.0f)];
    initLabel.text = @"Выберите каналы/регионы";
    initLabel.textAlignment = UITextAlignmentCenter;
    initLabel.backgroundColor = [UIColor clearColor];
    initLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    initLabel.textColor = [SZUtils color04];
    [self.view addSubview:initLabel];
    
    UIButton *initButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    initButton.frame = CGRectMake(40.0f, 200.0f, CGRectGetWidth(self.view.frame) - 80.0f, 40.0f);
    initButton.tintColor = [SZUtils color02];
    [initButton setTitle:@"выбор каналов" forState:UIControlStateNormal];
    [initButton setBackgroundColor:[SZUtils color02]];
//    [initButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [initButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
    [initButton addTarget:self action:@selector(goToSelectChannels) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:initButton];    
    
    
    // navigation buttons
    UIButton *channelsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    channelsButton.frame = CGRectMake(15, 7, 49, 29);
    [channelsButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [channelsButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
//    [channelsButton setImage:[UIImage imageNamed:@"channels_icon.png"] forState:UIControlStateNormal]; ytn 
    [channelsButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];  //zs
    [channelsButton addTarget:self action:@selector(changeChannels) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:channelsButton];
    
    //button to select date
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(250, 7, 49, 29);
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [dateButton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(createDatePicker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateButton];
    
    //Table view
    tableController = [[FavTableViewController alloc] init];
    tableController.delegate = self;
    tableView = tableController.tableView;
    [self.view addSubview:tableView];
    tableView.hidden = YES;
//----  add wait view to controller ---  
    //  tableController.waitView = [[WaitView alloc] initWithFrame:CGRectZero]; //zs 
//    tableController.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];     
//    [self.view addSubview:tableController.waitView]; // add activity indicator
    
    
    //slider of time
    timeScrolling = [[TimeScrollingController alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame) - 68.0f, CGRectGetWidth(self.view.frame), 68.0f)];
    timeScrolling.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    timeScrolling.delegate = self;
    [self.view addSubview:timeScrolling];
    
    tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetMinY(timeScrolling.frame));
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyyMMdd"];
    [headerView setDate:[formatter stringFromDate:date]];
    [tableController updateProgramToDate:[formatter stringFromDate:date]];
    
    NSDictionary *currTime = getCurrentTime();
    int cHour = [[currTime objectForKey:@"hour"] intValue];
    int cMin  = [[currTime objectForKey:@"min"] intValue];
    [tableController setTime:cHour minutes:cMin];
    
    
    
#ifdef WillShowWpBanner
    _NSLog(@"add wp_banner_2");
    viewForWpBanner = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 60.0f)];
    viewForWpBanner.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewForWpBanner];
    [self.view sendSubviewToBack:viewForWpBanner];       
    viewForWpBanner.hidden = YES;
    
    wpBannerView = [SZBannerManager wpBannerToView:viewForWpBanner];
    wpBannerView.delegate = self;
    [wpBannerView reloadBanner];
    [wpBannerView showFromBottom:YES];
#endif
    
#ifdef WillShowAdBanner    
    _NSLog(@"add ad_banner_2");  
    // ----iAd banner view-----
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];    
    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    adViewVisible = NO;
    [self.view sendSubviewToBack:bannerView];
#endif
    
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    headerView = nil;
    tableController = nil;
    timeScrolling = nil;
    channelSelection = nil;
    daySelection = nil;
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Любимые" image:[UIImage imageNamed:@"favorite.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"favorite_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;            
}

- (void)viewWillAppear:(BOOL)animated {
    [tableController reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//==============================================================================
#pragma mark
#pragma mark AdBannerView delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
	if (!adViewVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:1.0]; //zs
        [self.view bringSubviewToFront:bannerView];
        tableView.frame = CGRectMake(0.0f, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(tableView.frame), CGRectGetMinY(timeScrolling.frame) - CGRectGetMaxY(bannerView.frame));
        [UIView commitAnimations];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //iAds failed
	NSLog(@"%@",[error localizedDescription]);
	if (adViewVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [self.view sendSubviewToBack:bannerView];
        tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.frame), CGRectGetMinY(timeScrolling.frame));
        [UIView commitAnimations];
		adViewVisible = FALSE;
    }
}

//==========================wP_Banner====================================================
//- (void) bannerViewPressed:(WPBannerView *)bannerView_
//{    
//    if (bannerView_.bannerInfo.responseType == WPBannerResponseWebSite) {
//        NSURL *url = [NSURL URLWithString:bannerView_.bannerInfo.link];
//        if (url)
//            [[UIApplication sharedApplication] openURL:url];
//    }
//    ///zs    [bannerView_ reloadBanner];    
//}

- (void) bannerViewInfoLoaded:(WPBannerView *)bannerView_
{
    _NSLog(@"loaded Wp_Banner_2_Info"); 
	if (!wpViewVisible) {
        [UIView beginAnimations:@"animateWpBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
        viewForWpBanner.hidden = NO;        
//        [self.view bringSubviewToFront:viewForWpBanner];
        
        tableView.frame = CGRectMake(0, CGRectGetMaxY(viewForWpBanner.frame), 
                                     CGRectGetWidth(tableView.frame),  tableView.frame.size.height - viewForWpBanner.frame.size.height);
        
        [UIView commitAnimations];
		wpViewVisible = TRUE;
	}
    
}



@end
