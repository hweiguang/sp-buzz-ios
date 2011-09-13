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

- (id)init
{
    self = [super init];
    if (self) {
        self.title = [NSString string];
        self.description = [NSString string];
        self.link = [NSString string];
        self.comments = [NSString string]; 
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
