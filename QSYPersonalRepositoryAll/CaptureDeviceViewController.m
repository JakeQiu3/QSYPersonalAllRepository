//
//  CaptureDeviceViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/20.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CaptureDeviceViewController.h"
#import "MHScanViewController.h"
enum {
    SCANRESULTLBL = 1000,
    TIPSLBL,
    SCANBTN,
    
};

@interface CaptureDeviceViewController ()

@end

@implementation CaptureDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add a label to show the result of scan
    UILabel *scanResultLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kWidth, 30)];
    scanResultLbl.backgroundColor = [UIColor greenColor];
    scanResultLbl.textColor = [UIColor blackColor];
    scanResultLbl.tag = SCANRESULTLBL;
    [self.view addSubview:scanResultLbl];
//
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 230, kWidth - 20, 15)];
    tipsLbl.text = @"扫描结果已保存到粘贴板了~~~";
    tipsLbl.font = [UIFont systemFontOfSize:12];
    tipsLbl.textColor = [UIColor blackColor];
    tipsLbl.hidden = NO;//YES
    tipsLbl.tag = TIPSLBL;
    [self.view addSubview:tipsLbl];
    
    // add a button to jump to scan view
    UIButton *scanBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    scanBtn.frame = CGRectMake(kCenterX - 50, 150, 100, 30);
    [scanBtn setTitle:@"开始扫描" forState:(UIControlStateNormal)];
    [scanBtn setBackgroundColor:[UIColor whiteColor]];
    [scanBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    scanBtn.tag = SCANBTN;
    [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:scanBtn];
}


- (void)scanAction:(UIButton *)btn {
    MHScanViewController *scanVC = [[MHScanViewController alloc] init];
    scanVC.rebackData = ^(NSString *retStr) {
        NSLog(@"回传过来的的扫面结果%@", retStr);
        UILabel *scanResultLbl = (UILabel *)[self.view viewWithTag:SCANRESULTLBL];
        scanResultLbl.text = retStr;
        ((UILabel *)[self.view viewWithTag:TIPSLBL]).hidden = NO;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = retStr;
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}


@end
