//
//  AppDelegate.h
//  TPRevealController
//
//  Created by yan simon on 13-9-10.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPRevealViewController.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TPRevealViewController *viewController;

@end
