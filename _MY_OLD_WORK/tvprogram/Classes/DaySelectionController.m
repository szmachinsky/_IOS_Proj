//
//  DaySelectionController.m
//  TVProgram
//
//  Created by User1 on 17.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DaySelectionController.h"
#import "DaySelectionButton.h"

#import "TVDataSingelton.h"

@implementation DaySelectionController
@synthesize delegate;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)orientationChanged:(NSNotification *)notification
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(deviceOrientation))
    {
        float x = 4;
        float y = 60;
        for (int i = 0; i < [buttons count]; i++)
        {
            DaySelectionButton *dayButton = [buttons objectAtIndex:i];
            dayButton.frame = CGRectMake(x, y, 228, 45);
            y += 50;
            if(i == 3)
            {
                x = 250;
                y = 60;
            }
        }
    }
    else
    {
        for (int i = 0; i < [buttons count]; i++)
        {
            DaySelectionButton *dayButton = [buttons objectAtIndex:i];
            dayButton.frame = CGRectMake((frame.size.width- 278)/2, 70 + 45*i, 278, 45);
        }
    }
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIView *view = [[UIView alloc ] initWithFrame:frame];
    self.view = view;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [SZUtils color03];
    UIImageView *titleView = [[UIImageView alloc]init];
    titleView.image = [UIImage imageNamed:@"title_back.png"];
    titleView.frame = CGRectMake(0, 0, 320, 50);
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:titleView];
    
//    UILabel *initLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 120.0f, CGRectGetWidth(self.view.frame) - 40.0f, 80.0f)];
//    initLabel.text = @"нет выбранных каналов";
//    initLabel.textAlignment = UITextAlignmentCenter;
//    initLabel.backgroundColor = [UIColor clearColor];
//    initLabel.font = [UIFont boldSystemFontOfSize:20.0f];
//    initLabel.textColor = [SZUtils color02];
//    [self.view addSubview:initLabel];        
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:19];
    label.text = @"Выберите день недели";
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:label];
    labelTitle_ = label;
    
    // TODO: make rotation
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
    //                                             name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)changeDate:(id)sender
{
    DaySelectionButton *btn = sender;
    if(btn.selected == YES)
    {
        NSString *date = btn.day;
        _NSLog(@"day = %@",date);    
        [[self delegate] dayIsSelected:date];
        [[TVDataSingelton sharedTVDataInstance] setCurrentDate:date];
        [self.view removeFromSuperview];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _NSLog(@">%d",buttonIndex);
    [self.view removeFromSuperview];

}

-(void)show:(NSArray *)days
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    buttons = [[NSMutableArray alloc] init];
    NSInteger numOfDays = days.count > 7 ? 7 : days.count;
//    if ([SZAppInfo shared].colSelChannels == 0)
//        return;
    if (numOfDays == 0) {
//        labelTitle_.text = @"нет выбранных каналов";
//        if (days == nil) {
//            days = [[NSMutableArray alloc] initWithObjects: @"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота", @"Воскресенье", nil];
//            numOfDays = days.count;
//        }            
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"для отображения данных должен быть выбран хотя бы один канал"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];        
    }
    for (int i = 0; i < numOfDays; i++) {
        DaySelectionButton *dayButton = [DaySelectionButton buttonWithType:UIButtonTypeCustom];
        
        dayButton.frame = CGRectMake((frame.size.width - 278)/2, 70 + 50*i, 278, 45);
        NSString * day = [days objectAtIndex:days.count - numOfDays + i];
        [dayButton setDate:day forShort:NO forIndex:i];
        if ([curDate isEqualToString:day]) {
            dayButton.selected = YES;
        }
        [dayButton addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dayButton];
        [buttons addObject:dayButton];
    }
}

-(void)setSelectedDate:(NSString *)date
{
    curDate = [[NSString stringWithString:date] copy];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(CGRectContainsPoint(myImageView.frame, [touch locationInView:self.view] ) == NO)
    {
        [self.view removeFromSuperview];
    }
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
