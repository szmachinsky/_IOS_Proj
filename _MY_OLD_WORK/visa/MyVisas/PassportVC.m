//
//  PassportVC.m
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "PassportVC.h"
#import "Utils.h"


@interface PassportVC()
@property (nonatomic, retain) DatePicker *pickerView;
@property (nonatomic, retain) NSDate *issueDate;
@property (nonatomic, retain) NSDate *expiryDate;
@end

@implementation PassportVC
@synthesize pickerView, issueDate, expiryDate;

- (void)dealloc {
    self.pickerView = nil;
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
    
    UIButton *btn = createBackNavButton();
    [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    self.pickerView = [[[DatePicker alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 0.0f, 0.0f)] autorelease];
    self.pickerView.delegate = self;
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:pickerView];
    
    NSDictionary *passportInfo = [AppData sharedAppData].passportInfo;
    self.issueDate = [passportInfo objectForKey:@"issueDate"];
    self.expiryDate = [passportInfo objectForKey:@"expiryDate"];
    
//    self.navigationItem.title = checkForNotNull(issueDate) && checkForNotNull(expiryDate) 
//    ? NSLocalizedString(@"Passport Info", @"passport info") : NSLocalizedString(@"Not entered", @"not entered");
    
    self.navigationItem.title = NSLocalizedString(@"Passport Info", @"passport info");
}

- (void)backPressed {
    if (checkForNotNull(issueDate) && checkForNotNull(expiryDate) && [[issueDate earlierDate:expiryDate] isEqualToDate:expiryDate]) {
        [[[[UIAlertView alloc] initWithTitle:@"Dates incorrect" message:NSLocalizedString(@"Date of expiry can't be earlier than date of issue. Please edit one of them", @"passport dates error") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else {
        [[AppData sharedAppData].passportInfo setObject:(checkForNotNull(issueDate) ? issueDate : [NSNull null]) forKey:@"issueDate"];
        NSDate *prevDate = [[AppData sharedAppData].passportInfo objectForKey:@"expiryDate"];
        if (!checkForNotNull(prevDate) || (checkForNotNull(expiryDate) && ![expiryDate isEqualToDate:prevDate])) {
            [[AppData sharedAppData].passportInfo setObject:expiryDate forKey:@"expiryDate"];
            
            if ([[[AppData sharedAppData].showAlerts objectAtIndex:2] boolValue]) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate createNotificationForPassport];
            }
        }
        [self.pickerView removeFromSuperview]; 
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setPickerViewHidden:(BOOL)hidden {
    CGRect hiddenFrame = CGRectMake(0.0f, 480.0f, CGRectGetWidth(self.pickerView.frame), CGRectGetHeight(self.pickerView.frame));
    CGRect visibleFrame = CGRectMake(0.0f, 480.0f - CGRectGetHeight(self.pickerView.frame), CGRectGetWidth(self.pickerView.frame), CGRectGetHeight(self.pickerView.frame));
    
    self.pickerView.frame = hidden ? visibleFrame : hiddenFrame;
    [UIView beginAnimations:@"picker animation" context:NULL];
    [UIView setAnimationDuration:0.3f];
    self.pickerView.frame = hidden ? hiddenFrame : visibleFrame;
    [UIView commitAnimations];
}

- (void)editDate:(int)sectionNum {
    enteringIssueDate = (sectionNum == 0);
    [self setPickerViewHidden:NO];
    NSDate *date = enteringIssueDate ? issueDate : expiryDate;
    if (date != nil && ![date isEqual:[NSNull null]]) {
        self.pickerView.date = date;
    }
}

#pragma mark - Date picker delegate

- (void)pickerDonePressed:(id)sender {
    NSDate *selectedDate = pickerView.date;
    [self setPickerViewHidden:YES];
    if (enteringIssueDate) {
        self.issueDate = selectedDate;
    }
    else {
        self.expiryDate = selectedDate;
    }
    [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.backgroundColor = BACK_COLOR;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = (indexPath.row == 0) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    cell.accessoryView = indexPath.row == 1 ? [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pencil.png"]] autorelease] : nil;
    cell.imageView.image = indexPath.row == 1 ? [UIImage imageNamed:@"empty.png"] : 0;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = (indexPath.section == 0) ? NSLocalizedString(@"Date of issue", @"date of issue") : NSLocalizedString(@"Expiry date", @"expiry date");
    }
    if (indexPath.row == 1) {
        NSString *issueStr = checkForNotNull(issueDate) ? formattedDate(issueDate, NO) : NSLocalizedString(@"Not entered", @"not entered");
        NSString *expiryStr = checkForNotNull(expiryDate) ? formattedDate(expiryDate, NO) : NSLocalizedString(@"Not entered", @"not entered");
        cell.textLabel.text = (indexPath.section == 0) ? [NSString stringWithFormat:@" %@", issueStr] : [NSString stringWithFormat:@" %@", expiryStr];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self editDate:indexPath.section];
    }
}

@end
