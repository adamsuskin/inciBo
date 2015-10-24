//
//  RecipeViewController.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataManager.h"
#import "RecipeTableViewCell.h"
#import "Recipe.h"
#import "DataSubscriber.h"
#import "WebViewController.h"

@interface RecipeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataSubscriber>

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
