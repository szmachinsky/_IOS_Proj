//
//  ProgrammByChannelController.m
//  TVProgram
//
//  Created by User1 on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgrammByChannelController.h"
//#import "ProgrammTableViewController.h"
#import "ProgrammDataViewController.h"
#import "DaySelectionButton.h"

#import "TVDataSingelton.h"
//#import "Channel.h"
//b#import "Show.h"

#import "SZProgrammTableViewController.h"
#import "MTVShow.h"
#import "MTVChannel.h"
#import "SZCoreManager.h"
#import "SZAppInfo.h"

@interface ProgrammByChannelController ()
-(UIFont*)adjustFontString:(NSString*)string toLength:(NSInteger)len;
-(void)setFavButtonImage;

@end

@implementation ProgrammByChannelController
@synthesize context;
@synthesize titleForBackButton = titleForBackButton_;


- (id)init
{
    self = [super init];
    if (self) {
        self.titleForBackButton = @"Back";
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
- (void)changeDate:(id)sender
{
    DaySelectionButton *btn = sender;
    if(btn.selected == YES)
    {
        NSString *date = btn.day;
        [[TVDataSingelton sharedTVDataInstance] setCurrentDate:date];
        currentDate = [[NSString stringWithString:date] copy];
        [tableController setDate:currentDate];
    }
    for (int i = 0; i < [buttons count]; i++) {
        DaySelectionButton *dayButton = [buttons objectAtIndex:i];
        if(dayButton != btn)
            dayButton.selected = NO;
    }
    
}

-(void)createDaySelection
{
    buttons = [[NSMutableArray alloc] init];
    NSArray * days = [[TVDataSingelton sharedTVDataInstance] getDates];
    NSInteger numOfDays = days.count > 7 ? 7 : days.count; 
    
    CGFloat viewWidth = 43*numOfDays;
///    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - viewWidth)/2.0f, 50.0f, viewWidth, 30.0f)];
//    CGRect frame = CGRectMake((CGRectGetWidth(self.view.frame) - viewWidth)/2.0f, 55.0f + hightTableView, viewWidth, 30.0f);
    CGRect frame = CGRectMake((CGRectGetWidth(self.view.frame) - viewWidth)/2.0f, hightTableView - 33 , viewWidth, 30.0f);
    UIView *buttonsView = [[UIView alloc] initWithFrame:frame];
//    buttonsView.backgroundColor = [UIColor redColor];
    buttonsView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < numOfDays; i++) {
        DaySelectionButton *dayButton = [DaySelectionButton buttonWithType:UIButtonTypeCustom];
        dayButton.frame = CGRectMake(i*43, 0, 43, 30);
        NSString * day = [days objectAtIndex:days.count - numOfDays + i];
        [dayButton setDate:day forShort:YES forIndex:(i+1)];
        if ([currentDate isEqualToString:day]) {
            dayButton.selected = YES;
        }
        [dayButton addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:dayButton];
        [buttons addObject:dayButton];
    }
    [self.view addSubview:buttonsView];
    buttonsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv
{
//    CGRect f = channelNameLabel.frame;
        
    //NSLog(@"thumbImageViewWasTapped %@", tiv.name);
    for (int i = 0; i < [channelsArray count]; i++) {
        ThumbImageView *thumbView = [channelsArray objectAtIndex:i];
        if (thumbView.name == tiv.name) {
            [thumbView setSelected:YES];
        }
        else
        {
            [thumbView setSelected:NO];
        }
    }
    [self setChannelName:tiv.name initialDay:currentDate isFavor:isForFavorChannels];
}

- (void)createChannelScrollView
{      
        
    float scrollViewHeight = 64;
    thumbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 64, CGRectGetWidth(self.view.frame), scrollViewHeight)];
    thumbScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [thumbScrollView setCanCancelContentTouches:NO];
    [thumbScrollView setClipsToBounds:NO];
    
    thumbScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_panel.png"]];

    // now place all the thumb views as subviews of the scroll view 
    // and in the course of doing so calculate the content width
    float xPosition = 14;
    channelsArray = [[NSMutableArray alloc] init];
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    int count = 0;
    NSArray *items;
    NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];    
    if (isForFavorChannels == YES) {
        items = [SZCoreManager arrayOfFavoriteChannels:context_];
        count = [items count];  //[[TVDataSingelton sharedTVDataInstance] getNumberOfFavChannels];
    }
    else
    {
        items = [SZCoreManager arrayOfSelectedChannels:context_];
        count =[items count];  //[[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels];
    }
    for (int i = 0; i < count; i++) {
        MTVChannel *ch;
//        if (isForFavorChannels == YES)
//        {
//            ch = [[TVDataSingelton sharedTVDataInstance] getChannel:[[TVDataSingelton sharedTVDataInstance] getFavChannelByIndex:i]];
//        }
//        else
//        {
//            ch = [[TVDataSingelton sharedTVDataInstance] getChannel:[[TVDataSingelton sharedTVDataInstance] getSelectedChanelNameByIndex:i]];
//        }        
        ch = [items objectAtIndex:i];
        UIImage *thumbImage = [ch icon]; //[[TVDataSingelton sharedTVDataInstance] getIcon:ch.iconName];
        
        if (thumbImage) 
        {
            ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
            [thumbView setDelegate:self];
            
//            [thumbView setImageName:ch.iconName];
            [thumbView setName:ch.pName];
            
            [thumbView setBackgroundColor:[UIColor greenColor]];
            
            CGRect frame = CGRectMake(xPosition, 5, 45, 45);
            //[thumbView frame];
            frame.origin.y = 10;
            frame.origin.x = xPosition;
            if ([ch.pName isEqualToString:channelName]) {
                [thumbView setSelected:YES];
                rect = frame;
            }
            [thumbView setFrame:frame];
            [thumbView setHome:frame];
            [thumbScrollView addSubview:thumbView];
            [channelsArray addObject:thumbView];
            xPosition += (frame.size.width + 14);
        }
    }

    [thumbScrollView setContentSize:CGSizeMake(xPosition, scrollViewHeight)];
    
    [self.view addSubview:thumbScrollView];
    [thumbScrollView scrollRectToVisible:rect animated:YES];
}

-(void)addToFavour:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn currentImage] != [UIImage imageNamed:@"add_icon.png"]) {
                
        NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];
        MTVChannel *chanel = [[[SZAppInfo shared] coreManager] selChannelByName:channelName context:context_];
        if (chanel != nil) {
            chanel.pFavorite = NO;
            [SZCoreManager saveForContext:context_];        
            
            [favButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
///            [[TVDataSingelton sharedTVDataInstance] removeChannelFromFavor:channelName];  //zs - to delete          
        }
    }
    else
    {
        NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];
        MTVChannel *chanel = [[[SZAppInfo shared] coreManager] selChannelByName:channelName context:context_];
        if (chanel != nil) {
            chanel.pFavorite = YES;
            [SZCoreManager saveForContext:context_];   
            
///            [[TVDataSingelton sharedTVDataInstance] addChannelToFavor:channelName];
            [favButton setImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal];            
        }
    }
}

-(void)close:(id)sender
{
    tableController.delegate = nil;
    [self dismissModalViewControllerAnimated:YES];
    tableController = nil; //zs
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setFavButtonImage];    
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor blackColor];
    
    // top bar image
//    UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]];
//    myImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45);
//    myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:myImageView];
    
    // back button
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(5, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    
//    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom]; //UIButtonTypeRoundedRect
//    dateButton.frame = CGRectMake(5, 5, 65, 32);
//    [dateButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [dateButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
////    [dateButton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
//    [dateButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [dateButton setTitle:self.titleForBackButton forState:UIControlStateNormal];
//    [self.view addSubview:dateButton];
//    UILabel *l = dateButton.titleLabel;
//    l.font = [UIFont boldSystemFontOfSize:14];
//    l.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    l.adjustsFontSizeToFitWidth = YES;
//    l.minimumFontSize = 10;
//    l.lineBreakMode = UILineBreakModeClip;

    
    
//    typedef enum {
//        UILineBreakModeWordWrap = 0,
//        UILineBreakModeCharacterWrap,
//        UILineBreakModeClip,
//        UILineBreakModeHeadTruncation,
//        UILineBreakModeTailTruncation,
//        UILineBreakModeMiddleTruncation,
//    } UILineBreakMode;
     
 
    channelNameLabel = [[UILabel alloc]init];
    channelNameLabel.backgroundColor = [UIColor clearColor];
    //    channelNameLabel.frame = CGRectMake(80, 8, CGRectGetWidth(self.view.frame) - 160, 30);
    CGRect frame = CGRectMake(78, 0, CGRectGetWidth(self.view.frame) - 100, 40);
    channelNameLabel.frame = frame;
    channelNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    channelNameLabel.textAlignment = UITextAlignmentCenter;
    
//    CGSize stringSize = [channelName sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(200, 300)];
//    if (stringSize.width < 180) {
//        channelNameLabel.font = [UIFont boldSystemFontOfSize:17];
//    } else {
//        channelNameLabel.font = [UIFont boldSystemFontOfSize:15];            
//    }
    channelNameLabel.font = [self adjustFontString:channelName toLength:180];
    channelNameLabel.numberOfLines = 2;
    channelNameLabel.adjustsFontSizeToFitWidth = YES;
    channelNameLabel.minimumFontSize = 9;
    channelNameLabel.textColor = [UIColor whiteColor];
    [channelNameLabel setText:channelName];
//    [self.view addSubview:channelNameLabel];
    self.navigationItem.titleView = channelNameLabel;
    
    channelNameLabel.adjustsFontSizeToFitWidth = YES;
    channelNameLabel.minimumFontSize = 9;
    
    
    //add to favourites button
    favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 55, 8, 49, 29);
    favButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
///    [favButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
///    [favButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    [favButton addTarget:self action:@selector(addToFavour:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:favButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    
    
    //Table view
    tableController = [[SZProgrammTableViewController alloc] init];
    tableController.delegate = self;
    [tableController setDate:currentDate];
///   [tableController setChannel:[[TVDataSingelton sharedTVDataInstance] getChannel:channelName]];
    [tableController setChannelWithName:channelName];  //zs
    [self.view addSubview:tableController.view];
    CGRect fr = tableController.view.frame;
    hightTableView = fr.size.height;
    
    [self createDaySelection];
    [self createChannelScrollView];
    
    
    NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];
    MTVChannel *chanel = [[[SZAppInfo shared] coreManager] selChannelByName:channelName context:context_];
    bool isFav = chanel.pFavorite;
///zs    bool isFav = [[TVDataSingelton sharedTVDataInstance] isChannelFavor:channelName];
    UIImage *iconImage = isFav ? [UIImage imageNamed:@"delete_icon.png"] : [UIImage imageNamed:@"add_icon.png"];
    [favButton setImage:iconImage forState:UIControlStateNormal];
}




- (void) programIsSelected:(Show *) show
{
//    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
//    channelController.modalTransitionStyle = kModTranStyle;
//    NSString *n = [show name];
//    NSString *d = [show day];
//    NSDate *dt = show.startDate;
//    NSInteger h = [show getStartHour];
//    NSInteger m = [show getStartMin];
//    _NSLog(@"(%@) (%@) dat=%@  (%d:%d)",n,d,dt,h,m);      
//    _NSLog(@"NOOOOOOOOOOO_10!!!!!!");
//    abort();
////    [self presentModalViewController:channelController animated:YES];
////    Channel * channel = [[TVDataSingelton sharedTVDataInstance] getChannel:channelName];
////    [channelController showProgramData:show channel:[channel iconName] minutesBefore:[[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder] forChannelName:channelName];    
}

- (void) programIsSelectedMTV:(MTVShow*)show
{
//    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
    
    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] initWithNibName:@"ProgrammDataViewController" bundle:nil];
    
//    channelController.modalTransitionStyle = kModTranStyle;    
//    [self presentModalViewController:channelController animated:YES];

//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:channelName style:UIBarButtonItemStyleDone target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils colorLeftButton];
    self.navigationItem.backBarButtonItem = backButton;    
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


-(UIFont*)adjustFontString:(NSString*)string toLength:(NSInteger)len 
{
    UIFont *res = nil;  
    
    CGSize stringSize = [string sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(320, 100)];
    if (stringSize.width < 200) {
        res = [UIFont boldSystemFontOfSize:17];
    } else {
        res = [UIFont boldSystemFontOfSize:15];            
    }
    
    return res;
}

-(void)setFavButtonImage
{
    bool isFav = NO;//[[TVDataSingelton sharedTVDataInstance] isChannelFavor:name];    
    NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];
    MTVChannel *chanel = [[[SZAppInfo shared] coreManager] selChannelByName:channelName context:context_];
    if (chanel != nil) {
        isFav = chanel.pFavorite;
    }
    
    if (isFav == TRUE) {
        [favButton setImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal]; 
    }
    else
    {
        [favButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
    }
    
}

-(void) setChannelName:(NSString *)name initialDay:(NSString *)day isFavor:(BOOL)isFavor
{
    isForFavorChannels = isFavor;
    channelName = [[NSString stringWithString:name] copy];
    
    [channelNameLabel setText:channelName];
    channelNameLabel.font = [self adjustFontString:channelName toLength:180];
    
///    [tableController setChannel:[[TVDataSingelton sharedTVDataInstance] getChannel:name]];
    [tableController setChannelWithName:name]; //zs    
    currentDate = [[NSString stringWithString:day] copy];
    [tableController setDate:day];
    
//    bool isFav = NO;//[[TVDataSingelton sharedTVDataInstance] isChannelFavor:name];    
//    NSManagedObjectContext *context_ = [[[SZAppInfo shared] coreManager] createContext];
//    MTVChannel *chanel = [[[SZAppInfo shared] coreManager] selChannelByName:channelName context:context_];
//    if (chanel != nil) {
//        isFav = chanel.pFavorite;
//    }
//    
//    if (isFav == TRUE) {
//       [favButton setImage:[UIImage imageNamed:@"delete_icon.png"] forState:UIControlStateNormal]; 
//    }
//    else
//    {
//        [favButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
//    }
    [self setFavButtonImage];
}

@end
