//
//  MasterViewController.m
//  SP Buzz
//
//  Created by Wei Guang on 25/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController

@synthesize tabBarController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 20,
                                 self.view.frame.size.width, self.view.frame.size.height + 20);
    
    //UI Elements
    self.tabBarController = [[UITabBarController alloc]init];
    
    //Preparing the ViewControllers
    NewsViewController *newsVC = [[NewsViewController alloc]init];
    EventsViewController *eventsVC = [[EventsViewController alloc]init];
    AboutViewController *aboutVC = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    
    //Setting the titles
    newsVC.title = @"News";
    eventsVC.title = @"Events";
    aboutVC.title = @"About";
    
    //Setting the TabBar Image
    newsVC.tabBarItem.image = [UIImage imageNamed:@"News.png"];
    eventsVC.tabBarItem.image = [UIImage imageNamed:@"Events.png"];
    aboutVC.tabBarItem.image = [UIImage imageNamed:@"About.png"];
    
    //Array that holds all the ViewControllers
    NSMutableArray *tabBarViewControllers = [[NSMutableArray alloc]init];
    
    //Adding NavigationBar to all the ViewControllers
    UINavigationController *navigationController = nil;
    navigationController = [[UINavigationController alloc] initWithRootViewController:newsVC];
    [newsVC release];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    [tabBarViewControllers addObject:navigationController];
    [navigationController release];
    navigationController = nil;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:eventsVC];
    [eventsVC release];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    [tabBarViewControllers addObject:navigationController];
    [navigationController release];
    navigationController = nil;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [aboutVC release];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    [tabBarViewControllers addObject:navigationController];
    [navigationController release];
    navigationController = nil;
    
    //adding the ViewControllers to the TabBarController
    self.tabBarController.viewControllers = tabBarViewControllers;
    [tabBarViewControllers release];
    tabBarViewControllers = nil;
    
    [self.view addSubview:self.tabBarController.view];
}

- (void)dealloc {
    [tabBarController release];
    [super dealloc];
}

@end
