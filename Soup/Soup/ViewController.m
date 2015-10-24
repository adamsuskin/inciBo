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
    
    UIImageView *backscreen = [[UIImageView alloc] initWithFrame:[[self view] frame]];
    [backscreen setImage:[UIImage imageNamed:@"Default.png"]];
    [[self view] addSubview:backscreen];
    
    self.hasPicked = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    if(!self.hasPicked) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera Not Found" message:@"There is no accessible camera on this device. Sorry!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Time for a new phone.." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
            
        }
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
            self.hasPicked = NO;
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
