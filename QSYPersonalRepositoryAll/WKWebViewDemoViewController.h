//
//  WKWebViewDemoViewController.h
//  QSYPersonalRepositoryAll
//
/**
 * 
 1、WK的基本用法：
 加载网页html
 加载的状态回调：对应代理方法
 新增的WKUIDelegate协议
 动态加载并运行JS代码
 webView 执行JS代码
 JS调用App注册过的方法
 * 
 2、
 *
 *
 */
//  Created by 邱少依 on 16/6/22.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKWebViewDemoViewController : UIViewController
@property (nonatomic, copy) NSString *payUrl;

@end
