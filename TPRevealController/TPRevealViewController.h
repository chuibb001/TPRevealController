//
//  TPRevealViewController.h
//  TPRevealController
//
//  Created by yan simon on 13-9-10.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    TPRevealViewControllerLeft,
    TPRevealViewControllerRight,
    
    TPRevealViewControllerCenter,
}
TPRevealViewControllerType;

@interface TPRevealViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic,strong) UIViewController *rightViewController;
@property (nonatomic,strong) UIViewController *rootViewController;
@property (nonatomic,assign) CGFloat leftOffSet;
@property (nonatomic,assign) CGFloat rightOffSet;


+(id)sharedInstance;

/**
 *  show viewcontroller
 */
-(void)showRootViewControllerAnimated:(BOOL)animate;
-(void)showLeftViewControllerAnimated:(BOOL)animate;
-(void)showRightViewControllerAnimated:(BOOL)animate;

/**
 *  enable viewcontroller
 */
-(void)setLeftViewControllerEnable:(BOOL)enable;
-(void)setRightViewControllerEnable:(BOOL)enable;

/**
 *  change root viewcontroller
 */
-(void)changeRootViewController:(UIViewController *) rootController;

/**
 *  is showing root viewcontroller
 */
-(BOOL)isCentered;

@end
