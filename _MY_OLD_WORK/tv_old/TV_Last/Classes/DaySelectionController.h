//
//  DaySelectionController.h
//  TVProgram
//
//  Created by User1 on 17.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DaySelectionDelegate <NSObject>
@required
- (void) dayIsSelected:(NSString *)day;
@end

@interface DaySelectionController : UIViewController <UIAlertViewDelegate> {
    UIImageView *myImageView;
    NSMutableArray *buttons;
    __weak id <DaySelectionDelegate> delegate;
    NSString *curDate;
    __weak UILabel *labelTitle_;
}

@property (weak) id delegate; //zs strong

-(void)show:(NSArray *)days;
-(void)setSelectedDate:(NSString *)date;

@end
