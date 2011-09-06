//
//  DetailViewController.m
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SPBuzzAppDelegate.h"
#import "DetailViewController.h"
#import "Constants.h"
#import "SHKTwitter.h"
#import "SHKMail.h"
#import "SHKSafari.h"
//#import <Twitter/Twitter.h>

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
    [super dealloc];
}

- (void)reloadData {
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><body bgcolor=\"WhiteSmoke\"><h2><font color='red'>%@</font></h2> <img src='%@' align='left'/>%@<br/><br/><br/></body></html>",articletitle,comments,description];
    
    [webView loadHTMLString:htmlString baseURL:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request 
 navigationType:(UIWebViewNavigationType)navigationType {
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
            NSURL *url = [NSURL URLWithString:link];
            SHKItem *item = [SHKItem URL:url title:articletitle];
            [SHKMail shareItem:item];
        }
            break;
        case 1: {
            SPBuzzAppDelegate *appDelegate = (SPBuzzAppDelegate*)[UIApplication sharedApplication].delegate;
            
            if (![appDelegate.facebook isSessionValid])
                [appDelegate.facebook authorize:nil];
            else {
                
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
        case 2: {/*
            if ([TWTweetComposeViewController canSendTweet]) {   
                
                NSURL *url = [NSURL URLWithString:[NSMutableString stringWithFormat:
                                                   @"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",
                                                   SHKBitLyLogin,SHKBitLyKey,link]];
                
                request = [ASIHTTPRequest requestWithURL:url];
                [request setDelegate:self];
                [request startAsynchronous];
                
                shortenURLAlert = [[[UIAlertView alloc] initWithTitle:@"Shortening URL\nPlease Wait..."
                                                              message:nil 
                                                             delegate:self 
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles: nil] autorelease];
                [shortenURLAlert show];
                
                [self performSelector:@selector(addSpinner) withObject:nil afterDelay:0.05f];
            }
            else {*/
                NSURL *url = [NSURL URLWithString:link];
                SHKItem *item = [SHKItem URL:url title:articletitle];
                [SHKTwitter shareItem:item];
            //}
        }
            break;
        case 3: {
            NSURL *url = [NSURL URLWithString:link];
            SHKItem *item = [SHKItem URL:url title:articletitle];
            [SHKSafari shareItem:item];
        }
        default:
            break;
    }
}
/*
- (void)addSpinner {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(shortenURLAlert.bounds.size.width / 2, shortenURLAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [shortenURLAlert addSubview:indicator];
    [indicator release];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest { 
    
    [shortenURLAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSString *response = [[request responseString]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSURL *responseURL = [NSURL URLWithString:response];
    TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc]init];
    [tweet setInitialText:articletitle];
    [tweet addURL:responseURL];
    [self presentModalViewController:tweet animated:YES];
    [tweet release];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest {      
    
    [shortenURLAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shorten URL failed" 
                                                    message:@"Please try again." 
                                                   delegate:self 
                                          cancelButtonTitle:nil 
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}
*/
- (void)shareButtonSelected {
    
    if (isActionSheetDisplayed == YES) {
        return;
    }
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self 
                                                   cancelButtonTitle:@"Cancel" 
                                              destructiveButtonTitle:nil 
                                                   otherButtonTitles:@"Email",@"Post to Facebook",@"Post to Twitter",@"Open in Safari",nil];
    [popupQuery showFromBarButtonItem:actionButton animated:YES];
    [popupQuery release];
    
    isActionSheetDisplayed = YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
