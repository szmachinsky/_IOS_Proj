//
//  ProgramsByCattegoryViewController.m
//  TVProgram
//
//  Created by User1 on 26.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgramsByCattegoryViewController.h"
#import "ProgramsCategoryTableController.h"
#import "DaySelectionController.h"
#import "ProgrammDataViewController.h"

#import "CommonFunctions.h"
#import "TVProgramAppDelegate.h"

#import "TVDataSingelton.h"
//#import "Show.h"


@implementation ProgramsByCattegoryViewController
@synthesize delegate;

#define Height 45 
//#define Height 0

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)setData:(NSString *)catName forDate:(NSString *)date
{
    // all programms for selected category
    //zs    NSArray *allProgramms = [[NSMutableArray alloc] initWithArray:[[TVDataSingelton sharedTVDataInstance] getCategoryData:catName]];
    //    NSMutableArray * channelsName = [[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName];
    //    
    //    programms = [NSMutableArray arrayWithArray:[allProgramms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.channelName in %@", channelsName]]];
    
    categoryName = [[NSString stringWithString:catName] copy];
    currentDate = [date copy];
    
    categoryNameLabel.text = categoryName; //zs
    NSString *weekDay = getWeekDay(currentDate); //zs
    [dateLabel setText:weekDay]; //zs
//    self.title = weekDay;
    
    tableController.currentDate = currentDate;//zs
    tableController.catID = catID_;
    
    [tableController update]; //zs    
}


-(void)setData:(NSString *)catName catId:(NSInteger)catId forDate:(NSString *)date
{
    // all programms for selected category
//zs    NSArray *allProgramms = [[NSMutableArray alloc] initWithArray:[[TVDataSingelton sharedTVDataInstance] getCategoryData:catName]];
//    NSMutableArray * channelsName = [[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName];
//    
//    programms = [NSMutableArray arrayWithArray:[allProgramms filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.channelName in %@", channelsName]]];
    
    categoryName = [[NSString stringWithString:catName] copy];
    currentDate = [date copy];
    catID_ = catId;
    
    categoryNameLabel.text = categoryName; //zs
    NSString *weekDay = getWeekDay(currentDate); //zs
    [dateLabel setText:weekDay]; //zs
    
    tableController.currentDate = currentDate;//zs
    tableController.catID = catID_;
    
    [tableController update]; //zs    
}


- (void)updateDataForNewDay:(NSString *)day 
{
    currentDate = day;
//zs    [[TVDataSingelton sharedTVDataInstance] readChannelsData:(NSString *)currentDate];
    
    [self setData:categoryName catId:catID_ forDate:currentDate];
    
//zs  [tableController setData:[self getProgramsByDate]];
//    [tableController.tableView reloadData];    
    
    NSString *weekDay = getWeekDay(currentDate);
    [dateLabel setText:weekDay];
    
//    self.title = weekDay;
}

- (void) dayIsSelected:(NSString *)day
{
///  UIAlertView *alert = [self showIndicator];
//    UIAlertView *alert = [ModelHelper showProgressIndicator];
    [self performSelector:@selector(updateDataForNewDay:) withObject:day afterDelay:0.2f];
//    [ModelHelper hideProgressIndicator:alert];
///  [self hideIndicator:alert];
}

-(void)dateSelect:(id)sender
{
    daySelection = [[DaySelectionController alloc] init];
    daySelection.view.frame = [[UIScreen mainScreen] applicationFrame];
    [daySelection setSelectedDate:currentDate];
    
    NSArray *days = [[TVDataSingelton sharedTVDataInstance] getDates];
//    _NSLog(@"days:(%@)",days);
    [daySelection show:days];
    
    daySelection.delegate = self;
    
    [[(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:daySelection.view];
}

- (void)segmentAction:(id)sender
{
    if (tableController.searching) return;
	UIButton * btn = (UIButton *)sender;
    if ([[btn titleLabel].text isEqualToString:@"Канал"]) {
        //sort by channel
        [tableController sortChannelsByChannel:YES];
        [timeButton setSelected:NO];
        [channelButton setSelected:YES];
    }
    else
    {
        //sort by time
        [tableController sortChannelsByChannel:NO];
        [timeButton setSelected:YES];
        [channelButton setSelected:NO];
    }
}

-(void)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.title = @"12344";//weekDay;
    
//    NSString *weekDay = getWeekDay(currentDate);
//    self.title = weekDay;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [SZUtils color02];
    
    // top bar back image
//    UIImageView *myImageView = [[UIImageView alloc]init];
//    myImageView.image = [UIImage imageNamed:@"top.png"];
//    myImageView.frame = CGRectMake(0, 0, 320, 45);
//    myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:myImageView];
    
    // back button
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(5, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    // label with date in top bar
    dateLabel = [[UILabel alloc]init];
    dateLabel.backgroundColor = [UIColor clearColor];//[UIColor clearColor];
    dateLabel.frame = CGRectMake(60, Height/2 - 10, CGRectGetWidth(self.view.frame) - 120, Height/2);
    dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.font = [UIFont boldSystemFontOfSize:17];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.minimumFontSize = 9;
    NSString *weekDay = getWeekDay(currentDate);
    [dateLabel setText:weekDay]; 
//    [self.view addSubview:dateLabel];
//    self.navigationItem.title = weekDay; //zs! title
//    self.title = weekDay;
    self.navigationItem.titleView = dateLabel;
    
    
    //button to select date
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 55, 8, 49, 29);
    dateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [dateButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [dateButton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dateButton];
    dateButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dateButton]; //zs! right button
        
    // category name back image
    UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_panel.png"]];
    bg.frame = CGRectMake(0, 0, frame.size.width, Height);
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:bg];
    
    // category name label
    UIColor *textColor = [SZUtils color04];
    UIColor *shadowColor = [SZUtils color05];
    categoryNameLabel = [[UILabel alloc]init];
    categoryNameLabel.backgroundColor = [UIColor clearColor];
    categoryNameLabel.frame = CGRectMake(0, 12, CGRectGetWidth(self.view.frame), 20);
    categoryNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    categoryNameLabel.textAlignment = UITextAlignmentCenter;
    categoryNameLabel.font = [UIFont boldSystemFontOfSize:18];
    categoryNameLabel.textColor = textColor;
    categoryNameLabel.shadowColor = shadowColor;
    categoryNameLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    [categoryNameLabel setText:categoryName];
    categoryNameLabel.text = categoryName;
    [self.view addSubview:categoryNameLabel];
    
    // table view
    tableController = [[ProgramsCategoryTableController alloc] init];
//zs    [tableController setData:[self getProgramsByDate]];
    tableController.selectionDelegate = self;
    [self.view addSubview:tableController.view];
    
    // bottom bar
    time_panel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_panel.png"]];
    time_panel.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50);
    time_panel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:time_panel];
    
    // sorting label
    label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 40, 90, 30);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.text = @"Сортировка";
    label.textColor = textColor;
    label.shadowColor = shadowColor;
    label.shadowOffset = CGSizeMake(1.0f, 1.0f);
    [self.view addSubview:label];
    
    // sort by time or channels buttons
    channelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    channelButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 172, CGRectGetHeight(self.view.frame) - 40, 81, 31);
    channelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [channelButton setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [channelButton setBackgroundImage:[UIImage imageNamed:@"left_on.png"] forState:UIControlStateSelected];
    [channelButton setTitle:@"Канал" forState:UIControlStateNormal];
    [channelButton addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [channelButton setSelected:YES];
    [self.view addSubview:channelButton];
    
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 91, CGRectGetHeight(self.view.frame) - 40, 81, 31);
    timeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [timeButton setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [timeButton setBackgroundImage:[UIImage imageNamed:@"right_on.png"] forState:UIControlStateSelected];
    [timeButton setTitle:@"Время" forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeButton];
}

- (void) programIsSelected:(Show *)show
{
//    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
//    channelController.modalTransitionStyle = kModTranStyle;
//    
//    [self presentModalViewController:channelController animated:YES];
////zs    [channelController showProgramData:show channel:[show channelIconName] minutesBefore:[[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder] forChannelName:[show channelName]];
//    //[channelController release];
}

- (void) programIsSelectedMTV:(MTVShow*)show
{
    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
//    _NSLog(@"1=(%@)",show);\
    
//    channelController.modalTransitionStyle = kModTranStyle;    
//    [self presentModalViewController:channelController animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:dateLabel.text style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];
    self.navigationItem.backBarButtonItem = backButton;    
    [self.navigationController pushViewController:channelController animated:YES]; //zs
    
    
//    _NSLog(@"2=(%@)",show);    
    
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
