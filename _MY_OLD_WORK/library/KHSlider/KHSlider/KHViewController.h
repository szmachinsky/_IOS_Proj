//
//  KHViewController.h
//  KHSlider
//
//  Created by khuala on 9/11/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHDaySliderView.h"

@interface KHViewController : UIViewController <KHDaySliderViewDelegate>

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value;

@end
