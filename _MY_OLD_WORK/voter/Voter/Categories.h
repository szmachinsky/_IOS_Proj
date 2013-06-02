//
//  Categories.h
//  Voter
//
//  Created by Khitryk Artsiom on 27.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject
{
@private
    
    NSString* image_;
    NSString* nameOfCategory_;
    NSString* percent_;
    NSString* idCategory_;
}

@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* nameOfCategory;
@property (nonatomic, copy) NSString* percent;
@property (nonatomic, copy) NSString* idCategory;

@end
