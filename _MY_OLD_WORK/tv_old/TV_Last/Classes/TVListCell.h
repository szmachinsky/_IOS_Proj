//
//  TVListCell.h
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  CustomProgressView;

@interface TVListCell : UITableViewCell {
    UILabel *currentShowLabel;
    UILabel *nextShowLabel;
    UILabel *channelNameLabel;
    UIImageView *myImageView;
    CustomProgressView *progressBar;
    float iconH;
}

@property(nonatomic,strong)UILabel *currentShowLabel;
@property(nonatomic,strong)UILabel *nextShowLabel;
@property(nonatomic,strong)UILabel *channelNameLabel;
//@property(nonatomic,retain)UIImageView *myImageView;
///-(void)setIcon:(NSString *)iconName;
-(void)setIconImage:(UIImage*)icon;
-(void)setTimeFromBeginning:(float) min durationOfShow:(float)duration;
-(void)setProgressBarVisible:(BOOL)isVisible;

@end
