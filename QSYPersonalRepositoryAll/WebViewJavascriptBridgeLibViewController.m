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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"table为html,下2button为native";
    [self.view addSubview:self.myWebView];
    [self loadRequestHtml];
    [self creatJSBridge];// 创建bridge
    [self renderButtons:self.myWebView];// 渲染2个native的button，用于调用js
    [self jsCallNative];// js调用native
}

- (void)loadRequestHtml {
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"tesJavascriptBridge" ofType:@"html"];
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
    // 在webview的superview上建2个btn
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"OC调用JS" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(onOpenNewMan:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark 1、JS调用OjbC
- (void)jsCallNative {
    // JS会调用getUserIdFromObjC 和getBlogNameFromObjC 这2个OC方法，这是OC注册给JS调用的
    /*
     * @parameter handlerName ：注册的OC方法供js调用；
     * @parameter data ：js传递给OC的参数，可不传
                        responseCallback: OC通过该block执行回调，把返回值的传递给JS
     */
    [self.bridge registerHandler:@"getUserIdFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"这是我的OC方法，看JS调不调,js call getUserIdFromObjC, data from js is %@", data);
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
    
//    补充1：OC主动调用JS中已经公开的api方法getUserInfos，并传递参数data给JS
    [self.bridge callHandler:@"getUserInfos" data:@"邱少一怎一个帅字了得" responseCallback:^(id responseData) {// JS返回给OC
        NSLog(@"第1次调用的返回值 from js: %@", responseData);
    }];
    
    
    //补充2：这样行么？答案可以告诉你，确定是不行的。
    [self.bridge registerHandler:@"qsyLoveYou" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"我就看看回调了么%@",data);
    }];
    
    [self.bridge callHandler:@"qsyLoveYou" data:@"我爱你少一"];
}

#pragma mark 2、OC调用JS：
//onOpenBlogArticle为OC中btn的click方法,通过bride执行callHandler调用js中名称为handlerName的方法，并可以将OC的data数据传递给js。这就实现了OC调用JS。
//表现：在WebViewJavascriptBridge内部执行了
//- (NSString*) _evaluateJavascript:(NSString*)javascriptCommand
//{
//    return [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
//}
//本质：调用webView的stringByEvaluatingJavaScriptFromString。
- (void)onOpenNewMan:(UIButton *)sender {
    //    [self.bridge callHandler:@"openWebviewBridgeNewMan"];
    //    [self.bridge callHandler:@"openWebviewBridgeNewMan" data:nil];
     [self.bridge callHandler:@"openWebviewBridgeNewMan" data:@{@"name":@"把邱少一传给js看看会怎么样"} responseCallback:^(id responseData) {
         NSLog(@"js方法执行完后，返回给OC的是:%@",responseData);
    }];
}

#pragma mark webview的delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"当前执行的方法名：%@",NSStringFromSelector(_cmd));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"当前执行的方法名：%@",NSStringFromSelector(_cmd));
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载出错:%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView!=_myWebView) {
        return YES;
    }
    NSURL *totalUrl = [request URL];
    NSString *requestStr = [totalUrl absoluteString];
    NSLog(@"当前执行的方法名：%@, get currentLoadUrl:%@",NSStringFromSelector(_cmd),requestStr);
    return YES;
}

//- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
//{
//    NSURL *url = [request URL];
//    
//}
#pragma mark getter method
- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _myWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:246.0/255 alpha:1.0];
        _myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _myWebView.delegate = self;
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

@end
