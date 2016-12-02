//
//  CustumAlertView.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/7/17.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustumAlertView;
@protocol CustumAlertConfirmDelegate<NSObject>
- (void)confirmAlert:(CustumAlertView *)alertView withConfirmBtn:(UIButton *)btn;
@end

@interface CustumAlertView : UIView
{
    UIWindow *_window;
}
@property (nonatomic, weak) id<CustumAlertConfirmDelegate> delegate;
// 控件
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentLabel;
@property (nonatomic, strong) UIButton *confirmBtn;
- (id)initWithFrame:(CGRect)frame;
- (void)show;
- (void)dismiss;


@end
