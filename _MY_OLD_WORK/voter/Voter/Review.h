//
//  Review.h
//  Voter
//
//  Created by Khitryk Artsiom on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject
{
@private
    
    NSString* review_;
    NSString* photo_;
    NSString* userName_;
    NSString* mark_;
    NSString* idUser_;
    
}

@property (nonatomic, copy) NSString* review;
@property (nonatomic, copy) NSString* photo;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* mark;
@property (nonatomic, copy) NSString* idUser;

@end
