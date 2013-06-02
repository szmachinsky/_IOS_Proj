//
//  BrowseViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomCategoriesCell.h"
#import "SubCategoriesViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "Categories.h"
#import "UserInfo.h"
#import "WaitScreenView.h"

@interface BrowseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
@private
    
    UITableView* tableView_;
    UICustomCategoriesCell* customCell_;
    NSMutableArray* categoriesDSArray_;
    WaitScreenView* waitScreen_;
    
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UICustomCategoriesCell* customCell;
@property (nonatomic, retain) NSMutableArray* categoriesDSArray;
@property (nonatomic, retain) WaitScreenView* waitScreen;

@end
