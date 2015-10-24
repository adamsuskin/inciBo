//
//  DataManager.m
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (id)sharedManager {
    static DataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    return dataManager;
}

- (void)notify {
    for(id<DataSubscriber> subscriber in self.subscribers)
        [subscriber dataUpdated];
}

- (ClarifaiClient *)client {
    if (!_client) {
        _client = [[ClarifaiClient alloc] initWithAppID:kAppID appSecret:kAppSecret];
        // Uncomment this to request embeddings. Contact us to enable embeddings for your app:
        // _client.enableEmbed = YES;
    }
    return _client;
}

- (void)addToSubscribers:(id<DataSubscriber>)subscriber {
    [self.subscribers addObject:subscriber];
}

- (void)parseResults:(NSDictionary *)dictionary {
    
    [self.recipes removeAllObjects];
    
    NSArray *results = (NSArray *)[dictionary valueForKey:@"recipes"];
    for (NSDictionary *recipeDict in results) {
        Recipe *recipe = [[Recipe alloc] init];
        [recipe setTitle:[recipeDict valueForKey:@"title"]];
        [recipe setPublisher:[recipeDict valueForKey:@"publisher"]];
        [recipe setSource_url:[recipeDict valueForKey:@"source_url"]];
        [recipe setImage_url:[recipeDict valueForKey:@"image_url"]];
        
        [self.recipes addObject:recipe];
    }
    
    [self notify];
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
            [self parseResults:dictionary];
            
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


- (id)init {
    if(self = [super init]) {
        [self client];
        self.recipes = [[NSMutableArray alloc] init];
        self.subscribers = [[NSMutableArray alloc] init];
        self.mostRecentSearch = @"";
    }
    return self;
}

@end
