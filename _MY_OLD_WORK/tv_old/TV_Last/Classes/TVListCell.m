//
//  TVListCell.m
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVListCell.h"
#import "CustomProgressView.h"
//#import "TVDataSingelton.h"

#define kCellHight 64

@implementation TVListCell

@synthesize currentShowLabel,nextShowLabel, channelNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        currentShowLabel = [[UILabel alloc]init];
        currentShowLabel.textAlignment = UITextAlignmentLeft;
        currentShowLabel.font = [UIFont boldSystemFontOfSize:14];
        currentShowLabel.textColor = [UIColor blackColor];        
        currentShowLabel.numberOfLines = 2;  
//        currentShowLabel.lineBreakMode = UILineBreakModeClip; //without...
        
        nextShowLabel = [[UILabel alloc]init];
        nextShowLabel.textAlignment = UITextAlignmentLeft;
        nextShowLabel.font = [UIFont systemFontOfSize:14];
        nextShowLabel.textColor = [UIColor blackColor];
        nextShowLabel.adjustsFontSizeToFitWidth = YES;
        nextShowLabel.minimumFontSize = 13;
         
        channelNameLabel = [[UILabel alloc]init];
        channelNameLabel.textAlignment = UITextAlignmentCenter; //Center
        channelNameLabel.font = [UIFont boldSystemFontOfSize:12];
        nextShowLabel.adjustsFontSizeToFitWidth = YES;
        nextShowLabel.minimumFontSize = 11;
        channelNameLabel.textColor = [UIColor blackColor];//[UIColor blackColor];
        currentShowLabel.lineBreakMode = UILineBreakModeClip; //without...
        
        CGRect frame = CGRectMake(138.0, 19.0, 88, 10);
        progressBar = [[CustomProgressView alloc] initWithFrame:frame];
        progressBar.progressViewStyle = UIProgressViewStyleDefault;
        progressBar.progress = 0.5;
        
        myImageView = [[UIImageView alloc] init];
        //myImageView.contentMode = UIViewContentModeScaleAspectFit;
        myImageView.contentMode = UIViewContentModeCenter;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x ,0, kCellHight, kCellHight)];
        view.backgroundColor = [SZUtils color09];
        
        [self.contentView addSubview:view];
        [self.contentView addSubview:progressBar];
        [self.contentView addSubview:currentShowLabel];
        [self.contentView addSubview:nextShowLabel];
        [self.contentView addSubview:myImageView];
        [self.contentView addSubview:channelNameLabel];
        self.contentView.backgroundColor = [SZUtils color07];
        currentShowLabel.backgroundColor = [UIColor clearColor];
        nextShowLabel.backgroundColor = [UIColor clearColor];
        channelNameLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setProgressBarVisible:(BOOL)isVisible
{
    [progressBar setHidden:!isVisible];
}


- (void)setIconImage:(UIImage*)icon
{
    myImageView.image = icon;
    iconH = icon.size.height;
    //NSLog(@"icon size w %f h %f", icon.size.width, iconH);
    if (iconH > kCellHight) {
        iconH = kCellHight;
    }
    
}

//-(void)setIcon:(NSString *)iconName
//{
////    UIImage* icon = [[TVDataSingelton sharedTVDataInstance] getIcon:iconName];
////    [self setIconImage:icon];
////    myImageView.image = icon;
////    iconH = icon.size.height;
////    //NSLog(@"icon size w %f h %f", icon.size.width, iconH);
////    if (iconH > kCellHight) {
////        iconH = kCellHight;
////    }
//}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat width = contentRect.size.width;
    CGRect frame;
/*
    frame= CGRectMake(boundsX + 16, 10, 45, 45);
    myImageView.frame = frame;
    
    frame= CGRectMake(boundsX + 95, 10, width - 110, 15);
    currentShowLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 92, 32, width - 104, 12);
    progressBar.frame = frame;
    
    frame= CGRectMake(boundsX + 95, 60, width - 110, 15);
    nextShowLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 8, 60, 64, 15);
    channelNameLabel.frame = frame;
*/   
    //    frame= CGRectMake(boundsX + 77, 27, width - 90, 12);
    frame= CGRectMake(boundsX + 72, 0, width - 85, contentRect.size.height-1);
    progressBar.frame = frame;
    
    
    frame= CGRectMake(boundsX + 10, 3, 45, 45);
    myImageView.frame = frame;
    
    frame= CGRectMake(boundsX + 75, 3, width - 87, 33);//15
    currentShowLabel.frame = frame;
    
    
    frame= CGRectMake(boundsX + 75, 42, width - 87, 15);
    nextShowLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 2, 49, 65, 15);
    channelNameLabel.frame = frame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setTimeFromBeginning:(float) min durationOfShow:(float)duration
{
    float value = min/duration;
    if(value < 0)
        value = 0;
    if(value > 1)
        value = 1;
    progressBar.progress = value;
}

@end
