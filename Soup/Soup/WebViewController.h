//
//  WebViewController.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *titleView;

-(id)initWithURL:(NSString *)URL andFrame:(CGRect)frame;

@end
