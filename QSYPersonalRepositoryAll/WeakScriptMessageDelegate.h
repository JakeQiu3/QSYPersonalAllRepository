//
//  WeakScriptMessageDelegate.h
//  QSYPersonalRepositoryAll
//  
//  Created by 邱少依 on 2017/3/17.
//  Copyright © 2017年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
