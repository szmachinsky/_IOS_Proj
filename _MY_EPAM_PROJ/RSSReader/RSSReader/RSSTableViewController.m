//
//  RSSTableViewController.m
//  TestRssReader
//
//  Created by Sergei Zmachinsky on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSSTableViewController.h"
#import "RssDetailsViewController.h"
#import "RssItem.h"
#import "RssData.h"
//#import "RssXMLParser.h"


@implementation RSSTableViewController

@synthesize rssConnection, xmlData, rssFeedLink, rssFeedName;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{   
    [rssItem release];
    [rssData release];
    [parsXML release];
    
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
    
    app = [UIApplication sharedApplication];
    
    self.title=@"RSS reader";
    
    rssData = [[RssData alloc] init];
    rssItem = [[RssItem alloc] init];
    
NSLog(@">>>LOAD RSS");    
    [self loadRSS:nil];
NSLog(@"<<<LOAD RSS");
    //add nav bar button 
    UIBarButtonItem *bbi;
    bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self
                                                        action:@selector(loadRSS:)]; 
    [[self navigationItem] setRightBarButtonItem:bbi];
    [bbi release];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.rightBarButtonItem = 
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [rssItem release]; rssItem=nil;
    [rssData release]; rssData=nil; 
    [parsXML release]; parsXML=nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [rssData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RSSCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];        
    }
//  cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines=2;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:9.0];
    
    // Configure the cell...
    RssItem *item = [rssData itemWithIndex:[indexPath row]];   
// NSLog(@">>> Item %d = %@",[indexPath row],item);       
    cell.textLabel.text = item.rssTitle;
//  cell.detailTextLabel.text=@"  no details";
    cell.detailTextLabel.text=item.rssText;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     RssDetailsViewController *detailViewController = [[RssDetailsViewController alloc] initWithNibName:@"RssDetailsViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     RssItem *item = [rssData itemWithIndex:[indexPath row]]; 
    NSLog(@">>> Item %d = %@",[indexPath row],item);  
        
     detailViewController.rssItem=item;    
    
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    
//   NSLog(@">>> Item link=%@  url=%@",item.rssLink,item.rssUrl);    
//   NSURL *url=[[[NSURL alloc] initWithString:item.rssLink] autorelease]; 
//   [[UIApplication sharedApplication] openURL:item.rssUrl];
     
}


-(void) reloadRssData:(id)some
{
    [[self tableView] reloadData];
}


//================================================================================================

-(void) clearRssData {
    [rssData removeAllRssData];
}
     
-(void)loadRSS:(id)object {
    
    app.networkActivityIndicatorVisible = YES; 
    
    [self clearRssData];
    [rssItem clearItem];
    
    [[self tableView] reloadData];
    
//    NSURL *url = [NSURL URLWithString:@"http://news.tut.by/rss/index.rss"];
      NSURL *url = [NSURL URLWithString:rssFeedLink];
    
    
//    NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/"
//                  @"WebObjects/MZStoreServices.woa/ws/RSS/topsongs/" @"limit=10/xml"];   
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    
    if (rssConnection) {
        [rssConnection cancel];
        rssConnection=nil;
    };
    
    xmlData=nil;
    xmlData = [[NSMutableData alloc] init];
    
 NSLog(@"--start connection--");    
    rssConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
 NSLog(@"--end connection--");    
    
}

//---------------------------------------------------------------------------------------
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [xmlData appendData:data];
    NSLog(@"-->");
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{	
    app.networkActivityIndicatorVisible = NO;     
    rssConnection = nil;
    xmlData=nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@", [error localizedDescription]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:errorString
                                                             delegate:nil cancelButtonTitle:@"OK"
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet showInView:[[self view] window]]; 
    [actionSheet autorelease];
    
    
    
}	

//----------------------ERRORS----------------------------
/*
- (void)errorAlert:(NSString *) message {
    // NSLog(@"%s", __FUNCTION__);
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"RSS Error" message:message delegate:nil
                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)handleError:(NSError *)error {
    // NSLog(@"%s", __FUNCTION__);
    NSLog(@"error is %@, %@", error, [error domain]);
    NSString *errorMessage = [error localizedDescription];
    NSLog(@"errorMsg is %@", errorMessage);
    
    // errors in NSXMLParserErrorDomain >= 10 are harmless parsing errors
    if ([error domain] == NSXMLParserErrorDomain && [error code] >= 10) {
        [self errorAlert:[NSString stringWithFormat:@"Cannot parse feed: %@", errorMessage]];  // tell the user why parsing is stopped
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error" message:errorMessage delegate:nil
                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo =
        [NSDictionary dictionaryWithObject:NSLocalizedString(@"No Connection Error", @"Not connected to the Internet.")
                                    forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.rssConnection = nil;
}
 */
//--------------------------------------------------

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
    // We are just checking to make sure we are getting the XML 
//    NSString *xmlCheck = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"xmlCheck = %@", xmlCheck);
    app.networkActivityIndicatorVisible = NO;   
    
    NSLog(@"-m-Loading start parcer--"); 
    
//  [NSThread detachNewThreadSelector:@selector(runXMLParserWithXMLData:) toTarget:self withObject:xmlData];
    
    parsXML = [[RssXMLParser alloc] init];
    parsXML.rssData = rssData;
    parsXML.mainDelegate=self;
    
    [parsXML runParsing:xmlData];
    
    self.xmlData = nil;
    NSLog(@"-m-Loading end parcer--"); 
}	


-(void) parsingDidFinished:(id) object 
{
    NSLog(@"-m-MAIN PARSING DID FINISHED!!!--"); 
    [self reloadRssData:nil];
    [parsXML release]; parsXML=nil;
    
}





//---------------------------------------------------------------------------------------

@end
