    //
//  ChannelsViewController.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
//#import "TVDataSingelton.h"
#import "ProgramsByCattegoryViewController.h"
#import "CustomTabBarItem.h"
#import "CommonFunctions.h"

#import "MTVShow.h"
#import "MTVChannel.h"
#import "SZAppInfo.h"

#import "WaitView.h"
//#import "UserTool.h"
#import "SSVProgressHUD.h"

#import "SZBannerManager.h"

//#define maxCatNumber 100

@interface CategoryViewController()
- (void)reloadTable;

@property (strong, nonatomic) WaitView *waitView;  //zs 
@end


@implementation CategoryViewController
{
    UIAlertView *progressAlert_;        
    WaitView *waitView_;  //zs 
    BOOL toReload;
    __block BOOL isCalc_;
}
//@synthesize tableView;

@synthesize waitView = waitView_;

@synthesize context = context_;
@synthesize tabData = tabData_;
@synthesize tableDict = tableDict_;
@synthesize selArrays = selArrays_;

//------------------------------------------------
-(void)channelsHaveBeenSelected 
{
    toReload = YES;
}

-(void)contextUpdated 
{
    toReload = YES;
    int si = self.navigationController.tabBarController.selectedIndex;
    _NSLog(@">>>Category_notif:DownloadingDataHasCompleted  si=%d",si);
    if (si == 1)
    {
//    if ([self.navigationController.tabBarController.selectedIndex == 
//    if ([self.view isFirstResponder]) { //foreground
//        _NSLog(@">>>notif:reload");    
        toReload = NO;
        [self reloadTable];               
    }
}
//------------------------------------------------


-(id) initWithTabBar
{
    self = [super init];
	if (self) {
		self.tabBarItem.title = @"Категории";
		self.tabBarItem.image = [UIImage imageNamed:@"catigories.png"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelsHaveBeenSelected) name: @"ChannelsHaveBeenSelected" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextUpdated) name:@"DownloadingDataHasCompleted" object:nil];     

        toReload = YES;
	}
	return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
- (void)loadView 
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor lightGrayColor];   
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Категории";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];//[UIColor redColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    
//    // ----iAd banner view-----
//    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];    
//    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
//    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
//    bannerView.delegate = self;
//    [self.view addSubview:bannerView];
//     
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [SZUtils color02];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 0);
    [self.view addSubview:mytableView];

    
#ifdef WillShowWpBanner
    _NSLog(@"add wp_banner_3");
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
    _NSLog(@"add ad_banner_3");  
    // ----iAd banner view-----
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];    
    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    adViewVisible = NO;
    [self.view sendSubviewToBack:bannerView];
#endif
    
    
    
//    self.waitView = [[WaitView alloc] initWithFrame:CGRectZero]; //zs
//    [self.view addSubview:self.waitView];
    
 //   [mytableView reloadData];
//    [self reloadTable];
}

-(void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
//    if (self.waitView == nil) {
//        self.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; //zs
//        [self.view.superview addSubview:self.waitView];                
//    }
    
//    if (toReload) {
        toReload = NO;
        [self reloadTable];
//    }
}

//==============================================================================
- (NSInteger)requestForCategory:(NSInteger)category dateMin:(NSDate*)minD dateMax:(NSDate*)maxD;
{
    //    uint64_t t1 = getTickCount();
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    fetchRequest.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K == %d)&&(%K >= %@)&&(%K < %@)", 
            @"rTVChannel.pSelected",  @"pCategory", category,  @"pStart",minD, @"pStart",maxD];
    [fetchRequest setPredicate:pred];  
    
    [fetchRequest setFetchLimit:1];
    
    NSError *error=nil;
    //    NSArray *res = [self.context executeFetchRequest:request error:&err];
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];    
    if (error) {
        _NSLog(@"ERROR"); 
        return 0;
    };
    //    uint64_t t2 = getTickCount();    
    //    _NSLog2(@"--get categoty_%d  = %d (%llu ms)>>>", category, count, (t2-t1));
    return count;
}

//==============================================================================

- (NSDictionary *)requestForData
{
//    _NSLog(@"--1-cat->>>");  
    self.selArrays = [SZCoreManager arrayOfNoSortSelectedChannels:self.context];
//    self.selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];
    NSDictionary *res;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:12];
    NSInteger idd,cat;
    
/*    
    NSInteger arrInd[maxCatNumber];
    for (idd=0; idd<maxCatNumber; idd++) 
        arrInd[idd]=0;
//    _NSLog(@"--21-[%d]->>>",[self.selArrays count]);     
    for (MTVChannel *chan in self.selArrays) 
    {
        NSSet *shw = chan.rTVShow;
//        NSArray *shww = [shw allObjects];
        for (MTVShow *sw in shw) {
            cat = sw.pCategory;
            if (cat < maxCatNumber) {
                if (arrInd[cat] > 0) {
//                    break;
                }   else {
                    arrInd[cat] = 1;
                }                
///                arrInd[cat]++;
            }
        }       
    }
*/    
    
    NSInteger arrInd[maxCatNumber];
    for (idd=0; idd<maxCatNumber; idd++) 
        arrInd[idd]=0;
    for (MTVChannel *chan in self.selArrays) 
    {
        NSInteger category = chan.pCategories; 
        NSInteger mask = 0x00000001;
//        NSInteger iddd = 0;
        for (idd = 0; idd<maxCatNumber; idd++) {
            if ((mask & category) > 0) {
                arrInd[idd] = 1;
            }
            mask = mask << 1;
//            if ((idd == 1) || (idd == 3)) {
//            } else {
//                iddd++;
//            }
        }        
    }
        
//    _NSLog(@"--22-->>>"); 

    NSString *currentDate = [[ModelHelper shared] dayForToday];        
    NSDate *dat1 = [[ModelHelper shared] dateFromDay:currentDate];
    NSDate *dat2 = [dat1 dateByAddingTimeInterval:24*60*60];
    
    for (idd=0; idd<maxCatNumber; idd++) {
        cat = arrInd[idd];
///        cat = [[SZAppInfo shared] numberOfCategory:idd]; 
        if (cat > 0) {
            NSNumber *val = [NSNumber numberWithInteger:cat];
            NSNumber *key = [NSNumber numberWithInteger:idd];
//            _NSLog(@" set_number:%@  for category:%@",val,key);
            [dict setObject:val forKey:key];
            
            NSInteger count = [self requestForCategory:idd dateMin:dat1 dateMax:dat2];
            NSNumber *val2 = [NSNumber numberWithInteger:count];
            NSNumber *key2 = [NSNumber numberWithInteger:idd+1000];
            [dict setObject:val2 forKey:key2];
            
        }
    }    
    res = [NSDictionary dictionaryWithDictionary:dict];
//    _NSLog(@"--3--[res=%d]->>>",[res count]);
//    _NSLog(@"%@",res);
    return res;
}


-(void)showProgress
{
    if (isCalc_) {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
        [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//      [waitView_ showWaitScreen];
    }
}


- (void)reallyReloadTable
{
    self.context = [[[SZAppInfo shared] coreManager] createContext];
    
//  UIAlertView *alert = [ModelHelper showProgressIndicator];
    
    [self performSelector:@selector(showProgress) withObject:nil afterDelay:0.3];
    
    isCalc_ = YES;
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{     
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{     
        self.tableDict = [self requestForData];
//      sleep(5); 
        dispatch_async(dispatch_get_main_queue(), ^{ 
            isCalc_ = NO;
            [mytableView reloadData];               
            [SSVProgressHUD dismiss];
//          [waitView_ hideWaitScreen];
        }); 
    });         
    
}

- (void)reloadTable 
{
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyReloadTable) object:nil];
    [self performSelector:@selector(reallyReloadTable) withObject:nil afterDelay:0.05];
////    [waitView_ showWaitScreen];
//    [SVProgressHUD show];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];    
}


//==============================================================================

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Категории" image:[UIImage imageNamed:@"catigories.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"catigories_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;   
}


//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    NSInteger res = [[TVDataSingelton sharedTVDataInstance] getNumberOfCategories];
    NSInteger res = 8; //10
    return res;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43; //zs 50
}

//--------------------------------------------------------------------------------
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    BOOL ok = NO;
    if ((self.tableDict != nil)&&([self.tableDict count] >0)) 
    {
        NSNumber *key = [NSNumber numberWithInteger:indexPath.row];
        NSNumber *val = [self.tableDict objectForKey:key]; 
//      _NSLog(@" get_number:%@  for category:%@",val,key);
        NSInteger idd = [val integerValue];
        if (idd > 0) {
            ok = YES;
        }
    }
    if (ok) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        
//        NSString *currentDate = [[ModelHelper shared] dayForToday];        
//        NSDate *dat1 = [[ModelHelper shared] dateFromDay:currentDate];
//        NSDate *dat2 = [dat1 dateByAddingTimeInterval:24*60*60];
//        NSInteger count = [self requestForCategory:indexPath.row dateMin:dat1 dateMax:dat2];
        
        NSNumber *key = [NSNumber numberWithInteger:indexPath.row + 1000];
        NSNumber *val = [self.tableDict objectForKey:key]; 
//      _NSLog(@" get_count:%@  for category:%@",val,key);
        NSInteger count = [val integerValue];
        if (count)
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;            
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor grayColor];
    }
///    NSString *catName = [[TVDataSingelton sharedTVDataInstance] getCategoryName:indexPath.row];
    NSString *catName =  [ModelHelper categoryName:indexPath.row];
    
///    _NSLog(@" cat_%d = (%@)",indexPath.row,catName);        
    cell.textLabel.text = catName; 
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ProgramsByCattegoryViewController *programController = [[ProgramsByCattegoryViewController alloc] init];
    
    NSString *catName = [ModelHelper categoryName:indexPath.row];
    NSString *date = [[ModelHelper shared] dayForToday];
 
//    programController.modalTransitionStyle = kModTranStyle;
//    [self presentModalViewController:programController animated:YES];

//    [programController updateDataForNewDay:date]; //zs
//    NSString *weekDay = getWeekDay(date);
//    programController.navigationItem.title = weekDay;
    programController.hidesBottomBarWhenPushed = YES;  //disable tab bar 
    [self.navigationController pushViewController:programController animated:YES]; //zs
            
    [programController setData:catName catId:indexPath.row forDate:date];    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


//==============================================================================
#pragma mark
#pragma mark AdBannerView delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
	if (!adViewVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:1.0]; //zs
        [self.view bringSubviewToFront:bannerView];
//        mytableView.frame = CGRectMake(0.0f, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(mytableView.frame), CGRectGetMinY(timeScrolling.frame) - CGRectGetMaxY(bannerView.frame));
        mytableView.frame = CGRectMake(0, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(mytableView.frame), 
                                       mytableView.frame.size.height - bannerView.frame.size.height);
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
        mytableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(mytableView.frame), mytableView.frame.size.height + bannerView.frame.size.height);
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
    _NSLog(@"loaded Wp_Banner_3_Info"); 
	if (!wpViewVisible) {
        [UIView beginAnimations:@"animateWpBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
        viewForWpBanner.hidden = NO;        
//        [self.view bringSubviewToFront:viewForWpBanner];
        
        mytableView.frame = CGRectMake(0, CGRectGetMaxY(viewForWpBanner.frame), 
                                     CGRectGetWidth(mytableView.frame),  mytableView.frame.size.height - viewForWpBanner.frame.size.height);
        
        [UIView commitAnimations];
		wpViewVisible = TRUE;
	}
    
}



@end


//http://stackoverflow.com/questions/1134289/cocoa-core-data-efficient-way-to-count-entities
