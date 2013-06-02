//
//  EditProfileViewController.m
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import "NewLabelTextCell.h"
#import "NewButtonCell.h"
//#import "NewLabelImageCell.h"
#import "NewLabelButtonCell.h"

#import "UserInfo.h"


#define kTagUsername    1
#define kTagEmail       2
#define kTagZipCode     3
#define kTagYearOfBirth 4
#define kTagChangePass  5
#define kTagConfirmPass 6


@interface EditProfileViewController () 
- (void)changeImageToCell:(UIImageView*)cellView Image:(UIImage*)image ;
- (void)changeImageToCellImage;
- (void)pressAddPhoto;
- (void)pressSaveProfile;
@end


//------------------------------------------------------------------------------
@implementation EditProfileViewController
@synthesize thumbnail = thumbnail_;
@synthesize username = username_, email = email_;
@synthesize zipCode = zipCode_, yearOfBirth = yearOfBirth_;
@synthesize password = password_;
@synthesize changePass = changePass_, confirmPass = confirmPass_;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#ifdef DEBUG
        NSLog(@"--++INIT-EditProfile");
#endif 
    
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
    NSLog(@"---!!!didReceiveMemoryWarning-EditProfile");
#endif 
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
#ifdef DEBUG
    NSLog(@"---didUnload-EditProfile");
#endif 
    [infoTableView_ release];
    infoTableView_ = nil;
    
    [testButton_ release];
    testButton_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
#ifdef DEBUG
    NSLog(@"---dealloc-EditProfile");
#endif 
    [infoTableView_ release];
    
    self.thumbnail = nil;
    
    self.username = nil;
    self.email = nil;
    self.zipCode = nil;
    self.yearOfBirth = nil;
    self.password = nil;
    self.changePass = nil;
    self.confirmPass = nil;
    
    [testButton_ release];
    [super dealloc];
}


- (void)viewDidLoad
{
#ifdef DEBUG
    NSLog(@"--+didLoad-EditProfile");
#endif 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hideKeyboardShift = 44 + 10;
    
//  testButton_.tintColor = [UIColor clearColor];
//    [testButton_ setTintColor:[UIColor colorWithRed:100 green:100 blue:100 alpha:1.0]];
    testButton_.hidden = YES;
    
    self.username = @"";//[UserInfo sharedInstance].username;
    self.email = @"";//[UserInfo sharedInstance].email;
    self.password = @"";//[UserInfo sharedInstance].password;
    self.yearOfBirth = @"";//[UserInfo sharedInstance].yearOfBirth;
    self.zipCode = @"";//[UserInfo sharedInstance].zipCode;    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}



#pragma mark - Table View lifecycle

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    } 
    if (section==1) {
        return 1;
    } 
   return 1;    
}        

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0  &&  indexPath.row == 0)
        return 71;
    return 44;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  static NSString *CellIdentifier = @"CellSignUp2";
    UITableViewCell *cell =nil;   
        
    if (indexPath.section == 0) 
    {  
        if (indexPath.row == 0) 
        {
            NewLabelButtonCell *cell = (NewLabelButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"NewLabelButtonCell"];
            if (cell == nil) 
            {
                NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewLabelButtonCell" owner:self options:nil];
                for (UIView* aCell in loadedViews)
                {
                    if ([aCell isMemberOfClass:[NewLabelButtonCell class]])
                    {
                        cell = (NewLabelButtonCell*) aCell; break;
                    }                
                }            
            }     
            pickerCell_ = cell;
            cell.accessoryType = UITableViewCellAccessoryNone;
            //      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.cellLabel.text = @"Add Photo";
//          UIImage *ui = [UIImage imageNamed:@"_02.jpg"];
//          UIImage *ui = [UIImage imageNamed:@"me11_64.png"];
//          [cell.cellButton setImage:ui forState:UIControlStateNormal];
//          [cell.cellImage setImage:ui];
            if (self.thumbnail)
            {
                cell.cellImage.image = self.thumbnail;
//              [self changeImageToCell:cell.cellImage Image:self.thumbnail];
                
//              [self changeImageToCellImage];
//              [self performSelector:@selector(changeImageToCellImage) withObject:nil afterDelay:0.1];
            }
            [cell.cellButton addTarget:self action:@selector(pressAddPhoto) forControlEvents:UIControlEventTouchUpInside]; 
            cell.cellButton.adjustsImageWhenHighlighted=NO;
            cell.cellButton.highlighted = NO;
//            [cell.cellButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//            [cell.cellButton setTintColor:[UIColor redColor]];
//            cell.cellButton.tintColor = cell.cellButton.backgroundColor;
//            [cell.cellButton setTintColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];

            return cell;                                          
        } else 
        {        
            NewLabelTextCell *cell = (NewLabelTextCell*)[tableView dequeueReusableCellWithIdentifier:@"NewLabelTextCell"];
            if (cell == nil) 
            {
                NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewLabelTextCell" owner:self options:nil];
                for (UIView* aCell in loadedViews)
                {
                    if ([aCell isMemberOfClass:[NewLabelTextCell class]])
                    {
                        cell = (NewLabelTextCell*) aCell; break;
                    }                
                }            
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        
            switch (indexPath.row) 
            {
                case 1: 
                    [cell setFields:@"Username" editString:self.username Delegate:self Tag:kTagUsername Pos:90];
                    userField_ = cell.cellText;
                    break;
                case 2: 
                    [cell setFields:@"Email" editString:self.email Delegate:self Tag:kTagEmail Pos:60];
                    emailField_ = cell.cellText;
                    break;
                case 3: 
                    [cell setFields:@"Zip code" editString:self.zipCode Delegate:self Tag:kTagZipCode Pos:80];
                    zipField_ = cell.cellText;
                    break;
                case 4: 
                    [cell setFields:@"Year of Birth" editString:self.yearOfBirth Delegate:self Tag:kTagYearOfBirth Pos:105];
                    yearField_ = cell.cellText;
                    break;
                case 5: 
                    [cell setFields:@"Change Password" editString:self.changePass Delegate:self Tag:kTagChangePass Pos:150];
                    changePassField_ = cell.cellText;
                    cell.cellText.secureTextEntry = YES;
                    cell.cellText.clearsOnBeginEditing = YES;
                    break;
                case 6: 
                    [cell setFields:@"Confirm Password" editString:self.confirmPass Delegate:self Tag:kTagConfirmPass Pos:150];
                    confirmPassField_ = cell.cellText;
                    cell.cellText.secureTextEntry = YES;
                    cell.cellText.clearsOnBeginEditing = YES;
                    break;                
                
                default:
                    break;
            }
            return cell;
        }        
    }
    
    if (indexPath.section == 1) 
    {    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        if (indexPath.row == 0)
        {
            [cell.cellButton setTitle:@"Save Profile" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(pressSaveProfile) forControlEvents:UIControlEventTouchUpInside];
        }       
        return cell;   
    }
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUG
    NSLog(@"was seleted row %d in section %d)", indexPath.row, indexPath.section);
#endif 
    if (indexPath.row==0 && indexPath.section == 0) {
        [self pressAddPhoto];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
*/

- (void) setTextFields 
{
    self.email = emailField_.text;
    self.username = userField_.text;
    self.zipCode = zipField_.text;
    self.yearOfBirth = yearField_.text;
    NSString *txt = confirmPassField_.text;
    if (!txt && [txt isEqualToString:changePassField_.text])
        self.password = txt;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{   
#ifdef DEBUG
//  NSLog(@"  enter(%@) from field %d)",textField.text,textField.tag);    
#endif    
    [self setTextFields];
/*    
    NSString *text = textField.text;
    switch (textField.tag) 
    {
        case kTagUsername:
            self.username = text;
#ifdef DEBUG 
    NSLog(@" usename=(%@)",self.username);
#endif             
            break;
            
        case kTagEmail:
            self.email = text;
#ifdef DEBUG 
    NSLog(@" email=(%@)",self.email);
#endif             
            break;
            
        case kTagZipCode:
            self.zipCode = text;
#ifdef DEBUG 
    NSLog(@" zipCode=(%@)",self.zipCode);
#endif             
            break;
            
        case kTagYearOfBirth:
            self.yearOfBirth = text;
#ifdef DEBUG 
    NSLog(@" yearOfBirth=(%@)",self.yearOfBirth);
#endif             
            break;
            
        case kTagChangePass:
            self.changePass = text;
#ifdef DEBUG 
    NSLog(@" changePass=(%@)",self.changePass);
#endif             
            break;
            
        case kTagConfirmPass:
            self.confirmPass = text;
#ifdef DEBUG 
    NSLog(@" confirmPass=(%@)",self.confirmPass);
#endif          
            if ([self.confirmPass isEqualToString:self.changePass])
            {
                self.password = self.confirmPass;
#ifdef DEBUG 
    NSLog(@" password=(%@)",self.password);
#endif                          
            }                
            break;
           
        default:
            break;
    }
*/        
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - delegat's methods from Image Picker View Controller
- (UIImage *)setThumbnailDataFromImage:(UIImage *)imageFrom forSize:(float)sz
{
    float mx = sz;
    float my = sz;
    float x = imageFrom.size.width;
    float y = imageFrom.size.height;
    float d = x / y;
    if (d >= 1) {
        my = my / d;
    } else {
        mx = mx * d;
    }
    
    CGRect imageRect = CGRectMake(0, 0, roundf(mx),roundf(my)); 
    UIGraphicsBeginImageContext(imageRect.size);
    
    // Render the big image onto the image context 
    [imageFrom drawInRect:imageRect];
    
    // Make a new one from the image contextpickerCell_.cellImage.image    
    UIImage *imgTo = UIGraphicsGetImageFromCurrentImageContext();
//  NSData *data1 = UIImageJPEGRepresentation(imageFrom, 0.5);
//  NSData *data2 = UIImageJPEGRepresentation(imgTo, 0.5);
    
    // Clean up image context resources 
    UIGraphicsEndImageContext();    
    return imgTo;
}


- (void)changeImageToCell:(UIImageView*)cellView Image:(UIImage*)image 
{
//  [cellView setImage:image];      
    [UIView transitionWithView:cellView duration:1.0
                        options:UIViewAnimationOptionTransitionFlipFromLeft       
                     animations:^{ [cellView setImage:image];  }     
                     completion:NULL];     
}


- (void)changeImageToCellImage
{
//  pickerCell_.cellImage.image = self.thumbnail;     
    [UIView transitionWithView:pickerCell_.cellImage duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft       
                    animations:^{ [pickerCell_.cellImage setImage:self.thumbnail];  }     
                    completion:NULL]; 

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imagePhoto_ = [info objectForKey:UIImagePickerControllerOriginalImage]; 
    
    self.thumbnail = [self setThumbnailDataFromImage:imagePhoto_ forSize:60];     
//  pickerCell_.cellImage.image = self.thumbnail; 
    
    [self dismissModalViewControllerAnimated:YES];
    
//  NSData *data1 = UIImageJPEGRepresentation(self.imagePhoto, 0.5);
//  NSData *data2 = UIImageJPEGRepresentation(self.thumbnail, 0.5);
    
//  [self changeImageToCell:pickerCell_.cellImage Image:self.thumbnail];
//  [self changeImageToCellImage];
    [self performSelector:@selector(changeImageToCellImage) withObject:nil afterDelay:0.2];    
//  [infoTableView_ reloadData];
}


#pragma mark - Button's press actions

- (void)pressAddPhoto
{
#ifdef DEBUG
    NSLog(@"-pressAddPhoto");
#endif  
    [[self view] endEditing:YES];
    
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
//  imagePicker.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)pressSaveProfile
{
#ifdef DEBUG
    NSLog(@"-pressSignUp");
#endif  
    [self.view endEditing:YES];
    [self setTextFields];
}



@end
