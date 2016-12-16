//
//  UIColor+LBPlaceholder.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LBPlaceholder)

@property (nonatomic, readonly) UILabel *lbPlaceholderLabel;
@property (nonatomic, strong) NSString *lbPlaceholder;
@property (nonatomic, strong) NSAttributedString *lbAttributedPlaceholder;
@property (nonatomic, strong) UIColor *lbPlaceholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
