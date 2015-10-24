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
    [[DataManager sharedManager] recognizeImage:[UIImage imageNamed:@"dairy-and-eggs.jpg"]];
}

- (IBAction)back:(id)sender {
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

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[DataManager sharedManager] recipes] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableIdentifier = @"RecipeTableViewCell";
    
    RecipeTableViewCell *cell = (RecipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecipeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Recipe *recipe = [[[DataManager sharedManager] recipes] objectAtIndex:indexPath.row];
    
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
    
    Recipe *recipe = [[[DataManager sharedManager] recipes] objectAtIndex:indexPath.row];
    
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
