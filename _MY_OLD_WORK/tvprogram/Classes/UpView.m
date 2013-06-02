//
//  UpView.m
//  TVProgram
//
//  Created by User1 on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UpView.h"
#import "CommonFunctions.h"

@implementation UpView
@synthesize currentDate;

#define Height 44

#pragma mark - View lifecycle

- (void)showActivity {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"HH:mm"];
    timeLabel.text = [formatter stringFromDate:date];
}

- (void)runTimer {
    
    myTicker = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                target: self
                                              selector: @selector(showActivity)
                                              userInfo: nil
                                               repeats: YES];
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL toLandscape = (UIInterfaceOrientationIsLandscape(deviceOrientation));
    UIFont *labelsFont = toLandscape ? [UIFont boldSystemFontOfSize:16] : [UIFont boldSystemFontOfSize:12];
    dateLabel.font = timeLabel.font = labelsFont;
    
    CGRect dateFrame = dateLabel.frame;
    dateFrame.origin.y = toLandscape ? 20.0f : 15.0f;
    dateLabel.frame = dateFrame;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        dateLabel = [[UILabel alloc] init];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.frame = CGRectMake(0, 20.0f, CGRectGetWidth(frame), Height/2);
        dateLabel.textAlignment = UITextAlignmentCenter;
        dateLabel.font = [UIFont boldSystemFontOfSize:16];
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.frame = CGRectMake(0, 0, CGRectGetWidth(frame), Height/2);
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.font = [UIFont boldSystemFontOfSize:16];
        timeLabel.textColor = [UIColor whiteColor];
        [self showActivity];
        [self addSubview:timeLabel];
        [self runTimer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

-(void)setDate:(NSString *)date
{
    currentDate = [[NSString stringWithString:date] copy];
    NSString *weekDay = getWeekDay(date);
    [dateLabel setText:weekDay];
}

- (void)removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [myTicker invalidate]; //zs
    myTicker = nil;    
}


@end
