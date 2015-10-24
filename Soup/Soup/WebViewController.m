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
        self.view.backgroundColor = [UIColor colorWithRed:1 green:88.f/255.f blue:79.f/255.f alpha:1];
        [self.view addSubview:self.webView];
        
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 75)];
        self.titleView.backgroundColor = [UIColor colorWithRed:1 green:88.f/255.f blue:79.f/255.f alpha:1];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(8, self.titleView.frame.size.height-8-45, 45, 45)];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *recipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y, self.titleView.frame.size.width, button.frame.size.height)];
        [recipeLabel setText:@"Recipe"];
        [recipeLabel setTextColor:[UIColor whiteColor]];
        [recipeLabel setTextAlignment:NSTextAlignmentCenter];
        [recipeLabel setFont:[UIFont fontWithName:@"GillSans-SemiBold" size:38.0]];
        
        [self.titleView addSubview:button];
        [self.titleView addSubview:recipeLabel];
        [self.view addSubview:self.titleView];
    }
    return self;
}

-(void)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
