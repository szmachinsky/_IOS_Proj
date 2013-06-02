//
//  VoteMode.h
//  Voter
//
//  Created by Khitryk Artsiom on 29.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteMode : NSObject
{
@private
    
    NSString* idVoteMode_;
    NSString* image_;
    NSString* nameOfVote_;
}

@property (nonatomic, copy) NSString* idVoteMode;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* nameOfVote;

@end
