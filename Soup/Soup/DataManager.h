//
//  DataManager.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ClarifaiClient.h"
#import "Recipe.h"
#import "DataSubscriber.h"

static NSString * const kAppID = @"-V_qsW0d5vPvIrZORKs39o0zuYmmtVvqEPj8mltc";
static NSString * const kAppSecret = @"XqdAmXs_bVMytwbyE66oYAG-Icz7WLqTY9s95kWL";

@interface DataManager : NSObject

@property (strong, nonatomic) NSMutableArray *subscribers;

@property (strong, nonatomic) NSString *mostRecentSearch;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) ClarifaiClient *client;
@property (strong ,nonatomic) NSString *fileContentsString;


+ (id)sharedManager;

- (void)recognizeImage:(UIImage *)image;

- (void)addToSubscribers:(id<DataSubscriber>)subscriber;

@end
