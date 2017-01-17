//
//  WebViewViaJavaScriptCoreViewController.m
//  QSYPersonalRepositoryAll
//  Created by 邱少依 on 2017/1/13.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import "WebViewViaJavaScriptCoreViewController.h"
#import "WebviewCorrelationJSExport.h"
#import "XFNewsContentModel.h"
#import "XFNewsListModel.h"

#define NilToEmptyString(str)  ((IsEmptyString((str))) ? @"" : (str))
#define IsEmptyString(s)  (((s) == nil) || ([(s) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0))
@interface WebViewViaJavaScriptCoreViewController ()<UIWebViewDelegate,WebViewExportDelegate>
@property (nonatomic, strong)UIWebView *myWebView;
@property (nonatomic, strong) JSContext *jsContext;// js环境
@property (nonatomic, strong) WebviewCorrelationJSExport *jsExport;
@property (nonatomic, strong) XFNewsContentModel *data;
@property (nonatomic, strong) NSArray<XFNewsListModel *> *correlationData;

@end

@implementation WebViewViaJavaScriptCoreViewController

//详见：上面的master
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    [self.view addSubview:self.myWebView];
    [self loadRequestHtml];
    [self creatJSExport];
    [self creatNavBtns];
//    [self transferOCJS:self.myWebView];// JS和OC的交互
}

- (void)getData {
    //提供给html具体的data数据：body 和 底部的数据共5个
    _data = [XFNewsContentModel new];
    _correlationData = @[[XFNewsListModel new], [XFNewsListModel new], [XFNewsListModel new],[XFNewsListModel new],[XFNewsListModel new]];
}

- (void)loadRequestHtml {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"MX5NewsContent" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.myWebView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)creatJSExport {
    _jsExport = [WebviewCorrelationJSExport new];
    _jsExport.delegate = self;
}

- (void)creatNavBtns {
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchButton addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:switchButton];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Middle" style:UIBarButtonItemStylePlain target:self action:@selector(switchFontSize:)];
    item2.tag = 1;
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"Content" style:UIBarButtonItemStylePlain target:self action:@selector(switchContent:)];
    item3.tag = 1;
    self.navigationItem.rightBarButtonItems = @[item1, item2, item3];
}
#pragma mark - XFWebViewExportDelegate

- (void)onClick:(NSInteger)index {
    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

- (void)onload {
    [self webViewDidFinishLoadCompletely];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)documentReadyStateComplete {
    [self webViewDidFinishLoadCompletely];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)webViewDidFinishLoadCompletely {
    [self displayContent];
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"sxNewsContext"] = _jsExport;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete) {
            [self webViewDidFinishLoadCompletely];
        } else {
            NSString *jsString =
            @"window.onload = function() {"
            @"    sxNewsContext.onload();"
            @"};"
            @"document.onreadystatechange = function () {"
            @"    if (document.readyState == \"complete\") {"
            @"        sxNewsContext.documentReadyStateComplete();"
            @"    }"
            @"};";
            [webView stringByEvaluatingJavaScriptFromString:jsString];
        }
        NSLog(@"%@", NSStringFromSelector(_cmd));
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error {
    [self displayError];
}

#pragma mark - JavaScript
- (void)displayContent {
    if (!_data.content) {
        [self displayError];
        return;
    }
    
    NSString *htmlContent = _data.content;
    NSMutableString *jsCode = [NSMutableString stringWithFormat:@"addData(\"title\",\"%@\");"
                               @"addData(\"content\",\"%@\");"
                               @"addData(\"source\",\"%@\");"
                               @"addData(\"time\",\"%@\");",
                               [self escapeString:_data.title],
                               [self escapeString:htmlContent],
                               [self escapeString:_data.source],
                               [self escapeString:_data.createdAt]];
    
    for (int i = 0; i < _correlationData.count; i++) {
        if (i == 0) {
            [jsCode appendFormat:@"showCorrelationHeader(\"%@\");", NSLocalizedString(@"相关新闻", nil)];
        }
        
        XFNewsListModel *model = _correlationData[i];
        NSDictionary *dic = @{@"title":model.title,
                              @"img":model.image,
                              @"author":model.source,
                              @"date":model.displayTime};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [jsCode appendFormat:@"addCorrelationData(%@, %lu, %d);", paramString, (unsigned long)_correlationData.count, i];
    }
    
    [self.myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)displayLoading {
    // 国际化
    NSString *jsCode = [NSString stringWithFormat:@"showLoading(\"%@\");", NSLocalizedString(@"加载中…", nil)];
    [self.myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)displayError {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Error" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:imagePath];
    NSString *jsCode = [NSString stringWithFormat:@"showError(\"%@\");",[url absoluteString]];
    [self.myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (NSString *)escapeString:(NSString *)str {
    if (IsEmptyString(str) || ![str isKindOfClass:[NSString class]]) {
        return [NSString string];
    }
    NSString *jsString = str;
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\\r"];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\n"];
    return jsString;
}

#pragma mark - Action
- (void)switchMode:(UISwitch *)switchButton {
    NSString *jsCode = [NSString string];
    if (switchButton.isOn) {
        NSDictionary *dictionary = @{@"backgroundColor":@"#202125",
                                     @"titleColor":@"#AEB5C5",
                                     @"infoColor":@"#4E5057",
                                     @"contentColor":@"#AEB5C5",
                                     @"bannerColor":@"#343539"};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsCode = [NSString stringWithFormat:@"xfApplyThemeMode(%@);", paramString];
    } else {
        jsCode = @"xfRemoveThemeMode();";
    }
    [self.myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)switchFontSize:(UIBarButtonItem *)itemButton {
    if (++ itemButton.tag >= 3) {
        itemButton.tag = 0;
    }
    NSString *jsCode = [NSString string];
    switch (itemButton.tag) {
        case 0: {
            itemButton.title = @"Small";
            jsCode = @"xfSetFontSize('small');";
            break;
        } case 1: {
            itemButton.title = @"Middle";
            jsCode = @"xfSetFontSize('');";
            break;
        } case 2: {
            itemButton.title = @"Big";
            jsCode = @"xfSetFontSize('big');";
            break;
        } default: {
            break;
        }
    }
    [self.myWebView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (void)switchContent:(UIBarButtonItem *)itemButton {
    if (++ itemButton.tag >= 3) {
        itemButton.tag = 0;
    }
    switch (itemButton.tag) {
        case 0: {
            itemButton.title = @"Loading";
            [self displayLoading];
            break;
        } case 1: {
            itemButton.title = @"Content";
            [self displayContent];
            break;
        } case 2: {
            itemButton.title = @"Error";
            [self displayError];
            break;
        } default: {
            break;
        }
    }
}

- (void)transferOCJS:(UIWebView *)webView {
    
    // 加载 HTML 示例
    [webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"MX5NewsContent" withExtension:@"html"]]];
    // 加载 JavaScript 示例
    [webView stringByEvaluatingJavaScriptFromString:@"addData(\"title\",\"this is title\")"];
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"addData(\"correlationHeader\",\"%@\");", NSLocalizedString(@"相关新闻", nil)]];

    // iOS和js交互调用: 首先创建JSContext 对象:即是js环境
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //  1、直接调用html中的function：用context的下标取出html中的function
    context[@"testExecute"] = ^(){
        NSArray *args = [JSContext currentArguments];// 获取参数的数组
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    //一个参数
    NSString *jsFuncStr1 = @"testExecute('1个参数')";
    [context evaluateScript:jsFuncStr1];
    //二个参数
    NSString *jsFuncStr2 = @"testExecute('参数1','参数2')";
    [context evaluateScript:jsFuncStr2];
    
    JSContext *context2=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 手动书写的script，调动funtion
    JSContext *context3 = [[JSContext alloc] init];
    [context3 evaluateScript:@"function add(a,b) {return a + b; }"];
    JSValue *addFunction = context3[@"add"];
    JSValue *sum = [addFunction callWithArguments:@[@7,@12]];
    NSLog(@"%@",sum);
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
    [webView stringByEvaluatingJavaScriptFromString:@"document.title = '我是邱少依'"];
    
    // 5.调用该点击方法
    [webView stringByEvaluatingJavaScriptFromString:@"setImageClickFunction()"];
}

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
    if ([self.view window] == nil) {
        self.view = nil;
    }
}

@end
