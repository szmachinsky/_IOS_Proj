//
//  UserTool.h
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject

+ (void) netActivityON; 
+ (void) netActivityOFF; 
+ (void) netActivityStop;

+ (void) shiftRandom:(int)shift;
+ (NSString*)UUIDString;

//+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz;
+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz Radius:(float)radius;


+ (NSArray*)arrayFromString:(NSString*)str separateStr:(NSString*)sep;
+ (NSString*)stringFromArray:(NSArray*)arr separateStr:(NSString*)sep;
+ (NSInteger)countOfStrArr:(NSString*)str separateStr:(NSString*)sep;
+ (BOOL)ifStrArr:(NSString*)str separateStr:(NSString*)sep contains:(NSString*)subst;
+ (NSInteger)indexInStrArr:(NSString*)str separateStr:(NSString*)sep ofString:(NSString*)subst;
+ (NSInteger)indInStrArr:(NSString*)str separateStr:(NSString*)sep ofString:(NSString*)subst;

@end
