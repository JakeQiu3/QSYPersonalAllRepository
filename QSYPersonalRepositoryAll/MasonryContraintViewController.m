//
// ViewController.m
//  Masonry
//
//  Created by qsy on 15/8/ .
//  Copyright (c) 2015年 QSY. All rights reserved.
//

#import "MasonryContraintViewController.h"
#import "Masonry.h"
@interface MasonryContraintViewController ()

@end

@implementation MasonryContraintViewController

- (void)addTwoUI {
    //添加两个控件
    UIView *blueView = [UIView new];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    // 给blueView设置约束
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(94);//和父view的顶部间距为30;
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(redView.mas_left).offset(-30);//和红色view的间距为30;
        make.height.mas_equalTo(50);
    }];
    NSLog(@"blueView=====%@",NSStringFromCGRect(blueView.frame));
    //给红色View设置约束
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.top.equalTo(blueView.mas_top);
        make.height.equalTo(blueView.mas_height);
        make.width.equalTo(blueView.mas_width);
    }];
    NSLog(@"=====redView%@",NSStringFromCGRect(redView.frame));
}

-(void) addThreeView {
    UIView *sv = [UIView new];
    //在做autoLayout之前 一定要先将view添加到superview上 否则会报错
    sv.backgroundColor = [UIColor greenColor];
    [self.view addSubview:sv];
    //mas_makeConstraints就是Masonry的autolayout添加函数 将所需的约束添加到block中行了
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        //sv居中
        make.center.equalTo(self.view);
        
        //将size设置成(300,300)
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /** masonry*/
    [self addTwoUI];
    [self addThreeView];
    [self setupSubViews];
}

//距离屏幕顶部200,正方形100,居中
- (void)setupSubViews{
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.translatesAutoresizingMaskIntoConstraints = NO;
    imageV.image = [UIImage imageNamed:@"hhh"];
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view.mas_centerX);
        //        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.top.mas_equalTo(self.view.mas_top).offset(400);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
        
    }];
}
@end
