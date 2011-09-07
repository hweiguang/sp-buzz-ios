//
//  FeedObject.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedObject : NSObject {
    NSString *title;
    NSString *description;
    NSString *link;
    NSString *comments;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *link;
@property (nonatomic,retain) NSString *comments;

@end
