//
//  TimeScrollingController.m
//  TVProgram
//
//  Created by User1 on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVDataSingelton.h"

#import "TimeScrollingController.h"
#import "CommonFunctions.h"

#import "ModelHelper.h"


@implementation TimeScrollingController

//#define Height 100
#define Height 68
#define SLIDER_HEIGHT 30

@synthesize delegate;

- (void) setSliderValue:(int)hour  
{
    sliderValue.text = [NSString stringWithFormat:@"%.2d:00", hour]; 
    float x =  hour * dx;
    //NSLog(@"sliderAction %f", x);
    sliderValue.center = CGPointMake(timeSlider.frame.origin.x + x + 10, sliderValue.center.y);
}

- (void) setSliderValue:(int)hour minutes:(int)min 
{
    sliderValue.text = [NSString stringWithFormat:@"%.2d:%.2d", hour,min]; 
    float x =  (hour * dx);// + (min*dx/60.0);
    //NSLog(@"sliderAction %f", x);
    sliderValue.center = CGPointMake(timeSlider.frame.origin.x + x + 10, sliderValue.center.y);
}


- (void)sliderActionMove:(id)sender
{ 
    int hour = timeSlider.value;
//    _NSLog(@">1>>");    
    [self setSliderValue: hour];

//    [[self delegate] updateTime:hour minutes:0];

//    NSDictionary *currTime = getCurrentTime();
//    int curHour = [[currTime objectForKey:@"hour"] intValue];
//zs    nowButton.enabled = curHour != hour;
//    nowButton.enabled = YES;
}

- (void)sliderActionDateChanged:(id)sender
{ 
    int hour = timeSlider.value;
    _NSLog(@">2>>");    
    [self setSliderValue: hour];
    
    [[self delegate] updateTime:hour minutes:0];
    
    //    NSDictionary *currTime = getCurrentTime();
    //    int curHour = [[currTime objectForKey:@"hour"] intValue];
    //zs    nowButton.enabled = curHour != hour;
    nowButton.enabled = YES;
}

- (void) setTime: (int) hour forMin:(int)min
{
    timeSlider.value = hour + (min / 60.0);
    
    [self setSliderValue:hour minutes:min];
    [[self delegate] updateTime:hour minutes:min];
}

-(void) gotoNow:(UIScrollView *)sender
{
    NSString *date = [[ModelHelper shared] dayForToday];
//    NSString *date = @"20120627";
//    NSString *date = @"20120624";
//    NSString *date = @"20120701";
//    NSString *date = @"20120702";
//    _NSLog(@" _NSLog( %@",date);    
    [[self delegate] dayIsSelected:date];
    [[TVDataSingelton sharedTVDataInstance] setCurrentDate:date];    
    
    NSDictionary *currTime = getCurrentTime();
    int curHour = [[currTime objectForKey:@"hour"] intValue];
    int curMin  = [[currTime objectForKey:@"min"] intValue];
    [self setTime:curHour forMin:curMin];
    
    
//    NSArray *days = [[TVDataSingelton sharedTVDataInstance] getDates];
//    NSInteger numOfDays = days.count; // > 7 ? 7 : days.count;
//    NSString *dayMin = [days objectAtIndex:0];
//    NSString *dayMax = [days objectAtIndex:numOfDays-1];
//    _NSLog(@" min:%@  ..... max:%@",dayMin,dayMax);
//zs    nowButton.enabled = NO;
    
}

- (void)orientationChanged:(NSNotification *)notification
{
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    dx = (isLandscape ? 420.0f : 240.0f)/26.0f;
    [self setSliderValue:timeSlider.value];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_panel.png"]];
        bg.frame = CGRectMake(0, 0, self.frame.size.width, Height);
        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:bg];
        
        timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(16, 22, CGRectGetWidth(self.frame) - 80, 12)];
        timeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [timeSlider addTarget:self action:@selector(sliderActionMove:) forControlEvents:UIControlEventValueChanged];
        [timeSlider addTarget:self action:@selector(sliderActionDateChanged:) forControlEvents:UIControlEventTouchUpInside];

        UIImage *stetchLeftTrack = [[UIImage imageNamed:@"greenslide.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        UIImage *stetchRightTrack = [[UIImage imageNamed:@"grayslide.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
        [timeSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
        [timeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [timeSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        timeSlider.minimumValue = 0.0;
        timeSlider.maximumValue = 24.0;
        timeSlider.continuous = YES; //zs YES
        
        // Add an accessibility label that describes the slider.
        [timeSlider setAccessibilityLabel:@"CustomSlider"];
        [self addSubview:timeSlider];
        
        UIColor *textColor = [SZUtils color04];
        UIColor *shadowColor = [SZUtils color05];
        
        // label with selected time
        sliderValue = [[UILabel alloc] init];
        sliderValue.backgroundColor = [UIColor clearColor];
        sliderValue.frame = CGRectMake(CGRectGetWidth(timeSlider.frame)*timeSlider.value, 5, 40, 16);
        sliderValue.textAlignment = UITextAlignmentCenter;
        sliderValue.font = [UIFont boldSystemFontOfSize:12];
        sliderValue.textColor = textColor;
        sliderValue.shadowOffset = CGSizeMake(1.0f, 1.0f);
        sliderValue.shadowColor = shadowColor;
        dx = timeSlider.frame.size.width/26;
        NSDictionary *currTime = getCurrentTime();
        int cHour = [[currTime objectForKey:@"hour"] intValue];
        [self setSliderValue:cHour];
        timeSlider.value = cHour;
        [self addSubview:sliderValue];
        
        UILabel *text = [[UILabel alloc]init];
        text.backgroundColor = [UIColor clearColor];
        text.frame = CGRectMake(16, 48, frame.size.width, 15);
        text.textAlignment = UITextAlignmentLeft;
        text.font = [UIFont systemFontOfSize:14];
        text.textColor = textColor;
        text.shadowOffset = CGSizeMake(1.0f, 1.0f);
        text.shadowColor = shadowColor;
        text.text = @"Выберите время"; 
        [self addSubview:text];
        
        nowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nowButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 55, 20, 50, 30);
        nowButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [nowButton setBackgroundImage:[UIImage imageNamed:@"realtime_button.png"] forState:UIControlStateNormal];
        [nowButton setBackgroundImage:[UIImage imageNamed:@"realtime_button_on.png"] forState:UIControlStateSelected];
        [nowButton setBackgroundImage:[UIImage imageNamed:@"realtime_button_disable.png"] forState:UIControlStateDisabled];
        nowButton.titleLabel.textColor = [UIColor whiteColor];
        [nowButton addTarget:self action:@selector(gotoNow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nowButton];
        nowButton.hidden = NO;
        nowButton.enabled = YES; //zs NO
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        

    }
    return self;
}

- (void)removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
