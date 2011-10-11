//
//  EventsViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SPBuzzAppDelegate.h"
#import "DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "IconDownloader.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "TBXML.h"
#import "FeedObject.h"

@interface EventsViewController : UITableViewController <EGORefreshTableHeaderDelegate,UIScrollViewDelegate,IconDownloaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;//Pull to refresh View
    BOOL loading;//Downloading XML status
    
    NSMutableArray *data; //Array for storing all the news feed
    NSMutableDictionary *imageDownloadinProgress; //Dictionary that keep tracks of which image are being download
    ASIHTTPRequest *request;
    
    MBProgressHUD *loadingHUD;
}

@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(FeedObject *)aFeedObject; //Called when image has been downloaded
- (void)startIconDownload:(FeedObject *)aFeedObject forIndexPath:(NSIndexPath *)indexPath; //Start download if image is not available
- (void)loadImagesForOnscreenRows; //Load image for visible path
- (void)downloadXML;
- (void)parseXML;
- (NSString *)flattenHTML:(NSString *)html;//Get rid of HTML tags

@end
