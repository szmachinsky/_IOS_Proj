//
//  VisaCell.h
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VisaCellDelegate <NSObject>
- (void)entriesBtnPressedForCountry:(NSString *)country;
@end

@interface VisaCell : UITableViewCell {
    
}
@property (nonatomic, assign) id<VisaCellDelegate> delegate;
@property (nonatomic, retain) NSString *country;

@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UILabel *datesLabel;

@property (nonatomic, retain) IBOutlet UILabel *entriesTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *remainsTextLabel;

@property (nonatomic, retain) IBOutlet UILabel *entriesLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *remainsLabel;

@property (nonatomic, retain) IBOutlet UIButton *entriesButton;

@property (nonatomic, retain) UIColor *topColor;

@end
