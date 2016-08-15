//
//  BaseModel.m
//  PManager
//
//  Created by qsy on 13-12-11.
//  Copyright (c) 2013年 qsy. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

-(NSDictionary*)attributeMapDictionary
{
    return nil;
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

- (NSString *)customDescription
{
    return nil;
}

- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",attributeName, valueObj];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
            }
        }
    }
    
    NSString *customDesc = [self customDescription];
    NSString *desc;
    
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
    }else {
        desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
    }
    
    return desc;
}

-(void)setAttributes:(NSDictionary*)dataDic
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[dataDic count]];
        for (NSString *key in dataDic) {
            [dic setValue:key forKey:key];
            attrMapDic = dic;
        }
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
            id attributeValue = [dataDic objectForKey:dataDicKey];
            
            if (attributeValue == nil) {
                if ([attributeName isEqualToString:@"body"]) {
                    continue;
                }
                attributeValue = @"";
            }
            
            [self performSelectorOnMainThread:sel
                                   withObject:attributeValue
                                waitUntilDone:[NSThread isMainThread]];
            //---------------------------分线程取数据----------------------------------
            //如果开分线程请求网络,就用下面这句。
            //                        [self performSelectorOnMainThread:sel withObject:attributeValue waitUntilDone:YES];
        }
    }
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init] ){
        NSDictionary *attrMapDic = [self attributeMapDictionary];
        if (attrMapDic == nil) {
            return self;
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:attributeName];
                [self performSelectorOnMainThread:sel
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSDictionary *attrMapDic = [self attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
        }
    }
}

- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)cleanString:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    //    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

#pragma mark -- 解析model
+ (NSDictionary *)dictionaryWithModel:(id)model
{
    if (!model) {
        return nil;
    }
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    //    NSString *className = NSStringFromClass([model class]);
    //    id classObject = objc_getClass([className UTF8String]);
    
    // 得到所有的属性列表
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([model class], &count);
    
    for (int i=0; i<count; i++) {
//        objc_property_t property = properties[i];
        objc_property_t property  = *(properties + i);
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if (!valueObject) {
            continue;
        }
        
        if ([valueObject isKindOfClass:[NSDictionary class]] ||
            [valueObject isKindOfClass:[NSArray class]] ||
            [valueObject isKindOfClass:[NSString class]] ||
            [valueObject isKindOfClass:[NSNumber class]]) {
            propertyValue = [valueObject copy];
        } else {
            NSString *string = [NSString stringWithFormat:@"%@ must follow the protocol of <NSCopying>", propertyName];
            NSAssert([valueObject conformsToProtocol:@protocol(NSCopying)], string);
            propertyValue = [valueObject copy];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}

@end
