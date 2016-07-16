//
//  AutoLayoutViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/6/5.
//  Copyright © 2016年 QSY. All rights reserved.
//搞起来过一遍 https://letaibai.gitbooks.io/objective-c-notebook/content/chapter1.html
#pragma   storyboard 和xib本质都是xml。
//1. storyboard是含有业务逻辑的不同VC的集合； xib是View。
//2. xib中View创建对应代码-> init，frame、color、text、enabled等属性的设置，以及addSubView  这些操作。
#import "AutoLayoutViewController.h"
#import "CustomTestView.h"
static NSString *const autoIdentifier = @"autocellIdentifier";
@interface AutoLayoutViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation AutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];// 设置tableview才能显示分割线
#pragma mark 0. autoresizingMask自适应大小：该tableView控件相对self.view父控件,Autoresizing只能解决控件在父控件之间的位置,不能解决子控件与其他控件之间的位置,所以Autoresizing的局限性比较大.
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
#pragma mark 1. AutoLayout ：任何2控件间的约束-> 代码量大，复杂，弃之不用。
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:blueView];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 100,100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.tableView addSubview:redView];
    
    blueView.translatesAutoresizingMaskIntoConstraints = NO;//禁用button的Autoresizing功能,否则AutoLayout会冲突。
    redView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:.0f constant:200];
    //    添加约束到redView:
    [blueView addConstraint:widthConstraint];
    
    NSLayoutConstraint *widthContraint1 = [NSLayoutConstraint constraintWithItem:blueView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:redView attribute:NSLayoutAttributeHeight multiplier:.0f constant:20];
    [blueView addConstraint:widthContraint1];
    [redView addConstraint:widthContraint1];
#pragma mark 2. 代码约束：massonry
//    见之前
#pragma mark 3.init 和 xib 创建控件区别: 每种也都有2种方式，自定义（继承为子类）或系统（直接创建,以赴时控制器或者父视图）。
    //    init: 动态方法: // 上面initLabel1 或 initLabel2 底层调用：initwithFrame 方法
    CustomTestView *initView1 = [[CustomTestView alloc] init];
    initView1.frame = CGRectZero;
    UILabel *initLabel2 = [[UILabel alloc] initWithFrame:CGRectNull];
    
    // xib创建:静态方法或直接创建getter  底层调用：- (instancetype)initWithCoder:(NSCoder *)aDecoder 当控件加载完成之前调用；\
    - (void)awakeFromNib// 当控件加载完成之后调用
    //  在xib中通过控件和代码建立关联
    //    或
    //   UIView  *xibView = [[[NSBundle mainBundle] loadNibNamed:@"customTest" owner:nil options:nil] lastObject];
    //   再或（代码和xib 混合版）
    //    + (instancetype)label;
    //    + (instancetype)label {
    //        return [[[NSBundle mainBundle] loadNibNamed:@"viewLabel" owner:nil options:nil] lastObject];
    //    }
#pragma mark 4. UITableViewCell的创建及重用：纯代码或xib ，均又分：自定义或系统自带。
    //    1.纯代码系统自带：
    //    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //        static NSString *const cellID = @"autoLayoutCell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //        if (!cell) {
    //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    //        }
    
    //   1. 纯代码自定义：前提是在自定义cell里有- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    //    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //    if (self) {
    //        [self initSubViews];
    //    }
    //    return self;
    //}
    //在控制器中执行
    //   - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //        static NSString *cellIndenfiner = @"cellIndenfiner";
    //        StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfiner];
    //        if (!cell) {
    //            cell = [[StatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfiner];
    //        }
    //        WeiboStatus *status = _dataArray[indexPath.row];
    //        cell.weiboStatus = status;
    //        return cell;
    //    }
    
    // 代码版register 方法：  前提：设置标示-> static NSString *const autoIdentifier = @"autocellIdentifier"; 注册cell -> [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID] 或 [self.tableView registerNib:[UINib nibWithNibName:@"cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:autoIdentifier];
    
    //   - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    //        return cell;
    //    }
    
    //  2.storyboard 或xib
//storyboard 或xib 的自定义版本//    注册cell：加载该xib的cell到tableview 的cell 上
    [self.tableView registerNib:[UINib nibWithNibName:@"TestTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:autoIdentifier];
    //  重新设置tableview的属性
    _dataArray = @[].mutableCopy;
    for (NSInteger i=0; i<10; i++) {
        NSMutableString *firstStr =@"".mutableCopy;
        for (NSInteger j=0; j<i; j++) {
            NSString *str = @"autolayoutautolayout";
            [firstStr appendString:str];
        }
        //        [_dataArray addObject:firstStr];
    }
    // Do any additional setup after loading the view.
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *IDStr = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDStr];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"我要说我被点击了,收到了侵犯");
}

//estimatedHeightForRowAtIndexPath 是 iOS 7 推出的新 API。如果列表行数有一万行，那么 heightForRowAtIndexPath 就会在列表显示之前计算一万次，而 estimatedHeightForRowAtIndexPath 只会计算当前屏幕中显示着的几行，会大大提高数据量很大时候的性能。
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = _dataArray[indexPath.row];
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-16-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIColor greenColor],NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size;
    NSLog(@"===%f",size.height);
    return size.height+16;
    
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
