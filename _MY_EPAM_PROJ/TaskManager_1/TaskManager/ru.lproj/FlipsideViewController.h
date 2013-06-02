//
//  FlipsideViewController.h
//  ViewUtility
//
//  Created by Administrator on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;



@interface FlipsideViewController : UIViewController  <UIAlertViewDelegate> {
//    UINavigationBar
//    IBOutlet UINavigationItem *navBar;
    
    IBOutlet UINavigationBar *navigationBar;
//    UIImageView *test;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic) int showBar;

- (IBAction)done:(id)sender;
- (IBAction)callMy:(id)sender;
- (IBAction)mailMy:(id)sender;
- (IBAction)sendFeedback:(id)sender;
//@property (nonatomic, retain) IBOutlet UIImageView *test;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
