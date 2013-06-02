//
//  TVListCell.h
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgramByCategoryCell : UITableViewCell {
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UILabel *thirdLabel;
    UILabel *forthLabel;    
    UIImageView *myImageView;
    float iconH;
}

@property(nonatomic,strong)UILabel *primaryLabel;
@property(nonatomic,strong)UILabel *secondaryLabel;
@property(nonatomic,strong)UILabel *thirdLabel;
@property(nonatomic,strong)UILabel *forthLabel; //zs
//@property(nonatomic,retain)UIImageView *myImageView;

//-(void)setIcon:(NSString *)iconName;
-(void)setIconImage:(UIImage*)icon;

@end
