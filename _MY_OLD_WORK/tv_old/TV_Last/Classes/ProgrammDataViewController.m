//
//  ProgrammDataViewController.m
//  TVProgram
//
//  Created by User1 on 24.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgrammDataViewController.h"
#import "CommonFunctions.h"

//#import "Show.h"
//#import "TVDataSingelton.h"


@interface ProgrammDataViewController ()
-(UILocalNotification *)makeNotification;
-(void)setAlarmButtonTag:(NSInteger)tag;
-(void)setNotification:(id)sender;
@end

@implementation ProgrammDataViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    // background image
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"back.png"];
    image.frame = self.view.frame;
    image.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:image];
    
    // top bar
//    UIImageView *bg = [[UIImageView alloc]init];
//    bg.image = [UIImage imageNamed:@"top.png"];
//    bg.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45);
//    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:bg];
    
    // back button
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(5, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    // channel label
//    channelLabel = [[UILabel alloc]init];
//    channelLabel.frame = CGRectMake(70, 5, CGRectGetWidth(self.view.frame) - 140, 30);
//    channelLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    channelLabel.textAlignment = UITextAlignmentCenter;
//    channelLabel.font = [UIFont boldSystemFontOfSize:17];
//    channelLabel.textColor = [UIColor whiteColor];
//    channelLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:channelLabel];
    
    // alarm button
    alarmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alarmButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 55, 8, 49, 29);
    alarmButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [alarmButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [alarmButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
//    [alarmButton setImage:[UIImage imageNamed:@"reminder_dis.png"] forState:UIControlStateNormal];
//    [alarmButton setImage:[UIImage imageNamed:@"reminder_icon.png"] forState:UIControlStateDisabled];
    [alarmButton addTarget:self action:@selector(setNotification:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:alarmButton];
    alarmButton.tag = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:alarmButton];

    
    // green title image
    UIImageView *imageTitle = [[UIImageView alloc]init];
    imageTitle.image = [UIImage imageNamed:@"plashka_for_title.png"];
    imageTitle.frame = CGRectMake(0, 95, CGRectGetWidth(self.view.frame), 47);
    imageTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:imageTitle];

    // title (show name)
    titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 95, CGRectGetWidth(self.view.frame) - 20, 47);
    timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 2;
    [self.view addSubview:titleLabel];
    
    UIColor *textColor = [SZUtils color04];
    UIColor *shadowColor = [SZUtils color05];
    //date
    dateLabel = [[UILabel alloc] init];
    dateLabel.frame = CGRectMake(85, 15, CGRectGetWidth(self.view.frame), 20);
    dateLabel.textAlignment = UITextAlignmentLeft;
    dateLabel.font = [UIFont boldSystemFontOfSize:18];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = textColor;
    dateLabel.shadowColor = shadowColor;
    dateLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    [self.view addSubview:dateLabel];
    
    //time
    timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(85, 35, CGRectGetWidth(self.view.frame), 30);
    timeLabel.textAlignment = UITextAlignmentLeft;
    timeLabel.font = [UIFont boldSystemFontOfSize:24];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = textColor;
    timeLabel.shadowColor = shadowColor;
    timeLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    [self.view addSubview:timeLabel];
    
    // show description
    textLabel = [[UITextView alloc] init];
    textLabel.frame = CGRectMake(0, 140, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) -  140);
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textLabel.textAlignment = UITextAlignmentLeft;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.editable = NO;
    textLabel.backgroundColor = [SZUtils color06];
    textLabel.scrollEnabled = YES;
    [self.view addSubview:textLabel];
    
    myImageView = [[UIImageView alloc] init];
    myImageView.frame = CGRectMake(18, 18, 45, 45);
    [self.view addSubview:myImageView];
    
    UIImageView *iconFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
    iconFrame.frame = CGRectMake(15, 15, 50, 50);
    [self.view addSubview:iconFrame];
    
}

//-(void) showProgramData:(Show *)show channel:(NSString *)iconName minutesBefore:(int) min forChannelName:(NSString*)channelName
//{
////    _NSLog(@"NOOOOOOOOOOO_11!!!!!!");
////    abort();    
//}

-(UILocalNotification *)makeNotification
{
    UILocalNotification *notif;
    
//    alarmButton.enabled = NO;
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSString * day = curentShow.day;
    NSRange range;
    range.location = 6;
    range.length = 2;
    int d = [[day substringWithRange:range] intValue];
    [dateComps setDay:d];
    range.location = 4;
    range.length = 2;
    int m = [[day substringWithRange:range] intValue];
    [dateComps setMonth:m];
    range.location = 0;
    range.length = 4;
    int y = [[day substringWithRange:range] intValue];
    [dateComps setYear:y];
    [dateComps setHour:[curentShow startHour]];
    [dateComps setMinute:[curentShow startMin]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) 
    {
        if (notif == nil) 
        {
            notif = [[UILocalNotification alloc] init];
            if (notif == nil)
                return nil;
            NSDate *date = [itemDate dateByAddingTimeInterval:-(minutesBefore*60)];
            //NSLog(@"set_local_notif for date:%@  min_before:%d",date,minutesBefore);
            notif.fireDate = date;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            NSString *chnName = curentShow.rTVChannel.pName;
            if (chnName == nil)
                chnName = @"";
            
            alertString = [NSString stringWithFormat:@"\"%@\" по каналу \"%@\" начнется через %i минут",
                           [curentShow name], chnName, minutesBefore];
            notif.alertBody = alertString;
            notif.alertAction = NSLocalizedString(@"OK", nil);
            //          localNotif.hasAction = YES; //zs
            
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber = 1;
            //NSLog(@"%@", [curentShow day]);
            NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[curentShow name], @"showName" , [curentShow day], @"day", [NSNumber numberWithInt:[curentShow startHour]], @"hour", [NSNumber numberWithInt:[curentShow startMin]], @"min",
                                      [NSNumber numberWithInt:minutesBefore], @"minBefore",
                                      chnName, @"channelName", 
                                      curentShow.rTVChannel.pImage, @"channelImage",
                                      nil];
            notif.userInfo = infoDict;
        } 
        
//        [[UIApplication sharedApplication] scheduleLocalNotification:notif];         
        //        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif]; //show immediatelly
    }
    
    return notif;
}


-(void)addNotification
{
    if (localNotif == nil)
        return;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];         
//  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif]; //show immediatelly    
}


-(void)removeNotification
{
    if (localNotif == nil)
        return;
    [[UIApplication sharedApplication] cancelLocalNotification:localNotif];    
}


-(void)setAlarmButtonTag:(NSInteger)tag
{
    alarmButton.tag = tag;
    if (tag == 1) {
        [alarmButton setImage:[UIImage imageNamed:@"reminder_dis.png"] forState:UIControlStateNormal];
    }
    if (tag == 2) {
        [alarmButton setImage:[UIImage imageNamed:@"reminder_icon.png"] forState:UIControlStateNormal];
    } 
}


-(void)setNotification:(id)sender
{
    if (alarmButton.tag == 1) {
        [self addNotification];
        [self setAlarmButtonTag:2];
    } else {
        [self removeNotification];
        [self setAlarmButtonTag:1];
    }

}


-(void) showProgramDataMTV:(MTVShow *)show 
                   channel:(MTVChannel*)chanel
             minutesBefore:(int) min 
            forChannelName:(NSString*)channelName
{
    minutesBefore = min;
    
    myImageView.image = [chanel icon]; //[[TVDataSingelton sharedTVDataInstance] getIcon:iconName]; //[UIImage imageWithContentsOfFile:[docDir stringByAppendingPathComponent:iconName]];
    channelLabel.text = channelName;
    
    curentShow = show;
    [titleLabel setText:[show name]];
    [dateLabel setText:[NSString stringWithFormat:@"%@", convertDateToUserView2([show day])]];
    [timeLabel setText:[NSString stringWithFormat:@"%.2d:%.2d - %.2d:%.2d", [show startHour], [show startMin],
                        [show endHour], [show endMin]]];
    
    textLabel.text = [show descript];
    textLabel.hidden = [show descript].length == 0;
    
    CGSize descFrame = [textLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(textLabel.contentSize.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    textLabel.contentSize = CGSizeMake(textLabel.contentSize.width, descFrame.height + 30.0f);
    
    // hide alarm button if show already begin or ended
    alarmButton.hidden = [[show.pStart earlierDate:[NSDate date]] isEqualToDate:show.pStart];
    
    // change button to set/reset alarm
    Class localNotificationC = NSClassFromString(@"UILocalNotification");
    if (localNotificationC) 
    {
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (int i = 0; i < [notificationArray count]; i++) 
        {
            UILocalNotification *notif = [notificationArray objectAtIndex:i];
            NSDictionary *infoDict = notif.userInfo;
            NSString * name = [infoDict objectForKey:@"show"];
            NSString * day = [infoDict objectForKey:@"day"];
            int hour = [[infoDict objectForKey:@"hour"] intValue];
            int min = [[infoDict objectForKey:@"min"] intValue];
            if ([[curentShow name] isEqualToString:name]) 
            {
                if ([[curentShow day] isEqualToString: day] 
                    && ([curentShow startHour] == hour) 
                    && ([curentShow startMin] == min)) 
                {
//                  alarmButton.enabled = NO;
                    localNotif = notif; //found notification
                    [self setAlarmButtonTag:2];
                    break;
                } 
            }
        }
        if (localNotif == nil) {
            localNotif = [self makeNotification]; //make new notification
            [self setAlarmButtonTag:1];            
        }
    }
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

@end
