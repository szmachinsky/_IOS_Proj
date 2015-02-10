//
//  KHDaySliderView.m
//  KHDaySliderView
//
//  Created by khuala on 9/11/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import "KHDaySliderView.h"
#import "KHStretchView.h"

@interface KHDaySliderView ()

@property (nonatomic, weak) UILabel *dialogView;
@property (nonatomic, weak) UIView *fillView;
@property (nonatomic, weak) UIView *timeView;
@property (nonatomic, weak) UIImageView *markView;
@property (nonatomic, weak) UITextView *hintView;

@property (nonatomic, assign) CGFloat timeWidth;


- (NSString *)_hintText;
- (void)_setActive:(BOOL)active animated:(BOOL)animated;
- (void)_markTapGesture:(UITapGestureRecognizer *)recognizer;
- (void)_setPassiveWithAnimation;

- (void)_mainPanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)_mainTapGesture:(UIPanGestureRecognizer *)recognizer;

@end



const CGFloat KHDaySliderViewMaxValue  = 24.0;
const CGFloat KHDaySliderViewMinWidth  = 320.0;
const CGFloat KHDaySliderViewMinHeihgt = 50.0;

const CGFloat KHDaySliderViewTimeOffsetX = 7.0;
const CGFloat KHDaySliderViewMarkOffsetX = -24.0;
const CGFloat KHDaySliderViewMarkOffsetY = -17.0;

@implementation KHDaySliderView
{
    NSDateFormatter *_hintDateFormatter;
}

#pragma mark - Properties

@synthesize delegate = _delegate;

@synthesize value = _value;
@synthesize currentValue = _currentValue;
@synthesize precision = _precision;
@synthesize markView = _markView;
@synthesize dialogView = _dialogView;
@synthesize fillView = _fillView;
@synthesize timeView = _timeView;
@synthesize hintView = _hintView;

@synthesize timeWidth = _timeWidth;

- (void)setPrecision:(CGFloat)precision
{
    _precision = (precision < 0.1 || precision > 4.0) ? 1.0 : precision;
}

- (CGFloat)_correctValue:(CGFloat)value
{
    return (value > KHDaySliderViewMaxValue) ? KHDaySliderViewMaxValue : roundf(value / self.precision) * self.precision;
}

- (CGFloat)_positionForValue:(CGFloat)value
{
    return roundf(self.timeWidth * value / KHDaySliderViewMaxValue) + KHDaySliderViewTimeOffsetX;
}

- (void)setValue:(CGFloat)value
{
    _value = [self _correctValue:value];
        
    CGRect markFrame = self.markView.frame;
    markFrame.origin.x = KHDaySliderViewMarkOffsetX + [self _positionForValue:_value];
    
    self.markView.frame = markFrame;
    self.hintView.text = [self _hintText];
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    _currentValue = [self _correctValue:currentValue];
    
    CGRect fillFrame = self.fillView.frame;
    fillFrame.size.width = [self _positionForValue:_currentValue];
    
    self.fillView.frame = fillFrame;
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    // update frame size widht
    if (frame.size.width < KHDaySliderViewMinWidth) {
        frame.size.width = KHDaySliderViewMinWidth;
    }
    
    // update frame size height
    if (frame.size.height < KHDaySliderViewMinHeihgt) {
        frame.size.height = KHDaySliderViewMinHeihgt;
    }
    
    if (self = [super initWithFrame:frame]) {
        
        UIImage *timeImage = [UIImage imageNamed:@"sliderTime.png"];
        UIImage *baseImage = [UIImage imageNamed:@"sliderBase.png"];
        UIImage *fillImage = [UIImage imageNamed:@"sliderFill.png"];
        UIImage *markImage = [UIImage imageNamed:@"sliderMark.png"];
        UIImage *markImageHighlighted = [UIImage imageNamed:@"sliderMarkHighlighted.png"];
        UIImage *hintImage = [UIImage imageNamed:@"sliderHint.png"];
        
        CGRect timeFrame;
        timeFrame.size = timeImage.size;
        timeFrame.origin.x = roundf((CGRectGetWidth (self.frame) - CGRectGetWidth (timeFrame)) / 2);
        timeFrame.origin.y = roundf((CGRectGetHeight(self.frame) - CGRectGetHeight(timeFrame)) / 2);
        
        CGRect baseFrame = CGRectZero;
        baseFrame.size = baseImage.size;
        
        CGRect fillFrame = CGRectZero;
        fillFrame.size = fillImage.size;
        
        CGRect markFrame = CGRectZero;
        markFrame.size = markImage.size;
        markFrame.origin.x = KHDaySliderViewMarkOffsetX + KHDaySliderViewTimeOffsetX;
        markFrame.origin.y = KHDaySliderViewMarkOffsetY;
        
        CGRect hintFrame = CGRectZero;
        hintFrame.size = hintImage.size;
        hintFrame.origin.x = roundf((CGRectGetWidth(markFrame) - CGRectGetWidth(hintFrame)) / 2) - 1;
        hintFrame.origin.y = 2 - CGRectGetHeight(hintFrame);
        
        KHStretchView *timeView = [[KHStretchView alloc] initWithFrame:timeFrame];
        UIView *baseView = [[UIView alloc] initWithFrame:baseFrame];
        UIView *fillView = [[UIView alloc] initWithFrame:fillFrame];

        timeView.backgroundColor = [UIColor colorWithPatternImage:timeImage];
        baseView.backgroundColor = [UIColor colorWithPatternImage:baseImage];
        fillView.backgroundColor = [UIColor colorWithPatternImage:fillImage];
        
        UIImageView *markView = [[UIImageView alloc] initWithImage:markImage highlightedImage:markImageHighlighted];
        [markView setUserInteractionEnabled:YES];
        [markView setFrame:markFrame];
        
        UITextView *hintView = [[UITextView alloc] initWithFrame:hintFrame];
        hintView.backgroundColor = [UIColor colorWithPatternImage:hintImage];
        hintView.textColor = [UIColor whiteColor];
        hintView.textAlignment = UITextAlignmentCenter;
        hintView.font = [UIFont boldSystemFontOfSize:14.0];
        hintView.hidden = YES;
        
        [markView addSubview:hintView];

        [timeView addSubview:fillView];
        [timeView addSubview:baseView];
        [timeView addSubview:markView];
        
        [self addSubview:timeView];
        
        UIPanGestureRecognizer *mainPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_mainPanGesture:)];
        UITapGestureRecognizer *mainTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_mainTapGesture:)];
        UITapGestureRecognizer *markTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_markTapGesture:)];
        
        [markView addGestureRecognizer:markTapGestureRecognizer];
        [self addGestureRecognizer:mainPanGestureRecognizer];
        [self addGestureRecognizer:mainTapGestureRecognizer];
        
        self.fillView  = fillView;
        self.markView  = markView;
        self.timeView  = timeView;
        self.hintView  = hintView;
        self.precision = 1.0;
        self.timeWidth = timeFrame.size.width - 2 * KHDaySliderViewTimeOffsetX;
        
        self.markView.hidden = NO;
        
        NSDateFormatter *hintDateFormatter = [[NSDateFormatter alloc] init];
        [hintDateFormatter setDateFormat:@"HH:mm"];

        _hintDateFormatter = hintDateFormatter;
    }
    return self;
}

#pragma mark - Gestures

- (void)_respondToRecognizer:(UIGestureRecognizer *)recognizer
{
    CGFloat minLimitX = 0.0;
    CGFloat maxLimitX = self.timeWidth;
    
    CGFloat x = [recognizer locationInView:self.timeView].x - KHDaySliderViewTimeOffsetX;
    
    if (x < minLimitX) {
        x = minLimitX;
    } else if (x > maxLimitX) {
        x = maxLimitX;
    }
    
    self.value = KHDaySliderViewMaxValue * (x / self.timeWidth);
}

- (void)_mainPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self _setActive:YES animated:NO];
        [UIView animateWithDuration:0.4 animations:^{
            [self _respondToRecognizer:recognizer];
        }];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self _respondToRecognizer:recognizer];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self _setActive:NO animated:YES];
        
        // notify delegate of value changing
        [self.delegate sliderView:self didFinishWithValue:self.value];
    }
}

- (void)_mainTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self _setActive:YES animated:NO];
        [UIView animateWithDuration:0.4
                         animations:^{
                             [self _respondToRecognizer:recognizer];
                         }
                         completion:^(BOOL finished) {
                             [self _setActive:YES animated:NO];
                             [self _setActive:NO animated:YES];
                             
                             // notify delegate of value changing
                             [self.delegate sliderView:self didFinishWithValue:self.value];
                         }];
    }
}

- (void)_markTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self _setActive:YES animated:NO];
        [self _setActive:NO animated:YES];
    }
}

#pragma mark - Hint

- (NSString *)_hintText
{
    return [_hintDateFormatter stringFromDate:[KHDaySliderDateComponentsWithValue(self.value) date]];
}

- (void)_setActive:(BOOL)active animated:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (animated && !active) {
        [self performSelector:@selector(_setPassiveWithAnimation) withObject:nil afterDelay:2.0];
    } else {
        self.markView.highlighted = active;
        self.hintView.hidden = !active;
    }
}

- (void)_setPassiveWithAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.hintView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         self.hintView.alpha = 1.0;
                         self.hintView.hidden = YES;
                         self.markView.highlighted = NO;
                     }];
}

@end

float KHDaySliderValueWithDate(NSDate *date)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    
    return dateComponents.hour + dateComponents.minute / 60.0;
}

NSDateComponents *KHDaySliderDateComponentsWithValue(float value)
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.calendar = [NSCalendar currentCalendar];
    dateComponents.hour = value;
    dateComponents.minute = (value - dateComponents.hour) * 60;

    return dateComponents;
}
