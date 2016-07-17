//
//  CustomAlertViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "CustumAlertView.h"
@interface CustomAlertViewController ()<CustumAlertConfirmDelegate>

@end

@implementation CustomAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomAlertV];
    
    // Do any additional setup after loading the view.
}

- (void)initCustomAlertV {
    CustumAlertView *alert = [[CustumAlertView alloc] init];
    alert.delegate = self;
    alert.titleLabel.text = @"购买须知";
    alert.contentLabel.text = @"以商品实际销售价格作为完税价格（征税基数），参照行邮税税率征收税款。应征税额在50元（含50元）以下的，海关予以免征。消费者购买宁波跨境贸易电子商务进口商品，以“个人自用、合理数量”为原则，参照《海关总署公告2010年第43号（关于调整进出境个人邮递物品管理措施有关事宜）》要求，每次限值为2000元人民币，超出规定限值的，应按照货物规定办理通关手续。但单次购买仅有一件商品且不可分割的，虽超出规定限值，经海关审核确属个人自用的，可以参照个人物品规定办理通关手续。对于违反规定，超出个人自用合理数量购买的，系统将予以退单，情节严重的，将追究个人法律责任。";
    alert.confirmBtn.hidden = NO;
    [alert show];

}
#pragma _mark delegate 方法
- (void)confirmAlert:(CustumAlertView *)alertView withConfirmBtn:(UIButton *)btn {
    [alertView dismiss];
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
