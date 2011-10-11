//
//  DetailViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "SPBuzzAppDelegate.h"
#import "Constants.h"
#import "Base64.h"
#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKMail.h"
#import "FBDialog.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,FBDialogDelegate> {
    UIWebView *webView; //WebView for showing news articel
    NSString *articletitle;
    NSString *description;
    NSString *comments;
    NSString *link;
    NSTimer *timer;//Timer for checking WebView status
    UIBarButtonItem *actionButton;
    
    BOOL isActionSheetDisplayed;
    
    MBProgressHUD *shorteningURLHUD;
    
    ASIHTTPRequest *request;
}
@property (nonatomic,retain) NSString *articletitle;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *comments;
@property (nonatomic,retain) NSString *link;
@property BOOL isActionSheetDisplayed;

- (void)reloadData;
- (void)loading;
- (void)shareButtonSelected; //Display action sheet

@end
