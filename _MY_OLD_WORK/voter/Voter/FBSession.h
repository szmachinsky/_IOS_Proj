//
//  FBSession.h
//  VoterTest
//
//  Created by User User on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@protocol FBSeccionDelegate;

@interface FBSession : NSObject <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
@private
    Facebook* facebook_;
    NSArray* permissions_;
    NSMutableDictionary *result_;
    id<FBSeccionDelegate> delegate_;
}
@property(nonatomic, readonly) Facebook *facebook;
@property(nonatomic, retain)   NSArray *permissions;
@property(nonatomic, retain)   NSMutableDictionary *result;
@property(nonatomic, assign)   id<FBSeccionDelegate> delegate; 

- (id)initWithDelegate:(id<FBSeccionDelegate>) delegate; 
- (void)facebookLogin;
- (void)facebookLogout;
- (void)facebookGetInfo;
@end


@protocol FBSeccionDelegate <NSObject>
@optional
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date;
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date withInfo:(NSMutableDictionary*)result;
@end
