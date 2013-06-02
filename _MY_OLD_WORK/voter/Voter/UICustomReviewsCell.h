//
//  UICustomReviewsCell.h
//  Voter
//
//  Created by Khitryk Artsiom on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomReviewsCell : UITableViewCell
{
@private
    
    UIImageView* imageView_;
    UIButton* nameButton_;
    UILabel* descriptionLabel_;
    UILabel* nameLabel_;
    UILabel* dateLabel_;
    UIButton* reportButon_;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIButton* nameButton;
@property (nonatomic, retain) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UIButton* repotrButton;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
