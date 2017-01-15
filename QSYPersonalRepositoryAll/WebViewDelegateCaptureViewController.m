//
//  WebViewDelegateInterceptUrlsViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2017/1/12.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import "WebViewDelegateCaptureViewController.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height

@interface WebViewDelegateCaptureViewController ()<UIWebViewDelegate>
/**
 *  左侧导航条系列
 */
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  webview
 */
@property (nonatomic, strong) UIWebView *myWebView;
@property (strong, nonatomic) UILabel *webInfoLabel;//网页信息来源

/**
 *  头部加载进度系列
 */
@property (strong, nonatomic) UIProgressView *loadProgressView;
@property (strong, nonatomic) NSTimer *timer;//网页加载计时器
@property (nonatomic,assign) BOOL loading;// 是否正在加载

/**
 *  截取屏幕快照和滑动手势系列
 */
@property (nonatomic,strong)UIPanGestureRecognizer* swipePanGesture;
@property (nonatomic,strong)UIView* swipingBackgoundView; //滑动切换时背景视图
@property (nonatomic,strong)NSMutableArray* snapShotsArray;//滑动手势快照的数组
@property (nonatomic,strong)UIView* prevSnapShotView;// 上一个界面的快照View
@property (nonatomic,strong)UIView* currentSnapShotView;// 当前界面的快照View
@property (nonatomic, assign) BOOL isSwiping;// 滑动页面的状态

@end

@implementation WebViewDelegateCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCurrentView];
    [self setUpNavItems];
    [self loadWebView]; //加载remote的url或本地的html
}

- (void)setCurrentView {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)setUpNavItems {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [backgroundView addSubview:self.backBtn];
    [backgroundView addSubview:self.closeBtn];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backgroundView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)loadWebView {
    [self.view addSubview:self.myWebView];
    
    [self.myWebView insertSubview:self.webInfoLabel belowSubview:self.myWebView.scrollView];
    self.myWebView.scrollView.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    [self.view addSubview:self.loadProgressView];
    [self.myWebView addGestureRecognizer:self.swipePanGesture];
    //    加载本地资源
    [self loadLocalHtml];
    //   加载远程资源
    // [self loadRemoteHtml];
}

- (void)loadLocalHtml {
    //    加载方法1
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"9Y.html" withExtension:nil];
    //    或者 NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"9Y" ofType:@"html"]];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //    加载方法2
    //        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"9Y" ofType:@"html"];
    //    // utf8编码给html，但很多html本身内部已经实现了utf-8，故可以省略：htmlStr
    //        NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //        NSURL *baseUrl  = [NSURL URLWithString:htmlPath];
    //        [self.myWebView loadHTMLString:appHtml baseURL:baseUrl];
    
    //    加载方法3: 也可以加载本地pdf、mp3、png等文件。
    //        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"5种编程思想和5种设计模式的比较" ofType:@"xml"];
    //        NSURL *fpfBaseUrl = [NSURL URLWithString:filePath];
    //        if (filePath) {
    //            NSData *fileData  = [NSData dataWithContentsOfFile:filePath];
    //            [self.myWebView loadData:fileData MIMEType:@"text/HTML" textEncodingName:@"utf-8" baseURL:fpfBaseUrl];
    //            // MIMEType (资源的媒体类型) -> 1、网页等格式是：text/HTML
    //           // 2、客户端自己定义的格式，一般只能以 application/x- 开头,如 pdf: application/pdf,
    //        }
}

- (void)loadRemoteHtml {
    //    加载百度
    NSString *remoteStr = @"https://www.baidu.com";
    NSURL *remoteUrl = [NSURL URLWithString:remoteStr];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:remoteUrl]];
}


#pragma mark  backMethod 和 closeMethod
- (void)backAction:(UIButton *)backBtn {
    if (self.myWebView.canGoBack) {
        [self.myWebView goBack];
    } else {
        [self closeAction:nil];
    }
    //    常用：html 页面切换方法：前进、后退、刷新和停止刷新
    //    if (webView.canGoBack) {
    //        [webView goBack];//返回
    //    } else if (webView.canGoForward) {
    //        [webView goForward];//前进
    //    } else {
    //        [webView reload];//刷新
    //    [webView stopLoading];//停止刷新
    //    }
}

- (void)closeAction:(UIButton *)closeBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 手势方法
- (void)swipePanGestureAction:(UIPanGestureRecognizer *)panGesture {
    //    获取手势的位置和发生的位移量
    CGPoint translation = [panGesture translationInView:self.myWebView];
    CGPoint location = [panGesture locationInView:self.myWebView];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 50 && translation.x >= 0) {//拖动的位置在50以内，并且位移大于0, 才开始进行滑动操作
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
    
    if (self.currentSnapShotView.center.x >= boundsWidth) { // 滑动距离大于1/2时，pop 成功
        [UIView animateWithDuration:0.2 animations:^{
            // 淡入淡出的效果
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.prevSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.swipingBackgoundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.myWebView goBack];
            [self.snapShotsArray removeLastObject];
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

//更新web的label的info
- (void)updateHostLabelWithRequest:(NSURLRequest *)request {
    NSString *host = [request.URL host];
    if (host) {
        self.webInfoLabel.text = [NSString stringWithFormat:@"本网页由 %@ 提供",host];
    }
}
#pragma mark webview 的delegate
//判断webview已经完全加载完成：http://www.jianshu.com/p/897e2d82ee43
//除了原生方法外，网页的 readyState 属性也可以返回当前加载状态，共有5种:
//uninitialized : 还没开始加载
//loading : 加载中
//loaded : 加载完成
//interactive : 结束渲染，用户已经可以与网页进行交互。但内嵌资源还在加载中
//complete : 完全加载完成
// 不是webview开始加载执行，而是指网页中一个iframe或frame开始加载，所以若html有多个frame 会执行多次.故常常用作判断BOOL。

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.loadProgressView.progress = .0f;
    self.loadProgressView.hidden = NO;
    self.loading = YES;
    self.timer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 不是webview完全加载完毕，而是指网页中某一个iframe或frame加载完毕，所以若html有多个frame 会执行多次.故常常用作判断BOOL。
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    [SVProgressHUD dismiss];
    NSLog(@"查看执行的%@",NSStringFromSelector(_cmd));
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
    [self updateNavItems:webView];
    if (self.prevSnapShotView.superview) {
        [self.prevSnapShotView removeFromSuperview];
    }
}

// 加载失败时执行该method
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication]  setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
}

// 准备加载内容时调用的方法，通过返回值来进行是否加载的设置。每次request url都会先执行这个方法，所以一般会执行很多次：顺序上->优先于其他3个代理方法执行。
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self updateHostLabelWithRequest:request];
    NSURL *totalUrl = [request URL];
    NSString *absoluteUrlStr = [totalUrl absoluteString];
    
    // 根据请求的url做截获做处理
    if ([absoluteUrlStr containsString:@"www.qq.com"]) {
        BOOL captureBool = [self captureUserBehave:totalUrl];
        return captureBool;
    } else if ([absoluteUrlStr containsString:@"dismiss.com"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出支付？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.navigationController.viewControllers.count > 0) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }];
        [alertController addAction:cancelAction];
        
        UIAlertAction *nothingAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:NULL];
        [alertController addAction:nothingAction];
        [self presentViewController:alertController animated:YES completion:NULL];
        return NO;// 为NO，表示不执行该url的请求
    }
    
    // 截获具体的用户交互行为，对对应的requst，做出处理
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:// //判断是否是单击：用户触击了一个链接
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        case UIWebViewNavigationTypeFormSubmitted://提交表格：用户提交了一个表单
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        case UIWebViewNavigationTypeBackForward://用户触击前进或返回按钮
            break;
        case UIWebViewNavigationTypeReload://用户触击重新加载的按钮
            break;
        case UIWebViewNavigationTypeFormResubmitted://用户重复提交表单
            break;
        case UIWebViewNavigationTypeOther:// 其他的类型:用户发生了其它的交互行为
            [self pushCurrentSnapshotViewWithRequest:request];
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)captureUserBehave:(NSURL *)url {
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

#pragma mark - update nav items
- (void)updateNavItems:(UIWebView *)webView {
    if (webView.canGoBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.closeBtn.hidden = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.closeBtn.hidden = YES;
    }
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title length] > 10) {
        title = [[title substringToIndex:9] stringByAppendingString:@"..."];
    }
    self.title = title;
}

- (void)timerCallback {
    if (!self.loading) {
        if (self.loadProgressView.progress >=1) {
            self.loadProgressView.hidden = YES;
            [self.timer invalidate];
            self.timer = nil;
        } else {
            self.loadProgressView.progress += 0.5;
        }
    } else { //造成一个假象：加载到9成progress时，若正在加载，会停留在0.9进度上。
        self.loadProgressView.progress +=0.05;
        if (self.loadProgressView.progress >= 0.9) {
            self.loadProgressView.progress = 0.9;
        }
    }
}

#pragma mark - url中 push and pop snapShot views 的操作method
- (void)pushCurrentSnapshotViewWithRequest:(NSURLRequest *)request {
    NSLog(@"少：获取到被push 的 request %@",request);
    // 获取到last快照中 request
    NSURLRequest *lastRequest = (NSURLRequest *)[[self.snapShotsArray lastObject] objectForKey:@"request"];
    if ([[request.URL absoluteString] isEqualToString:@"about:blank"]) {
        return;
    }
    if ([[lastRequest.URL absoluteString] isEqualToString:[request.URL absoluteString] ]) {
        return;
    }
    if (![self.myWebView isLoading]) {
        NSString *readyState = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete) {
            UIView *currentSnapShotView = [self.myWebView snapshotViewAfterScreenUpdates:YES];
            if (![self.snapShotsArray containsObject:currentSnapShotView]) {
                [self.snapShotsArray addObject:@{@"request":request,@"snapShotView":currentSnapShotView}];
                NSLog(@"查看快照数组中的快照个数：%lu 和 该快照数组：%@",(unsigned long)self.snapShotsArray.count,self.snapShotsArray);
            }
        } else {
            NSLog(@"停止加载，但加载未完成，打印当前的method:%@",NSStringFromSelector(_cmd));
        }
    }
}

#pragma  mark  getter
- (NSMutableArray *)snapShotsArray {
    if (!_snapShotsArray) {
        _snapShotsArray = [[NSMutableArray alloc] init];
    }
    return _snapShotsArray;
}

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
        _myWebView.scalesPageToFit = NO; //是否支持缩放。默认为NO，显示的界面一般是最合适的。
        _myWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _myWebView;
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

// 界面滑动时中间那一层的阴影
-(UIView*)swipingBackgoundView{
    if (!_swipingBackgoundView) {
        _swipingBackgoundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _swipingBackgoundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _swipingBackgoundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _swipingBackgoundView;
}

- (BOOL)isSwiping {
    if (!_isSwiping) {
        _isSwiping = NO;
    }
    return _isSwiping;
}

- (UIProgressView *)loadProgressView {
    if (!_loadProgressView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 2.0);
        _loadProgressView = [[UIProgressView alloc] initWithFrame:frame];
        _loadProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _loadProgressView.tintColor = [UIColor colorWithRed:119.0/255 green:228.0/255 blue:115.0/255 alpha:1];
        _loadProgressView.trackTintColor = [UIColor clearColor];
    }
    return _loadProgressView;
}

- (UIPanGestureRecognizer *)swipePanGesture {
    if (!_swipePanGesture) {
        _swipePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureAction:)];
    }
    return _swipePanGesture;
}

#pragma mark 少 使webview 最适合屏幕的高度:见下面方法
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
