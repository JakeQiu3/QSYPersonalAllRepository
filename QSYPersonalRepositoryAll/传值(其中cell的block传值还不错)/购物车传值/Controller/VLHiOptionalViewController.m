//
//  VLHiOptionalViewController.m
//  VoiceLink
//
//  Created by fanyunyu on 16/1/12.
//  Copyright © 2016年 voilink. All rights reserved.
//

#import "VLHiOptionalViewController.h"
#import "VLDiscountInfoViewController.h"


#import "VLGetPackageItemParams.h"
#import "VLGetPackageDetail.h"
#import "VLPackageDetailItem.h"

#import "VLHiOptionalModel.h"
#import "VLHiOptionalViewControllerCell.h"

#import "VLHiOptionalCountModel.h"

@interface VLHiOptionalViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)  UIScrollView *bgScrollView;


@property (nonatomic, strong)  UILabel *desLabel ;

@property (nonatomic, strong)  UILabel *campaignValidTimeLabel;

@property (nonatomic, strong)  UIButton *buyBtn ;

@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong)  NSMutableArray *dataArray;

@property (nonatomic, strong)  NSMutableArray *countArray;

@property (nonatomic, assign)  NSInteger totalPrice ;

@property (nonatomic, strong)  UILabel *moneyLabel ;

@end


@implementation VLHiOptionalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"#55acef"];
    self.navigationItem.title = self.navTitle;
    
    [self createNav];
    
    
    if ([[UIDevice currentDevice]systemVersion].floatValue >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self CreateUI];
    
    
    [self createDataSoure];
    
}


-   (void)createDataSoure{
    _dataArray = [NSMutableArray array];
    _countArray = [NSMutableArray array];
    
    VLGetPackageItemParams *prams = [[VLGetPackageItemParams alloc]init];
    prams.packageNo = self.packageNo;
    
    [VLGetPackageDetail getPackageDetail:prams success:^(VLPackageDetail *packageDetail) {
        
        
        
        for (int i = 0; i < packageDetail.baseProducts.count; i++) {
            
            VLPackageDetailItem *item = packageDetail.baseProducts[i];
            
            VLHiOptionalModel *model = [ [VLHiOptionalModel alloc] init];
            
            NSLog(@"%@  %@  %@  %@",item.productName, item.productNo ,item.price ,item.times);
            
            
            model.productName = item.productName;
            model.bidPrice = item.bidPrice;
            model.price = item.price;
            model.times = item.times;
            
            
            VLHiOptionalCountModel *countModel = [ [VLHiOptionalCountModel alloc] init];
            countModel.productNo = item.productNo;
            countModel.price = item.price;
            countModel.times = [item.times integerValue];
            
            [_countArray addObject:countModel];

            
//            model.title = item.desc;
//            model.count = item.times;
            
            [_dataArray addObject:model];
        }
        
        
        _tableView.size = CGSizeMake(VLScreenW - 40, _dataArray.count*40);
        
        [_tableView reloadData];
        
        
        
        UILabel *secondLineLabel = [ [UILabel alloc] init];
        secondLineLabel.backgroundColor = [UIColor grayColor];
        secondLineLabel.size = CGSizeMake(VLScreenW - 40, 1);
        secondLineLabel.top = _tableView.bottom ;
        secondLineLabel.left = _tableView.left;
        [_bgScrollView addSubview:secondLineLabel];
        
        UILabel *ktTimeLabel = [[UILabel alloc]init];
        ktTimeLabel.text = @"开通时间:2016-01-04至2016-02-28";
        ktTimeLabel.size = CGSizeMake(VLScreenW - 40, 20);
        ktTimeLabel.top = secondLineLabel.bottom +10;
        ktTimeLabel.left = secondLineLabel.left;
        [_bgScrollView addSubview:ktTimeLabel];
        
        
        
        
        
        
        
        _totalPrice = 0;
        for (int i = 0; i<_countArray.count; i++) {
            VLHiOptionalCountModel *countModel = [ [VLHiOptionalCountModel alloc]init];
            countModel = _countArray[i];
            _totalPrice = _totalPrice + [countModel.price integerValue] *countModel.times;
        }
        
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.text =[NSString stringWithFormat:@"应付金额:%d元",_totalPrice];  //@"应付金额:%d元";
        _moneyLabel.size = CGSizeMake(200, 20);
        _moneyLabel.top = ktTimeLabel.bottom + 10;
        _moneyLabel.right = secondLineLabel.right;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        [_bgScrollView addSubview:_moneyLabel];
        
        
//        VLHiOptionalViewControllerCell *cell = [ [VLHiOptionalViewControllerCell alloc] init];
        
        
        
        
        
//        UILabel *youhuijiaLabel = [ [UILabel alloc] init];
//        youhuijiaLabel.text = [NSString stringWithFormat:@"优惠价:%@元",self.price];
//        youhuijiaLabel.size = CGSizeMake(100, 20);
//        youhuijiaLabel.top = yuanjiaLabel.bottom + 10;
//        youhuijiaLabel.right = yuanjiaLabel.right;
//        youhuijiaLabel.textAlignment = NSTextAlignmentRight;
//        [_bgScrollView addSubview:youhuijiaLabel];
        
        
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.size = CGSizeMake(200, 30);
        _buyBtn.centerX = secondLineLabel.centerX;
        _buyBtn.top = _moneyLabel.bottom + 30 ;
        
        [_buyBtn setTitle:@"我要购买" forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:[UIColor colorWithHexString:@"#55acef"]];
        _buyBtn.layer.cornerRadius = _buyBtn.height/2;
        _buyBtn.clipsToBounds = YES ;
        [_buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:_buyBtn];
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}




-   (void)createNav{
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBtn.frame = CGRectMake(20, 20+5, 18, 30);
    [leftBtn setImage:[UIImage imageNamed:@"regsiter_btn_back"] forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [ [UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.title = self.navTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-   (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}




-   (void)CreateUI{
    
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, VLScreenW, VLScreenH - 64)];
    _bgScrollView.contentSize = CGSizeMake(VLScreenW, VLScreenH*2);
    _bgScrollView.contentOffset = CGPointZero;
//    _bgScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_bgScrollView];
    
    NSString *text = self.desc;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(VLScreenW-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    _desLabel = [ [UILabel alloc] initWithFrame:CGRectMake(20,20, VLScreenW - 40, rect.size.height)];
    _desLabel.font = [UIFont systemFontOfSize:17];
    _desLabel.backgroundColor = [UIColor whiteColor];
    _desLabel.text = [NSString stringWithFormat:@"%@",text];
    
    _desLabel.numberOfLines = 0;
    [_bgScrollView addSubview:_desLabel];
    
    _campaignValidTimeLabel = [[UILabel alloc]init];
    _campaignValidTimeLabel.text = @"服务有效期:(新春特惠)至2016-02-28";
    _campaignValidTimeLabel.size = CGSizeMake(VLScreenW - 40, 20);
    _campaignValidTimeLabel.top = _desLabel.bottom + 10;
    _campaignValidTimeLabel.left = _desLabel.left;
    [_bgScrollView addSubview:_campaignValidTimeLabel];
    
    UILabel *emergencyLabel = [[UILabel alloc]init];
    emergencyLabel.size = CGSizeMake(60, 20);
    emergencyLabel.top = _campaignValidTimeLabel.bottom + 10;
    emergencyLabel.left = _campaignValidTimeLabel.left;
    emergencyLabel.text = @"自选包";
    [_bgScrollView addSubview:emergencyLabel];
    
    UILabel *firstLineLabel = [[UILabel alloc]init];
    firstLineLabel.backgroundColor = [UIColor grayColor];
    firstLineLabel.size = CGSizeMake(VLScreenW - 40, 1);
    firstLineLabel.top = emergencyLabel.bottom + 5;
    firstLineLabel.left = emergencyLabel.left;
    [_bgScrollView addSubview:firstLineLabel];
    
    
    _tableView = [[UITableView alloc]init];
    _tableView.top = firstLineLabel.bottom;
    _tableView.left = firstLineLabel.left;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_bgScrollView addSubview:_tableView];
    
}


#pragma mark - tableView的代理
-   (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-   (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * Identifier = @"springTravelID";
    VLHiOptionalViewControllerCell *packageCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (packageCell == nil) {
        packageCell = [ [VLHiOptionalViewControllerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    
    
    VLHiOptionalModel *model = _dataArray[indexPath.row];
    
    packageCell.indexPath = indexPath;
    
    [packageCell configCellWithModel:model];
    
//    packageCell.myBlock = ^(NSString *str){
//        model.times = str;
//    };
    
    
    packageCell.myBlock = ^(NSString *times , NSIndexPath *indexPath){
        _totalPrice = 0;
        
        
        //            _countArray replaceObjectAtIndex:indexPath.row withObject:<#(nonnull id)#>
        
        for (int i = 0; i<_countArray.count; i++) {
            if (i == indexPath.row) {
                VLHiOptionalCountModel *countModel = [ [VLHiOptionalCountModel alloc]init];
                countModel = _countArray[i];
                countModel.times = [times integerValue];
                [_countArray replaceObjectAtIndex:indexPath.row withObject:countModel];
            }
            
            VLHiOptionalCountModel *countModel = [ [VLHiOptionalCountModel alloc]init];
            countModel = _countArray[i];
            _totalPrice = _totalPrice + [countModel.price integerValue] *countModel.times;
            
            _moneyLabel.text = [NSString stringWithFormat:@"应付金额:%d元",_totalPrice];
        }
    };

    
    return packageCell;
}


-   (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


-   (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-   (void)buyBtnClick{
    VLDiscountInfoViewController *discountVc = [ [VLDiscountInfoViewController alloc] init];
    discountVc.packageNo = self.packageNo;
    [self.navigationController pushViewController:discountVc animated:YES];
}



@end
