//
//  LBProjectUtil.m
//  LBExpandDemo
//
//  Created by qsy on 16/11/17.
//  Copyright © 2016年 qsy. All rights reserved.
//

#import "LBProjectUtil.h"

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])
#define LBTOKEN @"deviceToken"
@implementation LBProjectUtil

+ (void)tokenStore:(NSString *)token{
    if (!OBJ_IS_NIL(token)) {
        [[NSUserDefaults standardUserDefaults]setValue:token forKey:LBTOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)tokenClean{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LBTOKEN];
}

+ (NSString *)tokenGet{
    NSString *token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LBTOKEN]];
    // 此处最好做判断，是否是字符串
    if (token) {
        return token;
    }
    return @"";
}

@end
