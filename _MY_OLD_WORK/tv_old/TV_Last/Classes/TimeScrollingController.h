//
//  TimeScrollingController.h
//  TVProgram
//
//  Created by User1 on 19.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaySelectionController.h"


@protocol SliderDelegate <NSObject>
@required
- (void) updateTime:(int)hour minutes:(int)min;
@end

@interface TimeScrollingController : UIView {
    UISlider * timeSlider;
    UILabel * sliderValue;
    UIButton *nowButton;
    UIImageView *bg;
    __weak id <SliderDelegate,DaySelectionDelegate> delegate;
    float dx;
}

@property (weak) id delegate; //zs strong
- (void) setTime: (int) hour forMin:(int)min;
@end
