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
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL loading;
    
    NSMutableArray *data;
    NSMutableDictionary *imageDownloadinProgress;
    ASIHTTPRequest *request;
    
    MBProgressHUD *loadingHUD;
}

@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(FeedObject *)aFeedObject;
- (void)startIconDownload:(FeedObject *)aFeedObject forIndexPath:(NSIndexPath *)indexPath;
- (void)loadImagesForOnscreenRows;

- (void)downloadXML;
- (void)parseXML;
- (NSString *)flattenHTML:(NSString *)html;

@end
