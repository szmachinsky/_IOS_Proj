//
//  WaitView.m
//  EIC
//
//  Created by Dima Duleba on 15.11.11.
//  Copyright 2011 EleganceIT. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView
@synthesize inRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        inRect = frame;
//        self.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:24/255.0 blue:7/255.0  alpha:0.6];
//      self.alpha = 0.6;
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);          
        activityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator_.frame = CGRectMake((frame.size.width - activityIndicator_.frame.size.width)/2,
                                                  (frame.size.height - activityIndicator_.frame.size.height)/2,
                                                  activityIndicator_.frame.size.width,
                                                  activityIndicator_.frame.size.height);        
        [self addSubview:activityIndicator_];
        [self setHidden:YES];
//        [activityIndicator_ startAnimating];
    }
    return self;
}

#pragma mark - Memory management
-(void)dealloc
{
    activityIndicator_=nil;
}

#pragma mark - Instance methods
- (void)showWaitScreen
{
    if (self.inRect.size.width == 0) {
        CGRect _frame1 = self.superview.frame;
//      CGRect _frame2 = [[UIScreen mainScreen] applicationFrame];
//      self.center = self.superview.center;
        self.frame = _frame1;
    } else {
//        self.frame = self.inRect;        
    }
    activityIndicator_.center = self.center;    
    
    [activityIndicator_ startAnimating];
    [self setHidden:NO];
}

- (void)hideWaitScreen
{
    [activityIndicator_ stopAnimating];
    [self setHidden:YES];
}

@end
