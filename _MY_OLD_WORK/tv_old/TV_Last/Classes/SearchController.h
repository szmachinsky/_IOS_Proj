//
//  SearchController.h
//  TVProgram
//
//  Created by Irisha on 22.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaitView;

enum SearchType {
    channelNames = 0,
    programName = 1
    };

@interface SearchController : UITableViewController <UISearchBarDelegate> {
    UISearchBar *searchBar;
    
    NSMutableArray *listOfItems;
    NSMutableArray *copyListOfItems;
    NSMutableArray *listOfInfo;
    NSMutableArray *copyListOfInfo;
    NSMutableArray *copyIndexes;
    
    BOOL searching;
    BOOL letUserSelectRow;
    enum SearchType currentSelectType;
    NSString * currentDay;
    BOOL isForFavor;
    UIButton * channelButton;
    UIButton * timeButton;
    
    NSManagedObjectContext *context_;
    NSArray *tabData_;    
}
@property (strong, nonatomic) NSManagedObjectContext *context; //zs
@property (strong, nonatomic) NSArray *tabData; //zs
@property (strong, nonatomic) WaitView *waitView;  //zs 


-(void) setDate:(NSString *)day forFavor:(BOOL)isFavor;

@end
