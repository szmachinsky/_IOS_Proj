//
//  EditProfileViewController.h
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTextViewController.h"
@class NewLabelButtonCell;


@interface EditProfileViewController : ScrollTextViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
{
@private    
    
    IBOutlet UITableView *infoTableView_;
   
    NewLabelButtonCell *pickerCell_;
    
    UIImage *imagePhoto_;
    UIImage *thumbnail_;
    
    NSString *username_;
    NSString *email_;      
    NSString *zipCode_;     
    NSString *yearOfBirth_; 
    NSString *changePass_;  
    NSString *confirmPass_;
    NSString *password_;   
    UITextField *userField_;
    UITextField *emailField_;
    UITextField *zipField_;
    UITextField *yearField_;
    UITextField *changePassField_; 
    UITextField *confirmPassField_;
    
    
    IBOutlet UIButton *testButton_;
    
}

@property (nonatomic,retain) UIImage *thumbnail;

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *email;      
@property (nonatomic,copy) NSString *zipCode;     
@property (nonatomic,copy) NSString *yearOfBirth; 
@property (nonatomic,copy) NSString *password;  
@property (nonatomic,copy) NSString *changePass;  
@property (nonatomic,copy) NSString *confirmPass;



@end
