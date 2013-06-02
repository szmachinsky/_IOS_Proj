//
//  WaitScreenView.h
//  EIC
//
//  Created by Dima Duleba on 15.11.11.
//  Copyright 2011 EleganceIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitScreenView : UIView
{
@private
    UIActivityIndicatorView* _activityIndicator;
}
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

-(void)showWaitScreen;
-(void)hideWaitScreen;

@end
