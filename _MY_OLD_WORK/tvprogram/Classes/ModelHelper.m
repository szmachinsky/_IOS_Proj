//
//  ModelHelper.m
//  TVProgram
//
//  Created by Admin on 29.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ModelHelper.h"

#include <mach/mach.h>
#include <mach/mach_time.h>

static ModelHelper *_ModelHelper=nil;

#define kSecondsPerDay 86400


@interface ModelHelper () 
- (NSDateFormatter*)dayFormatter;
- (NSDateFormatter*)hmDayFormatter;
- (NSDateFormatter*)hDayFormatter;

@end



@implementation ModelHelper

- (id)init
{
    self = [super init];
    if (self) {
        
        dayFormatter_ = [self dayFormatter];
        hmdayFormatter_ = [self hmDayFormatter];                       
        hdayFormatter_ = [self hDayFormatter];                       
    }
    return self;
}


+ (ModelHelper*)shared
{// static AppInfo *_sharedAppInfo=nil;
    @synchronized(self) {
        if(_ModelHelper == nil) {
            _NSLog(@"-initialize_ModelHelper");
            _ModelHelper = [[ModelHelper alloc] init];
        }
    }    
    return _ModelHelper;    
}


+ (void)initialize
{
    _NSLog(@"-initialize_ModelHelper");
    if(_ModelHelper == nil) {
        _ModelHelper = [[ModelHelper alloc] init];
    }    
}

//===============================================================================
- (NSDateFormatter*)dayFormatter
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setLocale:[NSLocale currentLocale]];        
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    return  formatter;
}

- (NSDateFormatter*)hmDayFormatter
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd:HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];        
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    return  formatter;    
}

- (NSDateFormatter*)hDayFormatter
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd:HH"];
    [formatter setLocale:[NSLocale currentLocale]];        
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    return  formatter;    
}

//-------------------------------------------------------------
- (NSString*)dayFromDate:(NSDate*)dat
{
    NSDate *date;
    if (dat == nil) {
        date = [NSDate date]; //current date
    } else {
        date = dat;
    }    
    NSString *res = [dayFormatter_ stringFromDate:date];
    
//    NSString *ress = [hmdayFormatter_ stringFromDate:date];    
//    NSDate *datt = [hmdayFormatter_ dateFromString:@"20120601:12:50"]; 
    
//    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:date];
//    NSDate *localDate = [date dateByAddingTimeInterval:timeZoneOffset];    
    
//    _NSLog(@"(%@) ->(%@)(%@) -> (%@)  (%@)",date,res,ress,datt,localDate);    
    return res;  
}


- (NSDate*)dateFromDay:(NSString*)day
{
    NSDate *date = [dayFormatter_ dateFromString:day];
    return date;
    
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:timeZoneOffset];    
//    _NSLog(@"(%@) -> (%@)(%@)",day,date,localDate);
    return localDate;  
}


- (NSDate*)dateBeginDaysFromNow:(NSInteger)days
{
    NSDate *today = [NSDate date];
    NSTimeInterval seconds = (24 * 60 * 60 * days);
    NSDate *dest =[today dateByAddingTimeInterval:seconds];
    NSString *str = [self dayFromDate:dest];
    NSDate *res = [self dateFromDay:str];
    return  res;
}


- (NSDate*)dateBeginHourFromDate:(NSDate*)date
{
    NSString *res = [hdayFormatter_ stringFromDate:date];    
    NSDate *dat = [hdayFormatter_ dateFromString:res]; 
//    _NSLog(@" %@  -> %@ -> %@",date,res,dat);    
    return  dat;
}



- (NSString*)dayForToday
{
    return [self dayFromDate:nil];
}

- (BOOL)isDateToday:(NSDate*)date
{
    NSString *str1 = [self dayFromDate:date];
    NSString *str2 = [self dayFromDate:nil];
    return [str1 isEqual:str2];
}


-(NSInteger)hourFromDate:(NSDate*)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *res = [formatter stringFromDate:date];
    return [res integerValue];
}

-(NSInteger)minFromDate:(NSDate*)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *res = [formatter stringFromDate:date];
    return [res integerValue];
}

//------------------------------------------------------------------------------
/*
+ (NSString *)categoryName:(NSInteger)index
{
    NSString *category = nil;
    switch (index) {
        case 1:
            category = @"Документальный сериал";
            break;
        case 2:
            category = @"Документальный фильм";
            break;
        case 3:
            category = @"Мультипликационный сериал";
            break;
        case 4:
            category = @"Мультипликационный фильм";
            break;
        case 5:
            category = @"Телевизионный сериал";
            break;
        case 6:
            category = @"Художественный фильм";
            break;
        case 7:
            category = @"Спортивная программа";
            break;
        case 8:
            category = @"Новостная программа";
            break;
        case 9:
            category = @"Музыкальная программа";
            break;
        default:
            //NSLog(@"категория %d", index);
            category = @"Без категории";
            break;
    }
    return category;
}
*/

//+ (NSString *)categoryName:(NSInteger)index
//{
//
//    NSString *name;
//    switch (index) {
//        case 0:
//            name = @"Без категории";
//            break;
//        case 1:
//        case 2:
//            name = @"Документальный фильм";
//            break;
//        case 3:
//        case 4:
//            name = @"Мультфильм";
//            break;
//        case 5:
//            name = @"Сериал";
//            break;
//        case 6:
//            name = @"Фильм";
//            break;
//        case 7:
//            name = @"Спорт";
//            break;
//        case 8:
//            name = @"Новости";
//            break;
//        case 9:
//            name = @"Музыка";
//            break;            
//        default:
//            name = @"Не определено";
//            break;
//    }
//    return name;
//}

+ (NSString *)categoryName:(NSInteger)index
{
    
    NSString *name;
    switch (index) {
        case 0:
            name = @"Без категории";
            break;
        case 1:
            name = @"Документальный фильм";
            break;
        case 2:
            name = @"Мультфильм";
            break;
        case 3:
            name = @"Сериал";
            break;
        case 4:
            name = @"Фильм";
            break;
        case 5:
            name = @"Спорт";
            break;
        case 6:
            name = @"Новости";
            break;
        case 7:
            name = @"Музыка";
            break;            
        default:
            name = @"Не определено";
            break;
    }
    return name;
}

+ (UIImage *)categoryImage:(NSInteger)index
{
    
//    NSString *name;
    UIImage *image;
    switch (index) {
        case 0:
//            name = @"Без категории";
//            image = nil;
//            image = [UIImage imageNamed:@"nocategory_1.png"];
            image = [UIImage imageNamed:@"no_category_icon_1.png"];
            break;
        case 1:
//            name = @"Документальный фильм";
            image = [UIImage imageNamed:@"docfilm_icon_1.png"];
            break;
        case 2:
//            name = @"Мультфильм";
            image = [UIImage imageNamed:@"children_icon_1.png"];
            break;
        case 3:
//            name = @"Сериал";
            image = [UIImage imageNamed:@"tvseries_icon_1.png"];
            break;
        case 4:
//            name = @"Фильм";
            image = [UIImage imageNamed:@"film_icon_1.png"]; //c_film_icon.png
//            image = [UIImage imageNamed:@"c_film_icon.png"]; //c_film_icon.png
            break;
        case 5:
//            name = @"Спорт";
            image = [UIImage imageNamed:@"sport_icon_1.png"];
            break;
        case 6:
//            name = @"Новости";
            image = [UIImage imageNamed:@"news_icon_1.png"];
            break;
        case 7:
//            name = @"Музыка";
            image = [UIImage imageNamed:@"music_icon_1.png"];
            break;            
        default:
//            name = @"Не определено";
            image = [UIImage imageNamed:@"nocategory_1.png"];
            break;
    }
    return image;
}


//-----------------------------Indicator----------------------------------------
+ (UIAlertView *)showProgressIndicator 
{
    UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-12.4, -20, 25, 25)];  
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;  
    progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);  
    
    UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle: @"Обновление..." message: @"Пожалуйста, подождите..." delegate:self cancelButtonTitle: nil otherButtonTitles: nil];     
    [progressAlert addSubview:progressView];  
    [progressAlert show];
    [progressView startAnimating]; 
    return progressAlert;
}

+ (void)hideProgressIndicator:(UIAlertView *)alert 
{
    [alert dismissWithClickedButtonIndex:alert.cancelButtonIndex animated:NO];
}



@end


uint64_t getTickCount(void)
{
    static mach_timebase_info_data_t sTimebaseInfo;
    uint64_t machTime = mach_absolute_time();
    
    // Convert to nanoseconds - if this is the first time we've run, get the timebase.
    if (sTimebaseInfo.denom == 0 )
    {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
    // Convert the mach time to milliseconds
    uint64_t millis = ((machTime / 1000000) * sTimebaseInfo.numer) / sTimebaseInfo.denom;
    return millis;
}


