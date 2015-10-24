//
//  WebViewController.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "WebViewController.h"
#import "Recipe.h"

@interface WebViewController ()

@end

@implementation WebViewController

-(id)initWithRecipe:(Recipe *)recipe andFrame:(CGRect)frame {
    self = [super init];
    if(self) {
        self.recipe = recipe;
        self.url = [self.recipe source_url];
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 75, frame.size.width, frame.size.height - 75)];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        self.view = [[UIView alloc] initWithFrame:frame];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.webView];
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 10, frame.size.width, 65)];
        self.titleView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10, 10, 45, 45)];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:button];
        [self.view addSubview:self.titleView];
    }
    return self;
}

-(void)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
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
