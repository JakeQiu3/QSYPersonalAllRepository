//
//  UIColor+LBPlaceholder.h
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextView+LBPlaceholder.h"

@implementation UITextView (LBPlaceholder)

#pragma mark - Swizzle Dealloc
+ (void)load {
    [super load];
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(lbPlaceholderLabel));
    if (label) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
+ (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        color = [textField valueForKeyPath:@"_placeholderLabel.textColor"];
    });
    return color;
}

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self updatePlaceholderLabel];
}


#pragma mark - Update
- (void)updatePlaceholderLabel {
    if (self.text.length) {
        [self.lbPlaceholderLabel removeFromSuperview];
        return;
    }
    [self insertSubview:self.lbPlaceholderLabel atIndex:0];

    self.lbPlaceholderLabel.font = self.font;
    self.lbPlaceholderLabel.textAlignment = self.textAlignment;

    // `NSTextContainer` is available since iOS 7
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;

#pragma deploymate push "ignored-api-availability"
    // iOS 7+
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        lineFragmentPadding = self.textContainer.lineFragmentPadding;
        textContainerInset = self.textContainerInset;
    }
#pragma deploymate pop

    // iOS 6
    else {
        lineFragmentPadding = 5;
        textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
    }

    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.lbPlaceholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.lbPlaceholderLabel.frame = CGRectMake(x, y, width, height);
}


#pragma mark - set & get
- (NSString *)lbPlaceholder {
    return self.lbPlaceholderLabel.text;
}

- (void)setLbPlaceholder:(NSString *)lbPlaceholder {
    self.lbPlaceholderLabel.text = lbPlaceholder;
    [self updatePlaceholderLabel];
}

- (NSAttributedString *)lbAttributedPlaceholder {
    return self.lbPlaceholderLabel.attributedText;
}

- (void)setLbAttributedPlaceholder:(NSAttributedString *)lbAttributedPlaceholder {
    self.lbPlaceholderLabel.attributedText = lbAttributedPlaceholder;
    [self updatePlaceholderLabel];
}

- (UIColor *)lbPlaceholderColor {
    return self.lbPlaceholderLabel.textColor;
}

- (void)setLbPlaceholderColor:(UIColor *)lbPlaceholderColor{
    self.lbPlaceholderLabel.textColor = lbPlaceholderColor;
}


#pragma mark - lazy load
- (UILabel *)lbPlaceholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(lbPlaceholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        
        label = [[UILabel alloc] init];
        label.textColor = [self.class defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(lbPlaceholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}

@end
