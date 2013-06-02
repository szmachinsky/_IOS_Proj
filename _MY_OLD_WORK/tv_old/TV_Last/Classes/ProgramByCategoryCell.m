//
//  TVListCell.m
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgramByCategoryCell.h"
#import "TVDataSingelton.h"

#define kCellHight 60

@implementation ProgramByCategoryCell

@synthesize primaryLabel,secondaryLabel,/*myImageView,*/ thirdLabel, forthLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
            // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = UITextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:14];
        primaryLabel.textColor = [UIColor blackColor];
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.textAlignment = UITextAlignmentLeft;
        secondaryLabel.font = [UIFont systemFontOfSize:14];
        secondaryLabel.textColor = [UIColor blackColor];
        thirdLabel = [[UILabel alloc]init];
        thirdLabel.textAlignment = UITextAlignmentLeft; //Center
        thirdLabel.font = [UIFont boldSystemFontOfSize:11];//zs 12
        thirdLabel.textColor = [UIColor blackColor];

        forthLabel = [[UILabel alloc]init];
        forthLabel.textAlignment = UITextAlignmentCenter;
        forthLabel.font = [UIFont boldSystemFontOfSize:16];
        forthLabel.textColor = [UIColor blackColor];
        
        myImageView = [[UIImageView alloc]init];
        //myImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:myImageView];
        [self.contentView addSubview:thirdLabel];
        [self.contentView addSubview:forthLabel];        //self.contentView.backgroundColor = [UIColor redColor];
        primaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.backgroundColor = [UIColor clearColor];
        thirdLabel.backgroundColor = [UIColor clearColor];
        forthLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
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

-(void)setIcon:(NSString *)iconName
{
    UIImage* icon = [[TVDataSingelton sharedTVDataInstance] getIcon:iconName];
    myImageView.image = icon;
    iconH = icon.size.height;
    //NSLog(@"%f", iconH);
    if (iconH > kCellHight) {
        iconH = kCellHight;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat width = contentRect.size.width;
    CGRect frame;
//zs    frame = CGRectMake(boundsX ,0, 75, iconH);  
/*    
    frame = CGRectMake(boundsX +10 ,10, 45, 45);    
    myImageView.frame = frame;
    
    frame= CGRectMake(boundsX + 77, 10, width - 100, 30);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 77 ,45, width - 90, 30);
    secondaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX, 60, 75, 20);
    thirdLabel.frame = frame;
    
    frame= CGRectMake(width - 22, 10, 18, 30);
    forthLabel.frame = frame;
*/ 
    frame = CGRectMake(boundsX +5 ,3, 45, 45);    
    myImageView.frame = frame;
    
    frame= CGRectMake(boundsX + 77, 3, width - 100, 20);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 77 ,30, width - 90, 20);
    secondaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX+5, 46, 75, 20);
    thirdLabel.frame = frame;
    
    frame= CGRectMake(width - 22,3, 18, 20);
    forthLabel.frame = frame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
