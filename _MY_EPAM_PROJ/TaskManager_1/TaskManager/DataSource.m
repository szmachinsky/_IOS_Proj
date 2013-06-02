//
//  DataSource.m
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataSource.h"
#import "Task.h"

@implementation DataSource
@synthesize cellsData=arrData;

-(id) init
{
    self = [super init];
    if (!self)
        return nil;   
    return self;
}

//------------------------------------------------------------------------------------------
-(id) initWithGeneratedData:(int)number
{
    self = [self init];
    if (!self)
        return nil;
    
    arrData = [[NSMutableArray alloc] init];
    for (int id=0; id<number; id++) {
        [arrData addObject:[Task generateTaskItem]]; 
    }
    
    return self;
}

-(NSString*) nameOfFile
{
    return @"TaskList1.plist";
}

//------------------------------------------------------------------------------------------
-(id) initFromFile 
{
    self = [self init];
    if (!self)
        return nil;
    arrData = [[NSMutableArray alloc] init];
    [self loadTaskListFromFile:[self nameOfFile]]; //load task list from file 
    return self;
}

//------------------------------------------------------------------------------------------
- (void)dealloc 
{
	[arrData release]; 
	[super dealloc];
}


//------------------------------------------------------------------------------------------
-(int) count
{
    return [arrData count];
}


//------------------------------------------------------------------------------------------
-(Task*) objByIndex:(int)index 
{
    return [arrData objectAtIndex:index];
}

-(Task*) taskByIndex:(NSIndexPath*)index
{   
//  int sec = [index section];
    int ind = [index row];
    return [arrData objectAtIndex:ind];    
}

-(void) removeByIndex:(int)index 
{
    int ind = index; //[index row];
    [arrData removeObjectAtIndex:ind];
}

-(void) replaceByIndex:(int)index Task:(Task*)task
{
    int ind = index; //[index row];
    [arrData replaceObjectAtIndex:ind withObject:task];    
}

-(void) addNewObject:(Task*)task
{
    [arrData addObject:task];    
}

-(void) addNewObjName:(NSString*)name Comment:(NSString*)comment DueDate:(NSDate*)dueDate 
{
//  CellItem *c = [[CellItem alloc] initWithName:name Comment:comment Status:0 Progress:0 DueDate:dueDate DateId:0];
    Task *c = [[Task alloc] initWithName:name Comment:comment Status:0 DueDate:dueDate  CreateDate:nil Completed:0];
    [arrData addObject:(c)];
    [c release];    
}

//===========================================================================================

-(NSString*) strDueDateByIndex:(NSIndexPath*)index FormStyle:(NSDateFormatterStyle)style
{
    Task *c = [self objByIndex:[index row]];  
    NSDate *dat = [c dateDueTo];
    NSDateFormatter *form = [[[NSDateFormatter alloc] init] autorelease];
    [form setDateStyle:style];
    NSString *ss = [form stringFromDate:dat];
    return ss;
}

-(NSString*) stringDueDate:(NSDate*)date FormStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *form = [[[NSDateFormatter alloc] init] autorelease];
    [form setDateStyle:style];
    NSString *ss = [form stringFromDate:date];
    return ss;
    
}

//============================================================================================

-(NSString*) pathName:(NSString*) filename
{
    NSArray  *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:filename];
    return path;    
}

-(void) saveTaskListToFile:(NSString*) filename
{
    NSString *path = [self pathName:filename];
  NSLog(@"SAVE DATA:%@",filename);  
//  NSLog(@"path=%@",path);
    
    NSMutableArray *tempFileArray = [[NSMutableArray alloc] init]; 
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"name",@"description",@"createDate",@"dueDate",@"status",@"completed", nil]; 
    
    for (Task* someTask in arrData) { 
        
        NSArray *values = [[NSArray alloc] initWithObjects:[someTask taskName],[someTask taskComment],
                           [someTask dateCreated], [someTask dateDueTo],
                           [NSNumber numberWithInt:[someTask taskStatus]], 
                           [NSNumber numberWithInt:[someTask taskCompleted]],                            
                           nil]; 
        
        NSDictionary *tempDictionary = [[NSDictionary alloc] initWithObjects:values forKeys:keys]; 
 //  NSLog(@"<<dict=%@",tempDictionary);         
        [tempFileArray addObject:tempDictionary]; 
        
        [tempDictionary release]; 
        
        [values release]; 
        
    } 
    [tempFileArray writeToFile:path atomically:YES]; 
    
    [keys release]; 
    
    [tempFileArray release]; 
    
    
}


-(NSMutableArray*) loadTaskListFromFile:(NSString*) filename
{
    NSString *path = [self pathName:filename];
    
NSLog(@"path=%@",path);
    
    [arrData removeAllObjects]; //clear task List
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist =[fm fileExistsAtPath:path];
    if (!exist) {
        NSLog(@"FILE NOT EXIST!!!");
        return nil;
    }
    
    NSArray *tempFileArray = [NSArray arrayWithContentsOfFile:path]; //loading
    NSDictionary *tempDictionary;
    int number = [tempFileArray count];
 NSLog(@"LOAD DATA (%d):%@",number,filename);  
    
    for (int id=0; id<number; id++) {
        tempDictionary = (NSDictionary*)[tempFileArray objectAtIndex:id];
// NSLog(@">>dict_%d=%@",id,tempDictionary);  
        
        NSString *name = [tempDictionary valueForKey:@"name"];
        NSString *comment = [tempDictionary valueForKey:@"description"];
        NSDate *dateCreate = [tempDictionary valueForKey:@"createDate"];
        NSDate *dateDue = [tempDictionary valueForKey:@"dueDate"];
        NSNumber *stat = [tempDictionary valueForKey:@"status"];
        int status = [stat intValue];
        NSNumber *compl = [tempDictionary valueForKey:@"completed"];
        int taskCompl = [compl intValue];
        
        Task *task = [[Task alloc] initWithName:name Comment:comment Status:status DueDate:dateDue  CreateDate:dateCreate  
                                    Completed:taskCompl];
//NSLog(@"task=%@",task);
        [arrData addObject:task];
        
//      [tempDictionary release]; 
        [task release];
    }
    
    [self setDateStatus];
    
    return arrData;
    
}

-(void) saveReloadtaskList {
    NSString *name=[self nameOfFile];
    [self saveTaskListToFile:name];   //save task list to file
    [self loadTaskListFromFile:name]; //load task list from file  
}
//------------------------------------------------------------------------------------------

-(void)setDateStatus
{
    NSDate *cdate=[NSDate date]; //current date
    NSDate *date;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSInteger months;
    NSInteger wday1,wday2;
    NSDateComponents *components;
    
    NSDate *beginningOfWeek = nil;    
    [gregorian rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                            interval:NULL forDate: cdate];   
    
    components = [gregorian components:unitFlags fromDate:beginningOfWeek toDate:cdate options:0];
    wday1 = [components day];  //day from beginning of current week  
//  NSLog(@"week=%@ wdays=%d",beginningOfWeek,wdays);
    
        
    nOverdue=0; nToday=0; nTomorrow=0; nThisWeek=0; nLater=0; nCompleted=0; 
    for (int i=0; i<5; i++)
        nSection[i]=0;
    for (Task *task in arrData) { 
//        NSLog(@"==>%@",task);
        date = task.dateDueTo; 
        
/////     components = [gregorian components:unitFlags fromDate:cdate toDate:date options:0];
//        months = [components month];
//        days = [components day];   //distance from cdate
        
        components = [gregorian components:unitFlags fromDate:beginningOfWeek toDate:date options:0];
        wday2 = [components day];  //day of current week  
                
//      if (days < 0) {
        if (wday1 > wday2) {
//                NSLog(@"==>in Past %d %d",wday1,wday2); 
            task.dueDescription=@"Overdue";
            task.taskStatus=Overdue;
            nSection[0]=++nOverdue;
        }
        if (wday1 == wday2) {
//            NSLog(@"==>Today %d %d",wday1,wday2); 
            task.dueDescription=@"Today";
            task.taskStatus=Today;
            nSection[1]=++nToday;
        }
        if (wday1 < wday2) {
//            NSLog(@"==>in Future %d %d",wday1,wday2); 
            if (wday1+1 == wday2) {
                    task.dueDescription=@"Tomorrow";                      
                    task.taskStatus=Tomorrow;
                    nSection[2]=++nTomorrow;
            } else {
                if (wday2 <= 6) {
                    task.dueDescription=@"This week";                
                    task.taskStatus=ThisWeek;
                    nSection[3]=++nThisWeek;
                } else {
                    task.dueDescription=@"Later";                
                    task.taskStatus=Later;
                    nSection[4]=++nLater;
                }
            }
        
        }
        task.timestamp=wday2;
        
        if (task.taskCompleted)
            nCompleted++;
        
        
    } //for
    NSLog(@"Compl=%d Over=%d Tod=%d Tom=%d Week=%d Lat=%d",nCompleted,nOverdue,nToday,nTomorrow,nThisWeek,nLater);
    
    [gregorian release];  
    
    [self sortDataByTime];
}

//------------------------------------------------------------------------------------------

-(void) sortDataByTime {    
    NSSortDescriptor *dateSorter = [[[NSSortDescriptor alloc] initWithKey:@"dateDueTo" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateSorter];
//  [arrData sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];    
    [arrData sortUsingDescriptors:sortDescriptors];    
}

//------------------------------------------------------------------------------------------

-(int) numberOfSectionsinMode:(int)mode {
    int sec=0;
    
    switch (mode) {
        case mList:
            sec=1;
            break;
        case mDate:
            sec=5;
           break;
        case mDone:
            sec=1;
            break;            
        default:
            sec=1;
            break;
    }
    return sec;
}

-(int) numberOfRowsinSection:(int)section Mode:(int)mode {
    int rows=0;
    
    switch (mode) {
        case mList:
            rows=[arrData count] - nCompleted;
            break;
        case mDate:
            if (section < 5)
                rows=nSection[section];
            break;
        case mDone:
            rows=nCompleted;
            break; 
            
        default:
            rows=[arrData count];
            break;
    }
    if (rows<0) rows=0; 
    return rows;
}

-(Task*) taskForMode:(int)mode Index:(NSIndexPath *)index {
    int sec = [index section];
    int row = [index row];
    int id=-1, i=-1;
    for (Task *task in arrData) { 
        i++;
        switch (mode) {
            case mList:
                if (task.taskCompleted == 0) {
                    id++;
                }
                break;
                
            case mDate:
                switch (sec) {
                    case Overdue:
                        if (task.taskStatus==Overdue)
                            id++;
                        break;
                    case Today:
                        if (task.taskStatus==Today)
                            id++;
                        break;
                    case Tomorrow:
                        if (task.taskStatus==Tomorrow)
                            id++;
                        break;
                    case ThisWeek:
                        if (task.taskStatus==ThisWeek)
                            id++;
                        break;
                    case Later:
                        if (task.taskStatus==Later)
                            id++;
                        break;                        
                    default:
                        id++;
                        break;
                };                
                break;
                
            case mDone:
                if (task.taskCompleted > 0) {
                    id++;
                }
                break; 
                
            default:
                id++; //all
                break;
        } //switch
        if (id >= row) {
//          NSLog(@"found %d %d %@",row,i,task.taskName);
            task.index=i;
            return task;  
        }
    }; //for
    
    return nil;    
}


@end


