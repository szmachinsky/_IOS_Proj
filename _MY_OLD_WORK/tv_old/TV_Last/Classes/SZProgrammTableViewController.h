//
//  ProgrammTableViewController.h
//  TVProgram
//
//  Created by User1 on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramSelectionDelegate.h"

//@class Channel;
//@class Show;
//@class MTVShow;
//@protocol ProgramSelectionDelegate <NSObject>
//@required
////- (void) programIsSelected:(Show *)show;
//- (void) programIsSelectedMTV:(MTVShow*)show;
//@end



@interface SZProgrammTableViewController : UITableViewController 
{    
    NSMutableArray * programByCurrentDate;
    
//    Channel *currentChannel;
    NSString * currentDate;
    int currentProgramIndex;
    
    UITableView *mytableView;
    __weak id <ProgramSelectionDelegate> delegate;

    NSString *currentDay_;
    NSDate *currToday_;
    NSDate *currDate_;
    NSString *channelName_;
    NSManagedObjectContext *context_;
    NSArray *tabData_;
//    NSArray *selArrays_;
    int count_;

    NSTimer *myTicker_;    
}
@property (strong, nonatomic) NSManagedObjectContext *context; //zs
@property (strong, nonatomic) NSArray *tabData; //zs
//@property (strong, nonatomic) NSArray *selArrays; //zs 
@property (strong, nonatomic) NSString *channelName; //zs
    
@property (weak) id delegate;  //zs strong

//-(void)setChannel:(Channel*)ch;
-(void)setChannelWithName:(NSString*)name; //zs

-(void)setDate:(NSString *) date;
@end
