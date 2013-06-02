//
//  CellItem.h
//  Random CellItem Creations

#import <Foundation/Foundation.h>


//static NSString *arrDates[6] = {@"",@"today",@"tomorrow",@"next week",@"next months",nil};

@interface Task : NSObject {
	NSString *taskName;
	NSString *taskComment;
	int   taskStatus;
    int   taskCompleted;
	NSDate *dateCreated;
    NSDate *dateDueTo; 
    NSString *dueDescription;
    int timestamp;
    int index;
}

@property (nonatomic,retain) NSString *taskName;
@property (nonatomic,retain) NSString *taskComment;

@property (nonatomic) int    taskStatus;
@property (nonatomic) int    taskCompleted;

@property (nonatomic,retain) NSDate *dateCreated;
@property (nonatomic,retain) NSDate *dateDueTo;

@property (nonatomic,retain) NSString *dueDescription; 
@property (nonatomic) int timestamp;
@property (nonatomic) int index;

+ (id)generateTaskItem;

- (id)initWithName:(NSString *)name Comment:(NSString *)comment 
            Status:(int)status DueDate:(NSDate*)date CreateDate:(NSDate*)cdate Completed:(int)completed;						
- (id)initWithName:(NSString *)name Comment:(NSString *)comment; 
- (id)initWithName:(NSString *)name;


@end
