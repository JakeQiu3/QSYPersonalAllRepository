//
//  FirstViewController.m
//  XibEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstModel.h"
#import "FirstTableViewCell.h"

#import "SecondViewController.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
//定义属性,接收模型
@property (nonatomic,strong) NSArray *firstModelArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 已被覆盖：弃用
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@end

@implementation FirstViewController
//懒加载模型
- (NSArray *)firstModelArr{
    if (_firstModelArr == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *statusArr = [NSMutableArray array];
        
        for (NSDictionary *dic in dictArr) {
            FirstModel *model = [FirstModel firstModelWithDict:dic];
            [statusArr addObject:model];
        }
        _firstModelArr = statusArr;
    }
    return _firstModelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
}

- (void)setNav {
    self.title = NSStringFromClass([self class]);
    
    UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"navigation_back_green.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"navigation_back_green.png"] forState:UIControlStateHighlighted];
    _backButton.frame = CGRectMake(0, 0, 30, 30);
    _backButton.showsTouchWhenHighlighted = 1;
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 80, 30);
    rightButton.showsTouchWhenHighlighted = 1;
    [rightButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)backAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction:(UIButton *)btn {
    [self clickJump:btn];
}

- (IBAction)clickJump:(id)sender {
    SecondViewController *secVC = [[SecondViewController alloc] initWithNibName:@"SecondVC" bundle:nil];//SecondViewController  
    [self.navigationController pushViewController:secVC animated:YES];
}
// 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.firstModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [FirstTableViewCell cellWithTableView:tableView];
    cell.firstModel = self.firstModelArr[indexPath.row];
    return cell;
}
//设置cell的估计高度,调换heightForRowAtIndexPath:与cellForRowAtIndexPath:的调用顺序,同时优化系统
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出模型中对应的高度数据
    FirstModel *model = self.firstModelArr[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(void)didReceiveMemoryWarning {
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
