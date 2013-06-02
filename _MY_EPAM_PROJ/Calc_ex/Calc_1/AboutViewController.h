//
//  AboutViewController.h
//  Calc_1
//
//  Created by Administrator on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AboutViewControllerDelegate;


@interface AboutViewController : UIViewController {
    
}
@property (nonatomic, assign) id <AboutViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end


@protocol AboutViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(AboutViewController *)controller;
//- (void)aboutViewControllerDidFinish:(AboutViewController *)controller;
@end

