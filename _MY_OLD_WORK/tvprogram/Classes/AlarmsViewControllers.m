//
//  AlarmsViewControllers.m
//  TVProgram
//
//  Created by User1 on 25.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmsViewControllers.h"
#import "ShowDescriptionCell.h"
#import "CustomTabBarItem.h"
#import "CommonFunctions.h"

@implementation AlarmsViewControllers

-(id) initWithTabBar {
    self = [super init];
	if (self) {
		self.tabBarItem.image = [UIImage imageNamed:@"reminder_selected.png"];
        self.tabBarItem.title = @"Напоминания";
        
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"go back!" style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
//        self.navigationItem.backBarButtonItem = bbi;        
//        self.navigationItem.hidesBackButton = NO;
//        self.navigationItem.leftItemsSupplementBackButton = YES;
	}
	return self;
	
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView {
//     self.tabBarItem.title = @"Напоминания";
//     self.tabBarItem.image = [UIImage imageNamed:@"reminder_selected.png"];
   
    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Напоминания" image:[UIImage imageNamed:@"reminder_selected.png"] tag:0];
    tabItem.customHighlightedImage=[UIImage imageNamed:@"reminder_selected.png"];
    self.tabBarItem = tabItem;
    tabItem=nil;       
    
    self.navigationItem.title = @"Напоминания";
//    NSString *str = self.navigationItem.leftBarButtonItem.title;
//    self.navigationItem.leftBarButtonItem.title = @"назад!";
    
    
//    NSString *title = @"Back";
//    CGSize stringSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(150, 100)];
//    CGFloat stringWidth = stringSize.width;
        
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];    
//    backButton.frame = CGRectMake(0, 0, stringWidth+12, 30);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on_.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];    
////    CGRect frl = CGRectMake(20, 2, stringWidth+5 - 20, 26);
////    backButton.titleLabel.frame = frl;
//    backButton.titleEdgeInsets = UIEdgeInsetsMake(0,10,0,0);
//    [backButton setTitle:title forState:UIControlStateNormal];      
//    backButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    backButton.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    backButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    backButton.titleLabel.minimumFontSize = 9;
//    backButton.titleLabel.backgroundColor = [UIColor clearColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
 
    
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
//                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                            target:self
//                            action:@selector(close:)];    
//    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    l.text = @"my title";
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:l];
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"go back" style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
//    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"go back!!!" style:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(close:)];
//    self.navigationItem.backBarButtonItem = bbi;
    
     
     tableview = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                              style:UITableViewStylePlain];
     tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
     tableview.delegate = self;
     tableview.dataSource = self;
     tableview.separatorColor = [SZUtils color01];
     tableview.backgroundColor = [SZUtils color02];
    
//     tableview.editing = YES; //edit mode!!!
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    tableview.allowsSelection = NO;
    
     [tableview reloadData];
     self.view = tableview;
}
 
-(void)viewDidLoad
{
    [super viewDidLoad]; 
//    self.navigationItem.hidesBackButton = NO;
//    self.navigationItem.leftItemsSupplementBackButton = YES;  
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillUnload
{
    [super viewWillUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationItem.hidesBackButton = NO;
//    self.navigationItem.leftItemsSupplementBackButton = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    CustomTabBarItem *tabItem = [[CustomTabBarItem alloc] initWithTitle:@"Напоминания" image:[UIImage imageNamed:@"reminder_selected.png"] tag:0];
//    tabItem.customHighlightedImage=[UIImage imageNamed:@"reminder_selected.png"];
//    self.tabBarItem = tabItem;
//    tabItem=nil;   

}


-(void) update
{
    [self->tableview reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We only have one section
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
//    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of notifications
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) {
        return [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
//    static NSString *CellIdentifier = @"ShowDescriptionCell";    
//    ShowDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        [[NSBundle mainBundle] loadNibNamed:@"ShowDescriptionCell" owner:self options:nil];
//        cell = alarmCell;
//    }
    
    static NSString *CellIdentifier = @"ShowDescriptionCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowDescriptionCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    ShowDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    
    
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) 
    {
        // Get list of local notifications
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        UILocalNotification *notif = [notificationArray objectAtIndex:indexPath.row];
        
        NSDictionary *dict = notif.userInfo;
        NSString *dayS = [dict objectForKey:@"day"];
        NSString *dateStr = convertDateToUserView2(dayS);
        NSString *showName = [dict objectForKey:@"showName"];
        NSData *imadeData = [dict objectForKey:@"channelImage"];
        UIImage *image = [UIImage imageWithData:imadeData];
        
        // Display notification info
//        NSRange range = [notif.alertBody rangeOfString:NSLocalizedString(@"через", nil)];
//        NSRange range = [notif.alertBody rangeOfString:NSLocalizedString(@"начнется", nil)];        
//        NSString *name = [notif.alertBody substringToIndex:range.location];
        
        cell.descriptionText.text = showName;//notif.alertBody;//name;
//        cell.descriptionText.text = @"u u u u u u u u u u u u u u u u u u u u v u u u u u u p u q u Р р u u u u u u";
        
        NSDate *showDate = notif.fireDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *timeStr = [formatter stringFromDate:showDate];
        NSString *time = [NSString stringWithFormat:@"%@  %@",timeStr,dateStr];
        cell.timeLabel.text = time;
        
        cell.channelImage.image = image;
               
    }
    else {
        cell.timeLabel.text = nil;
        cell.descriptionText.text = nil;
        cell.channelImage = nil;
    }
    
    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview beginUpdates];
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) {
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        UILocalNotification *notif = [notificationArray objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
        [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableview endUpdates];
    }
    [self update];
}

@end
