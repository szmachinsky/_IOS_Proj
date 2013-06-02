//
//  VisaPageView.m
//  MyVisas
//
//  Created by Nnn on 19.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "EntriesVC.h"
#import "FlurryAnalytics.h"
#import "FullVersionDescriptionVC.h"
#import "InAppPurchaseManager.h"
#import "RoundRectLabel.h"
#import "Utils.h"
#import "VisaPageView.h"
#import "VisasVC.h"

@implementation VisaPageView
@synthesize visaData, editMode, isEditing, controller;
@synthesize fromLabel, untilLabel, durationLabel, durationTextLabel, entriesLabel, entriesTextLabel;

@synthesize warningTextView;

- (void)changeDaysRemainLabels {
    NSDate *now = [NSDate date];
    NSDate *expiryDate = [self.visaData objectForKey:@"untilDate"];
    
    NSInteger monthNum = 0;
    NSInteger daysNum = 0;
    if (checkForNotNull(expiryDate) && [[cutTime(now) earlierDate:cutTime(expiryDate)] isEqualToDate:cutTime(now)]) {
        NSDictionary *daysAndMonth = getDaysAndMonthNumBetweenDates(now, expiryDate);
        monthNum = [[daysAndMonth objectForKey:@"month"] intValue];
        daysNum = [[daysAndMonth objectForKey:@"day"] intValue];
    }
    daysTextLabel.text = daysStr(daysNum);
    daysLabel.text = [NSString stringWithFormat:@"%d", daysNum];
    monthLabel.text = [NSString stringWithFormat:@"%d", monthNum];
    
    monthPart.hidden = (monthNum == 0);
    daysPart.frame = CGRectMake(monthPart.hidden ? 50.0f : 170.0f, CGRectGetMinY(daysPart.frame), CGRectGetWidth(daysPart.frame), CGRectGetHeight(daysPart.frame));
}

- (void)configurePage {
    countryLabel.text = getCountryNameByCode([self.visaData objectForKey:@"country"]);
    
    NSDate *fromDate = [self.visaData objectForKey:@"fromDate"];
    NSDate *untilDate = [self.visaData objectForKey:@"untilDate"];
    fromLabel.text = checkForNotNull(fromDate) ? formattedDate(fromDate, NO) : @"-";
    untilLabel.text = checkForNotNull(untilDate) ? formattedDate(untilDate, NO) : @"-";
    
    borderView.image = editMode ? nil : [UIImage imageNamed:@"green_frame.png"];
    
    if ([[fromDate earlierDate:[NSDate date]] isEqualToDate:fromDate])
    {
        editButton.hidden = YES;
    }
    if (editMode)
    {
        warningTextView.hidden = NO;
    }
    else
    {
        warningTextView.hidden = YES;
    }
    
    NSInteger beforeDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:0] intValue];   
    if (checkForNotNull(untilDate)) {
        // if visa expired - draw in red color 
        NSDate *now = [NSDate date];
        if (![[[NSDate dateWithTimeInterval:24*60*60 sinceDate:untilDate] earlierDate:now] isEqualToDate:now]) {
            fromLabel.color = untilLabel.color = daysLabel.color = durationLabel.color = entriesLabel.color = RED_COLOR;
            borderView.image = editMode ? nil : [UIImage imageNamed:@"red_frame.png"];
        }
        else if (daysBetweenDates([NSDate date], untilDate) < beforeDays) {
            // if about to expiry - draw in yellow color
            fromLabel.color = untilLabel.color = daysLabel.color = durationLabel.color =
            entriesLabel.color = YELLOW_COLOR2;
            borderView.image = editMode ? nil : [UIImage imageNamed:@"yellow_frame.png"];
        }
        else {
            fromLabel.color = untilLabel.color = daysLabel.color = durationLabel.color =
            entriesLabel.color = [[UIColor greenColor] colorWithAlphaComponent:0.2f];
        }
    }
    
    // if expiry date not entered - visa is not received
    BOOL visaNotReceived = (untilDate == nil) || ([[self.visaData objectForKey:@"status"] isEqualToString:VISA_STATUS_UNRECEIVED]);
    durationView.hidden = entriesView.hidden = !editMode && visaNotReceived;
    daysView.hidden = enterButton.hidden = editMode || visaNotReceived;
    notReceivedLabel.hidden = editMode || !visaNotReceived;
    
    [self changeDaysRemainLabels];
    
    NSInteger stayDays = getDurationNumForVisa(self.visaData);
    durationTextLabel.text = [NSString stringWithFormat:@"%@ %@", daysStr(stayDays), NSLocalizedString(@"days of stay", @"days of stay")];
    durationLabel.text = [NSString stringWithFormat:@"%d", stayDays];
    if (stayDays == 0) {
        durationLabel.color = RED_COLOR;
        borderView.image = editMode ? nil : [UIImage imageNamed:@"red_frame.png"];
    }
    
    NSInteger numOfEntries = [self.visaData objectForKey:@"entries"] != nil ? [[self.visaData objectForKey:@"entries"] intValue] : 0;
    entriesTextLabel.text = entriesStr(numOfEntries);
    entriesLabel.text = numOfEntries == NSIntegerMax ? @"MULT" : [NSString stringWithFormat:@"%d", numOfEntries];
    entriesLabel.font = numOfEntries == NSIntegerMax ? [UIFont boldSystemFontOfSize:16.0f] : [UIFont boldSystemFontOfSize:20.0f];
    if (numOfEntries == 0) {
        entriesLabel.color = RED_COLOR;
        borderView.image = editMode ? nil : [UIImage imageNamed:@"red_frame.png"];
    }
    
    // if no entries - hide button and not in country
    enterButton.hidden = editMode || ((numOfEntries == 0 || stayDays == 0 || [AppData sharedAppData].isInCountry) && ([[self.visaData objectForKey:@"nowInCountry"] boolValue] == NO));
}

- (void)appBecomeActive {
    // update only if new day
    NSDate *lastOpened = [AppData sharedAppData].lastDateOpened;
    if (isNewDay(lastOpened)) {
        [self configurePage];
    }
}

- (void)changeEnterBtnText {
    NSString *title = [[self.visaData objectForKey:@"nowInCountry"] boolValue] ? NSLocalizedString(@"Leave", @"leave") : NSLocalizedString(@"Arrive", @"arrive");
    [enterButton setTitle:title forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame data:(NSMutableDictionary *)data target:(id)target {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.visaData = data;
        self.backgroundColor = [UIColor clearColor];
        
        // load view from nib
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"VisaPageView" owner:self options:nil];
        if (nibViews.count) {
            [self addSubview:[nibViews objectAtIndex:0]];
        }
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 264.0f, 320.0f, 216.0f)];
        [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        //add actions for labels
        [fromLabel addTarget:target action:@selector(fromDateEditing)];
        [untilLabel addTarget:target action:@selector(untilDateEditing)];
        [durationLabel addTarget:target action:@selector(durationEditing)];
        [entriesLabel addTarget:target action:@selector(entriesEditing)];
        
        [self changeEnterBtnText];
        [enterButton setTitleColor:[UIColor colorWithRed:50.0f/255.0f green:74.0f/255.0f blue:88.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [enterButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullVersionUnlocked) name:kInAppPurchaseUnlock object:nil];
        [self configurePage];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame data:nil target:nil];
}

- (void)setEditModeForLabels:(BOOL)edit {
    fromLabel.editMode = untilLabel.editMode = durationLabel.editMode = entriesLabel.editMode = edit;
}

- (void)setIsEditing:(BOOL)edit {
    isEditing = edit;
    if (!edit) {
        fromLabel.editing = untilLabel.editing = durationLabel.editing = 
        entriesLabel.editing = NO;
    }
}

- (void)setEditMode:(BOOL)isEditMode {
    editMode = isEditMode;
    entriesButton.hidden = isEditMode;
    editButton.hidden = deleteButton.hidden = isEditMode;
    durationView.frame = CGRectMake(CGRectGetMinX(durationView.frame), isEditMode ? 92.0f : 157.0f, CGRectGetWidth(durationView.frame), CGRectGetHeight(durationView.frame));
    entriesView.frame = CGRectMake(CGRectGetMinX(entriesView.frame), isEditMode ? 138.0f : 203.0f, CGRectGetWidth(entriesView.frame), CGRectGetHeight(entriesView.frame));
    [self setEditModeForLabels:isEditMode];
    [self configurePage];
    // redraw views
    [fromLabel setNeedsDisplay];
    [untilLabel setNeedsDisplay];
    [durationLabel setNeedsDisplay];
    [entriesLabel setNeedsDisplay];
}

- (void)changeDate:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    if (selectedDate != nil) {
        [selectedDate release];
    }
    selectedDate = [picker.date retain];
    entryDateLabel.text = formattedDate(selectedDate, NO);
}

- (void)switchToEnterMode:(BOOL)isEnterMode {
    countryLabel.frame = CGRectMake(20.0f, isEnterMode ? 20.0f : 15.0f, 280.0f, 35.0f);
    entriesButton.hidden = isEnterMode;
    controller.locationButton.hidden = controller.searchButton.hidden = isEnterMode;
    datesView.hidden = daysView.hidden = durationView.hidden = entriesView.hidden = enterButton.hidden = isEnterMode;
    entryTextLabel.hidden = entryDateLabel.hidden = cancelButton.hidden = confirmButton.hidden = !isEnterMode;
    entryTextLabel.text = [[self.visaData objectForKey:@"nowInCountry"] boolValue] ? NSLocalizedString(@"Date of departure:", @"date of departure") : NSLocalizedString(@"Date of entry:", @"date of entry");
}

- (IBAction)enterBtnPressed:(id)sender {
//    NSString *country = [visaData objectForKey:@"country"];
//    NSArray *entries = [[AppData sharedAppData].entries objectForKey:country];
//    BOOL isInCountry = [[self.visaData objectForKey:@"nowInCountry"] boolValue];
//    if (!isInCountry && entries.count > ENTRIES_RESTRICTION - 1) {
//        NSString *infoStr = NSLocalizedString(@"Number of entries is limited in this version. To remove the restriction you can buy the full version.", @"number of entries restriction");
//        showFullVersionInfo(infoStr, self.controller);
//    }
//    else {
        [self switchToEnterMode:YES];
        // set date to current date
        datePicker.date = [NSDate date];
        [self changeDate:datePicker];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:datePicker];
        [controller entranceEditing:YES];
//    }
}

- (IBAction)cancelPressed:(id)sender {
    [self switchToEnterMode:NO];
    [datePicker removeFromSuperview];
    [controller entranceEditing:NO];
}

- (IBAction)confirmPressed:(id)sender {
    BOOL inCountry = [[self.visaData objectForKey:@"nowInCountry"] boolValue];
    NSDate *fromDate = [self.visaData objectForKey:@"fromDate"];
    NSDate *untilDate = [self.visaData objectForKey:@"untilDate"];
    NSDate *entryDate = [self.visaData objectForKey:@"entryDate"];
    
    BOOL showAlert = NO;
    int errorType = 0;
    if (inCountry) {
        // confirm departure
        if (isDateBetweenDates(selectedDate, entryDate, [NSDate dateWithTimeInterval:24*60*60 sinceDate:untilDate])) {
            // calculate remains days of stay
            NSDate *departuteDay = selectedDate;
            NSInteger periodOfStay = daysBetweenDates(cutTime(entryDate), cutTime(departuteDay));
            NSInteger remains = [[visaData objectForKey:@"duration"] intValue] - periodOfStay - 1;
            remains = remains > 0 ? remains : 0;
            [visaData setObject:[NSNumber numberWithInt:remains] forKey:@"duration"];
            [visaData removeObjectForKey:@"entryDate"];
            
            // cancel notification about duration
            for (UILocalNotification *note in [UIApplication sharedApplication].scheduledLocalNotifications) {
                if ([[note.userInfo objectForKey:@"type"] isEqualToString:@"duration"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            
            // add record about departure
            NSString *country = [self.visaData objectForKey:@"country"];
            NSMutableDictionary *entries = [AppData sharedAppData].entries;
            NSMutableArray *entriesToCountry = [entries objectForKey:country];
            if (entriesToCountry.count > 0) {
                NSMutableDictionary *entryDataDict = [entriesToCountry lastObject];
                [entryDataDict setObject:departuteDay forKey:@"departure"];
            }
        }
        else {
            showAlert = YES;
        }
    }
    else {
        // confirm entrance
        if (isDateBetweenDates(selectedDate, fromDate, untilDate) && [[cutTime(selectedDate) earlierDate:cutTime([NSDate date])] isEqualToDate:cutTime(selectedDate)]) {
            [visaData setObject:selectedDate forKey:@"entryDate"];
            NSInteger numOfEntries = [[self.visaData objectForKey:@"entries"] intValue];
            numOfEntries = numOfEntries == NSIntegerMax ? NSIntegerMax : numOfEntries - 1;
            [self.visaData setObject:[NSNumber numberWithInt:numOfEntries] forKey:@"entries"];
            if ([[[AppData sharedAppData].showAlerts objectAtIndex:1] boolValue]) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate createNotificationForDuration];
            }
            
            // add record about entry
            NSString *country = [self.visaData objectForKey:@"country"];
            NSMutableDictionary *entries = [AppData sharedAppData].entries;
            if (entries == nil) {
                entries = [NSMutableDictionary dictionary];
            }
            NSMutableArray *entriesToCountry = [entries objectForKey:country];
            if (entriesToCountry == nil) {
                entriesToCountry = [NSMutableArray array];
                [entries setObject:entriesToCountry forKey:country];
            }
            NSMutableDictionary *entryDataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:selectedDate, @"entryDate", nil];
            [entriesToCountry addObject:entryDataDict];
            [AppData sharedAppData].entries = entries;
        }
        else if (![[cutTime(selectedDate) earlierDate:cutTime([NSDate date])] isEqualToDate:cutTime(selectedDate)]) {
            showAlert = YES;
            errorType = 2;
        }
        else {
            showAlert = YES;
            errorType = 1;
        }
    }
    
    if (showAlert) {
        NSString *alertText = nil;
        if (errorType == 2) {
            alertText = [NSString stringWithFormat:NSLocalizedString(@"%@ has not come yet", @"date has not come yet"), formattedDate(selectedDate, YES)];
        }
        else {
           alertText = errorType == 0 ? NSLocalizedString(@"Date of departure should be within date of entrance and visa expiry date.",@"departure date error") : NSLocalizedString(@"Date of entrancce should be within the perion of visa",@"entrance date error");
        }
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    else {
        [self configurePage];
        [self switchToEnterMode:NO];
        [visaData setObject:[NSNumber numberWithBool:!inCountry] forKey:@"nowInCountry"];
        [visaData setObject:[NSDate date] forKey:@"modificationDate"];
        [AppData sharedAppData].isInCountry = !inCountry;
        
        [[AppData sharedAppData] save];
        
        [controller resortPages];
        [self changeEnterBtnText];
        [datePicker removeFromSuperview];
        [controller entranceEditing:NO];
    }    
}

- (IBAction)editPressed:(id)sender {
    [AppData sharedAppData].isVisaOnEdit = YES;
    [controller editPressed:sender];
}

- (IBAction)deletePressed:(id)sender {
    [controller deletePressed:sender];
}

- (IBAction)entriesBtnPressed:(id)sender {
    EntriesVC *entriesVC = [[[EntriesVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    entriesVC.country = [self.visaData objectForKey:@"country"];
    [self.controller.navigationController pushViewController:entriesVC animated:YES];
    
    [FlurryAnalytics logEvent:EVENT_VIEW_ENTRIES_LOG_PRESSED];
}

- (void)fullVersionUnlocked {
    //if (!editMode) {
    //    entriesButton.hidden = NO;
    //}
}

- (void)dealloc {
    self.visaData = nil;
    [countryLabel release];
    [datesView release];
    self.fromLabel = nil;
    self.untilLabel = nil;
    [daysLabel release];
    self.durationTextLabel = nil;
    self.durationLabel = nil;
    self.entriesLabel = nil;
    self.entriesTextLabel = nil;
    [daysView release];
    [durationView release];
    [entriesView release];
    [daysTextLabel release];
    [daysPart release];
    [monthPart release];
    [monthLabel release];
    [enterButton release];
    [notReceivedLabel release];
    [entryTextLabel release];
    [entryDateLabel release];
    [cancelButton release];
    [confirmButton release];
    [selectedDate release];
    [datePicker release];
    [borderView release];
    [entriesButton release];
    
    [warningTextView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
