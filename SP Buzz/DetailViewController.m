//
//  DetailViewController.m
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize description;
@synthesize comments;
@synthesize articletitle;
@synthesize link;
@synthesize isActionSheetDisplayed;

- (void)dealloc {
    [webView release];
    [timer invalidate];
    [actionButton release];
    [link release];
    [description release];
    [comments release];
    [articletitle release];
    [shorteningURLHUD release];
    [super dealloc];
}

- (void)reloadData {
    //Checking for local image
    NSString *imageName = [articletitle stringByAppendingString:@".jpg"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:imageName];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    NSString *html;
    
    if (imageData) {
        //If local image is available encode it to display in webView
        [Base64 initialize];
        NSString *Base64image = [Base64 encode:imageData];
        
        html = [NSString stringWithFormat:@"<html><head><body bgcolor='#E0FFFF'><h2><font color='red'>%@</font></h2> <img src='data:image/jpg;base64,%@' align='left'/>%@<br/><br/><br/></body></html>",articletitle,Base64image,description];
    }
    else {
        //If local image unavailable load image from server
        html = [NSString stringWithFormat:@"<html><head><body bgcolor='#E0FFFF'><h2><font color='red'>%@</font></h2> <img src='%@' align='left'/>%@<br/><br/><br/></body></html>",articletitle,comments,description];
    }
    [webView loadHTMLString:html baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request 
 navigationType:(UIWebViewNavigationType)navigationType {
    //If there is a link in article open it in safari
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication]openURL:[_request URL]];
        return  NO;
    }
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    isActionSheetDisplayed = NO;
    
    switch (buttonIndex) {
        case 0: {
            //Email
            NSURL *url = [NSURL URLWithString:link];
            SHKItem *item = [SHKItem URL:url title:articletitle];
            [SHKMail shareItem:item];
        }
            break;
        case 1: {
            SPBuzzAppDelegate *appDelegate = (SPBuzzAppDelegate*)[UIApplication sharedApplication].delegate;
            //Check Facebook Status
            if (![appDelegate.facebook isSessionValid])
                [appDelegate.facebook authorize:nil]; //Login Facebook
            else {
                //Post to Facebook
                SBJSON *jsonWriter = [[SBJSON new] autorelease];
                
                NSDictionary *actions = [NSDictionary dictionaryWithObjectsAndKeys:@"Get SP BUZZ", @"name",
                                         @"http://itunes.apple.com/sg/app/sp-buzz/id412682070?mt=8", @"link", nil];
                
                NSString *finalactions = [jsonWriter stringWithObject:actions];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:FacebookAppID,@"app_id",
                                               articletitle,@"name",
                                               link,@"link",
                                               comments,@"picture",
                                               description,@"description",
                                               finalactions,@"actions",nil];   
                
                [appDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
            }                        
        }
            break;
        case 2: {
            //iOS 5 Twitter integration, NOT YET IMPLEMENTED in current version of SP Buzz in AppStore
            if ([TWTweetComposeViewController canSendTweet]) { 
                //URL for shortening News Article link
                NSURL *url = [NSURL URLWithString:[NSMutableString stringWithFormat:
                                                   @"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",
                                                   SHKBitLyLogin,SHKBitLyKey,link]];
                request = [ASIHTTPRequest requestWithURL:url];
                request.delegate = self;
                [request startAsynchronous];
                
                shorteningURLHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:shorteningURLHUD];
                shorteningURLHUD.mode = MBProgressHUDModeIndeterminate;
                shorteningURLHUD.labelText = @"Shortening URL...";
                [shorteningURLHUD show:YES];
            }
            else {
                //ShareKit Twitter sharing
                NSURL *url = [NSURL URLWithString:link];
                SHKItem *item = [SHKItem URL:url title:articletitle];
                [SHKTwitter shareItem:item];
            }
        }
            break;
        case 3: {
            //Open link in Safari
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }
            break;
    }
}
//Successfully shorten URL
- (void)requestFinished:(ASIHTTPRequest *)theRequest {  
    [shorteningURLHUD hide:YES];
    NSString *response = [[theRequest responseString]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSURL *responseURL = [NSURL URLWithString:response];
    
    //Create a tweet view
    TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc]init];
    [tweet setInitialText:articletitle];
    [tweet addURL:responseURL];
    [self presentModalViewController:tweet animated:YES];
    [tweet release];
}
//Fail to shorten URL
- (void)requestFailed:(ASIHTTPRequest *)theRequest { 
    [shorteningURLHUD hide:YES];
    MBProgressHUD *errorHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:errorHUD];
    errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
    errorHUD.mode = MBProgressHUDModeCustomView;
    errorHUD.labelText = @"Shorten URL failed";
    [errorHUD show:YES];
    [errorHUD hide:YES afterDelay:1.5];
    [errorHUD release];
}

- (void)shareButtonSelected {
    if (isActionSheetDisplayed)
        return;
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:@"Cancel" 
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Email",@"Post to Facebook",@"Post to Twitter",@"Open in Safari",nil];
    [popupQuery showFromBarButtonItem:actionButton animated:YES];
    [popupQuery release];
    
    isActionSheetDisplayed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setting up all the UI elements
    actionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                                                                target:self 
                                                                action:@selector(shareButtonSelected)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    webView = [[UIWebView alloc]init];
    webView.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        webView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    else {
        webView.frame = CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height);
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        navigationController.navigationBar.tintColor = [UIColor blackColor];
        CGRect frame = navigationController.view.frame;
        frame.origin.x = 0.0;
        frame.origin.y = -20.0;
        navigationController.view.frame = frame;
        [self.view addSubview:navigationController.view];
        [navigationController release];
    }    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self 
                                           selector:@selector(loading) 
                                           userInfo:nil 
                                            repeats:YES];
}

- (void) loading {
    if (!webView.loading)
        self.title = nil;
    else
        self.title = @"Loading...";
}

@end
