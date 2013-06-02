//
//  AllVisasVC.m
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "AllVisasVC.h"
#import "EntriesVC.h"
#import "FlurryAnalytics.h"
#import "FullVersionDescriptionVC.h"
#import "Utils.h"
#import "VisasVC.h"

@interface AllVisasVC() 
@property (nonatomic, retain) NSMutableArray *visasData;
@property (nonatomic, retain) UILabel *noVisasLabel;
@end

@implementation AllVisasVC
@synthesize visasData, noVisasLabel;

- (void)dealloc {
    [visaCell release];
    self.visasData = nil;
    self.noVisasLabel = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)cancelPressed {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[AppData sharedAppData].shopManager isBannerRemoved] && ![[AppData sharedAppData].shopManager isUserLucky])
    {
        if ([BannerManager isEnglishLocale])
        {
//            adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//            adBannerView.delegate = self;
//            adBannerView.requiredContentSizeIdentifiers = isSystemVersionMoreThen(4.2) 
//            ? [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait] : [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
//            adBannerView.currentContentSizeIdentifier = isSystemVersionMoreThen(4.2) 
//            ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50;
//            adBannerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(adBannerView.frame), CGRectGetHeight(adBannerView.frame));
//            //[self.view addSubview:adBannerView];
//            self.tableView.tableHeaderView = nil;
//            self.tableView.tableHeaderView = adBannerView;
//            //[self.tableView reloadData];
            
            [[AppData sharedAppData].bannerManager addAdBannerToTableView:self.tableView markedByNumber:1];
        }
        else
        {
            //TODO: changeid
//            [self.view addSubview:[AppData sharedAppData].bannerManager.wpBannerView1];
//            [[AppData sharedAppData].bannerManager.wpBannerView1 showFromTop:YES];
            
//            WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:6504];
//            WPBannerView *wpBannerView = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo]; 
//            wpBannerView.showCloseButton = NO;
//            wpBannerView.autoupdateTimeout = 10;
//            wpBannerView.delegate = self;
//            wpBannerView.hideWhenEmpty = NO;
//            wpBannerView.isMinimized = NO;
//            //[view addSubview:wpBannerView1];
//            [wpBannerView showFromTop:YES];
//            [wpBannerView reloadBanner];
//            self.tableView.tableHeaderView = nil;
//            self.tableView.tableHeaderView = wpBannerView;
//            [self.tableView reloadData];
            [[AppData sharedAppData].bannerManager addWPBannerToTableView:self.tableView markedByNumber:1];
            
            //[[AppData sharedAppData].bannerManager addWPBannerToView:self.view markedByNumber:1];
        }
    }
    
    self.noVisasLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40.0f, 180.0f, 240.0f, 40.0f)] autorelease];
    noVisasLabel.text = NSLocalizedString(@"No visas yet", @"no visas");
    noVisasLabel.backgroundColor = [UIColor clearColor];
    noVisasLabel.textColor = [UIColor colorWithRed:59.0/255.0f green:70.0/255.0f blue:84.0f/256.0f alpha:1.0f];
    noVisasLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    noVisasLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:noVisasLabel];
    self.visasData = [NSMutableArray array];
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
    
    
    self.navigationItem.title = NSLocalizedString(@"My visas", @"my visas");
    if (isSystemVersionMoreThen(5.0)) {
        for (UIView *v in self.navigationController.navigationBar.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UINavigationBarBackground")]) {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
                [v insertSubview:imageView atIndex:1];
                
            }
        }
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullVersionUnlocked) name:kInAppPurchaseUnlock object:nil];
    
}


- (NSString *)getRemainsDaysToDate:(NSDate *)date {
    NSString *res = [NSString stringWithFormat:NSLocalizedString(@"%d d.", @"days format"), 0];
    NSDate *now = [NSDate date];
    if (checkForNotNull(date) && [[cutTime(date) earlierDate:cutTime(now)] isEqualToDate:cutTime(now)]) {
        NSDictionary *monthAndDays = getDaysAndMonthNumBetweenDates(now, date);
        NSInteger monthNum = [[monthAndDays objectForKey:@"month"] intValue];
        NSInteger daysNum = [[monthAndDays objectForKey:@"day"] intValue];
        
        res = (monthNum != 0) ? [NSString stringWithFormat:NSLocalizedString(@"%d m. %d d.", @"date format"), monthNum, daysNum]
        : [NSString stringWithFormat:NSLocalizedString(@"%d d.", @"days format"), daysNum];
    }
    return res;
}

- (void)updateData {
    [self.visasData removeAllObjects];
    for (NSDictionary *visa in [AppData sharedAppData].visas) {
        NSString *code = [visa objectForKey:@"country"];
        NSString *country = getCountryNameByCode(code);
        NSDate *untilDate = [visa objectForKey:@"untilDate"];
        NSString *dates = configureDatesStrFromDates([visa objectForKey:@"fromDate"], untilDate);
        NSString *remains = [self getRemainsDaysToDate:untilDate];
        NSInteger dur = getDurationNumForVisa(visa);
        NSString *duration = [NSString stringWithFormat:NSLocalizedString(@"%d d.", @"days format"), dur];
        NSInteger numOfEntries = [visa objectForKey:@"entries"] != nil ? [[visa objectForKey:@"entries"] intValue] : 0;
        NSString *entries = (numOfEntries == NSIntegerMax) ? @"MULT" : [NSString stringWithFormat:@"%d", numOfEntries];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", country, @"country", untilDate, @"untilDate", dates, @"dates", remains, @"remains",
                              duration, @"duration", entries, @"entries", nil];
        [visasData addObject:data];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateData];
    noVisasLabel.hidden = visasData.count != 0;
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.visasData = nil;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return visasData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    VisaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"VisaCell" owner:self options:nil];
        cell = visaCell;
    }
    cell.delegate = self;
    
    NSDictionary *data = [visasData objectAtIndex:indexPath.section];
    cell.country = [data objectForKey:@"code"];
    cell.countryLabel.text = [data objectForKey:@"country"];
    cell.topColor = nil;
    
    NSDate *untilDate = [data objectForKey:@"untilDate"];
    cell.datesLabel.text = [data objectForKey:@"dates"];
    NSInteger beforeDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:0] intValue];   
    if (checkForNotNull(untilDate)) {
        NSDate *now = [NSDate date];
        if (![[[NSDate dateWithTimeInterval:24*60*60 sinceDate:untilDate] earlierDate:now] isEqualToDate:now]) {
            cell.topColor = RED_COLOR;
            cell.remainsLabel.textColor = RED_COLOR;
        }
        else if (daysBetweenDates([NSDate date], untilDate) < beforeDays) {
            cell.topColor = YELLOW_COLOR;
        }
    }
    
    cell.remainsLabel.text = [data objectForKey:@"remains"];
    cell.durationLabel.text = [data objectForKey:@"duration"];
    if ([[data objectForKey:@"duration"] intValue] == 0) {
        cell.durationLabel.textColor = RED_COLOR;
        cell.topColor = RED_COLOR;
    }
    
    NSInteger numOfEntries = [[data objectForKey:@"entries"] isEqualToString:@"MULT"] ? NSIntegerMax : [[data objectForKey:@"entries"] intValue];
    cell.entriesLabel.text = [data objectForKey:@"entries"];
    if (numOfEntries == 0) {
        //cell.entriesTextLabel.textColor = 
        cell.entriesLabel.textColor = RED_COLOR;
        cell.topColor = RED_COLOR;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *visa = [[AppData sharedAppData].visas objectAtIndex:indexPath.section];
    // go to visa main screen
    UITabBarController *tabBarController = [(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController];
    tabBarController.selectedIndex = 1;
    // scroll to selected visa
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UINavigationController *navVC = (UINavigationController *)[tabViewControllers objectAtIndex:1];
    [(VisasVC *)[navVC.viewControllers objectAtIndex:0] scrollToVisa:visa];
}

- (void)entriesBtnPressedForCountry:(NSString *)country {
    EntriesVC *entriesVC = [[[EntriesVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    entriesVC.country = country;
    [self.navigationController pushViewController:entriesVC animated:YES];
    
    [FlurryAnalytics logEvent:EVENT_VIEW_ENTRIES_LOG_PRESSED];
}

- (void)fullVersionUnlocked {
    [self.tableView reloadData];
}


//#pragma mark
//#pragma mark AdBannerView delegate
//
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
//    //NSLog(@"bannerViewDidLoadAd");
//	if (!isBannerVisible && ![[AppData sharedAppData].shopManager isBannerRemoved]) {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        //adBannerView.frame = CGRectOffset(adBannerView.frame, 0, -CGRectGetHeight(adBannerView.frame));
//        [UIView commitAnimations];
//		isBannerVisible = YES;
//	}
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    //iAds failed
//	//NSLog(@"%@",[error localizedDescription]);
//	if (isBannerVisible) {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        adBannerView.frame = CGRectOffset(adBannerView.frame, 0, CGRectGetHeight(adBannerView.frame));
//        [UIView commitAnimations];
//		isBannerVisible = NO;
//    }
//}
//
//- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
//	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
//	return YES;
//}
//
//- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
//	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
//}

@end
