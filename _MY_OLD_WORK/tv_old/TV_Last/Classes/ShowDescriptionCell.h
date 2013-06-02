//
//  AlarmCell.h
//  TVProgram
//
//  Created by Nnn on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDescriptionCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *channelImage;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;


@end
