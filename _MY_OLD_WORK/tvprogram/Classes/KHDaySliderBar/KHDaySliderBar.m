//
//  KHDaySliderBar.m
//  KHSlider
//
//  Created by khuala on 9/12/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import "KHDaySliderBar.h"

const CGFloat KHDaySliderBarWidth  = 320.0;
const CGFloat KHDaySliderBarHeihgt = 50.0;

@implementation KHDaySliderBar

- (id)initWithSliderView:(KHDaySliderView *)sliderView origin:(CGPoint)origin
{
    CGRect frame;
    frame.origin = origin;
    frame.size = CGSizeMake(KHDaySliderBarWidth, KHDaySliderBarHeihgt);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *backImage = [UIImage imageNamed:@"sliderBack.png"];
        
        CGRect backFrame;
        backFrame.size = backImage.size;
        backFrame.origin.x = roundf((CGRectGetWidth(frame) - CGRectGetWidth (backFrame)) / 2);
        backFrame.origin.y = roundf(CGRectGetHeight(frame) - CGRectGetHeight(backFrame));
        
        UIImageView *backView = [[UIImageView alloc] initWithImage:backImage];
        backView.frame = backFrame;
        
        [self addSubview:backView];
        [self addSubview:sliderView];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"KHDaySliderBar::init~" format:@"Could not use 'initWithFrame:' method of class KHDaySliderBar"];
    return nil;
}

- (id)init
{
    [NSException raise:@"KHDaySliderBar::init~" format:@"Could not use 'init' method of class KHDaySliderBar"];
    return nil;
}

@end
