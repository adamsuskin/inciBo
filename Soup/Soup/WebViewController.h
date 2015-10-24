//
//  WebViewController.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
@class Recipe;

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) Recipe *recipe;

-(id)initWithRecipe:(Recipe *)recipe andFrame:(CGRect)frame;

@end
