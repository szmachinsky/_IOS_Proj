//
//  WriteAReviewViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 10.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"
#import "ReviewsViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"

@interface WriteAReviewViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, ShareViewControllerDelegate>
{
@private
    
    UITextView* reviewTextView_;
    UIButton* firstStarButton_;
    UIButton* secondStarButton_;
    UIButton* thirdStarButton_;
    UIButton* fourthStarButton_;
    UIButton* fifthStarButton_;
    UIButton* postPreviewButton_;
    
    NSMutableDictionary* writeViewDic_;
}

@property (nonatomic, retain) IBOutlet UITextView* reviewTextView;
@property (nonatomic, retain) IBOutlet UIButton* firstStarButton;
@property (nonatomic, retain) IBOutlet UIButton* secondStarButton;
@property (nonatomic, retain) IBOutlet UIButton* thirdStarButton;
@property (nonatomic, retain) IBOutlet UIButton* fourthStarButton;
@property (nonatomic, retain) IBOutlet UIButton* fifthStarButton;
@property (nonatomic, retain) IBOutlet UIButton* postPreviewButton;

-(IBAction)voteStar:(id)sender;
-(IBAction)postReview:(id)sender;

@end
