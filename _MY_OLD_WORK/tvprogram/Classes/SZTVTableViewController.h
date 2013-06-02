//
//  TVTableViewController.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KHDaySliderView.h"
#import "KHDaySliderBar.h"
#import "ProgramSelectionDelegate.h"

@class WaitView;
@class GuideViewController;

//@protocol ChannelSelectionDelegate <NSObject>
//@required
//- (void) channelIsSelected:(NSString *)channel;
//@optional
//- (void) channelIsSelected:(NSString *)channel chID:(NSInteger)chId;
//@end

//@protocol CategorySelectionDelegate <NSObject>
//- (void)categorySelected:(int)cat;
//@end

@interface SZTVTableViewController : UITableViewController {
    int hour;
    int min;
    int hour_;
    int min_;
    __weak id <ChannelSelectionDelegate,CategorySelectionDelegate,ProgramSelectionDelegate> delegate;
    BOOL isCurrDateToday;
 
    NSString *currentDay_;
    NSDate *currToday_;
    NSDate *currDate_;
    
    NSManagedObjectContext *context_;
    NSArray *tabData_;
    NSArray *nextData_;
    NSArray *selArrays_;
    
//    __block NSArray *tabData__;
//    __block NSArray *nextData__;    
//    __block NSArray *selArrays__;
    int count_;
    
    NSTimer *myTicker_;
    
    __weak KHDaySliderView *slider;
}
@property (strong) NSManagedObjectContext *context; //zs
@property (strong) NSArray *tabData; //zs
@property (strong) NSArray *nextData; //zs
@property (strong) NSArray *selArrays; //zs 
//@property (strong, nonatomic) WaitView *waitView;  //zs 

@property (weak) id delegate;
@property (weak) KHDaySliderView *slider;

@property (nonatomic,assign) BOOL isFavorite;
@property (nonatomic,assign) NSInteger tabNumber;

-(id)init;
-(void) updateProgramToDate:(NSString *)day;
-(void) setTime:(int)h minutes:(int)m;
-(void) update;
-(void) setHeight:(int)h fromBottom:(int)dif;

-(void) reloadDataTable;

@end
