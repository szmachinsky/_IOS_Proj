//
//  ProfileInfo.h
//  Voter
//
//  Created by Khitryk Artsiom on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfo : NSObject
{
@private    
    
    NSString* description_;
    NSString* name_;
    NSString* schedule_;
    NSString* site_;
    NSString* idProfile_;
    NSString* address_;
    NSString* menu_;
    NSString* printMenu_;
    NSString* rating_;
    NSString* phone_;
    NSMutableArray* contentOfLink_;
    
}

@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* schedule;
@property (nonatomic, copy) NSString* site;
@property (nonatomic, copy) NSString* idProfile;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* menu;
@property (nonatomic, copy) NSString* printMenu;
@property (nonatomic, copy) NSString* rating;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, retain) NSMutableArray* contentOfLink;

@end
