//
//  CellItem.m
//  Random CellItem 

#import "Task.h"

//static NSString *arrDates[5] = {@"?",@"today",@"tomorrow",@"next week",@"next months"};    

@implementation Task

@synthesize taskName, taskComment, taskStatus, taskCompleted, dateCreated, dateDueTo, dueDescription, 
            timestamp, index;

//------------------------------------------------------------------------------------------
+ (id)generateTaskItem {
	static int genNumber=0;
    genNumber++;
	Task *newCellItem = [[self alloc] initWithName:[NSString stringWithFormat:@"Task_%d",genNumber]
                                               Comment:[NSString stringWithFormat:@"comment... %d",genNumber] 
                                               Status:0 DueDate:nil CreateDate:nil  Completed:0];
    
    NSLog(@"generate:%@",newCellItem);
	return [newCellItem autorelease];
}

//------------------------------------------------------------------------------------------								
- (id)initWithName:(NSString *)name Comment:(NSString *)comment 
            Status:(int)status DueDate:(NSDate*)ddate CreateDate:(NSDate*)cdate  Completed:(int)completed 							
{
//  static NSString *arrDates[6] = {@"",@"today",@"tomorrow",@"next week",@"next months",nil};
    
	self = [super init];
	if (!self)
		return nil;
	self.taskName=name; 
	self.taskComment=comment; 
	self.taskStatus=status;
    self.taskCompleted=completed;
    NSDate *ndate=[NSDate date];
    if (cdate == nil) {
       self.dateCreated = ndate;
    } else {
       	self.dateCreated = cdate; 
    }
	self.dateCreated = ndate;
    if (ddate ==nil) {
        self.dateDueTo = ndate;        
    } else {
        self.dateDueTo = ddate;
    };
    //[date release];
/*
    dateId=1;//dateid;    
    NSString *ss=arrDates[dateid];
    strDueTo=ss;
//  NSLog(@"id=%d, str=%@ %@",dateid,ss,strDueTo);
*/
	return self;
}

//------------------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name Comment:(NSString *)comment 
{
	return [self initWithName:name Comment:comment Status:0 DueDate:nil  CreateDate:nil Completed:0];
}

//------------------------------------------------------------------------------------------
- (id)initWithName:(NSString *)name 
{
	return [self initWithName:name Comment:@"" Status:0 DueDate:nil  CreateDate:nil Completed:0];
}
//------------------------------------------------------------------------------------------
- (NSString *)description 
{
//	return [NSString stringWithFormat:@"%@ (%@) stat:%d, on:(%@) due:(%@)",
//			taskName, taskComment, taskStatus, dateCreated, dateDueTo];
    return [NSString stringWithFormat:@"%@ (%@) stat=%d, due:(%@) compl=%d",
    			taskName, taskComment, taskStatus, dateDueTo, taskCompleted];    
}

//------------------------------------------------------------------------------------------
- (void)dealloc 
{
	[taskName release]; 
	[taskComment release];
	[dateCreated release];
    [dateDueTo release];
//  [strDueTo release];
	[super dealloc];
}

@end
