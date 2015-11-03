//
//  RecipeViewController.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "RecipeViewController.h"

@interface RecipeViewController ()

@end

@implementation RecipeViewController
@synthesize titleView = _titleView;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedManager] addToSubscribers:self];
    
    [[self tableView] setBackgroundView:nil];
    [[self tableView] setBackgroundColor:[UIColor colorWithRed:189.f/255.f green:62.f/255.f blue:58.f/255.f alpha:1]];
    
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor colorWithRed:1 green:88.f/255.f blue:79.f/255.f alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back:)];
    [backItem setTintColor:[UIColor whiteColor]];
    [[self navigationItem] setLeftBarButtonItem:backItem];
    
    [self setTitle:@"Discover"];
    
}

- (IBAction)back:(id)sender {
    [[[DataManager sharedManager] recipes] removeAllObjects];
    [self performSegueWithIdentifier:@"cameraSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataUpdated {
    [[self tableView] reloadData];
}
#pragma mark - Table View Data Source

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CATransform3D transform = CATransform3DTranslate([[cell layer] transform], -30, 0, 0);
    cell.layer.transform = transform;
    cell.alpha = 0;

    
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    [UIView commitAnimations];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[[DataManager sharedManager] recipes] count];
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[DataManager sharedManager] recipes] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"RecipeTableViewCell";
    
    RecipeTableViewCell *cell = (RecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Recipe *recipe = [[[DataManager sharedManager] recipes] objectAtIndex:indexPath.section];
    
    cell.titleLabel.text = recipe.title;
    cell.publisherLabel.text = recipe.publisher;
    
    cell.imageView.image = nil;
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[recipe image_url]]]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        cell.imageView.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    Recipe *recipe = [[[DataManager sharedManager] recipes] objectAtIndex:indexPath.section];
    
    WebViewController *viewController = [[WebViewController alloc] initWithRecipe:recipe andFrame:self.view.frame];
    
    [self presentViewController:viewController animated:YES completion:^{}];
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
