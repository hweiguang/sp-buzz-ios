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
        title = [NSString string];
        description = [NSString string];
        link = [NSString string];
        comments = [NSString string]; 
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
