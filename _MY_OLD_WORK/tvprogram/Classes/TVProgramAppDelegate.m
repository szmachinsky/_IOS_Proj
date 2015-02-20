//
//  TVProgramAppDelegate.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVProgramAppDelegate.h"
#import "GuideViewController.h"
#import "CategoryViewController.h"
//#import "SettingsViewController.h"
#import "FavoriteViewController.h"
#import "AlarmsViewControllers.h"
#import "TVDataSingelton.h"
#import "ServerManager.h"
#import "Reachability.h"
#import "CommonFunctions.h"
#import "CustomTabBarItem.h"

#import "SZCoreManager.h"
#import "CreateChannels.h"
#import "SZAppInfo.h"
#import "ModelHelper.h"

///#import "ChannelsConfigController.h"
#import "SZChannelsConfigController.h" //zs

#import "SSVProgressHUD.h"

#import "ReloadViewController.h"

BOOL isSystemVersionMoreThen(CGFloat version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= version;
}


@implementation TVProgramAppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize progressAlert = progressAlert_;

@synthesize currNoteDict, schNotifications;

#pragma mark - Notifications
//--------------------------- selectChannels ------------------------------------------------
- (void) _selectChannels:(NSNotification* )note
{
    channelsConfigController = [[SZChannelsConfigController alloc] init];
    
//    channelsConfigController.view.frame = [[UIScreen mainScreen] applicationFrame];
///    channelsConfigController.isChanged = YES;
    
///    channelsConfigController.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext];
    channelsConfigController.hidesBottomBarWhenPushed = YES;  //disable tab bar
    
    UINavigationController *selecetedVC = (UINavigationController *)tabBarController.selectedViewController;
    [selecetedVC pushViewController:channelsConfigController animated:YES];
    
//    self.tabBarController.selectedIndex = 4;
//    UINavigationController *selecetedVC = (UINavigationController *)tabBarController.selectedViewController;
//    SettingsViewController *vc = [selecetedVC.viewControllers objectAtIndex:0];
//    [vc selectChannels];
}

- (void) selectChannels: (NSNotification* )note {
    [self performSelectorOnMainThread:@selector(_selectChannels:) withObject:note waitUntilDone:NO];          
}

//--------------------------- channelsHaveBeenSelected ----------------------------------------

- (void) _channelsHaveBeenSelected:(NSNotification* )note 
{
/// UINavigationController *nav = (UINavigationController *)[tabBarController selectedViewController];
    //number of channels were changed by settings
//    id poster = [note object];
/// _NSLog(@"%@",poster);
/// if([[nav.viewControllers objectAtIndex:0] isKindOfClass:[SettingsViewController class]])
//  if( [poster isMemberOfClass:[ChannelsConfigController class]] || 
    _NSLog(@">AppDelegate_got: _channelsHaveBeenSelected!!! ");  
    
//    [self.progressAlert dismissWithClickedButtonIndex:0 animated:YES];
//    self.progressAlert = nil;
//    [self _updateStart];
//    return;
     
    if ( [[note object] isMemberOfClass:[SZChannelsConfigController class]] ) 
//    if (YES) 
    {
        
        NSString *todayDay = [[ModelHelper shared] dayForToday];
        NSArray *maskDate = [NSArray arrayWithObject:todayDay];
        controller.maskForDateLoading = maskDate; //load for today only!!!
//        controller.maskForDateLoading = nil;
        [TVDataSingelton sharedTVDataInstance].currentState = eIndexParse;
        [controller updateChannelsData];       
    }
    //channels were selected from the list
    else {
        //download data for each channel
        [controller downloadAllChannelsData:NO];
    }
}

- (void)reallyChannelsHaveBeenSelected:(NSNotification* )note
{
    [self performSelector:@selector(_channelsHaveBeenSelected:) withObject:note afterDelay:0.5];    
}

- (void) channelsHaveBeenSelected:(NSNotification* )note 
{
//    id poster = [note object];
    [self performSelectorOnMainThread:@selector(reallyChannelsHaveBeenSelected:) withObject:note waitUntilDone:NO];          
}

//--------------------------- updateStart ----------------------------------------------
-(void) _updateStart
{ 
    static NSInteger scUpdate = 0;
    
    scUpdate++;
    _NSLog(@"==update_start=>> %d set show alert",scUpdate); 
    
    NSString *str = @"загрузка данных";
    
//    if ((scUpdate % 3) == 1) 
//        str = @"загрузка данных..";
//    if ((scUpdate % 3) == 2) 
//        str = @"загрузка данных...";

//    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeGradient];
//    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeNone];
    [SSVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
    return;
      
} 

//-(void)reallyUpdateStart
//{
//    [self performSelector:@selector(_updateStart) withObject:nil afterDelay:0.5];
//}

-(void) updateStart:(NSNotification *)note
{ 
    [self performSelectorOnMainThread:@selector(_updateStart) withObject:nil waitUntilDone:NO];          
}

//--------------------------- updateComplete ---------------------------------------------
-(void)saveArchive
{
//    uint64_t t1 = getTickCount();    
    _NSLog(@">-really save Archive1");
    
    [[TVDataSingelton sharedTVDataInstance] saveData];  //save archive
    
//    uint64_t t2 = getTickCount();
//    _NSLog(@">-really save Archive2-(%llu)",(t2-t1));
}

-(void)switchToTabBarController
{
//    self.tabBarController.selectedIndex = 2;
}

-(void)reallyUpdateComplete
{
//    _NSLog(@">>>AppDelegate_got:do: reallySaveData to archive!!!");
//    [[TVDataSingelton sharedTVDataInstance] saveData];
//    [self performSelectorInBackground:@selector(saveArchive) withObject:nil];
    _NSLog(@"--really_update_complete->>send ContextUpdateCompleted");    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ContextUpdateCompleted" object:nil]]; 
    [self performSelector:@selector(switchToTabBarController) withObject:nil afterDelay:0.1];
}

-(void) _updateComplete:(NSNotification *)note
{
    _NSLog(@"--update_complete->>hide alert");
    
    [SSVProgressHUD dismiss];    
    
//    [[TVDataSingelton sharedTVDataInstance] saveData];
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ContextUpdateCompleted" object:nil]]; 

    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyUpdateComplete) object:nil];
    [self performSelector:@selector(reallyUpdateComplete) withObject:nil afterDelay:0.3];
}

-(void) updateComplete:(NSNotification *)note
{ 
    _NSLog(@">AppDelegate_got: updateComplete!!! ");
    [self performSelectorOnMainThread:@selector(_updateComplete:) withObject:note waitUntilDone:NO];          
}


//--------------------------- DownloadingDataHasCompleted ---------------------------------------------


-(void) _downloadComplete:(NSNotification *)note
{ 
    _NSLog(@">AppDelegate_got: _downloadComplete!!! ");
    
    [SSVProgressHUD dismiss];    
    
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyUpdateComplete) object:nil];
    [self performSelector:@selector(reallyUpdateComplete) withObject:nil afterDelay:0.2];
    
    [self performSelectorInBackground:@selector(saveArchive) withObject:nil]; 
}


-(void) downloadComplete:(NSNotification *)note
{ 
    _NSLog(@">AppDelegate_got: downloadComp!!! ");
    [self performSelectorOnMainThread:@selector(_downloadComplete:) withObject:note waitUntilDone:NO];          
}



#pragma mark Application lifecycle
//======================================================================================================
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{   
//    uint64_t t1 = getTickCount();
    NSLog(@"app_path=/%@/",NSHomeDirectory());
    
    [self copyResurce:@"index.json" toDir:@"Documents"];
    [self copyResurce:@"tvdata.archive" toDir:@"Documents"];
    [self copyResurce:@"TVProgram.sqlite" toDir:@"Documents"];
    
    
    [window setBackgroundColor:[SZUtils color001]];
    NSLog(@"-----App_Load-Begin---");    
//zs---------    
    [[SZAppInfo shared] createCoreManagerWithDataFile:@"TVProgram.sqlite" Model:@"TVModel"]; //create Core Data controllers
//    _NSLog(@"-----App_Load-1---");    
    
    coreM_ = [SZAppInfo shared].coreManager;
//    _NSLog(@"-----App_Load-2---");  
    NSManagedObjectContext* context = [[SZAppInfo shared].coreManager createContext];
    NSInteger colSel = [SZCoreManager numberOfSelectedChannels:context];
    [SZAppInfo shared].colSelChannels = colSel;
    
    controller = [ServerManager sharedManager];  ;//[[ServerManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectChannels:) name:@"SelectChannels" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelsHaveBeenSelected:) name: @"ChannelsHaveBeenSelected" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStart:) name:@"UpdateStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComplete:) name:@"UpdateComplete" object:nil];
            
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadComplete:) name:@"DownloadingDataHasCompleted" object:nil]; //zs   
    
    application.applicationIconBadgeNumber = 0;
    
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) {    
    // Handle launching from a notification
        UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (localNotif) {
            _NSLog(@"!!Recieved Notification %@",localNotif);
        }
    }
    
    // Override point for customization after application launch.

	UINavigationController *localNavigationController;
	
	tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
	NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
	
    // tab bar back 
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tapbar.png"]]; //top.png
    imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 49.0f);
    imageView.contentMode = UIViewContentModeScaleToFill;
    
///    [self.tabBarController.tabBar insertSubview:imageView atIndex:isSystemVersionMoreThen(5.0) ? 1 : 0];    
    UITabBar *tabBar = [tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        [tabBar insertSubview:imageView atIndex:1];
//        tabBar.contentMode = UIViewContentModeScaleToFill;
//        [tabBar setBackgroundImage:[UIImage imageNamed:@"top.png"]];        
    }
    else    { // ios 4 code here
        [tabBar insertSubview:imageView atIndex:0];
    }    
    
    UIColor *navColor = [SZUtils color002];
    
    UIImage *image = [UIImage imageNamed:@"top_panel.png"];
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    //favorite
	FavoriteViewController *favViewController = [[FavoriteViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:favViewController];
//	favViewController.navigationController.navigationBar.tintColor = navColor;
    localNavigationController.navigationBar.tintColor = navColor;
    [localControllersArray addObject:localNavigationController];
    
        
	//category
	CategoryViewController *secondViewController = [[CategoryViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
	[localControllersArray addObject:localNavigationController];
    secondViewController.navigationController.navigationBar.tintColor = navColor;
    
    
 	//now page
	GuideViewController *myViewController;
	myViewController = [[GuideViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:myViewController];
	myViewController.navigationController.navigationBar.tintColor = navColor;
    [localControllersArray addObject:localNavigationController];
	
   
    // emptry VC for refresh button in tab bar
//    UIViewController *vc = [[UIViewController alloc] init];
    ReloadViewController *reloadViewController = [[ReloadViewController alloc] initWithTabBar];
    localNavigationController = [[UINavigationController alloc] initWithRootViewController:reloadViewController];
	reloadViewController.navigationController.navigationBar.tintColor = navColor;
    [localControllersArray addObject:localNavigationController];

	//settings
	SettingsViewController * thirdViewController = [[SettingsViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    thirdViewController.navigationController.navigationBar.tintColor = navColor;
	[localControllersArray addObject:localNavigationController];

	tabBarController.viewControllers = localControllersArray;
    
    handlingNotification = NO;
    self.schNotifications = [NSMutableArray array]; //zs
    
	
///	[window addSubview:tabBarController.view];
    self.window.rootViewController = tabBarController;
        
    [self.window makeKeyAndVisible];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"UpdateStart" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdate:) name:@"UpdateComplete" object:nil];
    
//    uint64_t t2 = getTickCount();
//    _NSLog(@"-----App_Load-End------(%llu ms)-",(t2-t1));
    
//  [self copyResurce:@"blue_1.png" toDir:@"Documents"];
    
//    [self copyResurce:@"index.json" toDir:@"Documents"];
//    [self copyResurce:@"tvdata.archive" toDir:@"Documents"];
//    [self copyResurce:@"TVProgram.sqlite" toDir:@"Documents"];
    NSLog(@"-----App_Load-End------");
    return YES;
}

#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
-(void)copyResurce:(NSString*)resFile toDir:(NSString*)Dir
{
    NSString *filePathFfom = [[NSBundle mainBundle] pathForResource:[resFile stringByDeletingPathExtension] ofType:[resFile pathExtension]];
    NSString *dirPathTo;
    NSString *filePathTo;
    dirPathTo = [NSHomeDirectory() stringByAppendingPathComponent:Dir];
    filePathTo = [dirPathTo stringByAppendingPathComponent:resFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:filePathTo])
    {
        NSError *error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPathTo
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        BOOL success = [fileManager copyItemAtPath:filePathFfom toPath:filePathTo error:&error];
        NSLog(@"copy = /%@/ to /%@/",filePathFfom,filePathTo);
        if (success)
        {
            NSLog(@"COPY OK");
        } else {
            NSLog(@"Failed to copy!!!");
        }
        
    } else {
        NSLog(@"OK-/%@/",filePathTo);
    }
}

#pragma mark TabBar methods
//--------------------------- shouldSelectViewController ----------------------------------------
- (BOOL)tabBarController:(UITabBarController *)tabBarControl shouldSelectViewController:(UIViewController *)viewController {
    NSArray *tabBarVCs = tabBarControl.viewControllers;
    NSInteger index = [tabBarVCs indexOfObject:viewController];
    if (index == 3) {
        // reload pressed
//        _NSLog(@"\n====RELOAD=====");
//        [TVDataSingelton sharedTVDataInstance].currentState = eNeedsIndexDownload;
//        [controller start:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];        
//        NSString *str = @"загрузка тест";       
        //    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeGradient];
        //    [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeNone];

//        [SSVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
//        [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        return;        
    }
//    return index != 3;
    return YES;
}

//--------------------------- didSelectViewController ----------------------------------------
- (void)tabBarController:(UITabBarController *)tbController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    if([[nav.viewControllers objectAtIndex:0] isKindOfClass:[AlarmsViewControllers class]])
    {
        AlarmsViewControllers * alarms = [nav.viewControllers objectAtIndex:0]; 
        [alarms update];
    };
    if([[nav.viewControllers objectAtIndex:0] isKindOfClass:[GuideViewController class]])
    {
        GuideViewController * tv = [nav.viewControllers objectAtIndex:0]; 
        [tv updateTVProgram];
    };
    if([[nav.viewControllers objectAtIndex:0] isKindOfClass:[FavoriteViewController class]])
    {
        FavoriteViewController * tv = [nav.viewControllers objectAtIndex:0]; 
        [tv updateTVProgram];
    };
    if([[nav.viewControllers objectAtIndex:0] isKindOfClass:[CategoryViewController class]])
    {
        //[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]];
        //[[TVDataSingelton sharedTVDataInstance] readChannelsData:[[TVDataSingelton sharedTVDataInstance] getCurrentDate]];
    }
}

#pragma mark - schedule LocalNotification
//================================================================================================
//--------------------------- didReceiveLocalNotification ----------------------------------------
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif 
{
    _NSLog(@"!!app_didReceiveLocalNotification");
    app.applicationIconBadgeNumber = notif.applicationIconBadgeNumber-1;   

    NSDictionary *noteData = notif.userInfo;     
    NSString *name = [noteData objectForKey:@"showName"];
    NSNumber *num = [noteData objectForKey:@"minBefore"];
    NSInteger minutesBefore = [num integerValue];
    NSString *chnName = [noteData objectForKey:@"channelName"];
    
    NSString *title = [NSString stringWithFormat:@"\"%@\" по каналу \"%@\" начнется через %i минут",
                       name, chnName, minutesBefore];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Напоминание" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];     
                                                    
    alert.message = title;
    [alert show];
                           
 }





#pragma mark - 
//--------------------------- saveData -----------------------------------------------------------
- (void)saveData 
{
//    uint64_t t1 = getTickCount();    
    _NSLog(@">-save Data1");
    
    [[TVDataSingelton sharedTVDataInstance] saveData]; //save archive
    
//    uint64_t t2 = getTickCount();
//    _NSLog(@">-save Data2-(%llu)",(t2-t1));
    
}


//--------------------------- indexJsonDownloadingOrParsing --------------------------------------
- (BOOL)indexJsonDownloadingOrParsing 
{
    StatesEnum currState = [TVDataSingelton sharedTVDataInstance].currentState;
    return (currState == eIndexDownloading || currState == eIndexDownload || currState == eIndexParsing || currState == eIndexParse);
}

//--------------------------- deleteOldData ----------------------------------------
- (void)deleteOldData 
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *docDir = [SZUtils pathTmpDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docDir];
    
    NSString *file = nil;
    NSMutableArray *filesToDelete = [NSMutableArray array];
    while (file = [dirEnum nextObject]) {
        if ([file rangeOfString:@"_"].location != NSNotFound) {
            NSString *fileDateStr = [file substringFromIndex:[file rangeOfString:@"_"].location + 1];
            fileDateStr = [fileDateStr stringByReplacingOccurrencesOfString:@".json" withString:@""];
            NSDate *fileDate = convertStringToDate(fileDateStr);
            if ([now timeIntervalSinceDate:fileDate] >= 8*24*60*60) {
                [filesToDelete addObject:file];
            }
        }
    }
    
    for (NSString *file in filesToDelete) {
        NSError *error = nil;
        NSString *filePath = [docDir stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:filePath error:&error];
        if (error != nil) {
            _NSLog(@"Error deleting file:%@ = %@", file, [error localizedDescription]);
        }
    }
    
}

#pragma mark - Application activity
//--------------------------- applicationDidBecomeActive ----------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    return; //zss
    
//    uint64_t t1 = getTickCount();
    _NSLog(@"--applicationDidBecomeActive STATE:%d", [TVDataSingelton sharedTVDataInstance].currentState);
 
    application.applicationIconBadgeNumber = 0; //zs
    
    // change selected date if app opened more than week after last opened date
    NSDate *now = [NSDate date];
    NSDate *selectedDate = convertStringToDate([[TVDataSingelton sharedTVDataInstance] getCurrentDate]);
    BOOL shouldChangeDate = [now timeIntervalSinceDate:selectedDate] > 7*24*60*60 || diffWeeks(selectedDate, now);
    if (shouldChangeDate) 
    {
        [[TVDataSingelton sharedTVDataInstance] setCurrentDate:convertDataToString(now)];
    }
    
    return; //ZS!!!!!
    
    if ([controller ifDataShouldBeDownloaded] && ![self indexJsonDownloadingOrParsing]) 
    {
        _NSLog0(@"---DataShouldBeDownloaded : reload data for today---");
        NSString *todayDay = [[ModelHelper shared] dayForToday];
        NSArray *maskDate = [NSArray arrayWithObject:todayDay];
        controller.maskForDateLoading = maskDate; //load for today only!!!        
        
        [TVDataSingelton sharedTVDataInstance].currentState = eNeedsIndexDownload;
        [controller start:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];
    }
    [self deleteOldData];
    
    
    if (shouldChangeDate) 
    {        
        // update view contorllers
        tabBarController.selectedIndex = 0;
//        GuideViewController *guideVC = [[(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
        FavoriteViewController *guideVC = [[(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
        [guideVC.navigationController popToRootViewControllerAnimated:NO];
        [guideVC updateTVProgram];
    }
//    uint64_t t2 = getTickCount();
//    _NSLog(@"--end_applicationDidBecomeActive----(%llu ms)--",(t2-t1));
}


//--------------------------- applicationWillTerminate ----------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateStart" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateComplete" object:nil];
    _NSLog0(@"!!!_ap_WillTerminate!!!"); 
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    _NSLog(@"!!_ap_del_application_WillResignActive");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveData]; //save archive
    _NSLog(@"!!_ap_del_application_DidEnterBackground");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}


//--------------------------- shouldHandleError ----------------------------------------
- (BOOL)shouldHandleError:(NSInteger)errCode {
    return (errCode == NSURLErrorTimedOut || errCode == NSURLErrorCannotFindHost || errCode == NSURLErrorCannotConnectToHost
            || errCode == NSURLErrorNetworkConnectionLost || errCode == NSURLErrorResourceUnavailable || errCode == NSURLErrorNotConnectedToInternet
            || errCode == NSURLErrorBadServerResponse || errCode == NSURLErrorSecureConnectionFailed || errCode == NSURLErrorCannotLoadFromNetwork);
}


#pragma mark Memory management
//--------------------------- applicationDidReceiveMemoryWarning -------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    _NSLog0(@"!!!_ap_DidReceiveMemoryWarning!!!"); 
}




@end
