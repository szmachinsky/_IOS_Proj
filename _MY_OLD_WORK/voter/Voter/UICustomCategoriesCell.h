//
//  UICustomCategoriesCell.h
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomCategoriesCell : UITableViewCell
{
@private
    
    UIImageView* imageView_;
    UILabel* categoryLabel_;
    UILabel* percentLabel_;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UILabel* categoryLabel;
@property (nonatomic, retain) IBOutlet UILabel* percentLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
