//
//  XML&JsonParser.h
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface XML_JsonParser : NSObject<NSXMLParserDelegate>
//数据数组和字典
@property (nonatomic, strong)NSMutableArray *teachersArray;
@property (nonatomic, strong)NSMutableDictionary *teacherDic;
@property (nonatomic, copy)NSString *contentString;

// xml解析:Sax
- (id)xmlWithSaxParserString:(NSString *)xmlName ;
// xml解析:Dom
- (id)xmlWithDomParserString:(NSString *)xmlName ;
// json 解析
- (id)jsonWithParserString:(NSString *)jsonName;

@end
