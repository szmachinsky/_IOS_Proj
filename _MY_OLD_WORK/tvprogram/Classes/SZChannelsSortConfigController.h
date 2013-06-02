//
//  ChannelsSortConfigController.h
//  TVProgram
//
//  Created by User1 on 20.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZChannelsSortConfigController : UITableViewController  
{
    UITableView *mytableView;
}

//zs-------
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
