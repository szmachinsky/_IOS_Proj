//
//  BizProfileViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 10.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteAReviewViewController.h"
#import "ReviewsViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"
#import "ProfileInfo.h"
#import "WaitScreenView.h"
#import "SignInViewController.h"

@interface BizProfileViewController : UIViewController <UIAlertViewDelegate>
{
@private
    
    UILabel* nominationLabel_;
    UILabel* adressLabel_;
    UIButton* siteButton_;
    UIButton* phoneButton_;
    UILabel* phoneLabel_;
    UILabel* siteLabel_;
    
    UIWebView* webView_;
    
    UIButton* voteForUsButton_;
    UIButton* writeAReviewButton_;
    UILabel* reviewsLabel_;
    UIButton* reviewsButton_;
    
    UIButton* facebookButton_;
    UIButton* twitterButton_;
    UIButton* googleButton_;
    
    UILabel* nameOfScheduleLabel_;
    UILabel* scheduleLabel_;
    UILabel* nameOfDescriptionLabel_;
    UILabel* descriptionLabel_;
    
    UIButton* menuButton_;
    UILabel* menuLabel_;
    UIButton* printCouponButton_;
    UILabel* printCouponLabel_;
    
    UIView* voteForUsView_;
    UIView* reviewView_;
    UIView* informationView_;
    UIView* shareView_;
    UIView* headerView_;
    UIView* contentView_;
    UIView* menuView_;
    
    UIScrollView* scrollView_;
    
    NSDictionary* profileDic_;
    NSMutableDictionary* requestProfileDic_;
    ProfileInfo* profileInfo_;
    WaitScreenView* waitScreen_;
    
    NSInteger currentNumberOfLink_;
    
}

@property (nonatomic, retain) IBOutlet UILabel* nominationLabel;
@property (nonatomic, retain) IBOutlet UILabel* adressLabel;
@property (nonatomic, retain) IBOutlet UIButton* siteButton;
@property (nonatomic, retain) IBOutlet UIButton* phoneButton;
@property (nonatomic, retain) IBOutlet UILabel* phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel* siteLabel;

@property (nonatomic, retain) IBOutlet UIWebView* webView;

@property (nonatomic, retain) IBOutlet UIButton* voteForUsButton;
@property (nonatomic, retain) IBOutlet UIButton* writeAReviewButton;
@property (nonatomic, retain) IBOutlet UILabel* reviewsLabel;
@property (nonatomic, retain) IBOutlet UIButton* reviewsButton;

@property (nonatomic, retain) IBOutlet UIButton* facebookButton;
@property (nonatomic, retain) IBOutlet UIButton* twitterButton;
@property (nonatomic, retain) IBOutlet UIButton* googleButton;

@property (nonatomic, retain) UILabel* nameOfscheduleLabel;
@property (nonatomic, retain) UILabel* scheduleLabel;
@property (nonatomic, retain) UILabel* nameOfdescriptionLabel;
@property (nonatomic, retain) UILabel* descriptionLabel;

@property (nonatomic, retain) IBOutlet UIButton* menuButton;
@property (nonatomic, retain) IBOutlet UILabel* menuLabel;
@property (nonatomic, retain) IBOutlet UIButton* printCouponButton;
@property (nonatomic, retain) IBOutlet UILabel* printCouponLabel;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic, retain) NSDictionary* profileDic;
@property (nonatomic, retain) ProfileInfo* profileInfo;

@property (nonatomic, retain) IBOutlet UIView* voteForUsView;
@property (nonatomic, retain) IBOutlet UIView* reviewView;
@property (nonatomic, retain) IBOutlet UIView* informationView;
@property (nonatomic, retain) IBOutlet UIView* shareView;
@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIView* contentView;
@property (nonatomic, retain) IBOutlet UIView* menuView;

- (IBAction)voteForUs:(id)sender;
- (IBAction)writeAReview:(id)sender;
- (IBAction)goToReviews:(id)sender;
- (IBAction)nextLink:(id)sender;
- (IBAction)previousLink:(id)sender;

@end
