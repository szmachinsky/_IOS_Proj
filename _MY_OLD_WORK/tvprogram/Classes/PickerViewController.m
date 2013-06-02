//
//  PickerViewController.m
//  PickerView
//
//  Created by iPhone SDK Articles on 1/24/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "PickerViewController.h"
#import "TVDataSingelton.h"

@implementation PickerViewController

-(id)init:(BOOL)isTime
{
    if (self = [super init]) {
        isForTime = isTime;
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    if (isForTime) {
        [[TVDataSingelton sharedTVDataInstance] setBeforeReminder:min];
    }
    [self.navigationController popViewControllerAnimated:NO];

}

NSInteger zoneSort(id num1, id num2, void *context)
{
    int h1 = [num1 intValue];
    int h2 = [num2 intValue];
    if (h1 < h2)
        return NSOrderedAscending;
    else if (h1 > h2)
        return NSOrderedDescending;
    else
    {
        return NSOrderedSame;
    }
}

-(void) createZones
{
    NSArray * zonesNames = [NSTimeZone knownTimeZoneNames];
    for (int i = 0; i < [zonesNames count]; i++) {
        _NSLog(@"%@", [zonesNames objectAtIndex:i]);
        NSTimeZone * zone = [NSTimeZone timeZoneWithName:[zonesNames objectAtIndex:i]];
        _NSLog(@"%@", [zone description]);
        int offset = [zone secondsFromGMT] / 3600;
        if (![arrayValues containsObject:[NSNumber numberWithInt: offset]]) {
            [arrayValues addObject:[NSNumber numberWithInt: offset]];
        }
    }
    
    [arrayValues sortUsingFunction:zoneSort context:NULL];
}

- (void)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [SZUtils color02];
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];    
//    backButton.frame = CGRectMake(0, 0, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    // time picker
	UIPickerView *myPickerView = [[UIPickerView alloc] init];
    myPickerView.frame = CGRectMake(0.0f, 173.0f, CGRectGetWidth(self.view.frame), 216.0f);
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:myPickerView];
    
    UIColor *textColor = [SZUtils color04];
    UIColor *shadowColor = [SZUtils color05];
    // text label 
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 60.0f, CGRectGetWidth(self.view.frame) - 40.0f, 80.0f)];
    textLabel.text = isForTime ? @"Выберите время для начала напоминания" : @"Выберите часовой пояс";
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    textLabel.textColor = textColor;
    textLabel.shadowColor = shadowColor;
    textLabel.numberOfLines = 0;
    [self.view addSubview:textLabel];
    
    
    arrayValues = [[NSMutableArray alloc] init];
    if (isForTime) {
        [arrayValues addObject:@"5"];
        [arrayValues addObject:@"10"];
        [arrayValues addObject:@"15"];
        [arrayValues addObject:@"20"];
        [arrayValues addObject:@"25"];
        [arrayValues addObject:@"30"];
        _NSLog(@"%d", [[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder]);
        min = [[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder];
        NSInteger row = [arrayValues indexOfObject:[NSString stringWithFormat:@"%d", min]];
        [myPickerView selectRow:row inComponent:0 animated:NO];
    }
    else
    {
        [self createZones];
        NSInteger timeZomeNum = [[NSTimeZone defaultTimeZone] secondsFromGMT]/3600; 
        timeZone = [NSString stringWithFormat:@"%d", timeZomeNum];
        NSInteger row = [arrayValues indexOfObject:[NSNumber numberWithInt:timeZomeNum]];
        [myPickerView selectRow:row inComponent:0 animated:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
}

#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [arrayValues count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	id value = [arrayValues objectAtIndex:row];
	return isForTime ? [NSString stringWithFormat:@"за %@ минут", value] : [NSString stringWithFormat:@"GMT %@%d", ([value intValue] > 0 ? @"+" : @""), [value intValue]];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (isForTime) {
        _NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayValues objectAtIndex:row], row);
        min = [[arrayValues objectAtIndex:row] intValue];
    }
    else
    {
        timeZone = [arrayValues objectAtIndex:row];
    }
}

@end
