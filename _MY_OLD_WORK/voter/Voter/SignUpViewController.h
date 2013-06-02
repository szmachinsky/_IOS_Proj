//
//  SignUpViewController.h
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTextViewController.h"
#import "FBSession.h"
#import "TWSeccion.h"

@interface SignUpViewController :ScrollTextViewController <UITableViewDelegate, UITableViewDataSource,
FBSeccionDelegate, TWSeccionDelegate,
UITextFieldDelegate> 
{
@private    
    IBOutlet UITableView *infoTableView_;
    
    IBOutlet UIButton *facebookButton_;    
    IBOutlet UIButton *twitterButton_;
    IBOutlet UIButton *googleButton_;
    IBOutlet UIButton *signUpButton_;

    NSString *username_;
    NSString *email_;      
    NSString *zipCode_;     
    NSString *yearOfBirth_; 
    NSString *password_;    
    UITextField *userField_;
    UITextField *emailField_;
    UITextField *zipField_;
    UITextField *yearField_;
    UITextField *passField_; 
    
    NSMutableDictionary *dictSignUp_;    
    
    FBSession *fbSession_;
    TWSeccion *twSession_;
}

@property(readonly) FBSession *fbSession; 
@property(readonly) TWSeccion *twSession; 

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *email;      
@property (nonatomic,copy) NSString *zipCode;     
@property (nonatomic,copy) NSString *yearOfBirth; 
@property (nonatomic,copy) NSString *password;  


- (IBAction)pressFacebook:(id)sender;
- (IBAction)pressTwitter:(id)sender;
- (IBAction)pressGoogle:(id)sender;
- (IBAction)pressSignIn:(id)sender;

- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date; 
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date withInfo:(NSMutableDictionary*)result;
- (void)twDidLogin:(NSString*)data forUsername:(NSString *)username;

@end
