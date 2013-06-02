//
//  ProgramsCategoryTableController.h
//  TVProgram
//
//  Created by User1 on 26.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramSelectionDelegate.h"

@class WaitView;

//@class Show;
//@class MTVShow;
//@protocol ProgramSelectionDelegate <NSObject>
//@required
////- (void) programIsSelected:(Show *)show;
//- (void) programIsSelectedMTV:(MTVShow*)show;
//@end


@interface ProgramsCategoryTableController : UITableViewController <UISearchBarDelegate> 
{
    UISearchBar *searchBar;
//    BOOL isSortByChannel;
    UITableView *mytableView;
    BOOL searching;
    BOOL letUserSelectRow;

    NSString * currentDate_;
    
    NSArray *programs;    
    NSArray *listOfItems;
    NSMutableArray *copyListOfItems;
    
    NSArray *programs_;    
    NSArray *listOfItems_;
    NSMutableArray *copyListOfItems_;
    
    NSManagedObjectContext *context_;
//    NSArray *selArrays_;
    NSArray *tabData_; 
    BOOL sortByChannel_; 
    NSInteger catID_;
}
@property (assign) id <ProgramSelectionDelegate> selectionDelegate;
@property (nonatomic,strong) NSString * currentDate;
@property (strong, nonatomic) NSManagedObjectContext *context; //zs
//@property (strong, nonatomic) NSArray *selArrays; //zs 
@property (strong, nonatomic) NSArray *tabData; //zs
@property (assign, nonatomic) NSInteger catID; //zs
@property (strong, nonatomic) WaitView *waitView;  //zs 

@property (nonatomic,assign) BOOL searching;



//-(void) setData:(NSMutableArray*)data;
-(void) sortChannelsByChannel:(BOOL)isByChannel;
-(void) update;


@end
