//
//  TVTableViewController.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaitView;

@protocol ChannelSelectionDelegate <NSObject>
@required
- (void) channelIsSelected:(NSString *)channel;
@optional
- (void) channelIsSelected:(NSString *)channel chID:(NSInteger)chId;
@end


@interface SZTVTableViewController : UITableViewController {
    int hour;
    int min;
    int hour_;
    int min_;
    id <ChannelSelectionDelegate> delegate;
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
}
@property (strong) NSManagedObjectContext *context; //zs
@property (strong) NSArray *tabData; //zs
@property (strong) NSArray *nextData; //zs
@property (strong) NSArray *selArrays; //zs 
//@property (strong, nonatomic) WaitView *waitView;  //zs 



@property (strong) id delegate;

-(id)init;
-(void) updateProgramToDate:(NSString *)day;
-(void) setTime:(int)h minutes:(int)m;
-(void) update;
-(void) setHeight:(int)h fromBottom:(int)dif;

@end
