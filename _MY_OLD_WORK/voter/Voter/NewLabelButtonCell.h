//
//  NewLabelButtonCell.h
//  VoterTest
//
//  Created by User on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLabelButtonCell : UITableViewCell
{
@private
    IBOutlet UILabel *cellLabel_;
    IBOutlet UIButton *cellButton_;
    IBOutlet UIImageView *cellImage_;
    
    
    
}

@property (nonatomic,retain) UILabel *cellLabel;
@property (nonatomic,retain) UIButton *cellButton;
@property (nonatomic,retain) UIImageView *cellImage;

@end
