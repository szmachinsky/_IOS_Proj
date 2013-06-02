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
- (void) channelIsSelected:(NSString *)channel chID:(NSInteger)chId;
@end

@interface FavTableViewController : UITableViewController {
//    NSString *currentDay;
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
    NSArray *selArrays_; 
    NSArray *tabData_;
    NSArray *nextData_;
//    NSArray *favArrays_;
    int count_;
    
    NSTimer *myTicker_;
}
@property (strong) NSManagedObjectContext *context; //zs
@property (strong) NSArray *selArrays; //zs 
@property (strong) NSArray *tabData; //zs
@property (strong) NSArray *nextData; //zs
//@property (strong, nonatomic) NSArray *favArrays; //zs 
//@property (strong, nonatomic) WaitView *waitView;  //zs 
    

@property (strong) id delegate;

-(void) updateProgramToDate:(NSString *)day;
-(void) setTime:(int)h minutes:(int)m;
-(void) reloadData;

@end
