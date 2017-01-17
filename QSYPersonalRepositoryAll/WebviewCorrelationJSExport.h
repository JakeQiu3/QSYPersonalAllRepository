//
//  XFCorrelationNewsJSExport.h
//  XFNewsContentDemo
//  JSExport工具类
//  Created by qsy on 16/8/24.
//  Copyright © 2016年 maxthon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WebViewExportDelegate <NSObject>

- (void)onClick:(NSInteger)index;
- (void)onload;
- (void)documentReadyStateComplete;

@end

@protocol WebviewCorrelationJSExport <JSExport>

- (void)onClick:(NSInteger)index;
- (void)onload;
- (void)documentReadyStateComplete;

@end

@interface WebviewCorrelationJSExport : NSObject <WebviewCorrelationJSExport>

@property (nonatomic, weak) id<WebViewExportDelegate> delegate;

@end
