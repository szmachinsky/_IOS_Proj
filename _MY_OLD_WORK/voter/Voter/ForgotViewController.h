//
//  ForgotViewController.h
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignInViewController;

@interface ForgotViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
@private
    IBOutlet UILabel *infoLabel_;
    IBOutlet UITableView *infoTableView_;
    
    NSString *email_;  
    int showMode_;
    
//  SignInViewController *signInViewController_;
}
@property (nonatomic,copy) NSString *email;

@end
