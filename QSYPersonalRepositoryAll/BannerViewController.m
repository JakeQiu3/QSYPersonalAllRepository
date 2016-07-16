//
//  BannerViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "BannerViewController.h"
#import "KNBannerView.h"
@interface BannerViewController ()<KNBannerViewDelegate>

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"BannerView演示";
    self.automaticallyAdjustsScrollViewInsets = NO;//不自适应滚动，ios7以后
    [self setupNetBannerView];//网络请求
    [self setupLocatioBannerView];// 本地获得
    
    // Do any additional setup after loading the view.
}

- (void)setupNetBannerView {
    /****************************** == url数组 == ********************************/
    NSMutableArray *imgArr = [NSMutableArray array];
    NSString *img1 = @"http://i3.download.fd.pchome.net/t_960x600/g1/M00/07/09/oYYBAFMv8q2IQHunACi90oB0OHIAABbUQAAXO4AKL3q706.jpg";
    NSString *img2 = @"http://images.weiphone.net/attachments/photo/Day_120308/118871_91f6133116504086ed1b82e0eb951.jpg";
    NSString *img3 = @"http://benyouhuifile.it168.com/forum/macos/attachments/month_1104/110425215921926a173e0f728e.jpg";
    NSString *img4 = @"http://benyouhuifile.it168.com/forum/macos/attachments/month_1104/1104241737046031b3a754f783.jpg";
    NSString *img5 = @"http://2b.zol-img.com.cn/product/68/951/cerUrKWCmHCnU.jpg";
    [imgArr addObject:img1];
    [imgArr addObject:img2];
    [imgArr addObject:img3];
    [imgArr addObject:img4];
    [imgArr addObject:img5];
    
    /****************************** == 描述文字 == ********************************/
    NSMutableArray *IntroduceArr = [NSMutableArray array];
    NSString *string1 = @"网络图片加载时";
    NSString *string2 = @"图片较大";
    NSString *string3 = @"所以比较缓慢";
    NSString *string4 = @"如有框架建议";
    NSString *string5 = @"GitHub联系我";
    
    [IntroduceArr addObject:string1];
    [IntroduceArr addObject:string2];
    [IntroduceArr addObject:string3];
    [IntroduceArr addObject:string4];
    //    [IntroduceArr addObject:string5];
    NSString *placeHolder = @"1.jpg";
    KNBannerView *bannerView = [KNBannerView bannerViewWithNetWorkImagesArr:imgArr frame:CGRectMake(0, 64, self.view.width, 180) placeHolder:placeHolder];
    bannerView.delegate = self;
    bannerView.IntroduceStringArr = IntroduceArr;
    /****************************** == 占位图 == ********************************/
    
    bannerView.tag = 100;
    [self.view addSubview:bannerView];
    
}

/**
 *  设置 本地 banner图
 */
- (void)setupLocatioBannerView{
    /****************************** == 本地图片名数组 == ********************************/
    NSString *img1 = @"1";
    NSString *img2 = @"2";
    NSString *img3 = @"3";
    NSString *img4 = @"4";
    NSString *img5 = @"5";
    NSArray *imgArr = [NSArray arrayWithObjects:img1,img2,img3,img4,img5, nil];
    /****************************** == 本地描述文字 == ********************************/
    NSString *string1 = @"这是本地图片";
    NSString *string2 = @"如果觉得还不错";
    NSString *string3 = @"记得给我点赞哦";
    NSString *string4 = @"我会更加努力的";
    NSString *string5 = @"谢谢大家的支持!";
    NSMutableArray *IntroduceArr = [NSMutableArray array];
    [IntroduceArr addObject:string1];
    [IntroduceArr addObject:string2];
    [IntroduceArr addObject:string3];
//    [IntroduceArr addObject:string4];
//        [IntroduceArr addObject:string5];
    NSString *placeHolder = @"1.jpg";
    KNBannerView *bannerView = [KNBannerView bannerViewWithLocationImagesArr:imgArr frame:CGRectMake(0, 300, self.view.frame.size.width, 180) placeHolder:placeHolder];
    bannerView.delegate = self;
    
    bannerView.IntroduceStringArr = IntroduceArr;
    bannerView.timeInterval = 2; // 图片轮播的时间间隔
    bannerView.timeInterval = 2; // 图片轮播的时间间隔
    bannerView.IntroduceTextFont = [UIFont systemFontOfSize:17];// 介绍文字字体大小
    bannerView.IntroduceBackGroundAlpha = 1.0;// 介绍文字的透明度
    bannerView.IntroduceBackGroundColor = [UIColor blackColor]; // 介绍文字的背景色
    //    bannerView.IntroduceHeight = 60;// 介绍文字的高度
    bannerView.IntroduceTextColor = [UIColor orangeColor]; // 介绍文字的颜色
    bannerView.PageIndicatorTintColor = [UIColor whiteColor];// pageControl的 其他'点'的颜色
    bannerView.CurrentPageIndicatorTintColor = [UIColor orangeColor];// pageControl的 当前'点'的颜色
    bannerView.pageControlStyle = KNPageControlStyleLeft;// pageControl 对其方式
    bannerView.IntroduceStyle = KNIntroduceStyleRight;// 介绍文字的对其方式
    bannerView.tag = 200;
    [self.view addSubview:bannerView];
    
    
}
// 代理方法
- (void)bannerView:(KNBannerView *)bannerView
didSelectItemAtIndexPath:(NSInteger)index{
    
    NSLog(@"点击了tag = %zd的 baannerview的第%zd个图片",bannerView.tag,index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
