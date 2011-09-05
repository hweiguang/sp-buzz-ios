//
//  DetailViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHK.h"
#import "FBDialog.h"
#import "ASIHTTPRequest.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,FBDialogDelegate> {
    UIWebView *webView;
    NSString *articletitle;
    NSString *description;
    NSString *comments;
    NSString *link;
    NSTimer *timer;
    UIBarButtonItem *actionButton;
    
    BOOL isActionSheetDisplayed;
    
    ASIHTTPRequest *request;
    
    UIAlertView *shortenURLAlert;
}
@property (nonatomic,retain) NSString *articletitle;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *comments;
@property (nonatomic,retain) NSString *link;
@property BOOL isActionSheetDisplayed;

- (void)reloadData;
- (void)loading;
- (void)shareButtonSelected;
//- (void)addSpinner;

@end
