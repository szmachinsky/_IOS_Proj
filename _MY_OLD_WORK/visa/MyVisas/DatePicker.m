//
//  DatePicker.m
//  MyVisas
//
//  Created by Nnn on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePicker.h"
#import "Utils.h"

@implementation DatePicker
@synthesize date, delegate;

- (id)initWithFrame:(CGRect)frame {
    frame.size.width = 320.0f;
    frame.size.height = 224.0f;
    
    self = [super initWithFrame:frame];
    if (self) {
        // create toolbar
        UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *spaceItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
        UIBarButtonItem *doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)] autorelease];
        doneItem.style = UIBarButtonItemStylePlain;
        
        [toolbar setItems:[NSArray arrayWithObjects:spaceItem, doneItem, nil] animated:NO];
        [self addSubview:toolbar];
        
        // create date picker view
        picker = [[UIDatePicker alloc] init];
        picker.frame = CGRectMake(0.0f, 44.0f, 320.0f, 180.0f);
        picker.datePickerMode = UIDatePickerModeDate;
        
        [self addSubview:picker];
    }
    return self;
}

- (void)donePressed {
    self.date = picker.date;
    if (delegate != nil && [(id)delegate respondsToSelector:@selector(pickerDonePressed:)]) {
        [(id)delegate pickerDonePressed:self];
    }
}

- (void)setDate:(NSDate *)newDate {
    [date release];
    date = [newDate retain];
    if (checkForNotNull(picker)) {
        picker.date = date;
    }
}


- (void)dealloc {
    [date release];
    [picker release];
    [super dealloc];
}

@end
