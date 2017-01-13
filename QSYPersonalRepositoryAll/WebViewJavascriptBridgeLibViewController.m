//
//  WebViewJavascriptBridgeLibViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2017/1/13.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import "WebViewJavascriptBridgeLibViewController.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewJavascriptBridgeLibViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *myWebView;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation WebViewJavascriptBridgeLibViewController
http://www.cnblogs.com/jiang-xiao-yan/p/5345755.html

http://xuyafei.cn/post/cocoatouch/tu-wen-hun-pai
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myWebView];
    [self loadRequestHtml];
    [self creatJSBridge];// 创建bridge
    [self renderButtons:self.myWebView];// 渲染2个button
    [self jsCallNative];// js调用native method
}

- (void)loadRequestHtml {
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.myWebView loadHTMLString:appHtml baseURL:baseURL];
    
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
}

- (void)creatJSBridge {
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView];
    [self.bridge setWebViewDelegate:self];
}

- (void)renderButtons:(UIWebView*)webView {
    // 在webview之上建2个btn
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"打开博文" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(onOpenBlogArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"刷新webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

// JS主动调用OjbC的方法
- (void)jsCallNative {
    // JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        if (responseCallback) {// 反馈给JS的data数据
            responseCallback(@{@"userId": @"123456"});
        }
    }];
    
    [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getBlogNameFromObjC, data from js is %@", data);
        if (responseCallback) {// 反馈给JS的data数据
            responseCallback(@{@"blogName":@"邱少的博客"});
        }
    }];
    
    
    [self.bridge callHandler:@"getUserInfos" data:@"getUserInfos" responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
}

- (void)onOpenBlogArticle:(UIButton *)sender {
    // 调用打开本demo的博文
    [self.bridge callHandler:@"openWebviewBridgeArticle" data:nil];
}

#pragma mark webview的delegate methods 

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载出错:%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView!=_myWebView) {
        return YES;
    }
    NSURL *totalUrl = [request URL];
    NSString *requestStr = [totalUrl absoluteURL];
    
    
    return YES;
}

#pragma mark getter method
- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _myWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:246.0/255 alpha:1.0];
        _myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //    基本属性设置
        _myWebView.scrollView.showsHorizontalScrollIndicator = NO;
        _myWebView.scrollView.showsVerticalScrollIndicator = YES;
        _myWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _myWebView.contentMode = UIViewContentModeScaleAspectFit;
        _myWebView.scalesPageToFit = NO; //是否支持缩放。默认为NO，显示的界面一般是最合适的。
        _myWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _myWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
