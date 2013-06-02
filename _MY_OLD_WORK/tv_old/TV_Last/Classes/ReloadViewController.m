//
//  ReloadViewController.m
//  TVProgram
//
//  Created by khuala on 8/8/12.
//
//

#import "ReloadViewController.h"
#import "TVDataSingelton.h"
#import "ModelHelper.h"
#import "ServerManager.h"
#import "CustomTabBarItem.h"
#import "UpView.h"

@interface ReloadViewController ()

@end

@implementation ReloadViewController

- (id)initWithTabBar {
    
	if (self = [super initWithNibName:@"ReloadViewController" bundle:nil]) {
		self.tabBarItem.title = @"Обновить";
		self.tabBarItem.image = [UIImage imageNamed:@"reload_selected.png"];
        
        self.navigationItem.titleView = [[UpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 44.0f)];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithTabBar];
}

#pragma mark - View lifecycle

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Обновить" image:[UIImage imageNamed:@"reload_selected.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"reload_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;
}

#pragma mark - Actions

- (IBAction)reloadAll:(UIButton *)button
{
    ServerManager *controller = [[ServerManager alloc] init];
//    ServerManager *controller = [ServerManager sharedManager];//[[ServerManager alloc] init];
    controller.maskForDateLoading = nil;
    
    // reload pressed
    _NSLog(@"\n====RELOAD for WEEK=====");
    [TVDataSingelton sharedTVDataInstance].currentState = eNeedsIndexDownload;
    [controller start:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];
}

- (IBAction)reloadDay:(UIButton *)button
{
    ServerManager *controller = [ServerManager sharedManager];
    NSString *todayDay = [[ModelHelper shared] dayForToday];
    NSArray *maskDate = [NSArray arrayWithObject:todayDay];
    controller.maskForDateLoading = maskDate;
    
    _NSLog(@"\n====RELOAD for TODAY:%@=====",todayDay);
    [TVDataSingelton sharedTVDataInstance].currentState = eNeedsIndexDownload;
    [controller start:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];
    
//    [TVDataSingelton sharedTVDataInstance].currentState = eIndexParse;
//    [controller updateChannelsData];         
}


@end
