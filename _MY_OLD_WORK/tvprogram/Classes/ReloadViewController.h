//
//  ReloadViewController.h
//  TVProgram
//
//  Created by khuala on 8/8/12.
//
//

#import <UIKit/UIKit.h>

@interface ReloadViewController : UIViewController

- (id)initWithTabBar;

- (IBAction)reloadAll:(UIButton *)button;
- (IBAction)reloadDay:(UIButton *)button;

@end
