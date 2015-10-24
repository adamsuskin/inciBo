//
//  WebViewController.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

-(id)initWithURL:(NSString *)URL andFrame:(CGRect)frame {
    self = [super init];
    if(self) {
        self.url = URL;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 75, frame.size.width, frame.size.height - 75)];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        self.view = [[UIView alloc] initWithFrame:frame];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.webView];
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 10, frame.size.width, 65)];
        self.titleView.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.titleView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
