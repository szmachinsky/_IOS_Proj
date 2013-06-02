//
//  EntryCell.h
//  MyVisas
//
//  Created by Natalia Tsybulenko on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeparatorLine;

@interface EntryCell : UITableViewCell {
    
}
@property (nonatomic, retain) IBOutlet UILabel *entryDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *departureDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *daysLabel;
@property (nonatomic, retain) IBOutlet UILabel *daysTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *entryImage;
@property (nonatomic, retain) IBOutlet UIImageView *departureImage;
@property (nonatomic, retain) IBOutlet UIImageView *daysImage;
@property (nonatomic, retain) IBOutlet SeparatorLine *line;

@end
