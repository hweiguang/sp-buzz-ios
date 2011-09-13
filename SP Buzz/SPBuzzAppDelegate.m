//
//  SPBuzzAppDelegate.m
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SPBuzzAppDelegate.h"

@implementation SPBuzzAppDelegate

@synthesize window = _window;
@synthesize splitViewController;
@synthesize masterViewController;
@synthesize detailViewController;
@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{       
    facebook = [[Facebook alloc] initWithAppId:FacebookAppID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([defaults boolForKey:@"logout"]) {
        [SHK logoutOfAll];
        [facebook logout:self];   
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"]; 
        [defaults setBool:NO forKey:@"logout"];
        [defaults synchronize];
    }
    
    if ([defaults boolForKey:@"clearcache"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0]; 
        NSError *error = nil;
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachesDirectory error:&error]) {
            [[NSFileManager defaultManager] removeItemAtPath:[cachesDirectory stringByAppendingPathComponent:file] error:&error];
        }
        [defaults setBool:NO forKey:@"clearcache"];
        [defaults synchronize];
    }
    
    masterViewController = [[MasterViewController alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setupiPhone];
    else
        [self setupiPad];
    return YES;
}

- (void)setupiPhone {
    [self.window addSubview:masterViewController.view];
    [self.window makeKeyAndVisible];
}

- (void)setupiPad {
    detailViewController = [[DetailViewController alloc]init];
    splitViewController = [[MGSplitViewController alloc]init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:masterViewController,detailViewController,nil];
    splitViewController.showsMasterInPortrait = YES;
    
    [self.window addSubview:splitViewController.view];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logged in" 
                                                   message:@"You may now share on Facebook." 
                                                  delegate:self
                                         cancelButtonTitle:@"Done" 
                                         otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    [_window release];
    [masterViewController release];
    [splitViewController release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [detailViewController release];
    
    [super dealloc];
}

@end
