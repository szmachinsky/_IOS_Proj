//
//  BrowseViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController()

- (void)getCategoriesDidSuccess:(id)object;
- (void)getCategoriesDidFail:(id)object;

@end

@implementation BrowseViewController
@synthesize tableView = tableView_;
@synthesize customCell = customCell_;
@synthesize categoriesDSArray = categoriesDSArray_;
@synthesize waitScreen = waitScreen_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.categoriesDSArray = [[NSMutableArray alloc]init];
        
    }
    return self;
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
    self.waitScreen = [[WaitScreenView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    NSMutableDictionary* dic = nil;
    [self.waitScreen showWaitScreen];
    [requestManager getCategories:dic andDelegate:self doneSelector:@selector(getCategoriesDidSuccess:) failSelector:@selector(getCategoriesDidFail:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.customCell = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesDSArray count];
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UICustomCategoriesCell* cell = nil;
    
    [[NSBundle mainBundle] loadNibNamed:@"UICustomCategoriesCell" owner:self options:nil];
    
    cell = (UICustomCategoriesCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UICustomCategoriesCell alloc]initWithReuseIdentifier:cellIdentifier]autorelease];
        cell = self.customCell;
        self.customCell = nil;
        
        for (UICustomCategoriesCell* iteratorCell in [cell subviews]) 
        {
            if ([iteratorCell isMemberOfClass:[UITableViewCell class]])
                [iteratorCell removeFromSuperview];
        }
    }

    cell.categoryLabel.text = (NSString*)[[self.categoriesDSArray objectAtIndex:indexPath.row]nameOfCategory];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfo* userInfo = [UserInfo sharedInstance];
    userInfo.categoryID = (NSString*)[[self.categoriesDSArray objectAtIndex:indexPath.row] idCategory];
    
    SubCategoriesViewController* subCategoriesViewController = [[[SubCategoriesViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:subCategoriesViewController animated:YES];
}

#pragma mark - Private Method

- (void)getCategoriesDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        [self.categoriesDSArray removeAllObjects];
        NSArray* array = (NSArray*)object;
        for (NSDictionary* oneCategory in array)
        {
            Categories* category = [[Categories alloc]init];
            category.image = @"http://photo.jpg";
            category.idCategory = [oneCategory objectForKey:@"id"];
            category.nameOfCategory = [oneCategory objectForKey:@"name"];
            
            [self.categoriesDSArray addObject:category];
            [category release];
        }
        
        [self.tableView reloadData];
        [self.waitScreen hideWaitScreen];
    }
    else
    {
        
    }
}

- (void)getCategoriesDidFail:(id)object
{
    //NSLog(@"%@", object);
    [self.waitScreen hideWaitScreen];
}

#pragma mark - dealloc

-(void) dealloc
{
    [tableView_ release];
    [customCell_ release];
    [categoriesDSArray_ release];
    [waitScreen_ release];
    
    [super dealloc];
}

@end
