//
//  SubCategories.h
//  Voter
//
//  Created by Khitryk Artsiom on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategories : NSObject
{
@private
    
    BOOL isCheck_;
    NSString* image_;
    NSString* nameOfSubCategory_;
    NSString* idSubCategory_;
    NSInteger tag_;
}

@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* nameOfsubCategory;
@property (nonatomic, copy) NSString* idSubCategory;
@property (nonatomic, assign) NSInteger tag;

@end
