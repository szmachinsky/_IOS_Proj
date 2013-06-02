//
//  ProgramsByCattegoryViewController.h
//  TVProgram
//
//  Created by User1 on 26.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramsCategoryTableController.h"
#import "ProgramSelectionDelegate.h"

@class DaySelectionController;
@interface ProgramsByCattegoryViewController : UIViewController <ProgramSelectionDelegate> 
{
    UILabel *categoryNameLabel;
    NSString * categoryName;
    UIButton * dateButton;
    ProgramsCategoryTableController *tableController;
    NSString * currentDate;
    UIImageView *time_panel;
    UILabel *label;
    UIButton * channelButton;
    UIButton * timeButton;
    UILabel *dateLabel;
    
//    NSMutableArray * programms;
        
    DaySelectionController *daySelection;
    NSInteger catID_;    
}
@property (weak) id delegate; //strong zs

-(void)setData:(NSString *)catName forDate:(NSString *)date;
-(void)setData:(NSString *)catName catId:(NSInteger)catId forDate:(NSString *)date;
- (void)updateDataForNewDay:(NSString *)day;

@end
