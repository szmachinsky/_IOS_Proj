//
//  UpView.h
//  TVProgram
//
//  Created by User1 on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpView : UIView {
    UILabel *dateLabel;
    UILabel *timeLabel;
    NSTimer *myTicker;
    NSString *currentDate;
}
@property (strong) NSString *currentDate;

- (void)setDate:(NSString *)newDate;

@end
