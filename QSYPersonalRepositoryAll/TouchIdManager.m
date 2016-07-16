//
//  TouchIdManager.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "TouchIdManager.h"

#define iOS8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
static NSString *const RESULT_STRING = @"验证Touch ID";
@interface TouchIdManager ()
@property (nonatomic, strong)LAContext *touchIdContext;
- (instancetype)init;
@end

@implementation TouchIdManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL )isSupportTouchId {
    
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    
    if (iOS8_LATER) {
        NSError *error = nil;
        BOOL availabel = [self.touchIdContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (!availabel && error) {
            switch (error.code) {
                case LAErrorTouchIDNotAvailable:
                    NSLog(@"touch id 不可用");
                    break;
                case LAErrorTouchIDNotEnrolled:
                    NSLog(@"touch id 未录入");
                    break;
                case LAErrorInvalidContext/*AVAILABLE iOS9.0*/:
                    break;
                case LAErrorTouchIDLockout:
                    /*AVAILABLE iOS9.0*/
                    // 用户输入多次TouchID,均错误
                    // 需要输入密码，系统已做处理
                    break;
                default:
                    break;
            }
        }
        return availabel;
    }
    return NO;
    
#endif
}

- (void)touchIdReply:(TouchIdReplyBlock )reply {//封装某个方法很简单： 把封装的方法的参数作为新方法的参数.
    if (![self isSupportTouchId]) return;
    [self.touchIdContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:RESULT_STRING reply:reply];
}

- (LAContext *)touchIdContext {
    if (!_touchIdContext) {
        _touchIdContext = [[LAContext alloc] init];
    }
    return _touchIdContext;
}
@end
