//
//  ScrollTextViewController.h
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollTextViewController : UIViewController 
{
@protected    
//  Outlets for keyboard hiding     
    IBOutlet UIScrollView *scrollView_;
    UITextField    *activeField_;
    
    int hideKeyboardShift;
    BOOL keyboardIsOnTop;
    CGSize kbSize;
}


@end
