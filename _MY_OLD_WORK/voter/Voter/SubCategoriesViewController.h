//
//  SubCategoriesViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomSubcategoriesCell.h"
#import "VoteModeViewController.h"
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"
#import "SubCategories.h"

@interface SubCategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
@private
    
    UITableView* tableView_;
    UICustomSubcategoriesCell* custonCell_;
    NSMutableArray* subCategoriesDSArray_;
    
    NSMutableDictionary* subCategoryDic_;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UICustomSubcategoriesCell* customCell;
@property (nonatomic, retain) NSMutableArray* subCategoriesDSArray;

- (IBAction)check:(id)sender;

@end
