//
//  EventsViewController.m
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventsViewController.h"

@implementation EventsViewController

- (void)dealloc {
    [data release];
    [imageDownloadinProgress release];
    [request clearDelegatesAndCancel];
    [request release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 115.0;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = UIColorFromRGB(0xE0FFFF);
    
	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    
    data = [[NSMutableArray alloc]init];
    imageDownloadinProgress = [[NSMutableArray alloc]init];
    
    loadingHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingHUD];
    loadingHUD.mode = MBProgressHUDModeIndeterminate;
    loadingHUD.labelText = @"Loading...";
    [loadingHUD show:YES];
    
    [self downloadXML];
}

- (void)downloadXML {
    loading = YES;
    
    NSURL *url = [NSURL URLWithString:EventsFeedURL];
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *XMLPath = [documentDirectory stringByAppendingPathComponent:@"Events.xml"];
    
    [request setDownloadDestinationPath:XMLPath]; //Set to save the file to documents directory
    [request startAsynchronous]; //Start request
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {  
    [self parseXML];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest {    
    if ([data count] == 0)
        [self parseXML];
    else {
        loading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    MBProgressHUD *errorHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:errorHUD];
	errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
    errorHUD.mode = MBProgressHUDModeCustomView;
    errorHUD.labelText = @"Update failed";
	errorHUD.detailsLabelText = @"No Internet Connection";
    [errorHUD show:YES];
	[errorHUD hide:YES afterDelay:1.5];
    [errorHUD release];
}

- (void)parseXML {  
    [data removeAllObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *XMLPath = [documentDirectory stringByAppendingPathComponent:@"Events.xml"];
    
    // Load and parse the Locations.xml file in document directory
    TBXML *tbxml = [[TBXML tbxmlWithXMLData:[NSData dataWithContentsOfFile:XMLPath]] retain];
    
    // Obtain root element
    TBXMLElement * root = tbxml.rootXMLElement;
    
    // if root element is valid
    if (root) {
        // search for the first category element within the root element's children
        TBXMLElement * channel = [TBXML childElementNamed:@"channel" parentElement:root];
        
        TBXMLElement * item = [TBXML childElementNamed:@"item" parentElement:channel];
        // if an location element was found
        while (item != nil) {
            FeedObject *aFeedObject = [[FeedObject alloc] init];
            
            TBXMLElement * title = [TBXML childElementNamed:@"title" parentElement:item];
            aFeedObject.title = [TBXML textForElement:title];
            
            TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:item]; 
            aFeedObject.description = [TBXML textForElement:description];
            
            TBXMLElement *link = [TBXML childElementNamed:@"link" parentElement:item];
            aFeedObject.link = [TBXML textForElement:link];
            
            TBXMLElement *comments = [TBXML childElementNamed:@"comments" parentElement:item];
            aFeedObject.comments = [TBXML textForElement:comments];
            
            [data addObject:aFeedObject];
            [aFeedObject release];
            
            item = [TBXML nextSiblingNamed:@"item" searchFromElement:item];
        }
    }
    // release resources
    [tbxml release];
    
    [self.tableView reloadData];
    loading = NO;
    
    if (loadingHUD != nil) {
        [loadingHUD hide:YES];
        [loadingHUD release];
        loadingHUD = nil;
    }
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    //If device is iPad load the first article to detail view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [data count] > 0) {
        
        FeedObject *aFeedObject = [data objectAtIndex:0];
        
        SPBuzzAppDelegate *appDelegate = (SPBuzzAppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (appDelegate.detailViewController.articletitle == nil) {
            appDelegate.detailViewController.articletitle = aFeedObject.title;
            appDelegate.detailViewController.description = aFeedObject.description;
            appDelegate.detailViewController.comments = aFeedObject.comments;
            appDelegate.detailViewController.link = aFeedObject.link;
            [appDelegate.detailViewController reloadData];
        }
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomTableViewCell alloc]initWithFrame:CGRectZero]autorelease];
    }
    
    FeedObject *aFeedObject = [data objectAtIndex:indexPath.row];
    
    NSString *description = [self flattenHTML:aFeedObject.description];
    
    cell.titleLabel.text = aFeedObject.title;
    cell.descriptionLabel.text = description;
    
    NSString *imageName = [aFeedObject.title stringByAppendingString:@".jpg"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:imageName];
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
    
    if (!image)
    {
        if (!self.tableView.dragging && !self.tableView.decelerating)
            [self startIconDownload:aFeedObject];
        // if a download is deferred or in progress, return a placeholder image
        cell.image.image = [UIImage imageNamed:@"Placeholder.png"];  
    }
    else
        cell.image.image = image;
    
    [image release];
    return cell;
}

-(NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
											   withString:@" "];
		
    } // while //
    
    return html;
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedObject *aFeedObject = [data objectAtIndex:indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];  
        
        DetailViewController *detailVC = [[DetailViewController alloc]init];
        detailVC.articletitle = aFeedObject.title;
        detailVC.description = aFeedObject.description;
        detailVC.comments = aFeedObject.comments;
        detailVC.link = aFeedObject.link;
        
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
        backbutton.title = @"Back";
        self.navigationItem.backBarButtonItem = backbutton;
        [backbutton release];
        
        [self.navigationController pushViewController:detailVC animated:YES];
        
        [detailVC reloadData];
        [detailVC release];
    }
    else {
        SPBuzzAppDelegate *appDelegate = (SPBuzzAppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.detailViewController.articletitle = aFeedObject.title;
        appDelegate.detailViewController.description = aFeedObject.description;
        appDelegate.detailViewController.comments = aFeedObject.comments;
        appDelegate.detailViewController.link = aFeedObject.link;
        [appDelegate.detailViewController reloadData];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self downloadXML];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return loading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark UIScrollViewDelegate

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(FeedObject *)aFeedObject
{
    if (![imageDownloadinProgress containsObject:aFeedObject]) {
        [imageDownloadinProgress addObject:aFeedObject];
        IconDownloader *iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.aFeedObject = aFeedObject;
        iconDownloader.delegate = self;
        [iconDownloader startDownload];
    }  
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(FeedObject *)aFeedObject
{
    [self.tableView reloadData];
    [imageDownloadinProgress removeObject:aFeedObject];
}

- (void)loadImagesForOnscreenRows
{
    if ([data count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            FeedObject *aFeedObject = [data objectAtIndex:indexPath.row];
            
            NSString *imageName = [aFeedObject.title stringByAppendingString:@".jpg"];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentDirectory stringByAppendingPathComponent:imageName];
            
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
            
            if (!image) // avoid the app icon download if the app already has an icon
                [self startIconDownload:aFeedObject];
            [image release];
        }
    }
}

@end

