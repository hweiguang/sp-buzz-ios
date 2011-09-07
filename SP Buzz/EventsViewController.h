//
//  EventsViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "IconDownloader.h"

@interface EventsViewController : UITableViewController <EGORefreshTableHeaderDelegate,UIScrollViewDelegate,IconDownloaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL loading;
    
    NSMutableArray *data;
    NSMutableArray *imageDownloadinProgress;
    ASIHTTPRequest *request;
    
    UIActivityIndicatorView *activity;
}

- (void)appImageDidLoad:(FeedObject *)aFeedObject;
- (void)startIconDownload:(FeedObject *)aFeedObject;
- (void)loadImagesForOnscreenRows;

- (void)downloadXML;
- (void)parseXML;
- (NSString *)flattenHTML:(NSString *)html;

@end
