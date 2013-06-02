//
//  KHDaySliderView.h
//  KHDaySliderView
//
//  Created by khuala on 9/11/12.
//  Copyright (c) 2012 Redplanetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KHDaySliderViewDelegate;

float KHDaySliderValueWithDate(NSDate *date);
NSDateComponents *KHDaySliderDateComponentsWithValue(float value);

@interface KHDaySliderView : UIView

@property (nonatomic, weak) id <KHDaySliderViewDelegate> delegate;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float currentValue;
@property (nonatomic, assign) float precision;

@end

@protocol KHDaySliderViewDelegate <NSObject>

- (void)sliderView:(KHDaySliderView *)sliderView didFinishWithValue:(float)value;

@end
