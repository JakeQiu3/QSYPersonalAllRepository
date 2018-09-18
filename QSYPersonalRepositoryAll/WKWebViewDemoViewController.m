//
//  WKWebViewDemoViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/22.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "WKWebViewDemoViewController.h"
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"

#define HTML @"<head></head><img src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />"

@interface WKWebViewDemoViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end



@implementation WKWebViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadWK];
    //    [self loadJSCode]; // OC手动调用js代码
}

- (void)loadWK {
    // 1、配置环境
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 1、1 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //1、2 web内容处理池:未暴露api，暂时无用
    config.processPool = [[WKProcessPool alloc] init];
    //1、3 通过JS与webview内容交互,注册js方法:注入JS对象名称“AppModel”的js方法，当JS通过AppModel来调用时，我们可以在WKScriptMessageHandler代理中接收到。
    config.userContentController = [[WKUserContentController alloc] init];
    //   添加js脚本
    WeakScriptMessageDelegate *weakDelegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    [config.userContentController addScriptMessageHandler:weakDelegate name:@"appFirstModel"];
    [config.userContentController addScriptMessageHandler:weakDelegate name:@"appSecondModel"];
    //     [config.userContentController addScriptMessageHandler:self name:@"AppModel"]; 该写法中会直接导致self被强引用，而不被释放。
    
    // 加载WKWebview
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"qsytest" withExtension:@"html"];
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    
    
//    注入js方法
    //    // 少1：传递参数给 后端 的方式：在request中执行操作
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //// 设置url
    //    [request setURL:url];
    // 设置Method
    //    [request setHTTPMethod:@"POST"];
    //    // 设置头
    //    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    //    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //    // 设置body
    //    NSString *bodyParams = [NSString stringWithFormat:@"id=%@&password=%@&role=%@",@"111",@"admin222",@"33333"];
    //    NSMutableData *postBody = [NSMutableData data];
    //    [postBody appendData:[bodyParams dataUsingEncoding:NSUTF8StringEncoding]];
    //    [request setHTTPBody:postBody];
    
    
    // 少2：传递带参数的js给前端的方式：
    //    含参数的
    NSString *sourceString = [NSString stringWithFormat:@"document.cookie='id=%@,password=%@,role=%@'",@"111",@"admin222",@"33333"];
    sourceString = [sourceString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:sourceString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [config.userContentController addUserScript:cookieScript];
    
    
    // 加载webview
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
    
    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    
    // 添加进入条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = self.view.bounds;
    [self.view addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStyleDone target:self action:@selector(gofarward)];
}

- (void)dealloc{
    //这里需要注意，前面增加过的方法一定要remove。
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"AppFirstModel"];
    [[self.webView configuration].userContentController removeScriptMessageHandlerForName:@"AppSecondModel"];
    [[self.webView configuration].userContentController removeAllUserScripts];
    [self.webView removeObserver:self forKeyPath:@"loading"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark 前进或后退的方法
- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];// 测试用
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)gofarward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

#pragma mark 添加观察者的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
        [self.webView evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"查看cookie中传递过来的参数=== %@",result);
            NSString *resultStr = (NSString *)result;
            NSArray *resultArr = [resultStr componentsSeparatedByString:@","];
            for (NSString *str in resultArr) {
                NSLog(@"具体的某个参数：%@",str);
                if ([str containsString:@"id"]) {
                    self.title = [[str componentsSeparatedByString:@"="] lastObject]; //重新把参数设置给title
                }
            }
        }];
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
}

#pragma mark WKScriptMessageHandler 的代理方法：接受到js调用时，传递过来的body中的信息,OC在JS调用方法后做的处理。如 html中执行了：window.webkit.messageHandlers.AppModel.postMessage({body: 'call js alert in js'});
// JS调用该OC方法，同时JS把message传递过来
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull类型
    NSDictionary *dic = (NSDictionary *)message.body;
    if ([message.name isEqualToString:@"AppFirstModel"]) {
        [self ShareWithInformation:dic];
    }else if ([message.name isEqualToString:@"AppSecondModel"]){
        [self camera:dic];
    }
}

#pragma mark - Method
-(void)ShareWithInformation:(NSDictionary *)dic {
    NSLog(@"我就是测一测传递给我的body是啥:%@",dic);
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *title = [dic objectForKey:@"title"];
    NSString *content = [dic objectForKey:@"content"];
    NSString *url = [dic objectForKey:@"url"];
    
    //在这里写分享操作的代码
    NSLog(@"要分享了哦😯");
    
    NSString *JSResult = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    
    // OC调用JS
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
}

-(void)camera:(NSDictionary *)dic
{
    //在这里写调用打开相88册的代码
    NSLog(@"我就是测一测传递给我的body是啥:%@",dic);
}

#pragma mark WKNavigationDelegate 的代理方法,执行状态回调
// 页面开始加载某个iframe或frame时就会执行调用
/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 当某个iframe的内容开始返回时调用
/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载success");
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"查看获取到的title is %@",result);
    }];
}

// 页面加载失败时调用
/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"加载失败了，这事谁都不能怪哦");
}

// 接收到服务器跳转请求之后调用
/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 在发送请求之前，决定是否跳转
/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostName = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated && [hostName containsString:@".baidu.com"]) { // 获取百度等跨域链接的地址
        // 对于跨域，手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
        }];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    NSLog(@"%s", __FUNCTION__);
}

// 在收到服务器response后，决定是否跳转
/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark WKUIDelegate 的代理方法:新增的方法
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return [[WKWebView alloc] init];
}

// 用于WKWebView处理web界面的三种提示框(警告框、确认框、输入框)
/**
 *  web界面（不是Native界面）中有弹出警告框时调用，也就是说js端调用alert方法 或者 Native端手动调用时，就会调用执行该代理方法。
 // 如：Native端的手动调用JS function: 每次页面完成都弹出来，大家可以在测试时再打开
 NSString *js = @"callJsAlert()";
 [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
 NSLog(@"response: %@ error: %@", response, error);
 NSLog(@"call js alert by native");
 }];
 
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();// 点击确定后，执行JS中的window.webkit.messageHandlers.AppModel.postMessage({body: 'call js alert in js'});该JS方法用于给OC传递数据，这时候就会调用 didReceiveScriptMessage 代理方法
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"就是alert方法中传递过来的参数：%@", message);
}

// 确认信息时调用
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

// 文本输入时会调用
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}


// webView 执行JS代码
- (void)webviewJs {
    [self.webView evaluateJavaScript:@"javaScriptString" completionHandler:nil];
}

// OC 动态加载并运行JS代码
- (void)loadJSCode {
    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
    // 根据JS字符串 初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];
    
    // wkwebview加载html
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [_webView loadHTMLString:@"<image src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />" baseURL:nil]; //
    [self.view addSubview:_webView];
    // OC调用JS方法
    [_webView evaluateJavaScript:js completionHandler:nil];
    //OC注册供JS调用的方法
    [[_webView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"closeMe"];
}
// 注入方法
- (void)inject_oc_method:(NSDictionary *)dic {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *resultJs = [NSString stringWithFormat:@"window.init(%@)",jsonString];
    [_webView evaluateJavaScript:resultJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"查看该js代码执行后的返回结果：%@",result);
    }];
}


@end
