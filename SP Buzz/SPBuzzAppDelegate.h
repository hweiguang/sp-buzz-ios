//
//  SPBuzzAppDelegate.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MGSplitViewController.h"
#import "Constants.h"
#import "SHK.h"
#import "FBConnect.h"

@class MasterViewController;
@class DetailViewController;
@class MGSplitViewController;

@interface SPBuzzAppDelegate : NSObject <UIApplicationDelegate,FBSessionDelegate> {
    MGSplitViewController *splitViewController;
    DetailViewController *detailViewController;
    MasterViewController *masterViewController;
    
    Facebook *facebook;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MGSplitViewController *splitViewController;
@property (nonatomic, retain) MasterViewController *masterViewController;
@property (nonatomic, retain) DetailViewController *detailViewController;
@property (nonatomic, retain) Facebook *facebook;

- (void)setupiPhone;
- (void)setupiPad;

@end
