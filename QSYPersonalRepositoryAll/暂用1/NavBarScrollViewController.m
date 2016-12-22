//
//  NavBarViewController.m
//  NavigationBarSliding
//
//  Created by US10 on 16/7/21.
//  Copyright © 2016年 US10. All rights reserved.
//

#import "NavBarScrollViewController.h"
#define NavBarFrame self.navigationController.navigationBar.frame
@interface NavBarScrollViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic)  UIView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIView *overLay;
@property (assign, nonatomic) BOOL isHidden;
@end

@implementation NavBarScrollViewController

- (UIView *)overLay{
    if (_overLay == nil) {
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        self.panGesture.delegate = self;
        self.panGesture.minimumNumberOfTouches = 1;
        [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
        [self.scrollView addGestureRecognizer:self.panGesture];
        self.overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        self.overLay.alpha = 0;
        self.overLay.backgroundColor = self.navigationController.navigationBar.barTintColor;
    }
    return _overLay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置跟随滚动的滑动试图
-(void)followSwipeScrollView:(UIView *)scrollView
{
    self.scrollView = scrollView;
    self.isHidden = NO;
    [self.navigationController.navigationBar addSubview:self.overLay];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

#pragma mark - 兼容其他手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - 手势调用函数
-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];
    NSLog(@"translation = %f",translation.y);
    //显示
    if (translation.y >= 5) {
        if (self.isHidden) {
            
            self.overLay.alpha = 0;
            CGRect navBarFrame = NavBarFrame;
            CGRect scrollViewFrame = self.scrollView.frame;
            
            navBarFrame.origin.y = 20;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.5 animations:^{
                NavBarFrame = navBarFrame;
                self.scrollView.frame = scrollViewFrame;
            }];
            self.isHidden = NO;
        }
    }
    //隐藏
    if (translation.y <= -20) {

        if (!self.isHidden) {
            
            CGRect frame = NavBarFrame;
            CGRect scrollViewFrame = self.scrollView.frame;
            frame.origin.y = -24;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                self.scrollView.frame = scrollViewFrame;
            } completion:^(BOOL finished) {
                self.overLay.alpha = 1;
            }];
            self.isHidden = YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect navBarFrame = NavBarFrame;
        navBarFrame.origin.y = 20;
        self.navigationController.navigationBar.frame = navBarFrame;
    } completion:^(BOOL finished) {
        //此行代码是必须写的，不然self.overLay会挡在navigationBar上面，不仅导航栏的title被遮盖住，返回按钮也不起作用，alpha = 0是不能响应事件的。
        self.overLay.alpha = 0;
    }];
}

@end
