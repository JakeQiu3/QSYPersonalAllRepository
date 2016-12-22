//
//  ViewController.m
//  NavigationBarSliding
//
//  Created by US10 on 16/7/21.
//  Copyright © 2016年 US10. All rights reserved.
//


/**
 使用说明：
 1.将需要此效果的 UIViewController 继承NavBarViewController；
 2.调用方法 [self followSwipeScrollView:self.****]; //可以是scrollView或者tableview，webview。
 注意：要设置 self.navigationController.navigationBar.barTintColor 属性,否则会出现一个小的视觉上的bug(navigationBar隐藏不了)。
 */

#import "UseNavBarScrollViewController.h"

#define NavBarFrame self.navigationController.navigationBar.frame
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
@interface UseNavBarScrollViewController ()
@property (retain , nonatomic) UITableView *tableView;
@end

@implementation UseNavBarScrollViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        CGRect frame = CGRectMake(0, 0, screenW, screenH);
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TableView";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //followSwipeScrollView：必须在此处调用，不然会有你意想不到的bug（你可能都发现不了）
    [self followSwipeScrollView:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"小新 ---%ld--- ",indexPath.row + 1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
