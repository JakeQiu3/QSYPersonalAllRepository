//
//  BaseModel.h
//  PManager
//
//  Created by qsy on 14-6-20.
//  Copyright (c) 2014年 qsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>{
    
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
- (NSString *)cleanString:(NSString *)str;//清除\n和\r的字符串

+ (NSDictionary *)dictionaryWithModel:(id)model;

@end
