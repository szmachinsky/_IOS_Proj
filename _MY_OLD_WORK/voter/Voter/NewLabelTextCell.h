//
//  NewLabelCell.h
//  VoterTest
//
//  Created by User on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface NewLabelTextCell : UITableViewCell 
{    
    IBOutlet UILabel *cellLabel_;
    IBOutlet UITextField *cellText_;
}
@property (nonatomic,retain) UILabel *cellLabel;
@property (nonatomic,retain) UITextField *cellText;

- (void)setFields:(NSString *)labelStr editString:(NSString *)editStr Delegate:(id)delegate Tag:(int)tag Pos:(int)position;


@end
