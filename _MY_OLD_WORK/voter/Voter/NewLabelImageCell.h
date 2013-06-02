//
//  NewLabelImageCell.h
//  VoterTest
//
//  Created by User on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLabelImageCell : UITableViewCell
{
    
    IBOutlet UILabel *cellLabel_;    
    IBOutlet UIImageView *cellImage_;
    
}

@property (nonatomic,retain) UILabel *cellLabel;
@property (nonatomic,retain) UIImageView *cellImage;

@end
