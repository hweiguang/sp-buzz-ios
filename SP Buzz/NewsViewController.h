//
//  NewsViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPBuzzAppDelegate.h"
#import "DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"
#import "IconDownloader.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "TBXML.h"
#import "FeedObject.h"
#import "CustomTableViewCell.h"

@interface NewsViewController : UITableViewController <EGORefreshTableHeaderDelegate,UIScrollViewDelegate,IconDownloaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL loading;
    
    NSMutableArray *data;
    NSMutableArray *imageDownloadinProgress;
    ASIHTTPRequest *request;
    
    MBProgressHUD *loadingHUD;
}

- (void)appImageDidLoad:(FeedObject *)aFeedObject;
- (void)startIconDownload:(FeedObject *)aFeedObject;
- (void)loadImagesForOnscreenRows;

- (void)downloadXML;
- (void)parseXML;
- (NSString *)flattenHTML:(NSString *)html;

@end
