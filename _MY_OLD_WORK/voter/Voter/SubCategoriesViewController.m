//
//  SubCategoriesViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubCategoriesViewController.h"

@interface SubCategoriesViewController()

- (void)getSubCategoriesDidSuccess:(id)object;
- (void)getSubCategoriesDidFail:(id)object;

@end

@implementation SubCategoriesViewController
@synthesize tableView = tableView_;
@synthesize customCell = custonCell_;
@synthesize subCategoriesDSArray = subCategoriesDSArray_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        subCategoryDic_ = [[NSMutableDictionary alloc]init];
        self.subCategoriesDSArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) dealloc
{
    [tableView_ release];
    [custonCell_ release];
    [subCategoriesDSArray_ release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"SubCategories";
    //self.navigationItem.hidesBackButton = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    [subCategoryDic_ setValue:userInfo.categoryID forKey:@"category_id"];
    [requestManager getSubcategories:subCategoryDic_ andDelegate:self doneSelector:@selector(getSubCategoriesDidSuccess:) failSelector:@selector(getSubCategoriesDidFail:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tableView = nil;
    self.customCell = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.subCategoriesDSArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";

    UICustomSubcategoriesCell* cell = nil;
    
    [[NSBundle mainBundle] loadNibNamed:@"UICustomSubcategoriesCell" owner:self options:nil];
    
    cell = (UICustomSubcategoriesCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UICustomSubcategoriesCell alloc]initWithReuseIdentifier:cellIdentifier]autorelease];
        cell = self.customCell;
        self.customCell = nil;
        
        for (UICustomSubcategoriesCell* iteratorCell in [cell subviews])
        {
            if ([iteratorCell isMemberOfClass:[UITableView class]])
            {
                [iteratorCell removeFromSuperview];
            }
        }
    }
    cell.checkButton.tag = 100 + indexPath.row;
    [[self.subCategoriesDSArray objectAtIndex:indexPath.row]setTag:cell.checkButton.tag];
    
    if ((BOOL)[[self.subCategoriesDSArray objectAtIndex:indexPath.row]isCheck])
    {
        cell.checkButton.backgroundColor = [UIColor redColor];
    }
    else
    {
        cell.checkButton.backgroundColor = [UIColor whiteColor];
    }
    
    cell.subCategoryLabel.text = (NSString*)[[self.subCategoriesDSArray objectAtIndex:indexPath.row] nameOfsubCategory];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UserInfo* userInfo = [UserInfo sharedInstance];
    [userInfo.subCategoryID removeAllObjects];
    for (SubCategories* oneCategory in self.subCategoriesDSArray)
    {
        if (oneCategory.isCheck)
        {
            [userInfo.subCategoryID addObject:oneCategory.idSubCategory];
        }
    }
    //userInfo.subCategoryID = (NSString*)[[self.subCategoriesDSArray objectAtIndex:indexPath.row]idSubCategory];
    
    VoteModeViewController* voteModeViewController = [[[VoteModeViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:voteModeViewController animated:YES];
}

#pragma mark - Action Methods

- (IBAction)check:(id)sender
{
    UIButton* button = (UIButton*)sender;
    
    NSInteger tag = button.tag;
    if ((BOOL)[[self.subCategoriesDSArray objectAtIndex:tag - 100]isCheck])
    {
        [[self.subCategoriesDSArray objectAtIndex:tag - 100]setIsCheck:NO];
    }
    else
    {
        [[self.subCategoriesDSArray objectAtIndex:tag - 100]setIsCheck:YES];
    }
    
    NSIndexPath* indexPath  = [NSIndexPath indexPathForRow:(tag - 100) inSection:0];
    NSArray* array = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView reloadRowsAtIndexPaths: array withRowAnimation:UITableViewRowAnimationNone];

    
}

#pragma mark - Private Methods

- (void)getSubCategoriesDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        [self.subCategoriesDSArray removeAllObjects];
        
        NSArray* array = (NSArray*)object;
        for (NSDictionary* oneSubCategory in array)
        {
            SubCategories* subCategory = [[SubCategories alloc]init];
            subCategory.nameOfsubCategory = [oneSubCategory objectForKey:@"name"];
            subCategory.idSubCategory = [oneSubCategory objectForKey:@"id"];
            subCategory.image = @"http://subcategory.jpg";
            
            [self.subCategoriesDSArray addObject:subCategory];
            [subCategory release];
        }
        [self.tableView reloadData];
    }
    else
    {
        
    }
}

- (void)getSubCategoriesDidFail:(id)object
{
    
}

@end
