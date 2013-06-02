//
//  UICustomVoteModeCell.h
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomVoteModeCell : UITableViewCell
{
    UIImageView* imageView_;
    UIButton* voteButton_;
    UILabel* nominationLabel_;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIButton* voteButton;
@property (nonatomic, retain) IBOutlet UILabel* nominationLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
