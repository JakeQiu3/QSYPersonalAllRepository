//
//  WebViewDemoViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/22.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "WebViewDemoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SVProgressHUD.h"
#import "WebViewJavascriptBridge.h"
#import "TestJSObject.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height
//html学习网站： http://www.w3school.com.cn
# pragma mark 1.js和html的交互原理： DOM：过文档对象模型。 通过获取html的DOM来访问每一个单独的元素，实现对html的增删改查。 JavaScript可以读取使用DOM，通过DOM可以访问Html的每个节点以及元素。   2. getElementById() 和 getElementsByTagName()：这两种方法，可查找整个 HTML 文档中的任何 HTML 元素。

@interface WebViewDemoViewController ()<UIWebViewDelegate>
// 导航条左侧的关闭和返回按钮
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIWebView *myWebView;
// 网页信息的label
@property (strong, nonatomic) UILabel *webInfoLabel;
// 加载的进度条
@property (strong, nonatomic) UIProgressView *progressView;
// 向右手势
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;
@property (strong, nonatomic) NSTimer *timer;//网页加载计时器
@property (nonatomic) BOOL loading;

// 滑动的背景视图
@property (nonatomic)UIView* swipingBackgoundView;
// 滑动手势快照的数组
@property (nonatomic)NSMutableArray* snapShotsArray;
// 上一个界面的快照View
@property (nonatomic)UIView* prevSnapShotView;
// 当前界面的快照View
@property (nonatomic)UIView* currentSnapShotView;
// 在滑动页面的bool
@property (nonatomic, assign) BOOL isSwiping;


@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation WebViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor grayColor];//webview的 scrollview的superView
    [self setUpNavItems];
    [self loadWebView];//加载url或本地的html
    //    [self loadWebView2];
}

- (void)setUpNavItems {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [backgroundView addSubview:self.backBtn];
    [backgroundView addSubview:self.closeBtn];
    UIBarButtonItem *setLeftItem = [[UIBarButtonItem alloc] initWithCustomView:backgroundView];
    self.navigationItem.leftBarButtonItem = setLeftItem;
    
}

- (void)loadWebView2 {
    if (_bridge ) {
        return;
    }
    //    添加webview
    [self.view addSubview:self.myWebView];
    
    //   创建bridge
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView];
    [self.bridge setWebViewDelegate:self];
    //    注册操作：当html有执行交互该testObjcCallback名称的操作时，就会执行下面的block
    [self.bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"data: %@",data);
        responseCallback(@"Response from testObjcCallback");
    }];
    ////
    //    [self.bridge callHandler:@"testJavascriptHandler" data:@{@"bridgeKey":@"邱少测试"} responseCallback:^(id responseData) {
    //         NSLog(@"responseData: %@",responseData);
    //    }];
    //  添加 3button
    [self redenerButtons:self.myWebView];
    //    加载html文件
    [self loadExamplePage:self.myWebView];
    
}

- (void)loadExamplePage:(UIWebView *)webView {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)redenerButtons:(UIWebView *)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    //   回调的button
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"回调" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(0, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    //  刷新的button：target是webView，action是webview 的reload。
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"刷新webView" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(90, 400, 100, 35);
    reloadButton.titleLabel.font = font;
    
    //  加载时间的button
    UIButton* safetyTimeoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safetyTimeoutButton setTitle:@"Disable safety timeout" forState:UIControlStateNormal];
    [safetyTimeoutButton addTarget:self action:@selector(disableSafetyTimeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:safetyTimeoutButton aboveSubview:webView];
    safetyTimeoutButton.frame = CGRectMake(190, 400, 120, 35);
    safetyTimeoutButton.titleLabel.font = font;
    
}

- (void)callHandler:(id)sender {
    id data = @{@"我是谁？":@"你好，我是邱少!"};
    // testJavascriptHandler 为html中函数的handler的名字；responseData 是html中的数据“ Javascript Says = Right back atcha!”
    [self.bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        NSLog(@"responseData: %@",responseData);
    }];
}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}


#pragma mark  少
- (void)loadWebView {
    //    添加 webview
    [self.view addSubview:self.myWebView];
    //   添加 webInfoLabel
    [self.myWebView insertSubview:self.webInfoLabel belowSubview:self.myWebView.scrollView];
    //    修改scrollview的父视图
    self.myWebView.scrollView.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    //   添加 progressView
    [self.view addSubview:self.progressView];
    //   添加 手势识别
    [self.myWebView addGestureRecognizer:self.swipePanGesture];
    //    加载本地资源
    //        [self loadLocalHtml];
    //   加载远程资源
    [self loadRemoteHtml];
    
}

- (void)loadLocalHtml {
    //    加载方法1
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    //    // 或者    NSURL *url = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //    加载方法2
    //    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];//本地图片
    //   utf8编码：htmlStr
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl  = [NSURL URLWithString:htmlPath];
    [self.myWebView loadHTMLString:appHtml baseURL:baseUrl];
    
    //    加载方法3: 本地pdf、mp3文件等等。
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iOS开发进阶 PDF电子书下载 带书签目录 完整版" ofType:@"pdf"];
    //    NSURL *fpfBaseUrl = [NSURL URLWithString:filePath];
    //    if (filePath) {
    //        NSData *fileData  = [NSData dataWithContentsOfFile:filePath];
    //        [self.myWebView loadData:fileData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:fpfBaseUrl];// MIMEType (资源的媒体类型) -> 网页是：text/HTML, 客户端自己定义的格式，一般只能以 application/x- 开头,如 pdf: application/pdf,
    //    }
    
}

- (void)loadRemoteHtml {
    //    加载百度
    self.payUrl = @"https://www.baidu.com";
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.payUrl]]];
    
    //  加载好豆菜谱
    //    self.payUrl = @"http://m.haodou.com/topic-327282.html?id=327282";
    //    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.payUrl]]];
}

#pragma mark webview 的delegate
// 不是webview开始加载，而是指网页中一个iframe或frame开始加载，所以若html有多个frame 会执行多次.故常常用作判断BOOL。
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.progressView.progress = .0f;
    self.progressView.hidden = NO;
    self.loading = YES;
    self.timer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    //    [SVProgressHUD showWithStatus:@"正在加载..."];
    
}

// timer method
- (void)timerCallback {
    if (!self.loading) {//加载完毕
        if (self.progressView.progress >=1) {
            self.progressView.hidden = YES;
            [self.timer invalidate];
            self.timer = nil;
        } else {
            self.progressView.progress += 0.5;
        }
    } else {//造成一个假象：加载到9成progress时，若正在加载，会停留在0.9进度上。
        self.progressView.progress +=0.05;
        if (self.progressView.progress >= 0.9) {
            self.progressView.progress = 0.9;
        }
    }
}
// 不是webview完全加载完毕，而是指网页中一个iframe或frame加载完毕，所以若html有多个frame 会执行多次.故常常用作判断BOOL。
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
    //    更新导航条左按钮和标题
    [self updateNavItems:webView];
    //  移除上一个视图快照
    if (self.prevSnapShotView.superview) {
        [self.prevSnapShotView removeFromSuperview];
    }
    //    调用js文件
    [self transferJs:webView];
    
}

- (void)transferJs:(UIWebView *)webView {
    //    常用： html的控制方法
    //    if (webView.canGoBack) {
    //        [webView goBack];//返回
    //    } else if (webView.canGoForward) {
    //        [webView goForward];//前进
    //    } else {
    //        [webView reload];//刷新
    //    [webView stopLoading];//停止刷新
    //    }
    
    //    =========== =========== =========== ===========
    //  0. iOS调用js和 js调用iOS : 首先创建JSContext 对象
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //  js调用iOS
    context[@"testExecute"] = ^(){
        NSArray *args = [JSContext currentArguments];// 获取参数的数组
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    //一个参数
    NSString *jsFuncStr1 = @"testExecute('参数1')";
    [context evaluateScript:jsFuncStr1];
    //二个参数
    NSString *jsFuncStr2 = @"testExecute('参数2','参数3')";
    [context evaluateScript:jsFuncStr2];
    
    //    =========== =========== =========== =========== ===========
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context2=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //第二种情况，js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
    //首先创建我们新建类的对象，将他赋值给js的对象
    TestJSObject *testJO=[TestJSObject new];
    context2[@"testobject"]=testJO;
    
    //同样我们也用刚才的方式模拟一下js调用方法
    NSString *jsStr1=@"testobject.TestNOParameter()";
    [context2 evaluateScript:jsStr1];
    NSString *jsStr2=@"testobject.TestOneParameter('参数1')";
    [context2 evaluateScript:jsStr2];
    NSString *jsStr3=@"testobject.TestTowParameterSecondParameter('参数A','参数B')";
    [context2 evaluateScript:jsStr3];
    
    // =========== =========== =========== =========== ===========
    
    //  1. 手动添加js代码和html实现交互,并调用：添加一个弹出框
    NSString *alertStr = @"alertTest('我就是我,是不一样的烟火')";
    BOOL isExist = [[webView stringByEvaluatingJavaScriptFromString:@"typeof alertTest == \'function\';"] isEqualToString:@"true"];
    if (!isExist) {
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function alertTest(str) { "
         "alert(str)"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        //        [webView stringByEvaluatingJavaScriptFromString:alertStr];
    }
    
    //  2. 修改和删除 html的内容： 利用Javascript去操作UIWebView的内容:document.getElementsByClassName('要消除的空间的class里面的字符串')[0].style.display = 'none'
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('auto mgt10')[0].style.display = 'none'"];
    
    //  3.获取到webview的所有文本内容:textContent
    if (!webView.isLoading) {// 未正在加载
        NSString *docAllStr=[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    }
    
    //  4.修改webview的标题,一般是head的标题,并不是body中展示的标题title
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.title = '我是邱少依'"];
    
    //5.加载js文件
    [self.myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil]];
    
    // 5.调用该点击方法
    [webView stringByEvaluatingJavaScriptFromString:@"setImageClickFunction()"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication]  setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
    
}

// 网页加载之前会调用此方法 :每当将加载请求的时候调用该方法，返回YES 表示加载该请求，返回NO 表示不加载该请求：常用于拦截请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    获取加载的url
    NSURL *url = [request URL];
    NSString *urlStr = [url absoluteString];
    if ([urlStr containsString:@""]) {//    判断请求的url
        return NO;//表示不符合要求，不加载url
    }
    //   获取web的 host
    [self updateHostLabelWithRequest:request];
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked://单击
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        case UIWebViewNavigationTypeFormSubmitted://提交表格
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        case UIWebViewNavigationTypeBackForward:
            break;
        case UIWebViewNavigationTypeReload:
            break;
        case UIWebViewNavigationTypeFormResubmitted:
            break;
        case UIWebViewNavigationTypeOther://其他的类型
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - url中 push and pop snapShot views 的操作method
- (void)pushCurrentSnapshotViewWithRequest:(NSURLRequest *)request {
    
    NSLog(@"push with request %@",request);
    //    获取最后一次快照中 request
    NSURLRequest *lastRequest = (NSURLRequest *)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    //如果当前的url是很奇怪的就不push
    if ([[request.URL absoluteString] isEqualToString:@"about:blank"]) {
        return;
    }
    //如果当前的url和最后一次的快照中一样就不进行push
    if ([[lastRequest.URL absoluteString] isEqualToString:[request.URL absoluteString] ]) {
        return;
    }
    //    判断网络真正不再加载
    if ([self.myWebView isLoading]) {
        return;
    }
    //  加载完url完后，获取到当前新界面的快照
    UIView *currentSnapShotView = [self.myWebView snapshotViewAfterScreenUpdates:YES];
    //    保存当前快照作为value，保存到一个字典数组中
    [self.snapShotsArray addObject:@{@"request":request,@"snapShotView":currentSnapShotView}];
    NSLog(@"查看快照数组中的快照个数：%d 和 该快照数组：%@",self.snapShotsArray.count,self.snapShotsArray);
}

//更新label
- (void)updateHostLabelWithRequest:(NSURLRequest *)request {
    NSString *host = [request.URL host];
    if (host) {
        self.webInfoLabel.text = [NSString stringWithFormat:@"本网页由 %@ 提供",host];
    }
}

#pragma mark 右滑返回上个网页 method
- (void)swipePanGestureAction:(UIPanGestureRecognizer *)panGesture {
    //    获取手势的位置和发生的位移量
    CGPoint translation = [panGesture translationInView:self.myWebView];
    CGPoint location = [panGesture locationInView:self.myWebView];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x >= 0) {//位置在50以内，并且位移大于0, 才开始进行滑动操作
            [self startPopSnapShotView];
        }
    } else if (panGesture.state == UIGestureRecognizerStateCancelled ||panGesture.state == UIGestureRecognizerStateEnded) {//取消或结束手势
        [self endPopSnapShotView];
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {//正在执行拖动手势
        [self popSnapShotViewwithPanGestureDistance:translation.x];
    } else {
        
    }
}
// 开始滑动时,执行method : 逻辑->设置当前快照center和之前快照center，并将快照add webView
- (void)startPopSnapShotView {
    if (self.isSwiping) {//正在滑动，直接返回
        return;
    }
    if (!self.myWebView.canGoBack) {// webview不能返回时
        return;
    }
    self.isSwiping = YES;
    
    CGPoint center = CGPointMake(boundsWidth/2, boundsHeight/2);
    // 更新后，获取current的view 快照
    self.currentSnapShotView = [self.myWebView snapshotViewAfterScreenUpdates:YES];
    self.currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    self.currentSnapShotView.layer.shadowRadius = 8;//阴影半径
    self.currentSnapShotView.layer.shadowOpacity = 0.75;
    //当前快照的中心和 屏幕中心一致
    self.currentSnapShotView.center = center;
    
    // 获取到last快照
    self.prevSnapShotView = (UIView *)[[self.snapShotsArray lastObject] objectForKey:@"snapShotView"];
    center.x -=60;
    self.prevSnapShotView.center = center;
    self.prevSnapShotView.alpha = 1;
    
    // ==========开始滑动就添加3个快照到webView上============
    [self.myWebView addSubview:self.prevSnapShotView];
    [self.myWebView addSubview:self.swipingBackgoundView];
    [self.myWebView addSubview:self.currentSnapShotView];
}

// 正在执行拖动手势 method:逻辑->根据distance，设置当前和pre的center的变化
- (void)popSnapShotViewwithPanGestureDistance:(CGFloat )distance {
    if (!self.isSwiping) {//未滑动，直接返回
        return;
    }
    if (distance <= 0) {
        return;
    }
    //    当前快照的center
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2,  boundsHeight/2);
    currentSnapshotViewCenter.x += distance;
    //   之前快照的center
    CGPoint preSnapShotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    preSnapShotViewCenter.x -= 60 - 60*distance/boundsWidth;
    self.currentSnapShotView.center =currentSnapshotViewCenter;
    self.prevSnapShotView.center = preSnapShotViewCenter;
    self.swipingBackgoundView.alpha = (boundsWidth -distance)/boundsWidth;
}

// 结束手势 method ：逻辑-> 根据center判断，滑动成功：动画，设置当前快照和pre快照的center，完成时执行webview goback，并移除数组中last快照,以及3个视图； 滑动失败：当前的center还在屏幕中心，完成时执行全部移除3个视图快照，恢复view的交互。
- (void)endPopSnapShotView {
    if (!self.isSwiping) { //未滑动，直接返回
        return;
    }
    self.view.userInteractionEnabled = NO;
    
    // 滑动距离大于1/2时，pop成功
    if (self.currentSnapShotView.center.x >= boundsWidth) { // pop 成功
        [UIView animateWithDuration:0.2 animations:^{
            //            淡入淡出的效果
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.myWebView goBack];
            [self.snapShotsArray removeLastObject];//移除快照view数组中的lastView
            [self.currentSnapShotView removeFromSuperview];
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.isSwiping = NO;
        }];
    } else {// pop失败
        [UIView animateWithDuration:0.2 animations:^{
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2 - 60, boundsHeight/2);
            self.prevSnapShotView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self.prevSnapShotView removeFromSuperview];
            [self.swipingBackgoundView removeFromSuperview];
            [self.currentSnapShotView removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.isSwiping = NO;
        }];
    }
}

// 导航返回和关闭的 method
- (void)backAction:(UIButton *)backBtn {
    if (self.myWebView.canGoBack) {
        [self.myWebView goBack];
    } else {
        [self closeAction:nil];
    }
}
- (void)closeAction:(UIButton *)closeBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - update nav items
- (void)updateNavItems:(UIWebView *)webView {
    //   更新左侧返回按钮和关闭按钮
    if (webView.canGoBack) {// webview可返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.closeBtn.hidden = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.closeBtn.hidden = YES;
    }
    //   更新title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title length] > 10) {
        title = [[title substringToIndex:9] stringByAppendingString:@"..."];
    }
    self.title = title;
}

#pragma mark - logic of push and pop snap shot views

#pragma  mark  getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.showsTouchWhenHighlighted = 1;
        [_backBtn setImage:[UIImage imageNamed:@"navigation_back.png"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(0, 0, 30, 30);
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.hidden = YES;
        _closeBtn.showsTouchWhenHighlighted = 1;
        [_closeBtn setImage:[UIImage imageNamed:@"navigation_close.png"] forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake(CGRectGetMaxX(_backBtn.frame)+5, 0, 30, 30);
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

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
        _myWebView.scalesPageToFit = YES;//是否支持缩放。默认为NO，显示的界面一般是最合适的。
        _myWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _myWebView;
}

- (UIPanGestureRecognizer *)swipePanGesture {
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureAction:)];
    }
    return _swipePanGesture;
}

- (UILabel *)webInfoLabel {
    if (!_webInfoLabel) {
        _webInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
        _webInfoLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
        _webInfoLabel.textColor = [UIColor grayColor];
        _webInfoLabel.font = [UIFont systemFontOfSize:14];
        _webInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _webInfoLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 2.0);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _progressView.tintColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    
    return _progressView;
}

- (NSMutableArray *)snapShotsArray {
    if (!_snapShotsArray) {
        _snapShotsArray = [[NSMutableArray alloc] init];
    }
    return _snapShotsArray;
}

- (BOOL)isSwiping {
    if (!_isSwiping) {
        //        默认是 NO, 未发生滑动
        _isSwiping = NO;
    }
    return _isSwiping;
}
// 滑动时中间那一层的阴影
-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _swipingBackgoundView;
}

#pragma mark 少 使webview 最适合屏幕的高度:见方法1和2
- (void)fitSizeWebView1:(UIWebView *)webView {
    //    防止获取的网页的大小，比webview小而带来的仅仅返回 获取得网页大小，而不是最适合大小。故先设置成当前的webview高度为1
    CGRect frame = webView.frame;
    
    frame.size.height = 1;
    
    webView.frame = frame;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    frame.size = fittingSize;
    
    webView.frame = frame;
}

- (void)fitSizeWebView2:(UIWebView *)webView {
    CGRect frame = webView.frame;
    CGFloat webBodyHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    frame.size.height = webBodyHeight;
    webView.frame = frame;
    
}

@end
