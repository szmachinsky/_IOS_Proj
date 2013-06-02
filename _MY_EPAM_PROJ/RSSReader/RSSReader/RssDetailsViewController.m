//
//  RssDetailsViewController.m
//  TestRssReader
//
//  Created by Sergei Zmachinsky on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssDetailsViewController.h"
#import "WebViewController.h"
#import "RssItem.h"
#import "TESTView.h"

@implementation RssDetailsViewController
@synthesize rssItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)dealloc
{
   
    [nameLabel release];
    [detailText release];
    [linkLabel release];
    
    [webView release];
    
    [dateLabel release];
    
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
    // Do any additional setup after loading the view from its nib.
    self.title=@"RSS details";
//  self.navigationItem.rightBarButtonItem=UIBarButtonSystemItemAction;
    
    UIBarButtonItem *bbi;
    // Done item 
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self
                  action:@selector(webMapButton:)]; 
    [[self navigationItem] setRightBarButtonItem:bbi];
    [bbi release];
    
//    nameLabel.text=stringName;
//    detailText.text=stringDetails;
//    linkLabel.text=stringLink;
    
    nameLabel.text=rssItem.rssTitle;
    linkLabel.text=rssItem.rssLink;
    //detailText.text=rssItem.rssDescr;
    detailText.hidden=YES;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLenient:NO];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//the formatter should live in UTC
    NSString *s = nil;
    NSDate * date = rssItem.rssDate;
    if (!date) date = [NSDate date];    // no date? use now.   
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   // SQL date format
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];   // SQL date format
    s = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    dateLabel.text=s;
    NSLog(@"%@ / %@", rssItem.rssText, s);

    
    [webView loadHTMLString:rssItem.rssDescr baseURL:nil];
    
}

- (void)viewDidUnload
{
    
    [nameLabel release];
    nameLabel = nil;
    
    [detailText release];
    detailText = nil;
    
    [linkLabel release];
    linkLabel = nil;
    
    [webView release];
    webView = nil;

    [dateLabel release];
    dateLabel = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) webMapButton:(id) object {
    NSLog(@"btn");
    
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.urlString=rssItem.rssLink;
    
//    TESTView *webViewController = [[TESTView alloc] initWithNibName:@"TESTView" bundle:nil];
//    webViewController.urlString=rssItem.rssDescr;
    
    
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];

    
    
//  NSURL *url=[[[NSURL alloc] initWithString:rssItem.rssLink] autorelease];  
//  [[UIApplication sharedApplication] openURL:rssItem.rssUrl];

}

@end
