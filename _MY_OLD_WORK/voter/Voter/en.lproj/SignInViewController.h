//
//  SignInViewController.h
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol FlipsideViewControllerDelegate;
@class ForgotViewController;

@interface SignInViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
@private
    IBOutlet UITableView *infoTableView_;
    
    IBOutlet UIButton *facebookButton_;
    IBOutlet UIButton *twitterButton_;
    IBOutlet UIButton *googleButton_;
    IBOutlet UIButton *signUpButton_;
    IBOutlet UIButton *forgotPassButton_;
    
    IBOutlet UIButton *signButton_;
            
    NSString *email_;
    NSString *password_;
    
    ForgotViewController *forgotViewController_;    
}
//@property (nonatomic, assign) id<FlipsideViewControllerDelegate> delegate;
//@property (nonatomic, assign) id delegate;

@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *password;

- (IBAction)pressFacebook:(id)sender;
- (IBAction)pressTwitter:(id)sender;
- (IBAction)pressGoogle:(id)sender;
- (IBAction)pressSignUp:(id)sender;
- (IBAction)pressForgotPassword:(id)sender;


@end

//@protocol FlipsideViewControllerDelegate
//- (void)flipsideViewControllerDidFinish:(UIViewController *)controller;
//@end
