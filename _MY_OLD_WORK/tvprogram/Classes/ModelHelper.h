//
//  ModelHelper.h
//  TVProgram
//
//  Created by Admin on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface ModelHelper : NSObject {
@private 
    
    NSDateFormatter *dayFormatter_;
    NSDateFormatter *hmdayFormatter_;
    NSDateFormatter *hdayFormatter_;
    //    UIAlertView *progressAlert_;        
}

+ (ModelHelper*)shared;

- (NSString*)dayFromDate:(NSDate*)dat;
- (NSDate*)dateFromDay:(NSString*)day;
- (NSDate*)dateBeginDaysFromNow:(NSInteger)days;
- (NSDate*)dateBeginHourFromDate:(NSDate*)date;
- (NSString*)dayForToday;
- (BOOL)isDateToday:(NSDate*)date;

- (NSInteger)hourFromDate:(NSDate*)date;
- (NSInteger)minFromDate:(NSDate*)date;


+ (NSString *)categoryName:(NSInteger)index;
+ (UIImage *)categoryImage:(NSInteger)index;

//+ (UIAlertView *)showProgressIndicator; 
//+ (void)hideProgressIndicator:(UIAlertView *)alert;


@end

uint64_t getTickCount(void);


