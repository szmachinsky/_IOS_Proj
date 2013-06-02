//
//  AppDelegate.m
//  MyVisas
//
//  Created by Nnn on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutVC.h"
#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "AllVisasVC.h"
#import "EntriesVC.h"
#import "FlurryAnalytics.h"
#import "LocationManager.h"
#import "PassportVC.h"
#import "SettingsVC.h"
#import "Utils.h"
#import "VisasVC.h"

#define SavedHTTPCookiesKey @"SavedHTTPCookies"

@implementation TabBarItem
@synthesize selImage;

-(id) init {
    self = [super init];
    return self;
}

- (UIImage *)selectedImage {
    return self.selImage;
}

- (void)dealloc {
    self.selImage = nil;
    [super dealloc];
}

@end

@interface AppDelegate()
@property (nonatomic, retain) NSDictionary *currNoteDict;
@property (nonatomic, retain) NSDate *openDate;
@property (nonatomic, retain) UIImageView *splashScreenView;
@property (nonatomic, retain) NSMutableArray *schNotifications;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize locationManager;
@synthesize settingsChanged, currNoteDict, openDate, splashScreenView;
@synthesize schNotifications;

static const int RATE_ALERT_TAG = 8;

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    self.currNoteDict = nil;
    self.openDate = nil;
    self.splashScreenView = nil;
    self.schNotifications = nil;
    [super dealloc];
}

- (void)setCurrNoteDict:(NSDictionary *)noteDict {
    [currNoteDict release];
    currNoteDict = [noteDict retain];
}

- (void)askToRate:(BOOL)onlyMail {
    UIActionSheet *actionSheet = nil;
    if (onlyMail) {
        actionSheet = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Review My Visa", @"review my visa") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Later", @"later") 
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles:NSLocalizedString(@"Tell a Friend", @"Tell a Friend"), nil] autorelease];
    }
    else {
        actionSheet = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Review My Visa", @"review my visa") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Later", @"later") 
                                     destructiveButtonTitle:nil 
                                          otherButtonTitles:NSLocalizedString(@"Review Now", @"review now"), NSLocalizedString(@"Tell a Friend", @"Tell a Friend"), nil] autorelease];
    }
    [actionSheet showFromTabBar:_tabBarController.tabBar];
}

- (void)removeSplashScreen {
    [self.splashScreenView removeFromSuperview];
    self.splashScreenView = nil;
}

- (void)cancelNotifications {
    NSArray *notes = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *note in notes) {
        NSDate *lastDate = nil;
        NSString *type = [note.userInfo objectForKey:@"type"];
        if (type == nil) {
            lastDate = [note.userInfo objectForKey:@"untilDate"];
        }
        else if ([type isEqualToString:@"passport"]) {
            lastDate = [note.userInfo objectForKey:@"date"];
        }
        else if ([type isEqualToString:@"duration"]) {
            lastDate = [[note.userInfo objectForKey:@"info"] objectForKey:@"untilDate"];
        }
        
        NSDate *now = [NSDate date];
        if (![[[NSDate dateWithTimeInterval:24*60*60 sinceDate:lastDate] earlierDate:now] isEqualToDate:now]) {
            [[UIApplication sharedApplication] cancelLocalNotification:note];
        }
    }
}

- (void)showNextNotification {
    if (self.schNotifications.count != 0) {
        UILocalNotification *note = [self.schNotifications objectAtIndex:0];
        [[UIApplication sharedApplication] presentLocalNotificationNow:note];
        [self.schNotifications removeObjectAtIndex:0];
    }
}

- (void)showObjOfAlert {
    NSArray *tabViewControllers = self.tabBarController.viewControllers;
    UINavigationController *navVC = (UINavigationController *)[tabViewControllers objectAtIndex:1];
    VisasVC *visasVC = (VisasVC *)[navVC.viewControllers objectAtIndex:0];
    NSString *noteType = [self.currNoteDict objectForKey:@"type"];
    if (noteType == nil) {
        self.tabBarController.selectedIndex = 1;
        [visasVC scrollToVisa:(NSMutableDictionary *)self.currNoteDict];
    }
    else if ([noteType isEqualToString:@"duration"]) {
        NSDictionary *visaInfo = [self.currNoteDict objectForKey:@"info"];
        self.tabBarController.selectedIndex = 1;
        [visasVC scrollToVisa:(NSMutableDictionary *)visaInfo];
    }
    else if ([noteType isEqualToString:@"location"]) {
        self.tabBarController.selectedIndex = 1;
        [self scrollToVisaByCurrLocation];
    }
    else {
        self.tabBarController.selectedIndex = 2;
        UINavigationController *navVC = [self.tabBarController.viewControllers objectAtIndex:2];
        PassportVC *passportVC = [[[PassportVC alloc] init] autorelease];
        [navVC pushViewController:passportVC animated:NO];
    }
    self.currNoteDict = nil;
    handlingNotification = NO;
    [self performSelector:@selector(showNextNotification) withObject:nil afterDelay:2.0f];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey] != nil) {
        [self updateLocation];
    }
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil) {
        self.currNoteDict = [(UILocalNotification *)[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] userInfo];
        [self performSelector:@selector(showObjOfAlert) withObject:nil afterDelay:0.0f];
        [AppData sharedAppData].lastLocation = [NSDictionary dictionary];
        [AppData sharedAppData].locationHandled = YES;
        //[AppData sharedAppData].isOnEdit = NO;
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // tab bar view controllers
    UIViewController *viewController1 = [[[AllVisasVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UIViewController *viewController2 = [[[VisasVC alloc] init] autorelease];
    UIViewController *viewController3 = [[[SettingsVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UIViewController *viewController4 = [[[AboutVC alloc] init] autorelease];
    
    UINavigationController *navVC = [[[UINavigationController alloc] initWithRootViewController:viewController3] autorelease];
    UINavigationController *navVC2 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    UINavigationController *mainNavVC = [[[UINavigationController alloc] initWithRootViewController:viewController2] autorelease];
    UINavigationController *navVC3 = [[[UINavigationController alloc] initWithRootViewController:viewController4] autorelease];
    [mainNavVC setNavigationBarHidden:YES animated:NO];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navVC2, mainNavVC, navVC, navVC3, nil];
    self.tabBarController.selectedIndex = 1;
    
    // custom tab bar items
    TabBarItem *item = [[[TabBarItem alloc] initWithTitle:NSLocalizedString(@"My visas", @"my visas") image:[UIImage imageNamed:@"summ_icon.png"] tag:0] autorelease];
    item.selImage = [UIImage imageNamed:@"summ_icon.png"];
    viewController1.tabBarItem = item;
    
    TabBarItem *item2 = [[[TabBarItem alloc] initWithTitle:NSLocalizedString(@"Visa", @"visa") image:[UIImage imageNamed:@"visa_icon.png"] tag:0] autorelease];
    item2.selImage = [UIImage imageNamed:@"visa_icon.png"];
    viewController2.tabBarItem = item2;
    
    TabBarItem *item3 = [[[TabBarItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"settings") image:[UIImage imageNamed:@"sett_icon.png"] tag:0] autorelease];
    item3.selImage = [UIImage imageNamed:@"sett_icon.png"];
    navVC.tabBarItem = item3;
    
    TabBarItem *item4 = [[[TabBarItem alloc] initWithTitle:NSLocalizedString(@"About", @"about") image:[UIImage imageNamed:@"info_icon.png"] tag:0] autorelease];
    item4.selImage = [UIImage imageNamed:@"info_icon.png"];
    viewController4.tabBarItem = item4;
    
    // tab bar back image
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom.png"]] autorelease];
    [self.tabBarController.tabBar insertSubview:imageView atIndex:isSystemVersionMoreThen(5.0) ? 1 : 0];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    // splash screen 
    self.splashScreenView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"splash.png"]] autorelease];
    [self.window addSubview:self.splashScreenView];
    [self performSelector:@selector(removeSplashScreen) withObject:nil afterDelay:4.0f];
    
    if ([AppData sharedAppData].isLocationOn) {
        [self updateLocation];
    }
    
    self.schNotifications = [NSMutableArray array];
    
    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    [FlurryAnalytics startSession:@"KRP3RI5PMIDFU35QEHHZ"];
    [FlurryAnalytics setUserID:udid];
    
//    if (![facebook isSessionValid]) {
//        NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                @"user_likes", 
//                                @"publish_stream",
//                                @"read_stream",
//                                nil];
//        [facebook authorize:permissions];
//        [permissions release];
//    }
    
    return YES;
}

- (void)showLocationAlert:(NSString *)alertText {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"MyVisas" message:alertText delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)checkIfAskToRateShouldBeShown {
    // ask user to rate app
    actionSheetShown = YES;
    BOOL appRated = [AppData sharedAppData].appRated;
    BOOL mailSend = [AppData sharedAppData].mailToFriendSend;
    NSTimeInterval timeFromLastLaunch = [self.openDate timeIntervalSinceDate:[AppData sharedAppData].lastDateOpened];
    if (!appRated && timeFromLastLaunch >= 7*24*60*60) {
        [self askToRate:NO];
    } else if (appRated && !mailSend && timeFromLastLaunch >= 14*24*60*60) {
        [self askToRate:YES];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.openDate = [NSDate date];
    NSDate *lastOpened = [AppData sharedAppData].lastDateOpened;
    if (isNewDay(lastOpened)) {
        [self cancelNotifications];
    }
    [self updateLocation];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (![AppData sharedAppData].locationHandled && [[AppData sharedAppData].lastLocation allKeys].count != 0) {
        NSString *alertText = [[AppData sharedAppData].lastLocation objectForKey:@"text"];
        alertText = [alertText substringToIndex:[alertText rangeOfString:@"."].location];
        alertText = [NSString stringWithFormat:NSLocalizedString(@"%@ You can enter information to visa.", @"You can enter information to visa"), alertText];
        
        NSString *countryCode = [[AppData sharedAppData].lastLocation objectForKey:@"countryCode"];
        for (NSMutableDictionary *visa in [AppData sharedAppData].visas) {
            if ([[visa objectForKey:@"country"] isEqualToString:countryCode]) {
                self.tabBarController.selectedIndex = 1;
                NSArray *tabViewControllers = self.tabBarController.viewControllers;
                UINavigationController *navVC = (UINavigationController *)[tabViewControllers objectAtIndex:1];
                VisasVC *visasVC = (VisasVC *)[navVC.viewControllers objectAtIndex:0];
                [visasVC scrollToVisa:visa];
                [self performSelector:@selector(showLocationAlert:) withObject:alertText afterDelay:0.5f];
                break;
            }
        }
        [AppData sharedAppData].lastLocation = [NSDictionary dictionary];
        [AppData sharedAppData].locationHandled = YES;
    }
    
    if (!actionSheetShown) {
        [self performSelector:@selector(checkIfAskToRateShouldBeShown) withObject:nil afterDelay:4.0f];
    }
    
    [FlurryAnalytics logEvent:EVENT_APP_OPENED_TIME timed:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[AppData sharedAppData] save];
    [AppData sharedAppData].lastDateOpened = self.openDate;
    
    [FlurryAnalytics endTimedEvent:EVENT_APP_OPENED_TIME withParameters:nil];
}

- (void)switchOffLocationServices {
    [self.locationManager.manager stopUpdatingLocation];
}

- (void)updateLocation {
    // initialize location manager
    if (self.locationManager == nil) {
        self.locationManager = [[[LocationManager alloc] init] autorelease];
    }
    
    // location setting set to ON
    if ([AppData sharedAppData].isLocationOn) {
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager.manager startUpdatingLocation];
            CLLocationDistance distanceToDetermine = 5000.0f;
            self.locationManager.manager.distanceFilter = distanceToDetermine;
        }
        else {
            [self.locationManager showLocationErrorAlert];
        }
    }
    else {
        // location setting set to OFF
        [self switchOffLocationServices];
    }
}

#pragma mark -
#pragma mark Notifications

- (void)recreateNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([[[AppData sharedAppData].showAlerts objectAtIndex:2] boolValue]) {
        // configure notification for passport
        [self createNotificationForPassport];
    }
    if ([[[AppData sharedAppData].showAlerts objectAtIndex:0] boolValue]) {
        // configure notification for all visas
        for (NSMutableDictionary *visa in [AppData sharedAppData].visas) {
            [self createNotificationForVisa:visa];
        }
    }
    if ([[[AppData sharedAppData].showAlerts objectAtIndex:1] boolValue]) {
        // configure notification for duration
        [self createNotificationForDuration];
    }
}

- (NSTimeInterval)intervalForTime:(NSString *)timeStr {
    BOOL isPM = [timeStr rangeOfString:@"PM"].location != NSNotFound;
    BOOL isAM = [timeStr rangeOfString:@"AM"].location != NSNotFound;
    
    NSArray *timeComponents = [timeStr componentsSeparatedByString:@":"];
    NSInteger hours = [[timeComponents objectAtIndex:0] intValue];
    NSInteger min   = [[timeComponents objectAtIndex:1] intValue];
    NSTimeInterval timeInt = hours*60*60 + min*60;
    if (isPM && hours != 12) {
        timeInt += 12*60*60;
    }
    if (isAM && hours == 12) {
        timeInt -= 12*60*60;
    }
    
    return  timeInt;
}

- (void)createNotificationForVisa:(NSMutableDictionary *)visaData {
    NSInteger beforeDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:0] intValue];
    NSDate *expiryDate = [visaData objectForKey:@"untilDate"];
    NSInteger repeatDays = [[[AppData sharedAppData].repeatDays objectAtIndex:0] intValue];
    
    // alerts start date
    NSTimeInterval interval = beforeDays*24*60*60 - [self intervalForTime:[[AppData sharedAppData].alertsTime objectAtIndex:0]];
    NSDate *startDate = [NSDate dateWithTimeInterval:-interval sinceDate:expiryDate];
    
    // calculation of notification fire date
    BOOL addNotification = NO;
    NSDate *noteDate = nil;
    if (checkForNotNull(expiryDate)) {
        NSInteger daysDiff = daysBetweenDates([NSDate date], expiryDate);
        if (daysDiff > beforeDays) {
            // date for first notification
            addNotification = YES;
            noteDate = startDate;
        }
        else {
            if (daysDiff >= 0) {
                NSInteger daysToRepeat = repeatDays == 1 ? 1 : 7;
                if (repeatDays > 0)
                {
                    NSDate *nextDate = [NSDate dateWithTimeInterval:daysToRepeat*24*60*60 sinceDate:startDate];
                    
                    while ([[nextDate earlierDate:cutTime([NSDate date])] isEqualToDate:nextDate]) {
                        nextDate = [NSDate dateWithTimeInterval:daysToRepeat*24*60*60 sinceDate:nextDate];
                    }
                    
                    if ([[nextDate earlierDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:expiryDate]] isEqualToDate:nextDate]) {
                        addNotification = YES;
                        noteDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:nextDate];
                    }
                }
                else
                {
                    startDate = [NSDate dateWithTimeInterval:[self intervalForTime:[[AppData sharedAppData].alertsTime objectAtIndex:0]] sinceDate:cutTime([NSDate date])];
                    NSDate *nextDate = [NSDate dateWithTimeInterval:(daysDiff-beforeDays+1)*24*60*60 sinceDate:startDate];
                    NSDate *currDate = [NSDate date];
                    if ([[nextDate earlierDate:currDate] isEqualToDate: currDate])
                    {
                        addNotification = YES;
                        noteDate = nextDate;
                    }
                }
            }
        }   
    }
    
    if (addNotification) {
        UILocalNotification *localNote = [[[UILocalNotification alloc] init] autorelease];
        localNote.userInfo = visaData;
        localNote.fireDate = noteDate;
        localNote.soundName = UILocalNotificationDefaultSoundName;
        localNote.applicationIconBadgeNumber = 1;
        if (repeatDays != 0) {
            localNote.repeatInterval = repeatDays == 1 ? NSDayCalendarUnit : NSWeekCalendarUnit;
        }
        NSString *country = getCountryNameByCode([visaData objectForKey:@"country"]);
        localNote.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Visa to %@ expiry %@", @"visa expiry"), country, formattedDate(expiryDate, YES)];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
}

- (void)changeNotificationForVisa:(NSMutableDictionary *)visaData {
    BOOL showAlert = [[[AppData sharedAppData].showAlerts objectAtIndex:0] boolValue];
    if (showAlert) {
        NSInteger visaNum = [[visaData objectForKey:@"num"] intValue];
        NSDate *expiryDate = [visaData objectForKey:@"untilDate"];
        NSArray *notific = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        if (checkForNotNull(expiryDate)) {
            // search if notification for visa exist
            BOOL shouldChange = YES;
            for (UILocalNotification *note in notific) {
                NSDictionary *noteInfo = note.userInfo;
                NSInteger num = [[noteInfo objectForKey:@"num"] intValue];
                NSDate *noteDate = [noteInfo objectForKey:@"untilDate"];
                if (num == visaNum) {
                    shouldChange = ![expiryDate isEqualToDate:noteDate];
                    if (shouldChange) {
                        // expiry date was changed, delete old notification
                        [[UIApplication sharedApplication] cancelLocalNotification:note];
                    }
                }
            }
            if (shouldChange) {
                [self createNotificationForVisa:visaData];
            }
        }
    }
}

- (void)createNotificationForPassport {
    // delete old notification if it exists
    NSArray *notific = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *note in notific) {
        NSDictionary *info = note.userInfo;
        if ([[info objectForKey:@"type"] isEqualToString:@"passport"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:note];
        }
    }
    
    NSDate *passportExpiryDate = [[AppData sharedAppData].passportInfo objectForKey:@"expiryDate"];
    NSInteger beforeDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:2] intValue];
    NSInteger repeatNum = [[[AppData sharedAppData].repeatDays objectAtIndex:2] intValue];
    
    // start notification date
    NSTimeInterval interval = beforeDays*24*60*60 - [self intervalForTime:[[AppData sharedAppData].alertsTime objectAtIndex:2]];
    NSDate *startDate = [NSDate dateWithTimeInterval:-interval sinceDate:passportExpiryDate];
    
    // calculation of fire date
    BOOL addNotification = NO;
    NSDate *noteDate = nil;
    NSInteger daysDiff = daysBetweenDates([NSDate date], passportExpiryDate);
    if (daysDiff >= beforeDays) {
        addNotification = YES;
        noteDate = startDate;
    }
    else if (daysDiff >= 0 && repeatNum > 0) {
        NSInteger repeatDays = (repeatNum == 2) ? 7 : 30;
        NSDate *nextDate = [NSDate dateWithTimeInterval:repeatDays*24*60*60 sinceDate:startDate];
        while ([[nextDate earlierDate:[NSDate date]] isEqualToDate:nextDate]) {
            nextDate = [NSDate dateWithTimeInterval:repeatDays*24*60*60 sinceDate:nextDate];
        }
        if ([[nextDate earlierDate:passportExpiryDate] isEqualToDate:nextDate]) {
            addNotification = YES;
            noteDate = nextDate;
        }
    }
    
    if (addNotification) {
        // create new notification
        UILocalNotification *note = [[[UILocalNotification alloc] init] autorelease];
        note.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"passport", @"type", passportExpiryDate, @"date", nil];
        note.fireDate = [NSDate dateWithTimeInterval:60.0f sinceDate:noteDate];
        note.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Your passoprt will expiry %@", @"passort notification"), formattedDate(passportExpiryDate, YES)];
        note.soundName = UILocalNotificationDefaultSoundName;
        if (repeatNum > 0) {
            note.repeatInterval = (repeatNum == 2) ? NSWeekCalendarUnit : NSMonthCalendarUnit;
        }
        note.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:note];
    }
}

- (void)createNotificationForDuration {
    // delete old notification
    NSArray *notific = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *note in notific) {
        NSDictionary *info = note.userInfo;
        if ([[info objectForKey:@"type"] isEqualToString:@"duration"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:note];
        }
    }
    
    BOOL addNotification = NO;
    NSDate *noteDate = nil;
    NSInteger beforeDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:1] intValue];
    NSInteger repeatDays = [[[AppData sharedAppData].repeatDays objectAtIndex:1] intValue];
    for (NSDictionary *visa in [AppData sharedAppData].visas) {
        if ([visa objectForKey:@"nowInCountry"]) {
            // start notification date
            NSInteger duration = getDurationNumForVisa(visa);
            NSInteger diff = duration - beforeDays;
            NSDate *startDate = [NSDate dateWithTimeInterval:[self intervalForTime:[[AppData sharedAppData].alertsTime objectAtIndex:1]] sinceDate:cutTime([NSDate date])];

            if (diff >= beforeDays)
            {
                addNotification = YES;
                startDate = [NSDate dateWithTimeInterval:diff*24*60*60 sinceDate: startDate];
                noteDate = startDate;
            }
            else if (duration >= 0)
            {
                if (repeatDays > 0)
                {
                    NSDate *nextDate = startDate;
                    while ([[nextDate earlierDate:[NSDate date]] isEqualToDate:nextDate]) {
                        nextDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:nextDate];
                    }
                    if ([[nextDate earlierDate:[NSDate dateWithTimeInterval:(duration + 1)*24*60*60 sinceDate:[NSDate date]]] isEqualToDate:nextDate]) {
                        addNotification = YES;
                        noteDate = nextDate;
                    }
                }
                else
                {
                    NSDate *nextDate = [NSDate dateWithTimeInterval:(diff)*24*60*60 sinceDate:startDate];
                    NSDate *currDate = [NSDate date];
                    if ([[nextDate earlierDate:currDate] isEqualToDate: currDate])
                    {
                        addNotification = YES;
                        noteDate = nextDate;
                    }
                }
            }
            if (addNotification) {
                UILocalNotification *note = [[[UILocalNotification alloc] init] autorelease];
                note.fireDate = noteDate;
                if (repeatDays != 0) {
                    note.repeatInterval = NSDayCalendarUnit;
                }
                note.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"duration", @"type", visa, @"info", nil];
                NSString *country = getCountryNameByCode([visa objectForKey:@"country"]);
                note.alertBody = [NSString stringWithFormat:NSLocalizedString(@"You can stay in %@ less than %d days.", @"duration notification"), beforeDays, country];
                note.soundName = UILocalNotificationDefaultSoundName;
                note.applicationIconBadgeNumber = 1;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:note];
            }
        }
        break;
    }
}

- (void)scrollToVisaByCurrLocation {
    for (NSMutableDictionary *visa in [AppData sharedAppData].visas) {
        if ([[visa objectForKey:@"country"] isEqualToString:[AppData sharedAppData].currCountry]) {
            NSArray *tabViewControllers = self.tabBarController.viewControllers;
            UINavigationController *navVC = (UINavigationController *)[tabViewControllers objectAtIndex:1];
            VisasVC *visasVC = (VisasVC *)[navVC.viewControllers objectAtIndex:0];
            [visasVC scrollToVisa:visa];
            break;
        }
    }
}

- (void)handleNotification:(UILocalNotification *)notification {
    NSDictionary *noteData = notification.userInfo; 
    self.currNoteDict = noteData;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"MyVisas" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"View", @"view"), nil] autorelease];
        if ([[noteData objectForKey:@"type"] isEqualToString:@"passport"]) {
            alert.message = NSLocalizedString(@"Your passoprt will expiry %@", @"passort notification");
            [alert show];
        }
        else if ([[noteData objectForKey:@"type"] isEqualToString:@"duration"]) {
            NSString *country = getCountryNameByCode([(NSDictionary *)[noteData objectForKey:@"info"] objectForKey:@"country"]);
            alert.message = [NSString stringWithFormat:NSLocalizedString(@"You can stay in %@ less than 3 days.", @"duration notification"), country];
            [alert show];
        }
        else if ([[noteData objectForKey:@"type"] isEqualToString:@"location"]) {
            self.tabBarController.selectedIndex = 1;
            [self scrollToVisaByCurrLocation];
        }
        else {
            NSString *country = getCountryNameByCode([noteData objectForKey:@"country"]);
            NSDate *expiryDate = [noteData objectForKey:@"untilDate"];
            alert.message = [NSString stringWithFormat:NSLocalizedString(@"Visa to %@ expiry %@", @"visa expiry"), country, formattedDate(expiryDate, YES)];
            [alert show];
        }
    }
    else {
        [self performSelector:@selector(showObjOfAlert) withObject:nil afterDelay:0.0f];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (handlingNotification) {
        [schNotifications addObject:notification];
    }
    else {
        [self handleNotification:notification];
    }
    
    if ([[notification.userInfo objectForKey:@"type"] isEqualToString:@"location"]) {
        [AppData sharedAppData].lastLocation = [NSDictionary dictionary];
        [AppData sharedAppData].locationHandled = YES;
    }
    handlingNotification = YES;
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
    [self cancelNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self updateLocation];
    
//    // Save cookies
//    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//    [[NSUserDefaults standardUserDefaults] setObject:cookiesData
//                                              forKey:SavedHTTPCookiesKey];
    
}

#pragma mark - Alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != RATE_ALERT_TAG) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self showObjOfAlert];
        }
        self.currNoteDict = nil;
        handlingNotification = NO;
        [self performSelector:@selector(showNextNotification) withObject:nil afterDelay:2.0f];
    }
}

#pragma mark - Action sheet delegate

- (void)sendMail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[[MFMailComposeViewController alloc] init] autorelease];
        mailVC.mailComposeDelegate = self;
        [mailVC setSubject:NSLocalizedString(@"Check out this app", @"check out this app")];
        [mailVC setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"Mail", @"tell a friend mail"), APP_STORE_URL] isHTML:YES];
        
        UIViewController *currVC = _tabBarController.selectedViewController;
        [currVC presentModalViewController:mailVC animated:YES];
    }
    else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail is not configured", @"mail is not configured") message:NSLocalizedString(@"Please, configure mail account", @"please configure mail account") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"ok") otherButtonTitles:nil] autorelease];
        [alertView show];
    }
    
    [FlurryAnalytics logEvent:EVENT_SEND_MAIL_PRESSED];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL appRated = [AppData sharedAppData].appRated;
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if ((appRated && buttonIndex == 0) || (!appRated && buttonIndex == 1)) {
            [self sendMail];
        } else {
            [FlurryAnalytics logEvent:EVENT_RATE_IT_PRESSED];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:APP_STORE_URL_FORMAT, APP_STORE_ID]];
            [[UIApplication sharedApplication] openURL:url];
            [AppData sharedAppData].appRated = YES;
        }
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
}

#pragma mark - Mail composer delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail is not sent", @"mail is not sent") message:NSLocalizedString(@"Fail to send mail.", @"fail to send mail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"ok") otherButtonTitles:nil] autorelease];
        [alertView show];
    } else if (result == MFMailComposeResultSent) {
        [AppData sharedAppData].mailToFriendSend = YES;
    }
}

@end
