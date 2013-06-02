//
//  SignInViewController.h
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestsManager.h"
#import "VoterServerError.h"

#import "FBSession.h"
#import "TWSeccion.h"


@class ForgotViewController;

@interface SignInViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
FBSeccionDelegate, TWSeccionDelegate,
UITextFieldDelegate> 
{
@private
    IBOutlet UITableView *infoTableView_;
    
    IBOutlet UIButton *facebookButton_;
    IBOutlet UIButton *twitterButton_;
    IBOutlet UIButton *googleButton_;
    IBOutlet UIButton *signUpButton_;
    IBOutlet UIButton *forgotPassButton_;
                
    NSString *email_;
    NSString *password_;
    UITextField *emailField_;
    UITextField *passField_;    
    
    ForgotViewController *forgotViewController_;       
    
    NSMutableDictionary *dictSignIn_;    

    FBSession *fbSession_;
    TWSeccion *twSession_;
    
}

@property(readonly) FBSession *fbSession; 
@property(readonly) TWSeccion *twSession; 


@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *password;

- (IBAction)pressFacebook:(id)sender;
- (IBAction)pressTwitter:(id)sender;
- (IBAction)pressGoogle:(id)sender;
- (IBAction)pressSignUp:(id)sender;
- (IBAction)pressForgotPassword:(id)sender;

- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date; 
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date withInfo:(NSMutableDictionary*)result;
- (void)twDidLogin:(NSString*)data forUsername:(NSString *)username;

@end

//@protocol FlipsideViewControllerDelegate
//- (void)flipsideViewControllerDidFinish:(UIViewController *)controller;
//@end
