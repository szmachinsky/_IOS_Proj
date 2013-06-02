//
//  SeparatorLine.m
//  MyVisas
//
//  Created by Natalia Tsybulenko on 25.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SeparatorLine.h"

@implementation SeparatorLine
@synthesize dashed;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 1.0f;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (dashed) {
        CGContextSetRGBStrokeColor(context, 190.0f, 190.0f, 190.0f, 0.5f);
        CGPoint points[160] = {CGPointMake(0.0f, 0.0f)};
        CGFloat x = 0.0f;
        for (int i = 0; i < 160; i++) {
            points[i] = CGPointMake(x, 0.0f);
            x += 2.0f;
        }
        CGContextStrokeLineSegments (context, points, 160);
    }
    else {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f].CGColor);
        CGContextStrokeRect(context, CGRectMake(0.0f, 0.0f, 300.0f, 1.0f));
    }
}


@end
