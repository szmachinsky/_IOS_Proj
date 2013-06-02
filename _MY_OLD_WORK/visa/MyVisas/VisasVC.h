//
//  ViewController.h
//  MyVisas
//
//  Created by Nnn on 18.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"
#import "KeyboardView.h"
#import <UIKit/UIKit.h>
//#import <iAd/ADBannerView.h>

//#import "WPBannerView.h"


@interface VisasVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, DatePickerDelegate, KeyboardDelegate, UIActionSheetDelegate>{//, ADBannerViewDelegate, WPBannerViewDelegate> {
    
    IBOutlet UIScrollView *pagesView;
    IBOutlet UILabel *pageLabel;
    IBOutlet UIButton *leftButton;
    
    IBOutlet UILabel *countryLabel;
    IBOutlet UITextField *countryField;
    IBOutlet UIButton *rightButton;
    IBOutlet UILabel *editLabel;
                         
    
    IBOutlet UILabel *noVisasLabel;
    
    IBOutlet UIImageView *topBarView;
    ADBannerView *adBannerView;
    
    BOOL isBannerVisible;
    BOOL isSearching;
    BOOL editFromDate;
    BOOL editUntilDate;
    BOOL editDuration;
    BOOL editEntries;
    BOOL editMode;
    BOOL addedVisa;
    
    //WPBannerView *wpBannerView;
}
@property (nonatomic, retain) IBOutlet UIButton *locationButton;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;

- (IBAction)leftBtnPressed:(id)sender;
- (void)editPressed:(id)sender;
- (void)deletePressed:(id)sender;
- (IBAction)searchPressed:(id)sender;
- (IBAction)locationPressed:(id)sender;
- (IBAction)rightBtnPressed:(id)sender;
- (void)resortPages;
- (void)entranceEditing:(BOOL)isEditing;
- (void)scrollToVisa:(NSMutableDictionary *)visa;

@end
