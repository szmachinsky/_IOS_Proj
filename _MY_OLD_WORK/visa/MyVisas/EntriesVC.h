//
//  EntriesVC.h
//  MyVisas
//
//  Created by Natalia Tsybulenko on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EntryCell;

@interface EntriesVC : UITableViewController {
    IBOutlet EntryCell *entryCell;
    BOOL shouldHideNavBarAfterPop;
}
@property (nonatomic, retain) NSString *country;

@end
