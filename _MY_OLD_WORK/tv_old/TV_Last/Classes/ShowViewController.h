//
//  ShowViewController.h
//  TVTestCore
//
//  Created by Admin on 21.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController;

@interface ShowViewController : UITableViewController
{
    NSArray *listShow_;
    int count_;
}
@property (nonatomic, strong) NSArray *listShow;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
