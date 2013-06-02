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

#import "SelectChannelsController.h"

#import "FavTableViewController.h"
#import "SZTVTableViewController.h"

#import "WaitView.h"

#import "ProgramsByCattegoryViewController.h"
#import "ProgrammDataViewController.h"


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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateChannelsViewSwitcherooNotification" object:nil];
    [tableController reloadDataTable];
}

- (void)updateData
{
    [tableController reloadDataTable]; //update after reloading
}


-(void) changeChannels
{
    channelSelection = [[SelectChannelsController alloc] init ];
    channelSelection.view.frame = [[UIScreen mainScreen] applicationFrame];
    channelSelection.hidesBottomBarWhenPushed = YES; //hide tab bar!
    [self.navigationController pushViewController:channelSelection animated:YES];
    
///    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannels:) name:@"UpdateChannelsViewSwitcherooNotification" object:nil];
}

//- (void) updateTime:(int)hour minutes:(int)min
//{
//    [tableController setTime:hour minutes:min];
//}
//---------------------- timer slider delegate -------------------------------
- (void) updateTime:(int)hour minutes:(int)min
{
    [tableController setTime:hour minutes:min];
}

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value
{
    NSDateComponents *dateComponents = KHDaySliderDateComponentsWithValue(value); 
    
    //    NSLog(@"Day slider value is %f, which means %d:%d", value, dateComponents.hour, dateComponents.minute);
    int h = dateComponents.hour;
    int m = dateComponents.minute;
    [tableController setTime:h minutes:m];    
}


- (void) programIsSelectedMTV:(MTVShow*)show
{
    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
    
    //    channelController.modalTransitionStyle = kModTranStyle;    
    //    [self presentModalViewController:channelController animated:YES];
    
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:channelName style:UIBarButtonItemStyleDone target:nil action:nil];
    //    backButton.tintColor = [SZUtils colorLeftButton];
    //    self.navigationItem.backBarButtonItem = backButton;  
    
    channelController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:channelController animated:YES]; //zs
    
    
    //    NSString *n = [show name];
    //    NSString *d = [show day];
    //    NSDate *dt = show.pStart;
    //    NSInteger h = [show startHour];
    //    NSInteger m = [show startMin];
    //    _NSLog(@"(%@) (%@) dat=%@  (%d:%d)",n,d,dt,h,m);                   
    
    MTVChannel *chan = show.rTVChannel;
    NSString *name = chan.pName;
    [channelController showProgramDataMTV:show channel:chan 
                            minutesBefore:[[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder] 
                           forChannelName:name];
}


- (void)categorySelected:(int)cat
{
    ProgramsByCattegoryViewController *programController = [[ProgramsByCattegoryViewController alloc] init];
    NSString *catName = [ModelHelper categoryName:cat];
    NSString *date = [[ModelHelper shared] dayForToday];
    programController.hidesBottomBarWhenPushed = YES;  //disable tab bar 
    
    [self.navigationController pushViewController:programController animated:YES]; //zs
    
    [programController setData:catName catId:cat forDate:date];        
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


-(id) initWithTabBar {
    self = [super init];
	if (self) {
//		self.tabBarItem.title = @"Любимые";
//		self.tabBarItem.image = [UIImage imageNamed:@"t_fave.png"]; //"favorite.png"
////        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"t_fave.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"t_fave.png"]];
        
        CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Любимые" image:[UIImage imageNamed:@"t_fave.png"] tag:0];
        tabItem.customHighlightedImage=[UIImage imageNamed:@"t_fave.png"];
        self.tabBarItem = tabItem;
        tabItem=nil;                    
        
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
    backButton.tintColor = [SZUtils colorLeftButton];//[UIColor redColor];
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
///    [channelsButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
///    [channelsButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
//    [channelsButton setImage:[UIImage imageNamed:@"channels_icon.png"] forState:UIControlStateNormal]; ytn 
    [channelsButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];  //zs
    [channelsButton addTarget:self action:@selector(changeChannels) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:channelsButton];
    
    //button to select date
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(250, 7, 49, 29);
///    [dateButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
///    [dateButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [dateButton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(createDatePicker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateButton];
    
    //Table view
//    tableController = [[FavTableViewController alloc] init];
//    tableController.delegate = self;
//    tableView = tableController.tableView;
//    [self.view addSubview:tableView];
//    tableView.hidden = YES;
    
    
    //----Table view-----
    tableController = [[SZTVTableViewController alloc] init]; //zs
    tableController.delegate = self;
    tableView = tableController.tableView;
    [self.view addSubview:tableView]; 
    tableView.hidden = YES;
    tableController.isFavorite = YES;
    
//----  add wait view to controller ---  
    //  tableController.waitView = [[WaitView alloc] initWithFrame:CGRectZero]; //zs 
//    tableController.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];     
//    [self.view addSubview:tableController.waitView]; // add activity indicator
    
    
    //slider of time
//    timeScrolling = [[TimeScrollingController alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(self.view.frame) - 68.0f, CGRectGetWidth(self.view.frame), 68.0f)];
//    timeScrolling.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    timeScrolling.delegate = self;
//    [self.view addSubview:timeScrolling];
    
//    tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetMinY(timeScrolling.frame));
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 343); //minY + 23
 
    //----- create slider ----------
    slider = [[KHDaySliderView alloc] init];    
    // set delegate
    slider.delegate = self;    
    // set precision for both values
    slider.precision = 1.0/4;    
    // set value and current value
    slider.value = KHDaySliderValueWithDate([NSDate date]);
    slider.currentValue = KHDaySliderValueWithDate([NSDate date]);    
    sliderBar = [[KHDaySliderBar alloc] initWithSliderView:slider origin:CGPointMake(0.0, 337.0)];    
    // add slider view as subview of controller view
    [self.view addSubview:sliderBar];
    sliderBar.alpha = 1;
    
    tableFrame = tableView.frame; 
    sliderFrame = sliderBar.frame;
    
    tableController.slider = slider; 
    //--------    
    
    
    
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
    viewForWpBanner = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f+327, CGRectGetWidth(self.view.frame), 60.0f)];
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
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f+337, CGRectGetWidth(self.view.frame), 50.0f)];    
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
    
//    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Любимые" image:[UIImage imageNamed:@"t_fave.png"] tag:0];
//    tabItem.customHighlightedImage=[UIImage imageNamed:@"t_fave.png"];
//    self.tabBarItem = tabItem;
//    tabItem=nil;            
    
    slider.currentValue = KHDaySliderValueWithDate([NSDate date]);
}

- (void)viewWillAppear:(BOOL)animated {
    [tableController reloadDataTable];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//==========================aD_Banner====================================================
#pragma mark
#pragma mark AdBannerView delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
	if (!adViewVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
        [self.view bringSubviewToFront:bannerView];
        
        float h = banner.frame.size.height;        
        CGRect frame1 = tableFrame;
        frame1.size.height -= h;// + 92;         
        CGRect frame2 = sliderFrame;
        frame2.origin.y -= h;          
        tableView.frame = frame1;
        sliderBar.frame = frame2;
        
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
        
        tableView.frame = tableFrame;
        sliderBar.frame = sliderFrame;
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
        
        float h = viewForWpBanner.frame.size.height;        
        CGRect frame1 = tableFrame;
        frame1.size.height -= h;         
        CGRect frame2 = sliderFrame;
        frame2.origin.y -= h;          
        tableView.frame = frame1;
        sliderBar.frame = frame2;        
        
        [UIView commitAnimations];
		wpViewVisible = TRUE;
	}
    
}




@end
