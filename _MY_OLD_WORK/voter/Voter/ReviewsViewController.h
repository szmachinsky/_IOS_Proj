//
//  ReviewsViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomReviewsCell.h"
#import "WriteAReviewViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"
#import "Review.h"
#import "SignInViewController.h"

@interface ReviewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
@private
    
    UITableView* tableView_;
    UICustomReviewsCell* customCell_;
    
    NSMutableDictionary* getReviewDic_;
    NSMutableArray* reviewDSArray_;
    NSMutableDictionary* reportDic_;
    
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UICustomReviewsCell* customCell;
@property (nonatomic, retain) NSMutableArray* reviewsDSArray;

- (IBAction)writeAReview:(id)sender;
- (IBAction)reportUser:(id)sender;

@end
