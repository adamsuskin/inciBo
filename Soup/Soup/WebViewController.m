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
        
        self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];

        self.view.backgroundColor = [UIColor colorWithRed:189.f/255.f green:62.f/255.f blue:56.f/255.f alpha:1];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityView setColor:[UIColor blackColor]];
        
        CGRect currFrame = [self.activityView frame];
        [self.activityView setFrame:CGRectMake(self.view.center.x - (currFrame.size.width/2), self.view.center.y - (currFrame.size.height/2), currFrame.size.width, currFrame.size.height)];
        [self.activityView startAnimating];
        
        self.recipe = recipe;
        self.url = [self.recipe source_url];
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 75, frame.size.width, frame.size.height - 75)];
        self.webView.delegate = self;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        self.view = [[UIView alloc] initWithFrame:frame];
        self.webView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.webView];
        [self.view addSubview:self.activityView];

        
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
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [shareButton setFrame:CGRectMake(self.titleView.frame.size.width-8-45, self.titleView.frame.size.height-8-35, 45, 35)];
        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:shareButton];
        [self.titleView addSubview:button];
        [self.titleView addSubview:recipeLabel];
        [self.view addSubview:self.titleView];
        
        self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        
        self.shareContentView = [[UIView alloc] initWithFrame:CGRectMake(self.shareView.frame.size.width / 8, self.shareView.frame.size.height / 4, 3 * self.shareView.frame.size.width / 4, self.shareView.frame.size.height / 2)];
        [self.shareContentView setBackgroundColor:[UIColor colorWithRed:1 green:88.f/255.f blue:79.f/255.f alpha:1]];
        self.shareContentView.layer.cornerRadius = 20;
        self.shareContentView.layer.masksToBounds = YES;
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.shareContentView.frame.size.height / 12, self.shareContentView.frame.size.width, self.shareContentView.frame.size.height / 3)];
        [shareLabel setNumberOfLines:2];
        [shareLabel setText:@"Share With Friends"];
        [shareLabel setTextAlignment:NSTextAlignmentCenter];
        [shareLabel setTextColor:[UIColor whiteColor]];
        [shareLabel setFont:[UIFont fontWithName:@"GillSans-Bold" size:30.0]];
        [self.shareContentView addSubview:shareLabel];
        
        self.fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [[self.fbButton titleLabel] setText:@"Facebook"];
        [[self.fbButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self.fbButton titleLabel] setTextColor:[UIColor whiteColor]];
        [self.fbButton setTitle:@"Facebook" forState:UIControlStateNormal];
        [[self.fbButton titleLabel] setFont:[UIFont fontWithName:@"GillSans-SemiBold" size:30.0]];
        [self.fbButton setFrame:CGRectMake(0, self.shareContentView.frame.size.height / 2, self.shareContentView.frame.size.width, self.shareContentView.frame.size.height / 6)];
        [self.fbButton addTarget:self action:@selector(fb:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareContentView addSubview:self.fbButton];
        
        self.twButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [[self.twButton titleLabel] setText:@"Twitter"];
        [[self.twButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self.twButton titleLabel] setTextColor:[UIColor whiteColor]];
        [self.twButton setTitle:@"Twitter" forState:UIControlStateNormal];
        [[self.twButton titleLabel] setFont:[UIFont fontWithName:@"GillSans-SemiBold" size:30.0]];
        [self.twButton setFrame:CGRectMake(0, 2 * self.shareContentView.frame.size.height / 3, self.shareContentView.frame.size.width, self.shareContentView.frame.size.height / 6)];
        [self.twButton addTarget:self action:@selector(tw:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareContentView addSubview:self.twButton];

        UIButton *hideShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hideShareButton.backgroundColor = [UIColor whiteColor];
        hideShareButton.frame = CGRectMake(self.shareContentView.frame.size.width - 30, -30, 90, 90);
        hideShareButton.layer.cornerRadius = hideShareButton.frame.size.width / 2;
        hideShareButton.clipsToBounds = YES;
        [hideShareButton addTarget:self action:@selector(hideShare:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareContentView addSubview:hideShareButton];
        
        [self.shareView addSubview:self.shareContentView];
        [self.shareView setHidden:YES];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tapGestureRecognizer setNumberOfTouchesRequired:1];
        
        [self.shareView addGestureRecognizer:tapGestureRecognizer];
        
        [self.view addSubview:self.shareView];

    }
    return self;
}

-(void)tap:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint touchPoint = [tapGestureRecognizer locationInView:self.shareContentView];
    if(touchPoint.x < 0 || touchPoint.x > self.shareContentView.frame.size.width)
        [self hideShare:nil];
    else if(touchPoint.y < 0 || touchPoint.y > self.shareContentView.frame.size.height)
        [self hideShare:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
}

-(void)back:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{}];
}

-(void)share:(id)sender {
    self.shareView.layer.opacity = 0;
    self.shareView.hidden = NO;
    
    [UIView beginAnimations:@"opacity" context:NULL];
    [UIView setAnimationDuration:0.5f];
    
    self.shareView.layer.opacity = 1;
    
    [UIView commitAnimations];
    
    self.fbButton.layer.opacity = 0;
    self.fbButton.layer.transform = CATransform3DTranslate(self.fbButton.layer.transform, 0, 15, 0);
    
    self.twButton.layer.opacity = 0;
    self.twButton.layer.transform = CATransform3DTranslate(self.twButton.layer.transform, 0, 15, 0);
    
    for(int i = 1; i < 3; i++) {
        [UIView animateWithDuration:0.5f
                              delay:((NSTimeInterval) i)*0.25
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             if(i == 1) {
                                 self.fbButton.layer.opacity = 1;
                                 self.fbButton.layer.transform = CATransform3DIdentity;
                             }
                             else {
                                 self.twButton.layer.opacity = 1;
                                 self.twButton.layer.transform = CATransform3DIdentity;
                             }
                         }
                         completion:nil];
    }
}

-(void)hideShare:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.shareView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         self.shareView.hidden = YES;
                     }];
    
}

-(void)fb:(id)sender {
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    [linkContent setContentTitle:[self.recipe title]];
    [linkContent setContentURL:[NSURL URLWithString:[self.recipe source_url]]];
    [linkContent setImageURL:[NSURL URLWithString:[self.recipe image_url]]];
    
    [FBSDKShareDialog showFromViewController:self withContent:linkContent delegate:nil];
}

-(void)tw:(id)sender {
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tweet" message:@"Enter your description here:" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = [NSString stringWithFormat:@"Wow this recipe is awesome!"];
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *tweet = [NSString stringWithFormat:@"%@ - %@", [[[alertController textFields] objectAtIndex:0] text], self.recipe.source_url];
            
            [self.twitter postStatusUpdate:tweet
                         inReplyToStatusID:nil
                                  latitude:nil
                                 longitude:nil
                                   placeID:nil
                        displayCoordinates:nil
                                  trimUser:nil
                              successBlock:^(NSDictionary *status) {
                                  NSLog(@"Posted status\n");
                              } errorBlock:^(NSError *error) {
                                  NSLog(@"Error posting status\n");
                                  NSLog(@"Error: %@", [error localizedDescription]);

                              }];
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@\n", [error localizedDescription]);
    }];

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
