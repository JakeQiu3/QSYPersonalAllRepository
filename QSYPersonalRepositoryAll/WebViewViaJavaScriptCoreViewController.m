//
//  WebViewViaJavaScriptCoreViewController.m
//  QSYPersonalRepositoryAll
//  Created by 邱少依 on 2017/1/13.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import "WebViewViaJavaScriptCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "TestJSObject.h"

@interface WebViewViaJavaScriptCoreViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *myWebView;
@end

@implementation WebViewViaJavaScriptCoreViewController

//详见：上面的master
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JavaScriptCore.framework交互";
    [self.view addSubview:self.myWebView];
    [self loadRequestHtml];
    [self transferOCJS:self.myWebView];// JS和OC的交互
}


- (void)loadRequestHtml {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"javascriptCoreTest" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [self.myWebView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)transferOCJS:(UIWebView *)webView {
    
    // 加载 HTML 示例
    [webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"XFNewsContent" withExtension:@"html"]]];
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
    //2、js是通过对象调用的，我们假设js里面有一个对象 testobject 在调用方法
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
