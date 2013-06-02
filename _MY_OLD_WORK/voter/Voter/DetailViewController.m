//
//  DetailViewController.m
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

#import "LabelEditCell.h"
#import "NewLabelTextCell.h"
#import "NewButtonCell.h"
#import "ScrollTextViewController.h"



@interface DetailViewController ()
@end

@interface DetailViewController ()
//- (void)configureView;
@end

@implementation DetailViewController

//@synthesize detailItem = _detailItem;
//@synthesize detailDescriptionLabel = _detailDescriptionLabel;
//@synthesize newCell = newCell_;

- (void)dealloc
{
//    [_detailItem release];
 //   [_detailDescriptionLabel release];
    [infoTableView_ release];
//    [scrollView release];
//    [editText1 release];
//    [scrollView release];
    
    [super dealloc];
}

#pragma mark - Managing the detail item


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
    hideKeyboardShift = 44+10;// + 10;
}

- (void)viewDidUnload
{
    [infoTableView_ release];
    infoTableView_ = nil;
//    [scrollView release];
//    scrollView = nil;
    [editText1 release];
    editText1 = nil;
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
*/
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Table View lifecycle

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }; 
    if (section==1) {
        return 2;
    }; 
    if (section==2) {
        return 1;
    }; 
    return 1;

}        

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
/*
    if (indexPath.section == 0) 
    {
        LabelEditCell *cell = (LabelEditCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (cell == nil) 
        {
            cell = [[[LabelEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0)
        {
            [cell setFields:@"xyz" editString:@"xyccscssvsvsvsvz" Delegate:self Pos:35];                
        } 
        if (indexPath.row == 1)
        {          
            [cell setFields:@"Email" editString:@"your mail" Delegate:self Pos:60];            
        } 
        if (indexPath.row == 2)
        {
            [cell setFields:@"Password" editString:@"your password" Delegate:self Pos:90];
            cell.cellText.secureTextEntry = YES;
        }

        return cell;
    }
*/    
    if (indexPath.section <= 2) 
    {
        NewLabelTextCell *cell = nil;        
        cell = (NewLabelTextCell*)[tableView dequeueReusableCellWithIdentifier:@"NewLabelTextCell"];
        if (cell == nil) 
        {
            //       [[NSBundle mainBundle] loadNibNamed:@"NewLabelCell" owner:self options:nil];
            //        cell = self.newCell; 
            //        self.newCell = nil;
            //        
            //        cell.accessoryType = UITableViewCellAccessoryNone;
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewLabelTextCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewLabelTextCell class]])
                {
                    cell = (NewLabelTextCell*) aCell;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
            }
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0)
        {
            [cell setFields:@"xyzz" editString:@"xccscscscccscscs" Delegate:self Tag:10 Pos:65];                
        } 
        if (indexPath.row == 1)
        {          
            [cell setFields:@"Email" editString:@"your mail" Delegate:self Tag:11 Pos:60];            
        } 
        if (indexPath.row == 2)
        {
            [cell setFields:@"Password" editString:@"your password" Delegate:self Tag:12 Pos:90];
            cell.cellText.secureTextEntry = YES;
        }
        return cell;    
    }        
    
    
    if (indexPath.section == 2) 
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSignUp"];
         if (cell == nil) 
         {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSignUp"] autorelease];
         cell.accessoryType = UITableViewCellAccessoryNone;
         }
         cell.textLabel.text = @"Sign up"; 
         cell.textLabel.textAlignment = UITextAlignmentCenter;
         cell.selectionStyle=UITableViewCellSelectionStyleBlue;
         return cell; 
        
/*        
        NewButtonCell *cell = (NewButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"NewButtonCell"];
        if (cell == nil) 
        {
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewButtonCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewButtonCell class]])
                {
                    cell = (NewButtonCell*) aCell;
                    break;
                }         
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;        
        if (indexPath.row == 0)
        {
            [cell.cellButton setTitle:@"Sign in somewhere" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        }       
        return cell;
 */
    }
    
    
    return nil; 
}

- (void)buttonAction 
{
    NSLog(@"---new button action----");    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUG
    NSLog(@"was seleted row %d in section %d)", indexPath.row, indexPath.section);
#endif 
    if (indexPath.row==0 && indexPath.section == 2) {
        [self buttonAction];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{   
#ifdef DEBUG
//    NSLog(@"--text End-- tag:%d (%@)",textField.tag,textField.text);
#endif 
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Hide Keyboard actions
//------------------------------------------------------------------------------




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
//    float y0 = hideKeyboardShift;
//    float y1 = leftTopPoint.y;
    float y2 = leftBottomPoint.y;
    float y3 = aRect.size.height;   
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



//------------------------------------------------------------------------------

/*
 - (void)keyboardWasShown:(NSNotification*)aNotification {
 NSDictionary* info = [aNotification userInfo];
 CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 CGRect bkgndRect = activeField.superview.frame;
 bkgndRect.size.height += kbSize.height;
 [activeField.superview setFrame:bkgndRect];
 //    [scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
 CGPoint leftBottomPoint = [activeField convertPoint:activeField.bounds.origin toView:self.view]; //left top corner
 leftBottomPoint.y+= activeField.bounds.size.height;//left bottom corner
 [scrollView setContentOffset:CGPointMake(0.0, leftBottomPoint.y-kbSize.height) animated:YES];    
 }
 */

/*
 NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.infoTableView.contentInset = contentInsets;
    self.infoTableView.scrollIndicatorInsets = contentInsets;
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint leftBottomPoint = [self.activeField convertPoint:self.activeField.bounds.origin toView:self.view]; //left top corner
    leftBottomPoint.y+= self.activeField.bounds.size.height;//left bottom corner
    
    if (!CGRectContainsPoint(aRect, leftBottomPoint)) 
    {
        CGPoint scrollPoint = CGPointMake(0.0,[self.activeField convertPoint:self.activeField.bounds.origin toView:self.infoTableView].y - 3);
        [self.infoTableView setContentOffset:scrollPoint animated:YES];
    }
 */

							
@end
