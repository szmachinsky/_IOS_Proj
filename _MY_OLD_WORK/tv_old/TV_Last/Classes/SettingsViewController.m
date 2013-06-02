    //
//  SettingsViewController.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmsViewControllers.h"
#import "SettingsViewController.h"
#import "TVDataSingelton.h"
#import "SelectUpdateDatesController.h"
#import "SelectTimeZoneController.h"

#import "UICustomSwitch.h"
#import "CustomTabBarItem.h"
#import "PickerViewController.h"

//#import "ChannelsConfigController.h"
#import "SZChannelsConfigController.h"

//#import "ChannelsSortConfigController.h"
#import "SZChannelsSortConfigController.h"
#import "MTVChannel.h"

#import "SSVProgressHUD.h"


@implementation SettingsViewController

#define CHANNELS_SECTION 0
#define APP_SECTION 1
#define REMIND_SECTION 2

-(id) initWithTabBar{
    self = [super init]; 
	if ([self init]) {
		self.tabBarItem.title = @"Настройки";
		self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
        
	}
	return self;
}

- (void)loadView {
    self.navigationItem.title = @"Настройки";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];//[UIColor redColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UIImage *i = [UIImage imageNamed:@"back.png"];
    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
    v.backgroundColor = c;
    
    settingsTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    settingsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    settingsTableView.delegate = self;
    settingsTableView.dataSource = self;
    [settingsTableView reloadData];
    settingsTableView.backgroundView = v;
    self.tableView = settingsTableView;
}

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

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Настройки" image:[UIImage imageNamed:@"settings.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"settings_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;            
}

-(void) viewWillAppear:(BOOL)animated
{
    minBefore.text = [NSString stringWithFormat:@"за %d минут  ", [[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    settingsTableView = nil;
    minBefore = nil;
    channelsConfig = nil;
    updateDates = nil;
    timeZone = nil;
    sortChannels = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case CHANNELS_SECTION:
            rows = 2;
            break;
        case APP_SECTION:
            rows = 2;
            break;
        case REMIND_SECTION:
            rows = 2;
            break;
		default:
            break;
    }
    return rows;
}

/*
- (void)sliderAction:(id)sender
{ 
    //[tableController showProgramForTime:timeSlider.value];
    UISlider *timeSlider = sender;
    int min = timeSlider.value;
    minBefore.text = [NSString stringWithFormat:@"за %d", min];
    [[TVDataSingelton sharedTVDataInstance] setBeforeReminder:min];
}*/

- (void)switchAction:(id)sender
{
    [[TVDataSingelton sharedTVDataInstance] setWiFiOnly:[sender isOn]];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == CHANNELS_SECTION) {
        cell.textLabel.text = indexPath.row == 0 ? @"Выбор каналов" : @"Сортировка каналов";
    }
 
    if (indexPath.section == APP_SECTION) 
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Загрузка обновлений";
        }
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Только Wi-Fi";
            
            CGRect frame = CGRectMake(198.0, 6.0, 94.0, 30.0);
            UICustomSwitch *switchCtl = [[UICustomSwitch alloc] initWithFrame:frame];
            [switchCtl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [switchCtl setOn:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];
            //switchCtl.tintColor = [UIColor greenColor];
            // in case the parent view draws with a custom color or gradient, use a transparent color
            switchCtl.backgroundColor = [UIColor clearColor];
            
            cell.accessoryView = switchCtl;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if (indexPath.section == REMIND_SECTION) 
    {    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Напоминания";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(indexPath.row == 1)
        {
            cell.textLabel.text = @"Напомнить";
            
            UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 130.0f, 40.0f)];
            minBefore = [[UILabel alloc] init];
            minBefore.frame = CGRectMake(0.0f, 0.0f, 130.0f, 40.0f);
            minBefore.textAlignment = UITextAlignmentRight;
            minBefore.font = [UIFont boldSystemFontOfSize:12];
            minBefore.textColor = [UIColor blackColor];
            minBefore.backgroundColor = [UIColor clearColor];
            [accessoryView addSubview:minBefore];
            minBefore.text = [NSString stringWithFormat:@"за %d минут  ", [[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder]];
            
            cell.accessoryView = accessoryView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.backgroundColor = [SZUtils color02];
    
    return cell;
}



-(void) selectZone
{
    PickerViewController *picker = [[PickerViewController alloc ] init:NO];
    [self.navigationController pushViewController:picker animated:YES];
}

-(void) selectUpdateDates
{
    updateDates = [[SelectUpdateDatesController alloc] init ];
    updateDates.view.frame = [[UIScreen mainScreen] applicationFrame];
    [self.navigationController pushViewController:updateDates animated:YES];
}


//-(void) selectedChannels:(BOOL)isChanged channels:(NSArray*)chnArr
//{
//    _NSLog(@"sel chn - done");  
//    if (isChanged) {
//        for (MTVChannel *ch in chnArr) {
//          //[TVDataSingelton sharedTVDataInstance] removeChannelNameFromSelected:channelName];
//            _NSLog(@" add+sel chn (%@)",ch.pName);
//            [[TVDataSingelton sharedTVDataInstance] removeChannelNameFromSelected:ch.pName];
//            [[TVDataSingelton sharedTVDataInstance] addChannelToSelected:ch.pName];
//        }
////        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChannelsHaveBeenSelected" object:self]];
//    }
//}


-(void)msgSelected
{
    _NSLog(@"--send selected--");  
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChannelsHaveBeenSelected" object:self]];    

//    [SVProgressHUD showWithStatus:@"загрузка данных..."];

}

-(void) selectedChannels:(BOOL)isChanged
{
    _NSLog(@"sel chn - done"); 
    [self.navigationController popViewControllerAnimated:NO];    
    if (isChanged) {
//      [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChannelsHaveBeenSelected" object:self]];
        [self performSelector:@selector(msgSelected) withObject:nil afterDelay:0.2];        
    }
}

-(void) selectChannels
{
    if (!channelsConfig) {
        channelsConfig = [[SZChannelsConfigController alloc] init ];
//        channelsConfig.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext];//[SZAppInfo shared].coreManager.managedObjectContext;
///        channelsConfig.view.frame = [[UIScreen mainScreen] applicationFrame];
    }
    channelsConfig.hidesBottomBarWhenPushed = YES;  //disable tab bar
//    channelsConfig.navigationItem.title = @"Каналы";  //zs 
    channelsConfig.delegate = self;
    [self.navigationController pushViewController:channelsConfig animated:YES];
    channelsConfig = nil; //zs
}


-(void) sortChannels
{
    if (!sortChannels) {
        sortChannels = [[SZChannelsSortConfigController alloc] init ];
///        sortChannels.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext];//[SZAppInfo shared].coreManager.managedObjectContext;
        sortChannels.view.frame = [[UIScreen mainScreen] applicationFrame];
    }
    sortChannels.hidesBottomBarWhenPushed = YES;  //disable tab bar  
    [self.navigationController pushViewController:sortChannels animated:YES];
    sortChannels = nil; //zs
}

-(void) setTimeValue
{
    PickerViewController *picker = [[PickerViewController alloc] init:YES];
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case CHANNELS_SECTION:
            switch (indexPath.row) {
                    //выбор каналов
                case 0:
                    [self selectChannels];
                    break;
                    //sort  channels
                case 1:
                    [self sortChannels];
                    break;
                default:
                    break;
            }
            break;
        case APP_SECTION:
            switch (indexPath.row) {
                //Загрузка обновлений
                case 0:
                    [self selectUpdateDates];
                    break;
//                case 2: 
//                {
//                    AlarmsViewControllers *alarmViewController = [[AlarmsViewControllers alloc] initWithTabBar];
//                    [self.navigationController pushViewController:alarmViewController animated:YES];
//                }
//                    break;
//                case 3:
//                    [self setTimeValue];
//                    break;
                default:
                    break;
            }
            break;
            
       case REMIND_SECTION:  
            switch (indexPath.row) {
                case 0: 
                {
//                  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Настройки" style:UIBarButtonItemStyleDone target:nil action:nil];
//                    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStyleDone target:nil action:nil];
//                    backButton.tintColor = [SZUtils color08];//[UIColor redColor];
//                    self.navigationItem.backBarButtonItem = backButton;
                    
                    AlarmsViewControllers *alarmViewController = [[AlarmsViewControllers alloc] initWithTabBar];
                    [self.navigationController pushViewController:alarmViewController animated:YES];
                }
                    break;
                case 1:
                    [self setTimeValue];
                    break;
                default:
                    break;
            }
            break;
                        
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
