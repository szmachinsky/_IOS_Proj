//
//  SelectChannelsController.m
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SZChannelsConfigController.h"
#import "TVDataSingelton.h"
//#import "Channel.h"
//#import "SearchController.h"

#import "SZCoreManager.h"
#import "MTVChannel.h"
#import "MTVShow.h"
#import "CreateChannels.h"
#import "ModelHelper.h"

#import "DetailViewController.h"
#import "ShowViewController.h"

#import "SSVProgressHUD.h"

#define maxSelectedChn 0


@interface mUITableViewCell : UITableViewCell {
    
@private
//    weak id delegate_;
    NSIndexPath *indexPath_;
}

@property (nonatomic,weak) id delegate;  //zs retain
@property (nonatomic,retain) NSIndexPath *indexPath;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end



@interface SZChannelsConfigController ()

- (NSInteger)selectAllChannels:(BOOL)checked;
- (NSInteger)numberOfChannels;
- (NSArray*)arrOfSelChannels;
- (NSInteger)numberOfSelChannels;
- (NSInteger)numberOfSelChannels2; 
- (NSInteger)numberOfSelectedChannels;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setCell:(UITableViewCell *)cell checked:(BOOL)checked ;
- (void)saveContext;
- (void)doubleClick:(NSIndexPath *)indexPath;

- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;

@end


//@implementation UITableViewCell (doubleTouch) 
@implementation mUITableViewCell  
@synthesize delegate = delegate_;
@synthesize indexPath = indexPath_;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(((UITouch *)[touches anyObject]).tapCount == 2)
    {
        _NSLog(@"DOUBLE TOUCH DETECTED");
        SEL selDouble = @selector(doubleClick:);
        if ([self.delegate respondsToSelector:selDouble])
            [self.delegate performSelector:selDouble withObject:indexPath_ afterDelay:0.1];
    }
    [super touchesEnded:touches withEvent:event];
}
@end



@implementation SZChannelsConfigController
@synthesize delegate;
@synthesize mytableView;
@synthesize isChanged;

@synthesize fetchedResultsController = __fetchedResultsController;  //zs
@synthesize managedObjectContext = __managedObjectContext;          //zs



//------------------------------- pressOK -------------------------------------------------
-(void)pressOK:(id)sender 
{
///    static BOOL wasAlert = NO;
    
//    [self.navigationController popViewControllerAnimated:NO];
    
//    if ( [self.delegate respondsToSelector:@selector(selectedChannels:channels:)] ) { 
//      [self.delegate selectedChannels:isChanged channels:nil]; 
    
    
//    NSInteger ii = [self numberOfSelChannels]; 
//    if ( (ii == 0) && !wasAlert )   {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"для отображения данных должен быть выбран хотя бы один канал"
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
////        wasAlert = YES;
////        return;
//    }
    
    [self saveContext];
    NSInteger ii = [self numberOfSelChannels]; //numberOfSelectedChannels
    [SZAppInfo shared].colSelChannels = ii;
    if (isChanged)
    {
        NSArray *arr = [self arrOfSelChannels]; //save selected array!!!
//        NSArray *arr = [SZCoreManager arrayOfSelectedChannels:self.managedObjectContext];
///        [SZAppInfo shared].selChannels = arr;
        for (MTVChannel *ch in arr) {
//            _NSLog(@" add_sel_chn (%@)",ch.pName);
            [[TVDataSingelton sharedTVDataInstance] removeChannelNameFromSelected:ch.pName];
            [[TVDataSingelton sharedTVDataInstance] addChannelToSelected:ch.pName];
        }
        
    }
    
    
    if (isChanged) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChannelsHaveBeenSelected" object:self]];
        
//        [SVProgressHUD showWithStatus:@"обновление данных"];
        
        double delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){   
//          [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            [SSVProgressHUD showWithStatus:@"обновление данных" maskType:SVProgressHUDMaskTypeClear];
        });    
        
    }
    
//    [self.navigationController popViewControllerAnimated:NO];     
}

-(void)viewWillDisappear:(BOOL)animated //zs
{
    [super viewWillDisappear:animated];
    
    [self pressOK:nil];
}


//------------------------------- checkButtonPressed ---------------------------------------
- (void)checkButtonPressed 
{
//    [self saveContext];
//    [CreateChannels addRandomChannels];
//    return;
    
    
    isChanged = YES;
    isUnCheckButton = !isUnCheckButton;
    if (!isUnCheckButton) {
        [[TVDataSingelton sharedTVDataInstance] unSelectAllChannels];
        [self selectAllChannels:NO];
    }
    else {
        if (maxSelectedChn == 0)
            [[TVDataSingelton sharedTVDataInstance] selectAllChannels];
        [self selectAllChannels:YES];
    }
    UIImage *btnImage = isUnCheckButton ? [UIImage imageNamed:@"check_icon.png"] : [UIImage imageNamed:@"uncheck_icon.png"];
    [selectAllButton setImage:btnImage forState:UIControlStateNormal];
    [mytableView reloadData];
    
}

//------------------------------- contextUpdated -------------------------------------------------
- (void)reallyContextUpdated
{
    _NSLog(@" >>>>>>> reallyContext was changed outside!!! - new Fetch");
    self.managedObjectContext = nil; //delete context
    self.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext]; //new context
    
    [NSFetchedResultsController deleteCacheWithName:nil]; //clear cache (if used) 
    self.fetchedResultsController = nil; //delete fecthed
    
    [mytableView reloadData]; //reload data - creafe new fetched controller!
    
    //    int i1 = [self numberOfChannels];
    //    int i2 = [self numberOfSelChannels];
//zs    [self numberOfSelChannels2];
    //    int i3 = [self numberOfSelectedChannels];    
}

- (void)contextUpdated 
{    
    _NSLog(@" >>>> contextUpdated!");
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyContextUpdated) object:nil];
    [self performSelector:@selector(reallyContextUpdated) withObject:nil afterDelay:1.0];    
}

//-------------------------------- init ------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextUpdated) name:@"ContextUpdateCompleted" object:nil];  
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];    
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.managedObjectContext = nil;
    [NSFetchedResultsController deleteCacheWithName:nil];
    self.fetchedResultsController = nil;
    self.delegate = nil;
}

//--------------------------------- loadView -----------------------------------------------
- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
///    self.tableView = myView; //zs!!!
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.view.autoresizesSubviews = YES;
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(15, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(pressOK:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
//    self.navigationItem.title = @"Список каналов";
    self.navigationItem.title = @"Каналы";
    
    //select all
    int i1 = [self numberOfChannels];
//    int i2 = [self numberOfSelChannels];
//    int i22 = [self numberOfSelChannels2];
    int i3 = [self numberOfSelectedChannels];
    
    int chNum = i1;//[[TVDataSingelton sharedTVDataInstance] getNumberOfChannels]; //zs
    int chSelNum = i3;//[[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels]; //zs
    isUnCheckButton = (chNum == chSelNum);
    selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(136, 8, 49, 29);
//    [selectAllButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [selectAllButton setBackgroundImage:[UIImage imageNamed:@"button_on.png"] forState:UIControlStateSelected];
    UIImage *btnImage = isUnCheckButton ? [UIImage imageNamed:@"check_icon.png"] : [UIImage imageNamed:@"uncheck_icon.png"];
    [selectAllButton setImage:btnImage forState:UIControlStateNormal];
    [selectAllButton addTarget:self action:@selector(checkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectAllButton];
    
    // title label
//    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
//    text.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    text.text = @"Выберите каналы из списка:";
//    text.textAlignment = UITextAlignmentCenter;
//    text.backgroundColor = [SZUtils color02];
//    [self.view addSubview:text];

//    // ----iAd banner view-----
//    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];    
//    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
//    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
//    bannerView.delegate = self;
//    [self.view addSubview:bannerView];
//    tableView_ = mytableView;
    
    
    // table view
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
//    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [SZUtils color02];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 44);
    
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;  
    bannerHight = 0;
//    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    mytableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    mytableView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    mytableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
 
    
//    self.tableView = mytableView;    
    [self.view addSubview:mytableView];
    
        
#ifdef WillShowWpBanner
    _NSLog(@"add wp_banner_3");
    viewForWpBanner = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f+376, CGRectGetWidth(self.view.frame), 60.0f)];
    viewForWpBanner.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewForWpBanner];
    [self.view sendSubviewToBack:viewForWpBanner];       
    viewForWpBanner.hidden = YES;
    
    wpBannerView = [SZBannerManager wpBannerToView:viewForWpBanner];
    wpBannerView.delegate = self;
    [wpBannerView reloadBanner];
    [wpBannerView showFromBottom:YES];
#endif
    
#ifdef WillShowAdBanner    
    _NSLog(@"add ad_banner_3");  
    // ----iAd banner view-----
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f+386, CGRectGetWidth(self.view.frame), 50.0f)];    
    bannerView.requiredContentSizeIdentifiers =[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];  
    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;    
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    adViewVisible = NO;
    [self.view sendSubviewToBack:bannerView];
#endif
  
    
//    self.tableView = mytableView; //zs   
//    [self.view addSubview:mytableView];
    
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,35,320,44)];
    searchBar.delegate = self;
    searchBar.tintColor =  [SZUtils color08];
    searching = NO;
    letUserSelectRow = YES;
//    searchBar.keyboardType = UIKeyboardTypeAlphabet;
    ///    searchBar.showsCancelButton = YES;
    mytableView.tableHeaderView = searchBar; 
    
    tableViewFrame = mytableView.frame;
    
//    CGRect fr = self.view.frame;    
//    _NSLog0(@" init frame1: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = mytableView.superview.frame;  
//    _NSLog0(@" init frame2: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = mytableView.frame;  
//    _NSLog0(@" init frame3: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = searchBar.frame;
//    _NSLog0(@" search frame4: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       // Uncomment the following line to preserve selection between presentations.
//         self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
//        self.tableView.allowsSelection = NO;
        //    self.tableView.
    
//    if (self.navigationItem.title == nil)
//        self.navigationItem.title = @"Каналы";  //zs 

    self.managedObjectContext = nil; //delete context
    self.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext]; //new context
    
    [NSFetchedResultsController deleteCacheWithName:nil]; //clear cache (if used) 
    self.fetchedResultsController = nil; //delete fecthed    
    
    [mytableView reloadData];
}

//-(void)viewWillDisappear:(BOOL)animated //zs
//{
//    [super viewWillDisappear:animated];
//
////    [self saveContext]; //the only place to SAVE!!!
//    
////    if (isChanged) {
////        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ChannelsHaveBeenSelected" object:self]];
////    }    
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


//-------------------------------------------------------------------------
#pragma mark actions
- (NSInteger)selectAllChannels:(BOOL)checked 
{
    NSInteger sec = 0, cn = 0;
    isChanged = YES;
    
//    if (checked == NO) {
//        NSSet *items = [self.managedObjectContext registeredObjects];
//        NSInteger s0 = [items count];
//        NSInteger sc=0;
//        for (MTVChannel *managedObject in items) {
//            managedObject.pSelected = NO;
//            managedObject.pOrderValue = 0.0;
//            managedObject.pFavorite = NO;
//            sc++;
//          }
//        _NSLog0(@" !> deselect1 obj=%d from %d",sc,s0);
// //       return sc;
//    }
    
   if (checked == NO) {
       NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];
       NSError *error;
       NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//       NSInteger s0 = [items count];
       NSInteger sc=0;
       for (MTVChannel *managedObject in items) {
           managedObject.pSelected = NO;
           managedObject.pOrderValue = 0.0;
           managedObject.pFavorite = NO;
           sc++;
       }
//       _NSLog(@" !> deselect2 obj=%d from %d",sc,s0);
       return sc;
   }
    
        
    NSInteger scMax = maxSelectedChn;
    for (id <NSFetchedResultsSectionInfo> secInfo in [self.fetchedResultsController sections]) {
        //      res = res + [secInfo numberOfObjects];        
        sec++;
//        _NSLog(@"-Section:%d  (%@)",sec,secInfo.name);
        for (MTVChannel *obj in [secInfo objects]) {
//          _NSLog(@"-got->(%@)",obj.pName);
            obj.pSelected = checked;
            ////if (obj.pOrderValue == 0)
            if (checked == YES) {
                obj.pOrderValue = 100000.0;
            } else {
                obj.pOrderValue = 0.0;                
            }
            if (checked == NO)
                obj.pFavorite = NO;
            cn++;
                 
            if ((scMax > 0)&&(cn>=scMax))
                return cn;
        }
        
    }
    _NSLog(@" All sec:%d  selected chanels:%d",sec,cn);
    return cn;
}

//-------------------------------------------------------------------------
#pragma mark Stat info
- (NSInteger)numberOfChannels 
{
    NSInteger res = 0;
    for (id <NSFetchedResultsSectionInfo> secInfo in [self.fetchedResultsController sections]) {
        res = res + [secInfo numberOfObjects];
    }
//    _NSLog(@" !> all objects=%d",res);       
    return res;
}

- (NSInteger)numberOfSelChannels 
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSInteger sc=0, scc = 0;
    for (MTVChannel *managedObject in items) {
        if (managedObject.pSelected)
            sc++;
        scc++;
    }
//    _NSLog(@" !> all1 obj=%d / sel=%d",scc,sc);        
    return sc;
}

- (NSInteger)numberOfSelChannels2 
{
    NSSet *items = [self.managedObjectContext registeredObjects];
//    int s0 = [items count];
    NSInteger sc=0, scc = 0;
    for (MTVChannel *managedObject in items) {
        if (managedObject.pSelected)
            sc++;
        scc++;
    }
//    _NSLog(@" !> all2 obj=%d  %d / sel=%d",s0,scc,sc);        
    return sc;
}

- (NSArray*)arrOfSelChannels 
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];
    
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"pName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,nil]];    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == YES", @"pSelected"];
    [fetchRequest setPredicate:pred];     
    NSError *error;
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _NSLog(@" !>exit: arr of selected = %d",[items count]);        
    return items;
}


- (NSInteger)numberOfSelectedChannels 
{
    NSInteger sc=0;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSError *error;    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K == YES", @"pSelected"];
//  NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"pSelected == YES"];
//  NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; //is always TRUE
    [fetchRequest setPredicate:pred1]; 
    
    NSUInteger count1 = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    sc = count1;
//    _NSLog(@" !> selected objects = %d",sc);        
    return sc;
}

#pragma mark - Table view data source
//-------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger res = [[self.fetchedResultsController sections] count];
    return res;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger res = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return res;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
{ 
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (id <NSFetchedResultsSectionInfo> inf in [self.fetchedResultsController sections]) {
        [res addObject:inf.name];
//        [res addObject:@"12"];
    }
//    _NSLog(@"res=(%@)",res);    
    return nil;//res;
}

//----------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 22.0f)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    back.frame = headerView.frame;
    back.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:back];
    
    UILabel *charLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 0.0f, CGRectGetWidth(self.view.frame) - 30.0f, 22.0f)];
    charLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    charLabel.backgroundColor = [UIColor clearColor];
    charLabel.textColor = [UIColor whiteColor];
    charLabel.shadowColor = [UIColor blackColor];
//zscharLabel.text = arrayOfCharacters.count ? [arrayOfCharacters objectAtIndex:section] : @"";
    charLabel.text = [[[self.fetchedResultsController sections] objectAtIndex:section] name] ;
    [headerView addSubview:charLabel];
    
    return headerView;
}


//----------------------------------- cellForRow ---------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[mUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
///        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton; //zs - for debug!
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //no selected!
    }
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];    //zs  
    return cell;
}



//-----------------Show details--------------------------------------
#pragma mark - show details
- (NSArray*)requestForEntity_1:(NSString*)entity Context:(NSManagedObjectContext*)_context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];    
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSError *err=nil;
    NSArray *res = [_context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
    //    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:res];
    _NSLog(@" request for entity:(%@) =%d",entity,[res count]);
    return res;
}

- (NSArray*)requestForEntity_2:(NSString*)entity Context:(NSManagedObjectContext*)_context iD:(NSInteger)idd
                       dateMin:(NSDate*)minD dateMax:(NSDate*)maxD;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];
    
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
        
    NSPredicate *pred;
    if ((minD) && (maxD))
//        pred = [NSPredicate predicateWithFormat:@"(%K == %d)&&(%K >= %@)&&(%K <= %@)", @"pId",idd, 
//                @"pStart",minD, @"pStop",maxD];
        pred = [NSPredicate predicateWithFormat:@"(%K == %d)&&(%K > %@)&&(%K < %@)", @"pId",idd, 
            @"pStop",minD, @"pStart",maxD];
    if ((minD) && (!maxD))
        pred = [NSPredicate predicateWithFormat:@"(%K == %d)&&(%K >= %@)", @"pId",idd, 
                @"pStart",minD];
    if ((!minD) && (!maxD))
        pred = [NSPredicate predicateWithFormat:@"(%K == %d)", @"pId",idd];
    
    [request setPredicate:pred];     
    
    NSError *err=nil;
    NSArray *res = [_context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
    //    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:res];
    _NSLog(@" request for entity:(%@) =%d",entity,[res count]);    
    NSArray* res2 = [res sortedArrayUsingComparator: ^(id obj1, id obj2) { 
        NSDate *d1 = ((MTVShow*)obj1).pStart;
        NSDate *d2 = ((MTVShow*)obj2).pStart;
        return [d1 compare:d2];
    }];    
    //    _NSLog(@" request for entity:(%@) =%d",entity,[res2 count]);    
    return res2;
}

-(void)listOfShow:(NSIndexPath *)indexPath
{
    ShowViewController *showViewController = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
    
    MTVChannel *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
//    NSSet *set = selectedObject.rTVShow;
//    NSArray *arr0 = [set allObjects];
//    NSArray* arr1 = [arr0 sortedArrayUsingComparator: ^(id obj1, id obj2) { 
//        NSDate *d1 = ((MTVShow*)obj1).pStart;
//        NSDate *d2 = ((MTVShow*)obj2).pStart;
//        return [d1 compare:d2];
//    }];    
    
    NSInteger idd = selectedObject.pID;
    
//    NSString *strr = [[ModelHelper shared] dayFromDate:nil];    
    NSDate *dat0 = [[ModelHelper shared] dateBeginDaysFromNow:0];
//    NSDate *dat1 = [[ModelHelper shared] dateBeginDaysFromNow:-1];
    NSDate *dat2 = [[ModelHelper shared] dateBeginDaysFromNow:1];
//    NSString *str0 = [[ModelHelper shared] dayFromDate:dat0];
//    NSString *str1 = [[ModelHelper shared] dayFromDate:dat1];
//    NSString *str2 = [[ModelHelper shared] dayFromDate:dat2];
    
//    _NSLog(@"%@  %@",strr,dat1);
    
    NSArray *arr2 = [self requestForEntity_2:@"MTVShow" Context:self.managedObjectContext iD:idd dateMin:dat0 dateMax:dat2];  
        
//   NSArray *arr2 = [self requestForEntity_2:@"MTVShow" Context:self.managedObjectContext iD:idd dateMin:[NSDate           dateWithTimeIntervalSinceNow:-7200] dateMax:nil];
//   NSArray *arr2 = [self requestForEntity_2:@"MTVShow" Context:self.managedObjectContext iD:idd dateMin:nil dateMax:nil];
    
//   NSArray *arr3 = [self requestForEntity_1:@"MTVShow" Context:self.managedObjectContext];
    
    showViewController.listShow = arr2;    
    [self.navigationController pushViewController:showViewController animated:YES];   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
    [self listOfShow:indexPath];
    return;
}

-(void)doubleClick:(NSIndexPath *)indexPath
{
    [self listOfShow:indexPath];
    return;    
}

//-------------------------------------didSelectRowAtIndexPath------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
//    [self tableView:tableView didSelectRowAtIndexPath_2:indexPath];
//    return;
    
    MTVChannel *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];  //zs  
    BOOL wasSelected = managedObject.pSelected;
    BOOL isSelected = !wasSelected;
//zsBOOL isSelected = [[TVDataSingelton sharedTVDataInstance] isChannelSelected:channelName];
    if (!isSelected) {
//zs        [[TVDataSingelton sharedTVDataInstance] removeChannelNameFromSelected:channelName];
//zs        [[TVDataSingelton sharedTVDataInstance] removeChannelFromFavor:channelName];
    }
    else {
//zs        [[TVDataSingelton sharedTVDataInstance] addChannelToSelected:channelName];
    }
    isChanged = YES;
    managedObject.pSelected = isSelected; 
    if (isSelected == NO)
        managedObject.pFavorite = NO;
    
    if (isSelected) {
        //if (managedObject.pOrderValue == 0)
        managedObject.pOrderValue = 100000;
    } else {
        managedObject.pOrderValue = 0;
    }
    
    [tableView reloadData];

//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setSelected:NO animated:NO];
//    [self setCell:cell checked:selected];
    
///    [self tableView:tableView didSelectRowAtIndexPath_2:indexPath]; //show details    
}
//-------------------------------------------------------------------------


#pragma mark - create Fetched results controller
//==================================================================================
- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    self.fetchedResultsController = [SZCoreManager ftResultsController:self ManagedObj:self.managedObjectContext 
                                                                Entity:@"MTVChannel"  
                                                               SortKey:@"pName" 
                                                    SectionNameKeyPath:@"tSectionIdentifier" 
                                                             CacheName:nil //@"ChannelsConfig" 
                                                          SearchString:searchString 
                                                             Ascending:YES];
    return __fetchedResultsController;
}    

#pragma mark -  Fetched's delegate methods
//==================================================================================
/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
*/

 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}

//==================================================================================
#pragma mark -
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{

    MTVChannel *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];        
    cell.textLabel.text = managedObject.pName;//channelName;    

//  if (managedObject.pLoaded && (managedObject.pImage != nil)) 
    if (managedObject.pImage != nil) 
    {        
        UIImage *im = [UIImage imageWithData:(NSData*)managedObject.pImage];
        UIImage *i = [SZUtils thumbnailFromImage:im forSize:37 Radius:5.0];
//        CGRect fr = cell.imageView.frame;
//        fr.size.width = 41;
//        fr.size.height = 41;
//        cell.imageView.frame = fr;
//        cell.imageView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth; //UIViewContentModeCenter,
//        cell.imageView.contentMode = UIViewContentModeCenter;
        
//      cell.imageView.backgroundColor = [UIColor whiteColor];
        cell.imageView.image = i;
        if (managedObject.pFavorite) {
            cell.imageView.alpha = 1.0; 
//            cell.imageView.backgroundColor = [UIColor greenColor];
        } else {
            cell.imageView.alpha = 1.0;
//            cell.imageView.backgroundColor = [UIColor clearColor];
       }
///     managedObject.pSelected = YES;
    } else {
        cell.imageView.image = nil;
    }
    cell.tag = indexPath.row;
    ((mUITableViewCell*)cell).delegate = self;
    ((mUITableViewCell*)cell).indexPath = indexPath;
    
    [self setCell:cell checked:managedObject.pSelected]; 
}

- (void)setCell:(UITableViewCell *)cell checked:(BOOL)checked 
{
    if (checked) {        
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_g.png"]];        
    } else {
        cell.accessoryView = nil;      
    }
}

-(void)saveContext 
{
//  [[SZAppInfo shared].coreManager saveContextWith:self.managedObjectContext];
    [SZCoreManager saveForContext:self.managedObjectContext];
}


//==============================================================================
#pragma mark
#pragma mark AdBannerView delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
	if (!adViewVisible) {
//        CGRect newFrame = CGRectMake(0, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(mytableView.frame), 
//                                     mytableView.frame.size.height - bannerView.frame.size.height);
        CGRect newFrame = CGRectMake(0, 0, CGRectGetWidth(mytableView.frame), 
                                        mytableView.frame.size.height - bannerView.frame.size.height);
        bannerHight = 50;
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:1.0]; //zs
        [self.view bringSubviewToFront:bannerView];
//        tableView_.frame = CGRectMake(0.0f, CGRectGetMaxY(bannerView.frame), CGRectGetWidth(tableView_.frame), CGRectGetMinY(timeScrolling.frame) - CGRectGetMaxY(bannerView.frame));
        mytableView.frame = newFrame;        
        tableViewFrame = newFrame;
        [UIView commitAnimations];
		adViewVisible = TRUE;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //iAds failed
	NSLog(@"%@",[error localizedDescription]);
	if (adViewVisible) {
        CGRect newFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(mytableView.frame), mytableView.frame.size.height + bannerView.frame.size.height);
        bannerHight = 0;
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [self.view sendSubviewToBack:bannerView];
//        tableView_.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView_.frame), CGRectGetMinY(timeScrolling.frame));
        mytableView.frame = newFrame;
//        self.tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(mytableView.frame), self.tableView.frame.size.height + bannerView.frame.size.height);
        tableViewFrame = newFrame;
        [UIView commitAnimations];
		adViewVisible = FALSE;
    }
}


//==========================wP_Banner====================================================
//- (void) bannerViewPressed:(WPBannerView *)bannerView_
//{    
//    if (bannerView_.bannerInfo.responseType == WPBannerResponseWebSite) {
//        NSURL *url = [NSURL URLWithString:bannerView_.bannerInfo.link];
//        if (url)
//            [[UIApplication sharedApplication] openURL:url];
//    }
//    ///zs    [bannerView_ reloadBanner];    
//}

- (void) bannerViewInfoLoaded:(WPBannerView *)bannerView_
{
    _NSLog(@"loaded Wp_Banner_4_Info"); 
	if (!wpViewVisible) {
        [UIView beginAnimations:@"animateWpBannerOn" context:NULL];
        [UIView setAnimationDuration:0.5]; //zs
        viewForWpBanner.hidden = NO;        
//        [self.view bringSubviewToFront:viewForWpBanner];
        
//        mytableView.frame = CGRectMake(0, CGRectGetMaxY(viewForWpBanner.frame), 
//                                       CGRectGetWidth(mytableView.frame),  mytableView.frame.size.height - viewForWpBanner.frame.size.height);
        mytableView.frame = CGRectMake(0, 0, 
                                       CGRectGetWidth(mytableView.frame),  mytableView.frame.size.height - viewForWpBanner.frame.size.height);
        bannerHight = 60;
        [UIView commitAnimations];
		wpViewVisible = TRUE;
	}
    
}


//------------------------------------------------------------------------------
#pragma mark - Search Bar delegate

- (void)renameCancellButtonInBar:(UISearchBar *)theSearchBar newTitle:(NSString*)newTitle
{
    [theSearchBar setShowsCancelButton:YES animated:YES];
    for(UIView *view in [theSearchBar subviews]) 
    {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) 
        {
            NSString *title = ((UIBarItem*)view).title;
            if ([title isEqualToString:@"Cancel"])
                [(UIBarItem *)view setTitle:newTitle];
        }
    }       
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGSize kbSize;
    int kbHight;

    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (kbSize.height < kbSize.width) {
        kbHight = kbSize.height; }
    else kbHight = kbSize.width;
        
    CGRect newFrame = tableViewFrame;
    newFrame.size.height = newFrame.size.height - kbHight + bannerHight;
    mytableView.frame = newFrame;
//    _NSLog0(@"+++keyb");
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{    
    mytableView.frame = tableViewFrame;
//    _NSLog0(@"---keyb");
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{
    searching = YES;
//    copyListOfItems = [NSMutableArray arrayWithArray:listOfItems];
    letUserSelectRow = YES;
    
    [theSearchBar setShowsCancelButton:YES animated:YES];
    [self renameCancellButtonInBar:theSearchBar newTitle:@"Готово"];  
    
    
    for (UIView *searchBarSubview in [theSearchBar subviews]) {        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {            
            @try {                
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
 //             [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e) {                
                // ignore exception
            }
        }
    }  
    
//    CGFloat height = (mytableView.frame.size.height/2);
//    CGFloat width = mytableView.frame.size.width;    
//    CGRect halfFrame = CGRectMake(0, 0, width, height);
//    mytableView.frame = halfFrame;
    
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{
//    _NSLog0(@"enter:%@",searchText);
    [NSFetchedResultsController deleteCacheWithName:nil]; //clear cache (if used) 
    self.fetchedResultsController = nil; //delete fecthed
    searchString = searchText;  
    [mytableView reloadData]; //reload data - creafe new fetched controller!
//    _NSLog0(@"new fetch");
    
    isUnCheckButton = NO;
    UIImage *btnImage = isUnCheckButton ? [UIImage imageNamed:@"check_icon.png"] : [UIImage imageNamed:@"uncheck_icon.png"];
    [selectAllButton setImage:btnImage forState:UIControlStateNormal];    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
    if ([theSearchBar.text length] == 0) {
        [theSearchBar setShowsCancelButton:NO animated:YES];
        [theSearchBar resignFirstResponder];
        
        theSearchBar.text = @"";
        letUserSelectRow = YES;
        searching = NO;
        searchString = nil;
//        self.tableView.scrollEnabled = YES;        
        [self.tableView reloadData];
        //        [self reloadData];
    } else {
        [theSearchBar resignFirstResponder];        
        [theSearchBar setShowsCancelButton:NO animated:YES];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{
//    CGRect fr = self.view.frame;
//    _NSLog0(@" search frame1: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = mytableView.superview.frame;  
//    _NSLog0(@" search frame2: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = mytableView.frame;  
//    _NSLog0(@" search frame3: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
//    fr = searchBar.frame;
//    _NSLog0(@" search frame4: (%f %f) (%f %f)",fr.origin.x, fr.origin.y, fr.size.width, fr.size.height);
    [self searchBarCancelButtonClicked:theSearchBar];
}


@end
