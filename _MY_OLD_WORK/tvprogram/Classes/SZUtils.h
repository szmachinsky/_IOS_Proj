//
//  SZUtils.h
//  TVProgram
//
//  Created by Admin on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define kModTranStyle UIModalTransitionStyleCrossDissolve 
//#define kModTranStyle UIModalTransitionStylePartialCurl
//#define kModTranStyle UIModalTransitionStyleCoverVertical
#define kModTranStyle UIModalTransitionStyleFlipHorizontal

@interface SZUtils : NSObject

+ (UIColor*)color001;
+ (UIColor*)color002;
+ (UIColor*)color01;
+ (UIColor*)color02;
+ (UIColor*)color03;
+ (UIColor*)color04;
+ (UIColor*)color05;
+ (UIColor*)color06;
+ (UIColor*)color07;
+ (UIColor*)color08;
+ (UIColor*)color09;

+ (UIColor*)colorLeftButton;

+ (NSString*)pathTmpDirectory; 
+ (NSString*)pathDocDirectory; 
+ (NSString*)pathTmpDir; 

+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz Radius:(float)radius;

@end
