//
//  Recipe.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Recipe : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *source_url;
@property (strong, nonatomic) NSString *image_url;

@end
