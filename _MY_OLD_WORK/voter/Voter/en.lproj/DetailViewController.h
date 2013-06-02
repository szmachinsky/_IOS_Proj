//
//  DetailViewController.h
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NewCell.h"
#import "ScrollTextViewController.h"

@class NewLabelTextCell;



@interface DetailViewController : ScrollTextViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 

{
    
    IBOutlet UITableView *infoTableView_;
    NewLabelTextCell* newCell_;
    

//    IBOutlet UIScrollView *scrollView;
//    UITextField    *activeField;
    
//  BOOL keyboardIsOnTop;
//    CGSize kbSize;
//  BOOL keyboardIsShown;
    
    IBOutlet UITextField *editText1;

}

//@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

//@property (nonatomic, retain) IBOutlet NewLabelCell *newCell;

@end
