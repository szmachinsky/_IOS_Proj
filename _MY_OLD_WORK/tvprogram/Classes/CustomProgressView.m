//
//  CustomProgressView.m
//  TVProgram
//
//  Created by Irisha on 06.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomProgressView.h"


#define kCustomProgressViewFillOffsetX 0
#define kCustomProgressViewFillOffsetTopY 0
#define kCustomProgressViewFillOffsetBottomY 0

@implementation CustomProgressView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame: frame] ;
//    self.alpha = 0.15;
    
//    background = [UIImage imageNamed:@"im_4.png"];
//    fill = [UIImage imageNamed:@"im_5.png"]; 
        
    
////  CGFloat h = frame.size.height;
////  CGSize backgroundStretchPoints = {6, 11}, fillStretchPoints = {5, 10};
//    CGSize backgroundStretchPoints = {21, 15}, fillStretchPoints = {20, 14};
////  CGSize backgroundStretchPoints = {6, h-4}, fillStretchPoints = {5, h-5}; 
//    background = [[UIImage imageNamed:@"butt_right.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width 
//                                                            topCapHeight:backgroundStretchPoints.height];    
//    fill = [[UIImage imageNamed:@"butt_left_on.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width 
//                                                            topCapHeight:fillStretchPoints.height]; 
    
    
//    UIEdgeInsets ins = {14,20,15,21}; 
//    background = [[UIImage imageNamed:@"butt_right.png"] resizableImageWithCapInsets:ins];
//    fill = [[UIImage imageNamed:@"butt_left_on.png"] resizableImageWithCapInsets:ins]; 

//    UIEdgeInsets ins = {20,10,21,11}; 
//    fill = [[UIImage imageNamed:@"programm_1.png"] resizableImageWithCapInsets:ins];
//    background = [[UIImage imageNamed:@"programm_timeline_1.png"] resizableImageWithCapInsets:ins]; 
//    arrow = [[UIImage imageNamed:@"time_arrow.png"] resizableImageWithCapInsets:ins];

    background = [UIImage imageNamed:@"programm_timeline_1.png"];
    fill = [UIImage imageNamed:@"programm_1.png"]; 
    arrow = [UIImage imageNamed:@"programm_timeline_arrow.png"];
    
    
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    return  self;    
}

//- (void)drawRect:(CGRect)rect {
//    
//    CGSize backgroundStretchPoints = {6, 11}, fillStretchPoints = {5, 10};
//    
//    // Initialize the stretchable images.
//    UIImage *background = [[UIImage imageNamed:@"grayslide.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width 
//                                                                                           topCapHeight:backgroundStretchPoints.height];
//    
//    UIImage *fill = [[UIImage imageNamed:@"orangeslide.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width 
//                                                                                       topCapHeight:fillStretchPoints.height];  
//    
//    // Draw the background in the current rect
//    [background drawInRect:rect];
//    
//    // Compute the max width in pixels for the fill.  Max width being how
//    // wide the fill should be at 100% progress.
//    NSInteger maxWidth = rect.size.width - (2 * kCustomProgressViewFillOffsetX);
//    
//    // Compute the width for the current progress value, 0.0 - 1.0 corresponding 
//    // to 0% and 100% respectively.
//    NSInteger curWidth = floor([self progress] * maxWidth);
//    curWidth = self.progress != 0 ? MAX(10.0f, curWidth) : curWidth;
//    
//    // Create the rectangle for our fill image accounting for the position offsets,
//    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
//    CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetX,
//                                 rect.origin.y + kCustomProgressViewFillOffsetTopY,
//                                 curWidth,
//                                 rect.size.height - kCustomProgressViewFillOffsetBottomY);
//    
//    // Draw the fill
//    [fill drawInRect:fillRect];
//}

- (void)drawRect:(CGRect)rect {
    
    //    UIEdgeInsets ins = {14,20,15,21}; 
    //    if (background == nil)
    //        background = [[UIImage imageNamed:@"butt_right.png"] resizableImageWithCapInsets:ins];
    //    if (fill == nil)
    //        fill = [[UIImage imageNamed:@"butt_left_on.png"] resizableImageWithCapInsets:ins]; 
    //    self.alpha = 0.15;
    //    CGRect fr = self.frame;
    //    fr.size.height = 50;
    //    self.frame = fr;
    
    
//    CGSize backgroundStretchPoints = {6, 11}; 
//    CGSize fillStretchPoints = {5, 10};    
    // Initialize the stretchable images.
//    UIImage *background = [[UIImage imageNamed:@"grayslide.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width 
//                                                                                     topCapHeight:backgroundStretchPoints.height];    
//    UIImage *fill = [[UIImage imageNamed:@"butt_center_on.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width 
//                                                                                 topCapHeight:fillStretchPoints.height]; 

    
//    CGFloat h = rect.size.height;
//    CGSize backgroundStretchPoints = {6, h-4}; 
//    CGSize fillStretchPoints = {5, h-4};    
//    UIImage *background = [[UIImage imageNamed:@"butt_right.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width 
//                                                                                         topCapHeight:backgroundStretchPoints.height];    
//    UIImage *fill = [[UIImage imageNamed:@"butt_left_on.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width 
//                                                                                     topCapHeight:fillStretchPoints.height]; 

    
////    UIEdgeInsets ins = {20,8,19,7};   
////    UIEdgeInsets ins = {20,62,20,62};
//    UIEdgeInsets ins = {21,14,21,14}; 
//    UIImage *background = [[UIImage imageNamed:@"butt_right.png"] resizableImageWithCapInsets:ins];
//    UIImage *fill = [[UIImage imageNamed:@"butt_left_on.png"] resizableImageWithCapInsets:ins]; 
        

    
//    background = [UIImage imageNamed:@"im_4.png"];
//    fill = [UIImage imageNamed:@"im_5.png"]; 
    
    
    // Compute the max width in pixels for the fill.  Max width being how
    // wide the fill should be at 100% progress.
    NSInteger maxWidth = rect.size.width - (2 * kCustomProgressViewFillOffsetX);
    
    // Compute the width for the current progress value, 0.0 - 1.0 corresponding 
    // to 0% and 100% respectively.
    NSInteger curWidth = floor([self progress] * maxWidth);
    curWidth = self.progress != 0 ? MAX(10.0f, curWidth) : curWidth;
    
    // Create the rectangle for our fill image accounting for the position offsets,
    // 1 in the X direction and 1, 3 on the top and bottom for the Y.
    CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetX,
                                 rect.origin.y + kCustomProgressViewFillOffsetTopY,
                                 curWidth,
                                 rect.size.height - kCustomProgressViewFillOffsetBottomY - kCustomProgressViewFillOffsetTopY);

    // Draw the background in the current rect

    CGRect backRect = fillRect;    
    backRect.origin.x = fillRect.size.width+12;
    backRect.size.width = rect.size.width - fillRect.size.width;    
    [background drawInRect:backRect];
    
    [fill drawInRect:fillRect];
    
    CGRect arrRect = fillRect;
    arrRect.origin.x = fillRect.size.width;
    arrRect.size.width = 12;
    [arrow drawInRect:arrRect blendMode:kCGBlendModeDifference alpha:1];
    
//    self.trackImage = background;
//    self.progressImage = fill;
    
//    UIView *back = [[UIView alloc] init];
//    [self addSubview:back];
//    back.backgroundColor = [UIColor greenColor];
////    back.alpha = 0.2;
//    back.frame = rect;    
//    UIView *progress = [[UIView alloc] init];
//    [self addSubview:progress];
//    progress.backgroundColor = [UIColor redColor];
////    progress.alpha = 0.2;
//    progress.frame = fillRect;
    
    
    
}


@end
