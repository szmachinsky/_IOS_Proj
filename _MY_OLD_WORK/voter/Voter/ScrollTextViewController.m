//
//  ScrollTextViewController.m
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollTextViewController.h"


//#define kHideKeyboardShift 0 + 5
@interface ScrollTextViewController (hideKeyboard)
- (void)registerForKeyboardNotifications;
- (void)unRegisterForKeyboardNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
@end


@implementation ScrollTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Hide Keyboard actions
//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.view endEditing:YES];   
    [self unRegisterForKeyboardNotifications];    
}

//method to move the view up/down whenever the keyboard is shown/dismissed

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];    
}

- (void)unRegisterForKeyboardNotifications
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView_.contentInset = contentInsets;
    scrollView_.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;    
    //  if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    //      CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
    //      [scrollView setContentOffset:scrollPoint animated:YES];
    //  }
    CGPoint leftTopPoint = [activeField_ convertPoint:activeField_.bounds.origin toView:self.view]; //left top corner
    CGPoint leftBottomPoint = leftTopPoint;
    leftBottomPoint.y+= activeField_.bounds.size.height;//left bottom corner    
    float y0 = hideKeyboardShift;
    //    float y1 = leftTopPoint.y;
    float y2 = leftBottomPoint.y;
    float y3 = aRect.size.height; 
    if (y3-y0 > 80) y3-=44;
    //NSLog(@"1: %.0f %.0f %.0f %.0f",y0,y1,y2,y3);
    if (y2 > y3) {
        float d = y2 - y3 + 5;
        CGPoint scrollPoint = CGPointMake(0.0, d);
        [scrollView_ setContentOffset:scrollPoint animated:YES];
    }
    /*    
     float yy = hideKeyboardShift;
     if (!CGRectContainsPoint(aRect, leftBottomPoint) ) {
     CGPoint scrollPoint = CGPointMake(0.0, leftBottomPoint.y - kbSize.height - activeField_.bounds.size.height + yy);
     [scrollView_ setContentOffset:scrollPoint animated:YES];
     }
     */
    keyboardIsOnTop = YES;    
}

- (void) correctKeyboard 
{
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;    
    CGPoint leftTopPoint = [activeField_ convertPoint:activeField_.bounds.origin toView:self.view]; //left top corner
    CGPoint leftBottomPoint =leftTopPoint;
    leftBottomPoint.y+= activeField_.bounds.size.height;//left bottom corner    
    float y0 = hideKeyboardShift;
    float y1 = leftTopPoint.y;
    float y2 = leftBottomPoint.y;
    float y3 = aRect.size.height;   
    //NSLog(@"2: %.0f %.0f %.0f %.0f",y0,y1,y2,y3);
    if (y1 < y0) {
        float d = y0 - y1;
        CGPoint scrollPoint = scrollView_.contentOffset;
        if ( scrollPoint.y >= d) {
            scrollPoint.y -=d;
        } else {
            scrollPoint.y = 0;
        }
        [scrollView_ setContentOffset:scrollPoint animated:YES];
        return;
    }    
    if (y3-y0 > 80) y3-=44;
    if (y2 > y3) {
        float d = y2 - y3 + 5;
        CGPoint scrollPoint = scrollView_.contentOffset;
        scrollPoint.y +=d;        
        [scrollView_ setContentOffset:scrollPoint animated:YES];
        return;
    }
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{    
     [scrollView_ setContentOffset:CGPointMake(0,0) animated:YES];    
/*
     UIEdgeInsets contentInsets = UIEdgeInsetsZero;
     scrollView_.contentInset = contentInsets;
     scrollView_.scrollIndicatorInsets = contentInsets; 
*/      
    
//  [scrollView_ setContentOffset:CGPointMake(0,0) animated:YES];
    keyboardIsOnTop = NO;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField_ = textField;
    if (keyboardIsOnTop) {
        [self correctKeyboard];         
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField_ = nil;
}




@end
