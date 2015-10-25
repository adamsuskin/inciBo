//
//  WebViewController.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <STTwitter/STTwitter.h>
#import "DataManager.h"
@class Recipe;

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIButton *fbButton;
@property (strong, nonatomic) UIButton *twButton;
@property (strong, nonatomic) STTwitterAPI *twitter;

-(id)initWithRecipe:(Recipe *)recipe andFrame:(CGRect)frame;

@end
