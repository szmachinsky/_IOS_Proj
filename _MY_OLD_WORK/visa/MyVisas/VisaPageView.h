//
//  VisaPageView.h
//  MyVisas
//
//  Created by Nnn on 19.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"
#import <UIKit/UIKit.h>

@class RoundRectLabel;
@class VisasVC;

@interface VisaPageView : UIView {
    IBOutlet UILabel *countryLabel;
    
    IBOutlet UIView *datesView;
    
    IBOutlet UIView *daysView;
    IBOutlet UIView *daysPart;
    IBOutlet UIView *monthPart;
    IBOutlet UILabel *daysTextLabel;
    IBOutlet RoundRectLabel *daysLabel;
    IBOutlet RoundRectLabel *monthLabel;
    
    IBOutlet UIView *durationView;
    IBOutlet UIView *entriesView;
    
    IBOutlet UILabel *notReceivedLabel;
    IBOutlet UIButton *enterButton;
    
    IBOutlet UILabel *entryTextLabel;
    IBOutlet RoundRectLabel *entryDateLabel;
    
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *confirmButton;
    
    IBOutlet UIImageView *borderView;
    
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *deleteButton;
    
    IBOutlet UIButton *entriesButton;
    
    NSDate *selectedDate;
    UIDatePicker *datePicker;
    
    IBOutlet UITextView *warningTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *warningTextView;

@property (nonatomic, retain) NSMutableDictionary *visaData;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) VisasVC *controller;
@property (nonatomic, retain) IBOutlet UILabel *durationTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *entriesTextLabel;
@property (nonatomic, retain) IBOutlet RoundRectLabel *fromLabel;
@property (nonatomic, retain) IBOutlet RoundRectLabel *untilLabel;
@property (nonatomic, retain) IBOutlet RoundRectLabel *durationLabel;
@property (nonatomic, retain) IBOutlet RoundRectLabel *entriesLabel;

- (id)initWithFrame:(CGRect)frame data:(NSMutableDictionary *)data target:(id)targer;
- (void)configurePage;
- (IBAction)enterBtnPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)confirmPressed:(id)sender;
- (IBAction)editPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)entriesBtnPressed:(id)sender;

@end
