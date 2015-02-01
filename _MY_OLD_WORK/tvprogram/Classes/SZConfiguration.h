//
//  SZConfiguration.h
//  TVProgram
//
//  Created by Admin on 22.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


//NSString* const kUrlChannelListJson = @"http://tvprogram.selfip.info/data/index.json.bz2";


#define _DEBUG_MSG
//#define _DEBUG_MSG0
//#define _DEBUG_MSG1
//#define _DEBUG_MSG2

#ifdef _DEBUG_MSG
#define _NSLog(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog(...)
#endif

#ifdef _DEBUG_MSG0
#define _NSLog0(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog0(...)
#endif

#ifdef _DEBUG_MSG1
#define _NSLog1(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog1(...)
#endif

#ifdef _DEBUG_MSG2
#define _NSLog2(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog2(...)
#endif


//#define WillShowAdBanner
//#define WillShowWpBanner
#define kWpAutoupdateTimeout 60


/*

 #import <Foundation/Foundation.h>
 #import <CoreData/CoreData.h>
 
 @class MTVShow;
 
 @interface MTVChannel : NSManagedObject
 
 @property (nonatomic) NSInteger pCategories;
 @property (nonatomic) NSInteger pID;
 @property (nonatomic) float pOrderValue;
 @property (nonatomic) BOOL pFavorite;
 @property (nonatomic) BOOL pLoaded;
 @property (nonatomic) BOOL pSelected;
 @property (nonatomic, retain) NSString * pName;
 @property (nonatomic, retain) NSString * pProgramUrl;
 @property (nonatomic, retain) NSString * pLogoUrl;
 @property (nonatomic, retain) NSString * pProgramUrlLoaded;
 @property (nonatomic, retain) NSString * pLogoUrlLoaded;
 @property (nonatomic, retain) NSString * tSectionIdentifier;
 
 @property (nonatomic, retain) NSDate * pLoadShow;
 @property (nonatomic, retain) NSDate * pLoadImage;
 @property (nonatomic, retain) NSDate * pUpdated;
 @property (nonatomic, retain) NSData * pImage;
 
 @property (nonatomic, retain) NSSet *rTVShow;
 
 -(UIImage*)icon;
 
 @end
 
 @interface MTVChannel (CoreDataGeneratedAccessors)
 
 - (void)addRTVShowObject:(MTVShow *)value;
 - (void)removeRTVShowObject:(MTVShow *)value;
 - (void)addRTVShow:(NSSet *)values;
 - (void)removeRTVShow:(NSSet *)values;
 @end

*/ 
 
//======================================

/*

 
 -(void)awakeFromFetch
 {
 [super awakeFromFetch];
 //    _NSLog(@" load %@ obj",self.pName);
 }
 -(NSString*)tSectionIdentifier 
 {
 NSString *str = [self.pName substringToIndex:1]; //self.pName;
 return str; 
 }
 
 -(UIImage*)icon
 {
 UIImage *im = [UIImage imageWithData:self.pImage];
 return im;
 }
 

*/



//======================================

/*
 
 #import <Foundation/Foundation.h>
 #import <CoreData/CoreData.h>
 
 @class MTVChannel;
 
 @interface MTVShow : NSManagedObject
 
 @property (nonatomic) NSInteger pCategory;
 @property (nonatomic) NSInteger pDay;
 @property (nonatomic, retain) NSString * pDescription;
 @property (nonatomic) NSInteger pId;
 @property (nonatomic, retain) NSDate *pStart;
 @property (nonatomic, retain) NSDate *pStop;
 @property (nonatomic, retain) NSString * pTitle;
 @property (nonatomic, retain) MTVChannel *rTVChannel;
 
 
 -(float)duration;
 -(NSString*)name;
 -(NSString*)descript;
 
 -(NSString*)day;
 -(NSInteger)startMin;
 -(NSInteger)startHour;
 -(NSInteger)endMin;
 -(NSInteger)endHour;
 
 @end
 
 
 */


/*
 
 #import "MTVShow.h"
 #import "MTVChannel.h"
 
 
 @implementation MTVShow
 
 @dynamic pCategory;
 @dynamic pDay;
 @dynamic pDescription;
 @dynamic pId;
 @dynamic pStart;
 @dynamic pStop;
 @dynamic pTitle;
 @dynamic rTVChannel;
 
 
 
 
 //------------------------------------------------------------------------------
 -(float)duration
 {
 NSDate *d1 = self.pStart;
 NSDate *d2 = self.pStop;
 float dur = fabs([d2 timeIntervalSinceDate:d1]/60.0);
 return dur;
 }
 
 -(NSString*)name
 {
 return self.pTitle;
 }
 
 -(NSString*)descript
 {
 return self.pDescription;
 }
 
 
 -(NSString*)day
 {
 NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"yyyyMMdd"];
 NSString *res = [formatter stringFromDate:self.pStart];
 return res;
 }
 
 -(NSInteger)startMin
 {
 NSDate *dat = self.pStart;
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 //  unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit;    
 unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
 NSDateComponents *components = [gregorian components:flags fromDate:dat];
 //  NSInteger day = [components day];
 //  NSInteger weekday = [components weekday];
 NSInteger min = [components minute];
 return min;
 }
 
 -(NSInteger)startHour
 {
 NSDate *dat = self.pStart;
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
 NSDateComponents *components = [gregorian components:flags fromDate:dat];
 NSInteger hour = [components hour];    
 return hour;
 }
 
 -(NSInteger)endMin
 {
 NSDate *dat = self.pStop;
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
 NSDateComponents *components = [gregorian components:flags fromDate:dat];
 NSInteger min = [components minute];
 return min;
 }
 
 -(NSInteger)endHour
 {
 NSDate *dat = self.pStop;
 NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
 unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
 NSDateComponents *components = [gregorian components:flags fromDate:dat];
 NSInteger hour = [components hour];    
 return hour;
 }
 
 
 
 @end
 
 
 */

