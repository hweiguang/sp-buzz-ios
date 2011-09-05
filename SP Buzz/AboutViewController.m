//
//  AboutViewController.m
//  SPMap
//
//  Created by Wei Guang on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "SHK.h"
#import "SPBuzzAppDelegate.h"

@implementation AboutViewController

@synthesize webView;

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        return;
    else {
        [SHK logoutOfAll];
        
        SPBuzzAppDelegate *appDelegate = (SPBuzzAppDelegate*)[UIApplication sharedApplication].delegate;
        
        [appDelegate.facebook logout:appDelegate];   
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];   
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Successfully Logged Out."  
                                                       message:nil
                                                      delegate:self 
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Ok", nil];
        [alert show];
        [alert release];
    }
}

- (void)logout {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout all Social Network?"  
                                                   message:nil
                                                  delegate:self 
                                         cancelButtonTitle:@"No" 
                                         otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (void)viewDidLoad {
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Logout" 
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self 
                                                                   action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aboutData" ofType:@"html"];
    
	NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
	[webView setDelegate:self];
	[webView loadHTMLString:htmlString baseURL:nil];
	
	//prevent bounce in UIWebView
	UIScrollView* sv = nil;
	for(UIView* v in webView.subviews){
		if([v isKindOfClass:[UIScrollView class] ]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = YES;
			sv.bounces = NO;
		}
	}
	
	webView.backgroundColor = [UIColor blueColor];
	[super viewDidLoad];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
