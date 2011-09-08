//
//  CustomTableViewCell.h
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@interface CustomTableViewCell : UITableViewCell {
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    UIImageView *image;
}

@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *descriptionLabel;
@property(nonatomic,retain) UIImageView *image;

@end
