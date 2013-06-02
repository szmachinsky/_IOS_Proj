//
//  KHStretchView.m
//  KHSlider
//
//  Created by khuala on 9/14/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import "KHStretchView.h"

@implementation KHStretchView

#pragma mark - Events

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            return YES;
        }
    }
    return NO;
}

@end
