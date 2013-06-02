//
//  UICustomSubcategoriesCell.h
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomSubcategoriesCell : UITableViewCell
{
    UIImageView* imageView_;
    UILabel* subCategoryLabel_;
    UIButton* checkButton_;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UILabel* subCategoryLabel;
@property (nonatomic, retain) IBOutlet UIButton* checkButton;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
