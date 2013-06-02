//
//  KHViewController.m
//  KHSlider
//
//  Created by khuala on 9/11/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import "KHViewController.h"
#import "KHDaySliderView.h"
#import "KHDaySliderBar.h"

@interface KHViewController ()

@end

@implementation KHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create slider
    KHDaySliderView *slider = [[KHDaySliderView alloc] init];

    // set delegate
    slider.delegate = self;
    
    // set precision for both values
    slider.precision = 1.0/6;

    // set value and current value
    slider.value = 8.0;
    slider.currentValue = KHDaySliderValueWithDate([NSDate date]);
    
    KHDaySliderBar *sliderBar = [[KHDaySliderBar alloc] initWithSliderView:slider origin:CGPointMake(0.0, 200.0)];

    // add slider view as subview of controller view
    [self.view addSubview:sliderBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Day slider view delegate

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value
{
    NSDateComponents *dateComponents = KHDaySliderDateComponentsWithValue(value);
    
    NSLog(@"Day slider value is %f, which means %d:%d", value, dateComponents.hour, dateComponents.minute);
}

@end
