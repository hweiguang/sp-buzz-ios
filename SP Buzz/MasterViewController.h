//
//  MasterViewController.h
//  SP Buzz
//
//  Created by Wei Guang on 25/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "AboutViewController.h"

@interface MasterViewController : UIViewController {
    UITabBarController *tabBarController;
}

@property (nonatomic,retain) UITabBarController *tabBarController;

@end
