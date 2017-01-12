//
//  WebViewDelegateInterceptUrlsViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 2017/1/12.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import "WebViewDelegateInterceptUrlsViewController.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height

@interface WebViewDelegateInterceptUrlsViewController ()<UIWebViewDelegate>
// 导航条左侧的关闭和返回按钮
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *backBtn;
// webview主体
@property (nonatomic, strong) UIWebView *myWebView;
// 网页信息的label
@property (strong, nonatomic) UILabel *webInfoLabel;
// 加载的进度条
@property (strong, nonatomic) UIProgressView *loadProgressView;
@property (strong, nonatomic) NSTimer *timer;//网页加载计时器
@property (nonatomic,assign) BOOL loading;// 是否正在加载
// 向右手势
@property (nonatomic)UIPanGestureRecognizer* swipePanGesture;


// 快照图片：滑动的背景视图
@property (nonatomic)UIView* swipingBackgoundView;
// 滑动手势快照的数组
@property (nonatomic)NSMutableArray* snapShotsArray;
// 上一个界面的快照View
@property (nonatomic)UIView* prevSnapShotView;
// 当前界面的快照View
@property (nonatomic)UIView* currentSnapShotView;
// 在滑动页面的bool
@property (nonatomic, assign) BOOL isSwiping;

@end

@implementation WebViewDelegateInterceptUrlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCurrentView];
    [self setUpNavItems];
    [self loadWebView]; //加载url或本地的html
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
    self.myWebView.scrollView.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f]; // 修改scrollview的superview的backgroundColor
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

- (BOOL)isSwiping {
    if (!_isSwiping) {
        //        默认是 NO, 未发生滑动
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

#pragma mark  backMethod 和 closeMethod
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

#pragma mark 手势方法
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

//更新web的label的info
- (void)updateHostLabelWithRequest:(NSURLRequest *)request {
    NSString *host = [request.URL host];
    if (host) {
        self.webInfoLabel.text = [NSString stringWithFormat:@"本网页由 %@ 提供",host];
    }
}
#pragma mark webview 的delegate
// 不是webview开始加载执行，而是指网页中一个iframe或frame开始加载，所以若html有多个frame 会执行多次.故常常用作判断BOOL。
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.loadProgressView.progress = .0f;
    self.loadProgressView.hidden = NO;
    self.loading = YES;
    self.timer = [NSTimer timerWithTimeInterval:.1f target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerCallback {
    if (!self.loading) {//加载完毕
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
    //    [self transferJs:webView];
    
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication]  setNetworkActivityIndicatorVisible:NO];
    self.loading = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self updateHostLabelWithRequest:request];
    NSURL *totalUrl = [request URL];
    NSString *absoluteUrlStr = [totalUrl absoluteString];
    if ([absoluteUrlStr containsString:@"22"]) {
        return YES;
    } else if ([absoluteUrlStr containsString:@"333"]) {
        return NO;
    }
    
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:// 单击
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
    // 判断网络真正不再加载
    if ([self.myWebView isLoading]) {
        return;
    }
    //  加载完url完后，获取到当前新界面的快照
    UIView *currentSnapShotView = [self.myWebView snapshotViewAfterScreenUpdates:YES];
    //    保存当前快照作为value，保存到一个字典数组中
    [self.snapShotsArray addObject:@{@"request":request,@"snapShotView":currentSnapShotView}];
    NSLog(@"查看快照数组中的快照个数：%lu 和 该快照数组：%@",(unsigned long)self.snapShotsArray.count,self.snapShotsArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
