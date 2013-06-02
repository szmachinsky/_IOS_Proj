//
//  HomeViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestsManager.h"
#import "VoterServerError.h"
#import "UserInfo.h"

@interface HomeViewController : UIViewController
{
@private
    
    IBOutlet UIButton* start_;

}

-(IBAction)start:(id)sender;

- (IBAction)testPress:(id)sender;
@end
