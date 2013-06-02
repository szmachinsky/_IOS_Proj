//
//  DataSource.h
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task;


enum {
    Overdue = 0,
    Today = 1,
    Tomorrow = 2,
    ThisWeek = 3,
    Later = 4,
};

enum {
    mList=0,
    mDate=1,
    mDone=2,
    mAll=3,
};


@interface DataSource : NSObject {
    
    NSMutableArray *arrData;
    
    int nCompleted,nOverdue,nToday,nTomorrow,nThisWeek,nLater;
    int nSection[5];
    
}

@property (nonatomic,assign) NSMutableArray *cellsData;

-(id)  init;
-(id)  initWithGeneratedData:(int)number;
-(id)  initFromFile;
-(int) count;

//-------------------------------------------------------------
-(Task*) objByIndex:(int)index;
-(Task*) taskByIndex:(NSIndexPath*)index;
-(void) addNewObject:(Task*)task;
-(void) removeByIndex:(int)index;
-(void) replaceByIndex:(int)index Task:(Task*)task;
-(void) addNewObjName:(NSString*)name Comment:(NSString*)comment DueDate:(NSDate*)dueDate;
//-------------------------------------------------------------
-(NSString*) nameOfFile;
-(void) saveTaskListToFile:(NSString*) filename;
-(NSMutableArray*) loadTaskListFromFile:(NSString*) filename;
-(void) saveReloadtaskList;
//-------------------------------------------------------------
-(NSString*) strDueDateByIndex:(NSIndexPath*)index FormStyle:(NSDateFormatterStyle)style;
-(NSString*) stringDueDate:(NSDate*)date FormStyle:(NSDateFormatterStyle)style;
//-------------------------------------------------------------

-(void) setDateStatus;
-(void) sortDataByTime;

-(int) numberOfSectionsinMode:(int)mode;
-(int) numberOfRowsinSection:(int)section Mode:(int)mode;
-(Task*) taskForMode:(int)mode Index:(NSIndexPath *)index;
@end
