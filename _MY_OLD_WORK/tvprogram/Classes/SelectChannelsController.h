//
//  SelectChannelsController.h
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectChannelsController : UITableViewController { 
    UITableView *mytableView;
    //UITableViewController *__unsafe_unretained delegate;

    NSManagedObjectContext *context_;
    NSArray *tabData_;
}
@property (strong, nonatomic) NSManagedObjectContext *context; //zs
@property (strong, nonatomic) NSArray *tabData; //zs

//@property (nonatomic, unsafe_unretained) UITableViewController *delegate;

@end
