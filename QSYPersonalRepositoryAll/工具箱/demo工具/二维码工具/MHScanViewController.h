//
//  MHScanViewController.h
//  MHBarCodesDemo
//
//  Created by Macro on 8/29/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWidth [[UIScreen mainScreen] bounds].size.width

#define kHeight [[UIScreen mainScreen] bounds].size.height

#define kCenterX self.view.center.x

#define kCenterY self.view.center.y

#pragma mark - about device

#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7

@interface MHScanViewController : UIViewController

@property (strong, nonatomic) void(^rebackData)(NSString *);

@end
