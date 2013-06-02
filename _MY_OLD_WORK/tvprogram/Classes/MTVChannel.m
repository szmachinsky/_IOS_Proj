//
//  MTVChannel.m
//  TVProgram
//
//  Created by Admin on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTVChannel.h"
#import "MTVShow.h"


@implementation MTVChannel

@dynamic pCategories;
@dynamic pFavorite;
@dynamic pID;
@dynamic pImage;
@dynamic pLoaded;
@dynamic pLoadImage;
@dynamic pLoadShow;
@dynamic pLogoUrl;
@dynamic pLogoUrlLoaded;
@dynamic pName;
@dynamic pOrderValue;
@dynamic pProgramUrl;
@dynamic pProgramUrlLoaded;
@dynamic pSelected;
@dynamic pUpdated;
@dynamic tSectionIdentifier;
@dynamic rTVShow;



-(void)awakeFromFetch
{
    [super awakeFromFetch];
    //    _NSLog(@" load %@ obj",self.pName);
}
-(NSString*)tSectionIdentifier 
{
    NSString *str = [self.pName substringToIndex:1]; //self.pName;
    return str; 
}

-(UIImage*)icon
{
    UIImage *im = [UIImage imageWithData:self.pImage];
    return im;
}


@end
