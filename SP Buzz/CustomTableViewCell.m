//
//  CustomTableViewCell.m
//  SP Buzz
//
//  Created by Wei Guang on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Primary Label for the title
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        self.titleLabel.textColor = [UIColor redColor];
        self.titleLabel.frame = CGRectMake(10,5,300,20);
        
        //Secondary Label for the subtitle
        self.descriptionLabel = [[UILabel alloc]init];
        self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.descriptionLabel.frame = CGRectMake(145,25,170,80);
        self.descriptionLabel.numberOfLines = 0;
        
        self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 130, 80)];
        self.image.layer.masksToBounds = YES;
        self.image.layer.cornerRadius = 15;
        self.image.layer.borderWidth = 3;
        self.image.layer.borderColor = [UIColor grayColor].CGColor;
        
        [self.contentView addSubview:self.titleLabel]; 
        [self.contentView addSubview:self.descriptionLabel];
        [self.contentView addSubview:self.image];
        
        self.contentView.backgroundColor = UIColorFromRGB(0xE0FFFF);
        self.titleLabel.backgroundColor = UIColorFromRGB(0xE0FFFF);
        self.descriptionLabel.backgroundColor = UIColorFromRGB(0xE0FFFF);
        
    }
    return self;
}

- (void)dealloc {
    [self.titleLabel release];
    [self.descriptionLabel release];
    [self.image release];
    [super dealloc];
}

@end
