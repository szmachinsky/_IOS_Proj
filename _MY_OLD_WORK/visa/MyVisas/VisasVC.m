//
//  ViewController.m
//  MyVisas
//
//  Created by Nnn on 18.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AllVisasVC.h"
#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "DatePicker.h"
#import "FlurryAnalytics.h"
#import "FullVersionDescriptionVC.h"
#import "InAppPurchaseManager.h"
#import "KeyboardView.h"
#import "RoundRectLabel.h"
#import "SettingsVC.h"
#import "Utils.h"
#import "VisaPageView.h"
#import "VisasVC.h"
#include "WPBannerInfo.h"


@interface VisasVC()

@property (nonatomic, assign) NSInteger currPageNum;

@property (nonatomic, retain) NSArray *countryList;
@property (nonatomic, retain) NSMutableArray *filteredList;
@property (nonatomic, retain) NSMutableArray *searchedList;
@property (nonatomic, retain) NSDictionary *selectedCountry;

@property (nonatomic, retain) UITableView *countriesTableView;

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) DatePicker *picker;
@property (nonatomic, retain) KeyboardView *keyboard;
@end


@implementation VisasVC
@synthesize currPageNum, countryList, filteredList, searchedList, selectedCountry;
@synthesize countriesTableView, searchBar, picker, keyboard;
@synthesize locationButton, searchButton;

static const CGFloat pageWidth = 320.0f;
static const int pagesOffsetNum = 1;
static const int errorAlertTag = NSIntegerMax;
static const int buyVersionAlertTag = 16;

- (void)dealloc {
    [pagesView release];
    [pageLabel release];
    
    [leftButton release];
    [topBarView release];
    [countryLabel release];
    [countryField release];
    [rightButton release];
    [editLabel release];
    [noVisasLabel release];
    [adBannerView release];
    
    self.countryList = nil;
    self.filteredList = nil;
    self.searchedList = nil;
    self.selectedCountry = nil;
    
    self.countriesTableView = nil;
    self.searchBar = nil;
    self.picker = nil;
    self.keyboard = nil;
    
    self.locationButton = nil;
    self.searchButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)removeBanner
{
//    if ([[[[NSLocale currentLocale] localeIdentifier] substringToIndex:2] isEqualToString:@"en"])
//    {
//        [adBannerView removeFromSuperview];
//    }
//    else
//    {
//        //[wpBannerView removeFromSuperview];
//        [[AppData sharedAppData].bannerManager.wpBannerView2 removeFromSuperview];
//    }
}

- (void)changeLocationIcon {
    NSString *imageName = [AppData sharedAppData].isLocationOn ? @"button_add_on.png" : @"button_add.png";
    [locationButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

- (VisaPageView *)currentPage {
    return (VisaPageView *)[pagesView viewWithTag:currPageNum + pagesOffsetNum];
}

- (void)setCurrPageNum:(NSInteger)pageNum {
    currPageNum = pageNum;
}

- (void)scrollToPageWithNum:(NSInteger)pageNum {
    CGFloat xOffset = pageWidth*pageNum;
    [pagesView setContentOffset:CGPointMake(xOffset, 0.0f) animated:YES];
}

- (void)configurePages {
    int i = 0;
    NSMutableArray *visas = [AppData sharedAppData].visas;
    NSSortDescriptor *descr = [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO];
    [visas sortUsingDescriptors:[NSArray arrayWithObject:descr]];
    
    [pagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSMutableDictionary *visa in visas) {
        // create page for each visa
        VisaPageView *pageView = [[[VisaPageView alloc] initWithFrame:CGRectMake(i*pageWidth + 0.0f, 0.0f, pageWidth, 305.0f) data:visa target:self] autorelease];
        pageView.tag = i + pagesOffsetNum;
        pageView.controller = self;
        [pagesView addSubview:pageView];
        i++;
    }
    [pagesView setContentSize:CGSizeMake(pageWidth*visas.count, pagesView.contentSize.height)];
    searchButton.hidden = locationButton.hidden = (visas.count == 0);
    noVisasLabel.hidden = !(visas.count == 0);
}

- (void)resortPages {
    NSMutableDictionary *currVisa = [[AppData sharedAppData].visas objectAtIndex:currPageNum];
    [self configurePages];
    [self scrollToVisa:currVisa];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // configure scrool view
    pagesView.bounces = NO;
    pagesView.showsHorizontalScrollIndicator = NO;
    pagesView.showsVerticalScrollIndicator = NO;
    pagesView.pagingEnabled = YES;
    
    [self configurePages];
    pagesView.delegate = self;
    self.currPageNum = 0;
    
    [AppData sharedAppData].shopManager = [[ShopManager alloc] init];
    [AppData sharedAppData].bannerManager = [[BannerManager alloc] init];

    // add iAd banner
    //BOOL isbannerRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"bannerRemoved"];
    //if (!isbannerRemoved) {
    //NSLog(@"localeIdentifier: %@", [[NSLocale currentLocale] localeIdentifier]);
    
    
    if (![[AppData sharedAppData].shopManager isBannerRemoved] && ![[AppData sharedAppData].shopManager isUserLucky])
    {
        if ([BannerManager isEnglishLocale])
        {
            [[AppData sharedAppData].bannerManager addAdBannerToView:self.view markedByNumber:2];
        }
        else
        {
            [[AppData sharedAppData].bannerManager addWPBannerToView:self.view markedByNumber:2];
        }
    }
    
//    BOOL notFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstStart"];
//    if (!notFirstStart)
//    {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"bannerRemoved"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstStart"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased"];
//        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"avaliableVisas"];
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"usedVisas"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLocationIcon) name:kLocationSettingChanged object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBanner) name:@"bannerRemoving" object:nil];
}

//- (void) bannerViewPressed:(WPBannerView *) bannerView
//{
//	if (bannerView.bannerInfo.responseType == WPBannerResponseWebSite)
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerView.bannerInfo.link]];
//    
//	[bannerView reloadBanner];
//}

- (void)viewWillAppear:(BOOL)animated {
    if ([(AppDelegate *)[UIApplication sharedApplication].delegate settingsChanged]) {
        for (UIView *subview in pagesView.subviews) {
            if ([subview isKindOfClass:[VisaPageView class]]) {
                [(VisaPageView *)subview configurePage];
            }
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate setSettingsChanged:NO];
    }
    [self changeLocationIcon];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)isVisible:(UIView *)view {
    return CGRectGetMinY(view.frame) < 480.0f;
}

- (void)setView:(UIView *)view hidden:(BOOL)hidden {
    if (hidden == [self isVisible:view]) {
        CGRect hiddenFrame = CGRectMake(0.0f, 480.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        CGRect visibleFrame = CGRectMake(0.0f, 480.0f - CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        
        view.frame = hidden ? visibleFrame : hiddenFrame;
        [UIView beginAnimations:@"animation" context:NULL];
        [UIView setAnimationDuration:0.3f];
        view.frame = hidden ? hiddenFrame : visibleFrame;
        [UIView commitAnimations];
    }
}

#pragma mark - Buttons actions

- (void)showTableView {
    if (self.countriesTableView == nil) {
        self.countriesTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxY(topBarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain] autorelease];
        countriesTableView.delegate = self;
        countriesTableView.dataSource = self;
    }
    countriesTableView.frame = CGRectMake(0.0f, CGRectGetMaxY(topBarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.view addSubview:countriesTableView];
}

- (void)resizeTableView {
    [countriesTableView setFrame:CGRectMake(0.0f, CGRectGetMaxY(topBarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 210.0f)];
}

- (void)createCountryList {
    NSLocale *locale = chooseLocale();
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSString *code in countryCodes) {
        NSString *country = [locale displayNameForKey:NSLocaleCountryCode value:code];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", country, @"name", nil];
        [temp addObject:dict];
    }
    // add 'Schengen' to list
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"SCH", @"code", NSLocalizedString(@"Schengen", @"schengen"), @"name", nil];
    [temp addObject:dict];
    
    NSSortDescriptor *sortDescr = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    [temp sortUsingDescriptors:[NSArray arrayWithObject:sortDescr]];
    self.countryList = [NSArray arrayWithArray:temp];
    self.filteredList = [NSMutableArray arrayWithArray:countryList];
    
    
}

- (void)switchViewToTextField:(BOOL)toField {
    leftButton.hidden = searchButton.hidden = locationButton.hidden = toField;
    countryLabel.hidden = countryField.hidden = rightButton.hidden = !toField;
    [rightButton setTitle:NSLocalizedString(@"Cancel", @"cancel") forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
   // [self filterContryList:countryField.text];
}

- (void)switchViewToSearchField:(BOOL)toField {
    leftButton.hidden = locationButton.hidden = searchButton.hidden = toField;
    rightButton.hidden = self.searchBar.hidden = !toField;
    [rightButton setTitle:NSLocalizedString(@"Cancel", @"cancel") forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)switchViewToEditMode:(BOOL)toEditMode {
    rightButton.hidden = editLabel.hidden = !toEditMode;
    searchButton.hidden = locationButton.hidden = toEditMode;
    pagesView.scrollEnabled = !toEditMode;
    [leftButton setTitle:(toEditMode ? NSLocalizedString(@"Cancel", @"cancel") : nil) forState:UIControlStateNormal];
    [leftButton setImage:(toEditMode ? nil : [UIImage imageNamed:@"add_icon.png"]) forState:UIControlStateNormal];
    [leftButton setImage:(toEditMode ? nil : [UIImage imageNamed:@"add_icon.png"]) forState:UIControlStateHighlighted];
    CGRect leftFrame = leftButton.frame;
    leftFrame.origin.x = toEditMode ? 10.0f : 257.0f;
    leftButton.frame = leftFrame;
    [rightButton setTitle:NSLocalizedString(@"Done", @"done") forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addedVisa = NO;
}


- (IBAction)leftBtnPressed:(id)sender {
    if (editMode) {
        // hide keyboard
        if (!keyboard.hidden) {
            [self keyboardDone];
            [self setView:keyboard hidden:YES];
        }
        // hide date picker
        if (!self.picker.hidden) {
            [self pickerDonePressed:nil];
            [self setView:self.picker hidden:YES];
        }
        
        if (![AppData sharedAppData].isVisaOnEdit)
        {
            [[AppData sharedAppData].visas removeObjectAtIndex:currPageNum];
        }
        [AppData sharedAppData].isVisaOnEdit = NO;
        [self configurePages];
        self.currPageNum = currPageNum - 1 > 0 ? currPageNum - 1 : 0;
        
        VisaPageView *page = [self currentPage];
        page.editMode = editMode = NO;
        [page configurePage];
        [self switchViewToEditMode:NO];
    }
    else {
        //int avaliableCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"avaliableVisas"];
        //if (avaliableCount > 0){
        if ([[AppData sharedAppData].shopManager isOneVisaAvaliable] || [[AppData sharedAppData].shopManager isUserLucky]){
            // create countries list
            if (self.countryList == nil) {
                [self createCountryList];
            }
            // change view
            [self switchViewToTextField:YES];
            [countryField becomeFirstResponder];
            [self showTableView];
            [self performSelector:@selector(resizeTableView) withObject:nil afterDelay:0.5f];
        }
        else {
            NSString *infoStr = NSLocalizedString(@"Your count of avaliable visas is 0. Please buy at least 1 new.", @"alert text for 0 visas");
            showFullVersionInfo(infoStr, self);
        }
        [FlurryAnalytics logEvent:EVENT_ADD_VISA_PRESSED];
    }
}

- (IBAction)searchPressed:(id)sender {
    isSearching = YES;
    
    if (self.searchBar == nil) {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 240.0f, 48.0f)] autorelease];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
        imageView.frame = searchBar.frame;
        [self.searchBar insertSubview:imageView atIndex:1];
        self.searchBar.delegate = self;
        [self.view addSubview:searchBar];
    }
    [self switchViewToSearchField:YES];
    [self.searchBar becomeFirstResponder];
    
    [self showTableView];
    [self performSelector:@selector(resizeTableView) withObject:nil afterDelay:0.5f];
}

- (void)editPressed:(id)sender {
    VisaPageView *page = [self currentPage];
    page.editMode = YES;
    editMode = YES;
    [self switchViewToEditMode:YES];
    
    [FlurryAnalytics logEvent:EVENT_EDIT_PRESSED];
}

- (void)deletePressed:(id)sender {
    UIActionSheet *deleteSheet = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Visa will be deleted", @"visa will be deleted") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel") destructiveButtonTitle:NSLocalizedString(@"Delete", @"delete") otherButtonTitles:nil] autorelease];
    deleteSheet.delegate = self;
    [deleteSheet showInView:[(AppDelegate *)[UIApplication sharedApplication].delegate window]];
}

- (IBAction)locationPressed:(id)sender {
    [AppData sharedAppData].isLocationOn = ![AppData sharedAppData].isLocationOn;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocation];
}

- (void)finishAddingVisa:(NSMutableDictionary *)visa {
    [self switchViewToTextField:NO];
    countryField.text = nil;
    [self textField:countryField shouldChangeCharactersInRange:NSRangeFromString(@"{0,0}") replacementString:nil];
    [countryField resignFirstResponder];
    if (visa != nil) {
        // scroll to visa
        [self configurePages];
        [self scrollToVisa:visa];
        
        //myCode
//        int avaliableCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"avaliableVisas"];
//        int usedCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"usedVisas"];
//        [[NSUserDefaults standardUserDefaults] setInteger:(avaliableCount-1) forKey:@"avaliableVisas"];
//        [[NSUserDefaults standardUserDefaults] setInteger:(usedCount+1) forKey:@"usedVisas"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        ////////
        //switch to edit mode
        [self editPressed:nil]; 
        addedVisa = YES;
    }
    self.selectedCountry = nil;
}

- (void)entranceEditing:(BOOL)isEditing {
    leftButton.hidden = isEditing;
}

#pragma mark - Text Field delegate

- (void)filterCountryList:(NSString *)text {
    self.filteredList = [NSMutableArray arrayWithArray:countryList];
    
    NSMutableArray *sensSearchArr = nil;
    NSMutableArray *insensSearchArr = nil;
    if (text.length > 0) {
        NSPredicate *cPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", text];
        [filteredList filterUsingPredicate:cPredicate];
        insensSearchArr = [NSMutableArray arrayWithArray:filteredList];
        
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"name contains[s] %@", text];
        sensSearchArr = [NSMutableArray arrayWithArray:[filteredList filteredArrayUsingPredicate:sPredicate]];
        
        NSSortDescriptor *sortDescr = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
        [sensSearchArr sortUsingDescriptors:[NSArray arrayWithObject:sortDescr]];
        [insensSearchArr sortUsingDescriptors:[NSArray arrayWithObject:sortDescr]];
        
        self.filteredList = [NSMutableArray arrayWithArray:sensSearchArr];
        for (NSDictionary *country in insensSearchArr) {
            if ([filteredList indexOfObject:country] == NSNotFound) {
                [filteredList addObject:country];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = textField.text.length ? [textField.text stringByReplacingCharactersInRange:range withString:string] : string;
    [self filterCountryList:newText];
    [countriesTableView reloadData];
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isSearching ? searchedList.count : filteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = isSearching
    ? getCountryNameByCode([(NSDictionary *)[searchedList objectAtIndex:indexPath.row] objectForKey:@"country"])
    : [(NSDictionary *)[filteredList objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearching) {
        [AppData sharedAppData].isVisaOnEdit = NO;
        [self rightBtnPressed:nil];
        
        // scroll to selected visa
        NSDictionary *visa = [searchedList objectAtIndex:indexPath.row];
        NSInteger visaIndex = [[AppData sharedAppData].visas indexOfObject:visa];
        if (visaIndex != NSNotFound) {
            self.currPageNum = visaIndex;
            [self scrollToPageWithNum:visaIndex];
        }
    }
    else {
        self.selectedCountry = [filteredList objectAtIndex:indexPath.row];
        
        NSArray *existingVisas = [[AppData sharedAppData].visas valueForKey:@"country"];
        NSInteger index = [existingVisas indexOfObject:[self.selectedCountry objectForKey:@"code"]];
//        id tempCountry = [self.selectedCountry objectForKey:@"code"];
//        NSEnumerator *enumerator = [existingVisas reverseObjectEnumerator];
//        NSInteger index = NSNotFound;
//        id country;
//        int i = existingVisas.count;
//        while (country = [enumerator nextObject])
//        {
//            i--;
//            if ([country isEqual:tempCountry])
//            {
//                index = i;
//                break;
//            }
//        }
        BOOL goNext = NO;
        if (index != NSNotFound) {
            // visa already exist
            NSDate *today = [NSDate date];
            if ([[[[[AppData sharedAppData].visas objectAtIndex:index] objectForKey:@"fromDate"] earlierDate:today] isEqualToDate:today])
            {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Visa to selected country is already exist. You can edit existing visa or add new one. Create new visa?", @"visa exist") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"no") otherButtonTitles:NSLocalizedString(@"Yes", @"yes"), nil] autorelease];
                alert.tag = index;
                alert.delegate = self;
                [alert show];
            }
            else
            {
                goNext = YES;
            }
        }
        if (goNext || (index == NSNotFound) ){
//        else {
            NSInteger visaNum = ([AppData sharedAppData].nextVisaNum + 1) % NSIntegerMax;
            [AppData sharedAppData].nextVisaNum = visaNum;
            NSString *countryCode = [self.selectedCountry objectForKey:@"code"];
            NSMutableDictionary *addVisa = [NSMutableDictionary dictionaryWithObjectsAndKeys:countryCode, @"country",                                                                                              [NSNumber numberWithInt:visaNum], @"num",                                                                                              VISA_STATUS_UNRECEIVED, @"status",                                                                                              [NSDate date], @"modificationDate",                                                                                             [NSNumber numberWithBool:NO], @"edited", nil];
            [[AppData sharedAppData].visas addObject:addVisa];
            [self finishAddingVisa:addVisa];
            
            // remove table view
            [countriesTableView removeFromSuperview];
            self.countriesTableView = nil;
            
            [FlurryAnalytics logEvent:EVENT_VISA_IS_ADDED withParameters:[NSDictionary dictionaryWithObject:countryCode forKey:@"country"]];
        }
    } 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // change page num
    CGFloat offset = scrollView.contentOffset.x;
    int pageNum = offset/pageWidth;
    self.currPageNum = pageNum;
}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    if (self.searchedList == nil) {
        self.searchedList = [NSMutableArray array];
    }
    [self.countriesTableView reloadData];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    [self.searchedList removeAllObjects];
    if (searchText.length > 0) {
        for (NSDictionary *visa in [AppData sharedAppData].visas) {
            NSString *countryName = getCountryNameByCode([visa objectForKey:@"country"]);
            NSRange searchResultsRange = [countryName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (searchResultsRange.length > 0) {
                [self.searchedList addObject:visa];
            }
        }
    }
    [self.countriesTableView reloadData];
    
}

#pragma mark - Page Editing

- (void)showPickerAndSetEditing {
    if (self.picker == nil) {
        self.picker = [[[DatePicker alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 0.0f, 0.0f)] autorelease];
        self.picker.delegate = self;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:self.picker];
    }
    [self setView:self.picker hidden:NO];
    VisaPageView *page = [self currentPage];
    page.isEditing = YES;
}

- (void)hideKeyboard:(BOOL)hideKeyboard andPicker:(BOOL)hidePicker {
    VisaPageView *page = [self currentPage];
    page.isEditing = editFromDate = editUntilDate = editDuration = editEntries = NO;
    if ([self isVisible:self.picker] && hidePicker) {
        [self setView:self.picker hidden:YES];
    }
    if ([self isVisible:self.keyboard] && hideKeyboard) {
        [self setView:self.keyboard hidden:YES];   
    }
}

- (void)dateEditing:(BOOL)isFromDate {
    [self hideKeyboard:YES andPicker:NO];
    [self showPickerAndSetEditing];
    if (isFromDate) {
        editFromDate = YES;
    }
    else {
        editUntilDate = YES;
    }
    VisaPageView *page = [self currentPage];
    NSDate *date = isFromDate ? dateFromString(page.fromLabel.text) : dateFromString(page.untilLabel.text);
    if (checkForNotNull(date)) {
        self.picker.date = date;
    }
}

- (void)fromDateEditing {
    [self dateEditing:YES];
}

- (void)untilDateEditing {
    [self dateEditing:NO];
}

- (void)showKeyboard {
    if (self.keyboard == nil) {
        self.keyboard = [[[KeyboardView alloc] initWithFrame:CGRectMake(0.0f, 480.0f, 320.0f, 223.0f)] autorelease];
        self.keyboard.delegate = self;
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:self.keyboard];
    }
    keyboard.value = 0;
    keyboard.text = @"";
    [self setView:self.keyboard hidden:NO];
    
    VisaPageView *page = [self currentPage];
    page.isEditing = YES;
}

- (void)durationEditing {
    [self hideKeyboard:NO andPicker:YES];
    editDuration = YES;
    [self showKeyboard];
    keyboard.withMultButton = NO;
}

- (void)entriesEditing {
    [self hideKeyboard:NO andPicker:YES];
    editEntries = YES;
    [self showKeyboard];
    keyboard.withMultButton = YES;
}

#pragma mark - Date Picker delegate

- (void)pickerDonePressed:(id)sender {
    [self setView:self.picker hidden:YES];
    
    VisaPageView *page = [self currentPage];
    if (picker.date) {
        if (editFromDate) {
            page.fromLabel.text = formattedDate(picker.date, NO);
            
        }
        else {
            page.untilLabel.text = formattedDate(picker.date, NO);
        }
    }
    page.isEditing = NO;
    editFromDate = editUntilDate = NO;
}

#pragma mark - Keyboard delegate

- (void)keyboardDone {
    [self setView:keyboard hidden:YES];
    VisaPageView *page = [self currentPage];
    page.isEditing = NO;
    editDuration = editEntries = NO;
    
    keyboard.value = 0;
    keyboard.text = @"";
}

- (void)keyboardBtnPressed {
    VisaPageView *page = [self currentPage];
    if (editEntries) {
        NSInteger numOfEntries = keyboard.value;
        page.entriesLabel.text = (numOfEntries == NSIntegerMax) ? @"MULT" : [NSString stringWithFormat:@"%d", numOfEntries];
        page.entriesLabel.font = numOfEntries == NSIntegerMax ? [UIFont boldSystemFontOfSize:16.0f] : [UIFont boldSystemFontOfSize:20.0f];
        page.entriesTextLabel.text = entriesStr(numOfEntries);
    }
    else {
        page.durationLabel.text = [NSString stringWithFormat:@"%d", keyboard.value];
        page.durationTextLabel.text = [NSString stringWithFormat:@"%@ %@", daysStr(keyboard.value), NSLocalizedString(@"days of stay", @"days of stay")];
    }
}

#pragma mark DONE button

- (IBAction)rightBtnPressed:(id)sender {
    if (isSearching) {
        [self switchViewToSearchField:NO];
        [self.searchBar resignFirstResponder];
    }
    else if (editMode) {
//        BOOL isFullVersion = [[NSUserDefaults standardUserDefaults] boolForKey:@"isProUpgradePurchased"];
        
        VisaPageView *page = [self currentPage];
        NSMutableDictionary *visaData = [[AppData sharedAppData].visas objectAtIndex:currPageNum];
        
//        if (isFullVersion || (!isFullVersion && [[visaData objectForKey:@"status"] isEqualToString:VISA_STATUS_UNRECEIVED])) {
            // check if data is correct
            NSDate *fromDate = dateFromString(page.fromLabel.text);
            NSDate *untilDate = dateFromString(page.untilLabel.text);
            NSInteger entries = [page.entriesLabel.text isEqualToString:@"MULT"] ? NSIntegerMax : [page.entriesLabel.text intValue];
            NSInteger duration = [page.durationLabel.text intValue];
            NSInteger visaPeriod = checkForNotNull(untilDate) ? daysBetweenDates(fromDate, untilDate) : NSIntegerMax;
            
            if (checkForNotNull(untilDate) && [[untilDate earlierDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]] isEqualToDate:untilDate]) {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Date", @"incorrect date") message:NSLocalizedString(@"Date of expiry is not correct. Please, change it.", @"until date error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else if (checkForNotNull(fromDate) && checkForNotNull(untilDate) && [[untilDate earlierDate:fromDate] isEqualToDate:untilDate]) {
                // check dates
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Date", @"incorrect date") message:NSLocalizedString(@"Dates are not correct. Please, change one of them.", @"dates error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else if (visaPeriod < duration) {
                // check duration of stay
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Duration", @"incorrect duration") message:NSLocalizedString(@"Duration of stay can't be larger than period of visa. Please, change it.", @"duration error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else if (entries < NSIntegerMax && entries > duration) {
                // check num of entries
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Entries", @"incorrect entries") message:NSLocalizedString(@"Number of entries can't be larger than duration of stay. Please, change it.", @"entries error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else if (addedVisa && entries == 0) {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Entries", @"incorrect entries") message:NSLocalizedString(@"Number of entries isn't entered. Please, enter it.", @"no entries error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else if (!checkForNotNull(fromDate) && !checkForNotNull(untilDate) && entries == 0 && duration == 0) {
                // no visa data
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No data entered", @"no data entered") message:NSLocalizedString(@"No visa data has been entered.", @"data error") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                alert.tag = errorAlertTag;
                [alert show];
            }
            else {
                page.editMode = editMode = NO;
                [self switchViewToEditMode:NO];
                // hide keyboard
                if (!keyboard.hidden) {
                    [self keyboardDone];
                    [self setView:keyboard hidden:YES];
                }
                // hide date picker
                if (!self.picker.hidden) {
                    [self pickerDonePressed:nil];
                    [self setView:self.picker hidden:YES];
                }
                // save new visa data
                if (![fromDate isEqualToDate:[visaData objectForKey:@"fromDate"] ]|| ![untilDate isEqualToDate:[visaData objectForKey:@"untilDate"]]
                    || entries != [[visaData objectForKey:@"entries"] intValue] || duration != [[visaData objectForKey:@"duration"] intValue]) {
                    if (checkForNotNull(fromDate)) {
                        [visaData setObject:fromDate forKey:@"fromDate"];
                    }
                    if (checkForNotNull(untilDate)) {
                        [visaData setObject:untilDate forKey:@"untilDate"];
                        [visaData setObject:VISA_STATUS_RECEIVED forKey:@"status"];
                    }
                    [visaData setObject:[NSNumber numberWithInt:entries] forKey:@"entries"];
                    if (duration != getDurationNumForVisa(visaData)) {
                        [visaData setObject:[NSNumber numberWithInt:duration] forKey:@"duration"];
                    }
                    [visaData setObject:[NSDate date] forKey:@"modificationDate"];
                    [visaData setObject:[NSNumber numberWithBool:YES] forKey:@"edited"];
                    
                    [self resortPages];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate changeNotificationForVisa:[[AppData sharedAppData].visas objectAtIndex:currPageNum]];
                    //to save after adding
                    if (![AppData sharedAppData].isVisaOnEdit  && ![[AppData sharedAppData].shopManager isUserLucky])
                    {
                        [[AppData sharedAppData].shopManager useVisa];
                    }
                    [AppData sharedAppData].isVisaOnEdit = NO;
                    [[AppData sharedAppData] save];
//                    int avaliableCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"avaliableVisas"];
//                    int usedCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"usedVisas"];
//                    [[NSUserDefaults standardUserDefaults] setInteger:(avaliableCount-1) forKey:@"avaliableVisas"];
//                    [[NSUserDefaults standardUserDefaults] setInteger:(usedCount+1) forKey:@"usedVisas"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
    }
    else {
        [self finishAddingVisa:nil];
    }
    // remove table view
    [countriesTableView removeFromSuperview];
    self.countriesTableView = nil;
    isSearching = NO;
}

- (void)scrollToVisa:(NSMutableDictionary *)visa {
    // exit from search, edit and add mode
    [self switchViewToEditMode:NO];
    [self switchViewToSearchField:NO];
    [self switchViewToTextField:NO];
    [self.searchBar resignFirstResponder];
    [countryField resignFirstResponder];
    [countriesTableView removeFromSuperview];
    self.countriesTableView = nil;
    
    // scroll to page
    NSInteger num = [[AppData sharedAppData].visas indexOfObject:visa];
    num = (num == NSNotFound) ? [(NSArray *)[AppData sharedAppData].visas count] - 1 : num;
    [pagesView setContentOffset:CGPointMake(num*pageWidth, 0.0f)];
    self.currPageNum = num;
}

#pragma mark ActionSheet delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        // delete visa
        
        if ([[[AppData sharedAppData].visas objectAtIndex:currPageNum] objectForKey:@"nowInCountry"])
        {
            [AppData sharedAppData].isInCountry = NO;
        }
        
        [[AppData sharedAppData].visas removeObjectAtIndex:currPageNum];
        [self configurePages];
        self.currPageNum = currPageNum - 1 > 0 ? currPageNum - 1 : 0;
        
        [[AppData sharedAppData] save];
    }
}

#pragma mark AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == buyVersionAlertTag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            // buy full version
            showFullVersionInfo(nil, self);
        }
    }
    else if (alertView.tag != errorAlertTag) {
        NSMutableDictionary *addVisa = nil;
        if (buttonIndex != alertView.cancelButtonIndex) {
            // existing visa
            NSMutableDictionary *visa = [[AppData sharedAppData].visas objectAtIndex:alertView.tag];
            NSDate *today = [NSDate date];
            if ([[[visa objectForKey:@"fromDate"] earlierDate:today] isEqualToDate: today])
            {
                [AppData sharedAppData].isVisaOnEdit = YES;
                addVisa = [[AppData sharedAppData].visas objectAtIndex:alertView.tag];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Sorry, but you have no permission to edit it, because visa already started", @"visa_started") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
//            [today release];
        }
        else {
            // new visa
            NSInteger visaNum = ([AppData sharedAppData].nextVisaNum + 1) % NSIntegerMax;
            [AppData sharedAppData].nextVisaNum = visaNum;
            NSString *countryCode = [self.selectedCountry objectForKey:@"code"];
            addVisa = [NSMutableDictionary dictionaryWithObjectsAndKeys:countryCode, @"country", [NSNumber numberWithInt:visaNum], @"num", VISA_STATUS_UNRECEIVED, @"status", [NSDate date], @"modificationDate", [NSNumber numberWithBool:NO], @"edited", nil];
            [[AppData sharedAppData].visas addObject:addVisa];
            
            [FlurryAnalytics logEvent:EVENT_VISA_IS_ADDED withParameters:[NSDictionary dictionaryWithObject:countryCode forKey:@"country"]];
        }
        [self finishAddingVisa:addVisa];
        [countriesTableView removeFromSuperview];
        self.countriesTableView = nil;   
    }
}

//#pragma mark
//#pragma mark AdBannerView delegate
//
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner  {
//    //NSLog(@"bannerViewDidLoadAd");
//	if (!isBannerVisible && ![[AppData sharedAppData].shopManager isBannerRemoved]) {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//        adBannerView.frame = CGRectOffset(adBannerView.frame, 0, -CGRectGetHeight(adBannerView.frame));
//        [UIView commitAnimations];
//		isBannerVisible = YES;
//	}
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    //iAds failed
//	//NSLog(@"%@",[error localizedDescription]);
//	if (isBannerVisible) {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//        //adBannerView.frame = CGRectOffset(adBannerView.frame, 0, CGRectGetHeight(adBannerView.frame));
//        [UIView commitAnimations];
//		isBannerVisible = NO;
//    }
//}
//
//- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
//	[[[UIApplication sharedApplication] delegate] applicationWillResignActive:nil];
//	return YES;
//}
//
//- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
//	[[[UIApplication sharedApplication] delegate] applicationDidBecomeActive:nil];
//}


@end
