//
//  ViewController.h
//  Soup
//
//  Created by Adam Suskin on 10/24/15.
//  Copyright © 2015 Adam Suskin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (assign, nonatomic) BOOL hasPicked;

@end

