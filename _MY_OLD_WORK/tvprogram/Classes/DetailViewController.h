//
//  DetailViewController.h
//  TVTestCore
//
//  Created by Admin on 17.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObject *detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (assign, nonatomic) id delegate; //zs

@end
