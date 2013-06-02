//
//  TWSeccion.h
//  Voter
//
//  Created by User User on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

//@class SA_OAuthTwitterEngine;
@protocol TWSeccionDelegate;

@interface TWSeccion : NSObject <SA_OAuthTwitterControllerDelegate> 
{
@private
    SA_OAuthTwitterEngine *engine_;
    UIViewController<TWSeccionDelegate> *delegate_;    
}
@property(nonatomic, assign) UIViewController<TWSeccionDelegate> *delegate; 

- (id)initWithDelegate:(UIViewController<TWSeccionDelegate>*)delegate; 
- (void)twitterLogin;
- (void)twitterLogout;
@end


@protocol TWSeccionDelegate <NSObject>
@optional
- (void)twDidLogin:(NSString*)data forUsername:(NSString *)username;
@end
