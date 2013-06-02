//
//  AllVisasVC.h
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VisaCell.h"
#import <UIKit/UIKit.h>
#import "BannerManager.h"

@interface AllVisasVC : UITableViewController <VisaCellDelegate> {
    IBOutlet VisaCell *visaCell;
    
//    BOOL isBannerVisible;
//    ADBannerView *adBannerView;
}



@end
