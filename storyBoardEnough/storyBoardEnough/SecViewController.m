//
//  SecViewController.m
//  storyBoardEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "SecViewController.h"

@interface SecViewController ()<UIViewControllerRestoration>

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
//    设置状态恢复的标示和恢复对象
    self.restorationIdentifier = @"resetIdentifier";
    self.restorationClass = [self class];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实现恢复协议方法
+ (nullable UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
 NSLog(@"viewControllerWithRestorationIdentifierPath: %@", identifierComponents);
    
    SecViewController *vc = [[SecViewController alloc] init];
    vc.restorationIdentifier = [identifierComponents lastObject];
    vc.restorationClass = [self class];
    return vc;
}
//从后台返回到前台的时候对应的能够恢复到对应的页面，具体subView的数据状态恢复还需要实现以下方法。
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    //[coder encodeObject:AnyObject forKey:@“AnyKey"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    //AnyObject = [coder decodeObjectForKey:@“AnyKey"];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
