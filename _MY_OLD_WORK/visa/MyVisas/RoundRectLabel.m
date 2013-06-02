//
//  RoundRectLabel.m
//  MyVisas
//
//  Created by Nnn on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RoundRectLabel.h"

@implementation RoundRectLabel
@synthesize editing, editMode, color;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.color = [UIColor greenColor];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)drawRect:(CGRect)rect {
    UIColor *fillColor = editMode ? [[UIColor whiteColor] colorWithAlphaComponent:0.2f] : (color ? color : [[UIColor greenColor] colorWithAlphaComponent:0.2f]);
    fillColor = editing ? [[UIColor blueColor] colorWithAlphaComponent:0.4f] : fillColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGFloat radius = 5.0f;
    CGFloat minx = CGRectGetMinX(rect) + 1.0f, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) - 1.0f;
    CGFloat miny = CGRectGetMinY(rect) + 1.0f, midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect) - 1.0f;
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); 
    
    [super drawRect:rect];
}

- (void)setEditing:(BOOL)isEditing {
    editing = isEditing;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)newColor {
    [color release];
    color = [newColor retain];
    [self setNeedsDisplay];
}

- (void)addTarget:(id)target action:(SEL)action {
    lTarget = target;
    lAction = action;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!editing && editMode) {
        if (lTarget != nil) {
            [lTarget performSelector:lAction withObject:self];
        }
        self.editing = YES;
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    [color release];
    [super dealloc];
}


@end
