//
//  ViewController.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "ViewController.h"

static NSString * const kAppID = @"-V_qsW0d5vPvIrZORKs39o0zuYmmtVvqEPj8mltc";
static NSString * const kAppSecret = @"XqdAmXs_bVMytwbyE66oYAG-Icz7WLqTY9s95kWL";

@interface ViewController ()
@property (strong, nonatomic) ClarifaiClient *client;
@property (strong, nonatomic) NSString *mostRecentSearch;
@property (strong ,nonatomic) NSString *fileContentsString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self recognizeImage:[UIImage imageNamed:@"dairy-and-eggs.jpg"]];
}

- (IBAction)buttonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        [self recognizeImage:image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (ClarifaiClient *)client {
    if (!_client) {
        _client = [[ClarifaiClient alloc] initWithAppID:kAppID appSecret:kAppSecret];
        // Uncomment this to request embeddings. Contact us to enable embeddings for your app:
        // _client.enableEmbed = YES;
    }
    return _client;
}

- (void)update {
    
    NSArray *tokens = [[self mostRecentSearch] componentsSeparatedByString:@", "];
    
    NSError *error = nil;
    
    if (!self.fileContentsString) {
        NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"foods" ofType:@"txt"]];
        self.fileContentsString = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    }
    
    if (!self.fileContentsString) {
        NSLog(@"Error reading file: %@", [error localizedDescription]);
        return;
    }
    
    NSMutableString *usefulTokens = [[NSMutableString alloc] initWithString:@"http://food2fork.com/api/search?key=567fe60894262b4177afe245e7ffc36f&q="];
    
    for (NSString *token in tokens) {
        NSRange result = [self.fileContentsString rangeOfString:token];
        if(result.location != NSNotFound) {
            [usefulTokens appendString:[[[token lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"&"]];
        }
    }
    
    if([usefulTokens length] > 0) {
        usefulTokens = (NSMutableString *)[usefulTokens stringByReplacingCharactersInRange:NSMakeRange([usefulTokens length] - 1, 1) withString:@""];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:usefulTokens parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            //use dictionary here
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }
}

- (void)recognizeImage:(UIImage *)image {
    // Scale down the image. This step is optional. However, sending large images over the
    // network is slow and does not significantly improve recognition performance.
    CGSize size = CGSizeMake(320, 320 * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Encode as a JPEG.
    NSData *jpeg = UIImageJPEGRepresentation(scaledImage, 0.9);
    
    // Standard Recognition: Send the JPEG to Clarifai for standard image tagging.
    [self.client recognizeJpegs:@[jpeg] completion:^(NSArray *results, NSError *error) {
        // Handle the response from Clarifai. This happens asynchronously.
        if (error) {
            NSLog(@"Error: %@", error);
            self.mostRecentSearch = NULL;
        } else {
            ClarifaiResult *result = results.firstObject;
            self.mostRecentSearch = [NSString stringWithFormat:@"%@",
                                     [result.tags componentsJoinedByString:@", "]];
        }
        [self update];
    }];
}

@end
