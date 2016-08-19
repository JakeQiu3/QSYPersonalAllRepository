//
//  QSYActivityView.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/16.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QSYActivityView : UIView
+ (void)startAnimatingInSuperView:(UIView *)superView isSystem:(BOOL)isSystem;
+ (void)stopAnimating;
+ (BOOL)isAnimating;
@end
