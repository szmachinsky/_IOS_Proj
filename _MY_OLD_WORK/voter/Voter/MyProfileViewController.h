//
//  MyProfileViewController.h
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomProfileCell.h"

@interface MyProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
@private
    
    UITableView* tableView_;
    UIButton* reportUser_;
    UIButton* editProfile_;
    UILabel* address_;
    UILabel* name_;
    UIImageView* image_;
    
    UICustomProfileCell* customCell_;
    
}

@property (nonatomic, retain) IBOutlet UIButton* reportUser;
@property (nonatomic, retain) IBOutlet UIButton* editProfile;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* address;
@property (nonatomic, retain) IBOutlet UILabel* name;
@property (nonatomic, retain) IBOutlet UIImageView* image;
@property (nonatomic, retain) IBOutlet UICustomProfileCell* customCell;

@end
