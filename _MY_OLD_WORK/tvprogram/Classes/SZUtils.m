//
//  SZUtils.m
//  TVProgram
//
//  Created by Admin on 11.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZUtils.h"

@implementation SZUtils

//--------------------------
+ (UIColor*)color001 {
    return [UIColor colorWithRed:51/255.0 green:24/255.0 blue:7/255.0 alpha:1];
}

+ (UIColor*)color002 {
    return [UIColor colorWithRed:61/255.0 green:28/255.0 blue:5/255.0 alpha:1];
}
//--------------------------
+ (UIColor*)color01 {
    return [UIColor colorWithRed:146/255.0 green:130/255.0 blue:93/255.0 alpha:1];
}

+ (UIColor*)color02 {
    return [UIColor colorWithRed:255/255.0 green:250/255.0 blue:224/255.0 alpha:1];
}

+ (UIColor*)color03 {
    return [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
}

+ (UIColor*)color04 {
    return [UIColor colorWithRed:45/255.0 green:17/255.0 blue:0.0f alpha:1.0];
}

+ (UIColor*)color05 {
    return [UIColor colorWithRed:1.0 green:252/255.0 blue:1.0 alpha:1.0];
}

+ (UIColor*)color06 {
    return [UIColor colorWithRed:255/255.0 green:252/255.0 blue:228/255.0 alpha:0.6];
}

+ (UIColor*)color07 {
    return [UIColor colorWithRed:255/255.0 green:252/255.0 blue:228/255.0 alpha:1];
}

+ (UIColor*)color08 {
    return [UIColor colorWithRed:102/255.0 green:73/255.0 blue:58/255.0 alpha:1];
}

+ (UIColor*)color09 {
    return [UIColor colorWithRed:245/255.0 green:227/255.0 blue:190/255.0 alpha:1];
}



+ (UIColor*)colorLeftButton {
    return [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1];
}


//-------------------------
//[window setBackgroundColor: [UIColor colorWithRed:51/255.0 green:24/255.0 blue:7/255.0 alpha:1]];         //001
//UIColor *navColor         = [UIColor colorWithRed:61/255.0 green:28/255.0 blue:5/255.0 alpha:1];          //002

//tableview.separatorColor  = [UIColor colorWithRed:146/255.0 green:130/255.0 blue:93/255.0 alpha:1];       //01
//tableview.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:224/255.0 alpha:1];      //02
//self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];         //03
//UIColor *textColor        = [UIColor colorWithRed:45/255.0f green:17/255.0f blue:0.0f alpha:1.0f];        //04
//UIColor *shadowColor      = [UIColor colorWithRed:1.0f green:252/255.0f blue:1.0f alpha:1.0f];            //05
//textLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:228/255.0 alpha:0.6];   //06
//c..entView.backgroundColor =[UIColor colorWithRed:255/255.0 green:252/255.0 blue:228/255.0 alpha:1];      //07

//searchBar.tintColor       = [UIColor colorWithRed:102/255.0 green:73/255.0 blue:58/255.0 alpha:1];        //08
//view.backgroundColor      = [UIColor colorWithRed:245/255.0 green:227/255.0 blue:190/255.0 alpha:1];      //09


+ (NSString*)pathTmpDir 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Tmp"];    
    return documentPath;     
}

+ (NSString*)pathTmpDirectory 
{ 
    return NSTemporaryDirectory();
}


+ (NSString*)pathDocDir 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return documentPath;     
}


+ (NSString*)pathDocDirectory 
{ 
//    return [[self class] pathTmpDirectory]; // go to tmp 
    
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    //  NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Tmp"]; 
    
//  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);     
//  NSString *documentPath = [documentDirectories objectAtIndex:0];     
    
    return documentPath;     
}


//========================thumbnailFromImage===================================
#pragma mark Image's methods
+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz Radius:(float)radius
{
    float mx = sz;
    float my = sz;
    float x = imageFrom.size.width;
    float y = imageFrom.size.height;
    float d = x / y;
    if (d >= 1) {
        my = my / d;
    } else {
        mx = mx * d;
    }    
    CGRect imageRect = CGRectMake(0, 0, roundf(mx),roundf(my)); 
    UIGraphicsBeginImageContext(imageRect.size);    
    
    if (radius > 0.0) {
        UIBezierPath *bez = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius];
        [bez addClip];
    }
    
    // Render the big image onto the image context 
    [imageFrom drawInRect:imageRect];    
    // Make a new one from the image contextpickerCell_.cellImage.image    
    UIImage *imgTo = UIGraphicsGetImageFromCurrentImageContext();
    
    //  NSData *data1 = UIImageJPEGRepresentation(imageFrom, 0.75);
    //  NSData *data2 = UIImageJPEGRepresentation(imgTo, 0.75);
    //    NSData *data1 = UIImagePNGRepresentation(imageFrom);
    //    NSData *data2 = UIImagePNGRepresentation(imgTo);    
    //    int i1 = data1.length;
    //    int i2 = data2.length;
    //    _NSLog(@" image from %d to %d",i1,i2);
    
    // Clean up image context resources 
    UIGraphicsEndImageContext();    
    return imgTo;
}


@end




