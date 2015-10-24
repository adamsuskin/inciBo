//
//  ViewController.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hasPicked = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    if(!self.hasPicked) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = NO;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.hasPicked = YES;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [[DataManager sharedManager] recognizeImage:image];
        [self dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"displayRecipesSegue" sender:self];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
