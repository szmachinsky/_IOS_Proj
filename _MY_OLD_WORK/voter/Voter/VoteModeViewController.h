//
//  VoteModeViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomVoteModeCell.h"
#import "BizProfileViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"
#import "VoteMode.h"
#import "ShareViewController.h"
#import "SignInViewController.h"

@interface VoteModeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
@private
    
    UITableView* tableView_;
    UICustomVoteModeCell* customCell_;
    NSMutableArray* voteDSArray_;
    NSMutableDictionary* voteDic_;
    
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UICustomVoteModeCell* customCell;
@property (nonatomic, retain) NSMutableArray* voteDSArray;

- (IBAction)vote:(id)sender;

@end
