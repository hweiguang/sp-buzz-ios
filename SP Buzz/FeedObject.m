//
//  FeedObject.m
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedObject.h"

@implementation FeedObject

@synthesize title;
@synthesize description;
@synthesize link;
@synthesize comments;
@synthesize icon;

- (id)init
{
    self = [super init];
    if (self) {
        title = [[NSString alloc]init];
        description = [[NSString alloc]init];
        link = [[NSString alloc]init];
        comments = [[NSString alloc]init]; 
    }
    
    return self;
}

- (void)dealloc {
    [title release];
    [description release];
    [link release];
    [comments release];
    [super dealloc];
}

@end
