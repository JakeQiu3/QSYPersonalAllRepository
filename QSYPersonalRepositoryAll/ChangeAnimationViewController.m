//
//  ChangeAnimationViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/23.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ChangeAnimationViewController.h"
#import "ChangeAnimationView.h"

@interface ChangeAnimationViewController ()
@property (nonatomic, strong) ChangeAnimationView *animationView;
@end

@implementation ChangeAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _animationView = [[ChangeAnimationView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 120)];
    [self.view addSubview:_animationView];
    
    
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(10, 300, 100, 50);
    [startButton addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"启动动画" forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(110, 300, 100, 50);
    [stopButton addTarget:self action:@selector(stopAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [stopButton setTitle:@"暂停动画" forState:UIControlStateNormal];
    [self.view addSubview:stopButton];
    
    UIButton *resumeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resumeButton.frame = CGRectMake(210, 300, 100, 50);
    [resumeButton addTarget:self action:@selector(resumeAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [resumeButton setTitle:@"恢复动画" forState:UIControlStateNormal];
    [self.view addSubview:resumeButton];

}

-(void)startAnimation:(UIButton *)sender
{
    [_animationView startAnimation];
}


-(void)stopAnimation:(UIButton *)sender
{
    [_animationView stopAnimation];
}

-(void)resumeAnimation:(UIButton *)sender
{
    [_animationView resumeAnimation];
}

@end
