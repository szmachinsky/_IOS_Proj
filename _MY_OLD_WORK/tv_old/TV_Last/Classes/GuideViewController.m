//
//  GuideViewController.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GuideViewController.h"
#import "UpView.h"
#import "DaySelectionController.h"
#import "TimeScrollingController.h"
#import "ProgrammByChannelController.h"
#import "SearchController.h"
#import "CommonFunctions.h"
#import "CustomTabBarItem.h"
#import "TVDataSingelton.h"

#import "TVProgramAppDelegate.h"

#import "SZTVTableViewController.h"
#import "WaitView.h"

#import "SZBannerManager.h"

@implementation GuideViewController

#define HEADER_HEIGHT 30

- (void)orientationChanged:(NSNotification *)notification
{
    //UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //if (UIInterfaceOrientationIsLandscape(deviceOrientation)){
    
}

-(void)updateTVProgram
{
    NSDictionary *currTime = getCurrentTime();
    int curHour = [[currTime objectForKey:@"hour"] intValue];
    int curMin  = [[currTime objectForKey:@"min"] intValue];
    NSString *curDay = [[TVDataSingelton sharedTVDataInstance] getCurrentDate];
    [headerView setDate:curDay];
    [tableController updateProgramToDate:curDay];
    [tableController setTime:curHour minutes:curMin];
 //   [tableController update];
    [timeScrolling setTime:curHour forMin:curMin];
}

-(void) updateData:(NSNotification *)notification
{  
    [[TVDataSingelton sharedTVDataInstance] readChannelsData:[[TVDataSingelton sharedTVDataInstance] getCurrentDate]];
    [self updateTVProgram];
}

- (void)createDatePicker
{
    if (tableView.hidden == YES) {   
//      self.navigationItem.rightBarButtonItem.enabled = NO;
        return;
    }
    daySelection = [[DaySelectionController alloc] init ];
    daySelection.view.frame = [[UIScreen mainScreen] applicationFrame];
    [daySelection setSelectedDate:[headerView currentDate]];
    [daySelection show:[[TVDataSingelton sharedTVDataInstance] getDates]];
    daySelection.delegate = self;
    
    [[(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:daySelection.view];
}

-(void) createSearchControl
{
    SearchController *search = [[SearchController alloc] init];
    search.view.frame = [[UIScreen mainScreen] applicationFrame];
    [search setDate:[headerView currentDate] forFavor:NO];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
//----  add wait view to controller ---  
//    //  search.waitView = [[WaitView alloc] initWithFrame:CGRectZero]; //zs 
//    search.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];     
//    [self.view addSubview:search.waitView]; // add activity indicator    
}

-(id) initWithTabBar
{
    self = [super init];
	if (self) {
		self.tabBarItem.title = @"В эфире";
		self.tabBarItem.image = [UIImage imageNamed:@"v_efire.png"];
        
        headerView = [[UpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.0f)];
        self.navigationItem.titleView = headerView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:@"DownloadingDataHasCompleted" object:nil];    
	}
///zs    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:@"DownloadingDataHasCompleted" object:nil];
	return self;
	
}


-(void)goToSelectChannels
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"SelectChannels" object:nil]];
}


- (void)loadView 
{
    self.navigationItem.title=@"В эфире";
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
    
    
    //----button to select date----
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(0, 0, 49, 29);
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [dateButton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(createDatePicker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateButton];
    
    //----search button----
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 49, 29);
    [searchButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [searchButton setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(createSearchControl) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
//    // ----iAd banner view-----
//    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];    
//    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
//    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
//    bannerView.delegate = self;
//    [self.view addSubview:bannerView];
    
//     bannerView_ = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 55.0f)];
//     SZBannerManager *bm = [SZAppInfo shared].bannerManager; //zs
//     [bm addAdBannerToView:bannerView_ markedByNumber:1];       
//     [self.view addSubview:bannerView_];

    
    
    //----Table view-----
    tableController = [[SZTVTableViewController alloc] init]; //zs
    tableController.delegate = self;
    tableView = tableController.tableView;
    [self.view addSubview:tableView]; 
    tableView.hidden = YES;
//----  add wait view to controller ---  
//    tableController.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];     
//    [self.view addSubview:tableController.waitView]; // add activity indicator

    
    //----slider of time----
    timeScrolling = [[TimeScrollingController alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame) - 68.0f, CGRectGetWidth(self.view.frame), 68.0f)];
    timeScrolling.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    timeScrolling.delegate = self;
    [self.view addSubview:timeScrolling];
    
    tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetMinY(timeScrolling.frame));
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//zs  NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
//    NSDate *date = [NSDate date];    
//    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *day = [[ModelHelper shared] dayFromDate:nil];
    [headerView setDate:day];
    [tableController updateProgramToDate:day];
    
    NSDictionary *time = getCurrentTime();
    NSString *hour = [time objectForKey:@"hour"];
    NSString *min = [time objectForKey:@"min"];
    [tableController setTime:[hour intValue] minutes:[min intValue]];
  
    
    
#ifdef WillShowWpBanner
    _NSLog(@"add wp_banner_1");
    viewForWpBanner = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 60.0f)];
    viewForWpBanner.backgroundColor =[UIColor blackColor];// [SZUtils color09];//[UIColor brownColor];
    [self.view addSubview:viewForWpBanner];
    [self.view sendSubviewToBack:viewForWpBanner];       
    viewForWpBanner.hidden = YES;
        
    wpBannerView = [SZBannerManager wpBannerToView:viewForWpBanner];
    wpBannerView.delegate = self;
    [wpBannerView reloadBanner];
    [wpBannerView showFromBottom:YES];
#endif
    
#ifdef WillShowAdBanner    
    _NSLog(@"add ad_banner_1");  
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

-(void) viewDidAppear:(BOOL)animated 
{
    [self updateTVProgram];
    [super viewDidAppear:animated];
    
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"В эфире" image:[UIImage imageNamed:@"v_efire.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"v_efire_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;     
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    SZBannerManager *bm = [SZAppInfo shared].bannerManager; //zs
//    [bm addAdBannerToTableView:tableView markedByNumber:1];  
    
      
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
//    BOOL toLandscape = toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
//    bannerView.currentContentSizeIdentifier = toLandscape 
//    ? (isSystemVersionMoreThen(4.2) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifier480x32)
//    : (isSystemVersionMoreThen(4.2) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50);
//    if (adViewVisible) {
//        tableView.frame = CGRectMake(0.0f, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(tableView.frame), CGRectGetMinY(timeScrolling.frame) - CGRectGetMaxY(bannerView.frame));
//    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    [[TVDataSingelton sharedTVDataInstance] clearCache];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    daySelection = nil;
}

- (void) dayIsSelected:(NSString *)day
{
    [[TVDataSingelton sharedTVDataInstance] setCurrentDate:day]; ///zs
    
    [headerView setDate:day];
    [tableController updateProgramToDate:day];
    
//    [tableController update]; //zs
}

- (void) updateTime:(int)hour minutes:(int)min
{
    [tableController setTime:hour minutes:min];
}

- (void) channelIsSelected:(NSString *)channel //chID:(NSInteger)chId
{  
    ProgrammByChannelController *channelController = [[ProgrammByChannelController alloc] init];
    [channelController setChannelName:channel initialDay:[headerView currentDate] isFavor:NO];
    
//    channelController.modalTransitionStyle = kModTranStyle;
//    channelController.titleForBackButton = @"В эфире";
//    [self presentModalViewController:channelController animated:YES];
    
    channelController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:channelController animated:YES]; //zs
    
    channelController = nil;
}

- (void) channelIsSelected:(NSString *)channel chID:(NSInteger)chId
{  
    ProgrammByChannelController *channelController = [[ProgrammByChannelController alloc] init];
    [channelController setChannelName:channel initialDay:[headerView currentDate] isFavor:NO];
    
//    channelController.modalTransitionStyle = kModTranStyle;
//    channelController.titleForBackButton = @"В эфире";
//    [self presentModalViewController:channelController animated:YES];
    
    channelController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:channelController animated:YES]; //zs
    
    channelController = nil;
}


//==========================aD_Banner====================================================
#pragma mark
#pragma mark AdBannerView delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
	if (!adViewVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
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

/*
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
}
*/

//==========================wP_Banner====================================================
//- (void) bannerViewPressed:(WPBannerView *)bannerView_
//{    
//    if (bannerView_.bannerInfo.responseType == WPBannerResponseWebSite) {
//        NSURL *url = [NSURL URLWithString:bannerView_.bannerInfo.link];
//        if (url)
//            [[UIApplication sharedApplication] openURL:url];
//    }
/////zs    [bannerView_ reloadBanner];    
//}

- (void) bannerViewInfoLoaded:(WPBannerView *)bannerView_
{
    _NSLog2(@"loaded Wp_Banner_1_Info"); 
	if (!wpViewVisible) {
        [UIView beginAnimations:@"animateWpBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
        viewForWpBanner.hidden = NO;        
        [self.view bringSubviewToFront:viewForWpBanner];
        
        tableView.frame = CGRectMake(0, CGRectGetMaxY(viewForWpBanner.frame), 
                                    CGRectGetWidth(tableView.frame),  tableView.frame.size.height - viewForWpBanner.frame.size.height);
        
        [UIView commitAnimations];
		wpViewVisible = TRUE;
	}
    
}

 
@end
