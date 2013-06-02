//
//  WaitScreenView.m
//  EIC
//
//  Created by Dima Duleba on 15.11.11.
//  Copyright 2011 EleganceIT. All rights reserved.
//

#import "WaitScreenView.h"

@implementation WaitScreenView

@synthesize activityIndicator = _activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.frame = CGRectMake((frame.size.width - _activityIndicator.frame.size.width)/2,
                                                  (frame.size.height - _activityIndicator.frame.size.height)/2,
                                                  _activityIndicator.frame.size.width,
                                                  _activityIndicator.frame.size.height);
        
        [self addSubview:_activityIndicator];
        [self setHidden:YES];
    }
    return self;
}

#pragma mark - Memory management
-(void)dealloc
{
    [_activityIndicator release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - Instance methods

-(void)showWaitScreen
{
    [self.activityIndicator startAnimating];
    [self setHidden:NO];
}

-(void)hideWaitScreen
{
    [self.activityIndicator stopAnimating];
    [self setHidden:YES];
}

@end
