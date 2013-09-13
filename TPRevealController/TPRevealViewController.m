//
//  TPRevealViewController.m
//  TPRevealController
//
//  Created by yan simon on 13-9-10.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "TPRevealViewController.h"

@interface TPRevealViewController ()

@end

@implementation TPRevealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupData];
    [self setupViewController];
    
}

#pragma mark Gesture Recognizer
- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture
{
    // 记录速率
    self.velocity = [self.pan velocityInView:self.view];
    // 相对坐标
    CGPoint point = [panGesture translationInView:self.view];
    // 判断方向
    if(point.x > 0)
        self.direction = TPRevealSwipeDirectionRight;
    else
        self.direction = TPRevealSwipeDirectionLeft;

    // Root View 产生位移的条件:在边界范围内,产生>3的位移,标志允许
    if(self.baseRect.origin.x + point.x < self.maxX && self.baseRect.origin.x + point.x > self.minX && fabsf(point.x) > 3.0 && self.canSwipe)
    {
        self.rootViewController.view.frame = CGRectMake(self.baseRect.origin.x + point.x, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
        // 调整Left/Right View的顺序,避免遮挡
        if(self.leftViewController && self.rightViewController)
        {
            if (self.rootViewController.view.frame.origin.x > 0 && self.upperController != TPRevealSwipeDirectionLeft) {
                [self.leftViewController.view removeFromSuperview];
                [self.view insertSubview:self.leftViewController.view aboveSubview:self.rightViewController.view];
                self.upperController = TPRevealSwipeDirectionLeft;
            }
            else if (self.rootViewController.view.frame.origin.x < 0 && self.upperController != TPRevealSwipeDirectionRight)
            {
                [self.rightViewController.view removeFromSuperview];
                [self.view insertSubview:self.rightViewController.view aboveSubview:self.leftViewController.view];
                self.upperController = TPRevealSwipeDirectionRight;
            }
        }
    }
}
- (void)gestureRecognizerDidTap:(UIPanGestureRecognizer*)panGesture
{
    [self showRootViewController];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat x = self.rootViewController.view.frame.origin.x;
    
    BOOL shouldQuickSwipe = NO;
    if(self.velocity.x > 200.0 || self.velocity.x < -200.0) // 支持快速滑动的手势
    {
        shouldQuickSwipe = YES;
    }
    
    // 计算动画时间
    CGFloat timeInterval =fabsf(320.0 / self.velocity.x);
    timeInterval = (timeInterval < 0.2)?timeInterval:0.2;
    
    // 动画后的位置
    CGRect endRect = CGRectZero;
    
    switch (self.direction) {
        case TPRevealSwipeDirectionLeft:
        {
            CGFloat midX = self.baseRect.origin.x - self.offSet / 2;
            if(midX > self.minX)
            {
                if(x > midX && !shouldQuickSwipe)
                    endRect = self.baseRect;
                else
                    endRect = CGRectMake(self.baseRect.origin.x - self.offSet, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            }
        }
            break;
        case TPRevealSwipeDirectionRight:
        {
            CGFloat midX = self.baseRect.origin.x + self.offSet / 2;
            if(midX < self.maxX)
            {
                if(x < midX && !shouldQuickSwipe)
                    endRect = self.baseRect;
                else
                    endRect = CGRectMake(self.baseRect.origin.x + self.offSet, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            }
        }
            break;
        default:
            
            break;
    }
    
    // start animation
    if(!CGRectEqualToRect(endRect, CGRectZero))
    {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:timeInterval animations:^{
            self.rootViewController.view.frame = endRect;
        } completion:^(BOOL Finished){
            self.rootViewController.view.frame = endRect;
            self.baseRect = endRect;
        }];
    }

}

#pragma mark animation
-(void)showRootViewController
{
    if(!self.rootViewController)
        return ;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.19f animations:^{
        self.rootViewController.view.frame = self.centerRect;
    } completion:^(BOOL Finished){
        self.rootViewController.view.frame = self.centerRect;
        self.baseRect = self.centerRect;
    }];
}

-(void)showLeftViewController
{
    if(!self.leftViewController)
        return ;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.19f animations:^{
        self.rootViewController.view.frame = self.rightRect;
    } completion:^(BOOL Finished){
        self.rootViewController.view.frame = self.rightRect;
        self.baseRect = self.rightRect;
    }];
}

-(void)showRightViewController
{
    if(!self.rightViewController)
        return ;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.19f animations:^{
        self.rootViewController.view.frame = self.leftRect;
    } completion:^(BOOL Finished){
        self.rootViewController.view.frame = self.leftRect;
        self.baseRect = self.leftRect;
    }];
}

// 在Left和Right都有的情况下隐藏左边。必须在视图加载后才可调用,因为ViewDidLoad会先Setup一次数据。
-(void)setLeftViewControllerEnable:(BOOL)enable  
{
    if(!(self.leftViewController && self.rightViewController))
        return ;
    
    if(!enable)  // 通过改变边界值来限制滑动
    {
        self.minX = - self.offSet;
        self.maxX = 0.0;
    }
    else
    {
        self.minX = - self.offSet;
        self.maxX = self.offSet;
    }
}
// 在Left和Right都有的情况下隐藏右边。
-(void)setRightViewControllerEnable:(BOOL)enable
{
    if(!(self.leftViewController && self.rightViewController))
        return ;
    
    if(!enable)  // 通过改变边界值来限制滑动
    {
        self.minX = 0.0 ;
        self.maxX = self.offSet;
    }
    else
    {
        self.minX = - self.offSet;
        self.maxX = self.offSet;
    }
}

#pragma mark init
-(void)setupData
{
    self.offSet = 250.0;    // 默认230.0
    // 原来的view要考虑电池栏,故y为20,现在调整一下
    self.rootViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 20);
    self.leftViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 20);
    self.rightViewController.view.frame = CGRectMake(0, 0, 320.0, self.view.bounds.size.height + 20);
    self.baseRect = self.rootViewController.view.frame;
    self.leftRect = CGRectMake(- self.offSet, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.centerRect = CGRectMake(0.0, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.rightRect = CGRectMake(self.offSet, self.baseRect.origin.y, self.baseRect.size.width, self.baseRect.size.height);
    self.canSwipe = YES;
    
    if(self.leftViewController && self.rightViewController)
    {
        self.minX = - self.offSet;
        self.maxX = self.offSet;
    }
    else if(self.leftViewController && !self.rightViewController)
    {
        self.minX = 0.0;
        self.maxX = self.offSet;
    }
    else if(!self.leftViewController && self.rightViewController)
    {
        self.minX = - self.offSet;
        self.maxX = 0.0;
    }
    else
    {
        self.minX = 0.0;
        self.maxX = 0.0;
    }
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
    self.pan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.pan];  // 当前的View处理触摸事件
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidTap:)];
    [self.view addGestureRecognizer:self.tap];
}
-(void)setupViewController
{
    if(self.rightViewController)
        [self.view addSubview:self.rightViewController.view];
    if(self.leftViewController)
        [self.view addSubview:self.leftViewController.view];
    if(self.rootViewController)
    {
        [self.view addSubview:self.rootViewController.view];
        [self addShadowToRootView];
    }
    
    if(self.leftViewController && self.rightViewController)  // 初始化相对顺序在上面的视图是左边的
        self.upperController = TPRevealSwipeDirectionLeft;
    
}
-(void)addShadowToRootView
{
    self.rootViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.rootViewController.view.bounds].CGPath;
    self.rootViewController.view.layer.shadowOffset = CGSizeMake(0, 3);
    self.rootViewController.view.layer.shadowRadius = 10.0;
    self.rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.rootViewController.view.layer.shadowOpacity = 0.8;
    self.rootViewController.view.layer.masksToBounds = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
