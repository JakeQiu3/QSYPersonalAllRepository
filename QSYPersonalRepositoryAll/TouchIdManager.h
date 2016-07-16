//
//  TouchIdManager.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef void(^TouchIdReplyBlock)(BOOL success,NSError *error);

@interface TouchIdManager : NSObject
- (BOOL )isSupportTouchId;
- (void)touchIdReply:(TouchIdReplyBlock )reply;

@end
