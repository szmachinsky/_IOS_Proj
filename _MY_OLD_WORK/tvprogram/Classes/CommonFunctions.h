//
//  CommonFunctions.h
//  TVProgram
//
//  Created by User1 on 23.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


int getCurrentHour();
int getCurrentMin();
NSString *convertDateToUserView(NSString *date);
NSString *convertDateToUserView2(NSString *date);
NSString *convertDateToUserView22(NSString *date);

NSString *getWeekDay(NSString *date);
NSString *getShortWeekDay(NSString *date);
NSString *convertDataToString(NSDate * date);
NSDate *convertStringToDate(NSString *dateStr);
NSInteger weekdayFromDate(NSDate *date);
BOOL diffWeeks(NSDate *date1, NSDate *date2);
NSDictionary *getCurrentTime(void);