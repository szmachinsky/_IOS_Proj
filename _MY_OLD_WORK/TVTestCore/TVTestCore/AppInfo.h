//
//  AppInfo.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZCoreManager;

@interface AppInfo : NSObject {    
    SZCoreManager *coreManager_;
}

+(AppInfo*)shared;

-(SZCoreManager*)createCoreManagerWithDataFile:(NSString*)file Model:(NSString*)model;

@end
