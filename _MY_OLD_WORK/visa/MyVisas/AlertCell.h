//
//  AlertCell.h
//  MyVisas
//
//  Created by Nnn on 21.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *settingsLabel;
@property (nonatomic, retain) IBOutlet UILabel *repeatsLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@end
