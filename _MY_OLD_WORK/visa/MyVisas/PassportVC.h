//
//  PassportVC.h
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"
#import <UIKit/UIKit.h>

@interface PassportVC : UIViewController <DatePickerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tableView;
    BOOL enteringIssueDate;
}

@end
