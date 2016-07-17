//
//  ViewController.m
//  XibEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
#pragma mark xib使用步骤: 1.创建某个控制器（勾选或不勾选再手动创建xib文件） 2.手动创建的xib，需要拖一个xib的view，在关联控制器和view，File's Owner 的Custom class为某控制器，该控制器的view 设置成刚拖的xib的view。 3.页面跳转：用initwitNib创建待跳转的控制器即可。 
// 注：  若是创建的是某个view的xib（如：cell），对应的view和类名关联起来，File's Owner不需要设置。


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickNext:(id)sender {
    SEL push = @selector(push:);
    [self performSelector:push withObject:self];//perfom 会造成潜在内存泄露,swift 已舍弃
}

- (void)push:(id)sender {
    Class cls;
    cls = NSClassFromString(@"FirstViewController");
//  若类名和xib同名，则加载alloc 和init 会自动加载nib。
    UIViewController *vc = [[cls alloc]initWithNibName:@"FirstViewController" bundle:nil];
    
// 少 返回按钮：是当前控制器的来设置给下一个控制器的,可不设置即直接被下个控制器导航条的leftbarbuttonItem覆盖掉
//    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
//    returnButtonItem.title = @"";
//    self.navigationItem.backBarButtonItem = returnButtonItem;
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置返回按钮
- (void)addBackItemWithAction{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        returnButtonItem.title = @"返回";
        self.navigationItem.backBarButtonItem = returnButtonItem;
    } else {
        // 设置返回按钮的文本
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"返回"
                                       style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
        
        // 设置返回按钮的背景图片
        UIImage *img = [UIImage imageNamed:@"navigation_back.png"];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        // 设置文本与图片的偏移量
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
                                                             forBarMetrics:UIBarMetricsDefault];
        // 设置文本的属性
        NSDictionary *attributes = @{UITextAttributeFont:[UIFont systemFontOfSize:16],
                                     UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]};
        [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
