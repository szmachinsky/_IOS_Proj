//
//  DatePicker.h
//  MyVisas
//
//  Created by Nnn on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerDelegate <NSObject>
- (void)pickerDonePressed:(id)sender;
@end

@interface DatePicker : UIView {
    UIDatePicker *picker;
}
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) id<DatePickerDelegate> delegate;


@end
