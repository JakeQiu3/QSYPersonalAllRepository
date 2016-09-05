//
//  ViewController.m
//  Model
//
//  Created by qsyMac on 16/1/22.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_fileNameArray;
    NSMutableArray *_titileArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadData {
//    http://www.jianshu.com/p/8dda0caf47ea
    _fileNameArray = @[@"知识点总测试",@"Xib和Storyboard使用汇总",@"坐标系转换",@"单tab的下拉菜单",@"Masonry 适配",@"Json和XML解析",@"数据库工具之FMDB",@"数据库工具之sqlite3.0",@"TabBar封装",@"二维码和条形码",@"计时器",@"导航条的隐藏和渐变处理",@"改变动画",@"冻结cell列表",@"加载Webview",@"加载WKWebview",@"TouchID使用",@"广告位轮播",@"自定义含button的弹出框",@"左Tab右Tab或Col",@"混合Tab (<=2)的下拉菜单",@"无交互的滑动栏间PickerView",@"有交互的滑动栏pickerView",@"清除缓存工具",@"自定义和系统菊花转起来"].mutableCopy;
    _titileArray = @[@"TestTotalViewController",@"AutoLayoutViewController",@"TapAExitOtherViewController",@"PullDownMenuViewController",@"MasonryContraintViewController",@"JsonAndXmlParserViewController",@"FmdbViewController",@"SqliteDatabaseViewController",@"无",@"CaptureDeviceViewController",@"MZTLViewController",@"NavBarViewController",@"ChangeAnimationViewController",@"FreezeViewController",@"WebViewDemoViewController",@"WKWebViewDemoViewController",@"TouchIdViewController",@"BannerViewController",@"CustomAlertViewController",@"TabActionColViewController",@"MutlipleTwoTabAndOneTabViewController",@"QSYSinglePickerView",@"MulitplePickerViewController",@"ClearCacheViewController",@"UserDefinedLoadingViewController"].mutableCopy;//
}

- (void)setUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    _tableView.rowHeight = 50;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *qsyIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:qsyIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:qsyIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@" %@:  %@",@"邱少一",_fileNameArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls;
//    不同类型(特指出结构体类型)和字符串之间转换
    cls = NSClassFromString(_titileArray[indexPath.row]);
    UIViewController *viewC = [[cls alloc] init];
    [self.navigationController pushViewController:viewC animated:YES];
}

// 收到memory warning 。。。。
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
    }

}

@end
