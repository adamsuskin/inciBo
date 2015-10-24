//
//  RecipeTableViewCell.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "RecipeTableViewCell.h"

@implementation RecipeTableViewCell

@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize publisherLabel = _publisherLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
