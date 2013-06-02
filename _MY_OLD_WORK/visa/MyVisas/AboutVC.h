//
//  AboutVC.h
//  MyVisas
//
//  Created by Natalia Tsybulenko on 25.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FBConnect.h"
#import "FacebookLikeView.h"

@class AboutVC;

@interface AboutVC : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIWebViewDelegate> {
    IBOutlet UIButton *buyButton;
    IBOutlet UIButton *feedbackButton;
    IBOutlet UIButton *rateButton;
    IBOutlet UIView *bottomButtonsView;
    
    Facebook *_facebook;
}

@property (nonatomic, retain) IBOutlet UILabel *rightsLabel;

@property (nonatomic, retain) IBOutlet FacebookLikeView *facebookLikeView;
@property (nonatomic, retain) IBOutlet UIButton *fbCoverButton;
-(void)removeCoverButton;

- (IBAction)aboutPressed:(id)sender;
- (IBAction)feedbackPressed:(id)sender;
- (IBAction)reviewPressed:(id)sender;
- (IBAction)buyPressed:(id)sender;

@end
