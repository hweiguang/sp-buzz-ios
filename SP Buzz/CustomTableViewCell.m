//
//  CustomTableViewCell.m
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomTableViewCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Primary Label for the title
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
        titleLabel.textColor = [UIColor redColor];
        titleLabel.frame = CGRectMake(10,5,300,20);
        
        //Secondary Label for the subtitle
        descriptionLabel = [[UILabel alloc]init];
        descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        descriptionLabel.frame = CGRectMake(145,25,170,80);
        descriptionLabel.numberOfLines = 0;
        
        image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 130, 80)];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 15;
        
        [self.contentView addSubview:titleLabel]; 
        [self.contentView addSubview:descriptionLabel];
        [self.contentView addSubview:image];
        
        self.contentView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
        titleLabel.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
        descriptionLabel.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
        
    }
    return self;
}

- (void)dealloc {
    [titleLabel release];
    [descriptionLabel release];
    [image release];
    [super dealloc];
}

@end
