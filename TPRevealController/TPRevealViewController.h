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
    TPRevealSwipeDirectionLeft,
    TPRevealSwipeDirectionRight
}
TPRevealSwipeDirection;

typedef enum
{
    TPRevealViewControllerLeft,
    TPRevealViewControllerRight,
    TPRevealViewControllerCenter,
}
TPRevealViewControllerType;

@interface TPRevealViewController : UIViewController

@property (nonatomic,strong) UIViewController *leftViewController;
@property (nonatomic,strong) UIViewController *rightViewController;
@property (nonatomic,strong) UIViewController *rootViewController;

@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,assign) CGFloat offSet;             // 偏移量
@property (nonatomic,assign) CGFloat minX;
@property (nonatomic,assign) CGFloat maxX;
@property (nonatomic,assign) CGRect baseRect;            // root view当前位置的Rect
@property (nonatomic,assign) const CGRect leftRect;      // root view最左位置的Rect
@property (nonatomic,assign) const CGRect centerRect;    // root view中间位置的Rect
@property (nonatomic,assign) const CGRect rightRect;     // root view最右位置的Rect
@property (nonatomic,assign) CGPoint velocity;           // 滑动速率
@property (nonatomic,assign) TPRevealSwipeDirection direction;  // 滑动方向
@property (nonatomic,assign) TPRevealViewControllerType upperController;   // 在上面的视图
@property (nonatomic,assign) BOOL canSwipe;

-(void)showRootViewController;

-(void)showLeftViewController;

-(void)showRightViewController;

-(void)setLeftViewControllerEnable:(BOOL)enable;

-(void)setRightViewControllerEnable:(BOOL)enable;

@end
