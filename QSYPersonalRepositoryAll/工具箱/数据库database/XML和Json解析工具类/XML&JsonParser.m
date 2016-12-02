//
//  XML&JsonParser.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "XML&JsonParser.h"

@implementation XML_JsonParser
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)xmlWithSaxParserString:(NSString *)xmlName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"];
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
  
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:fileData];
    
    xmlParser.delegate = self;
    //    5.开始解析
    [xmlParser parse];
    return _teachersArray;
}

//xml解析:Dom
- (id)xmlWithDomParserString:(NSString *)xmlName {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"];

    NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:fileStr options:0 error:nil];

    GDataXMLElement *rootElement = [document rootElement];

    NSArray *studentArray = [rootElement elementsForName:@"teacher"];

    _teachersArray = [[NSMutableArray alloc]init];
    for (GDataXMLElement *studentElement in studentArray) {
      
        NSArray *nameArray = [studentElement elementsForName:@"name"];
        NSArray *ageArray = [studentElement elementsForName:@"age"];
        NSArray *sexArray = [studentElement elementsForName:@"sex"];
        NSArray *addressArray = [studentElement elementsForName:@"address"];
        
        NSString *nameStr = [[nameArray lastObject]stringValue];
        NSString *ageStr = [[ageArray lastObject] stringValue];
        NSString *sexStr = [[sexArray lastObject]stringValue];
        NSString *addressStr = [[addressArray lastObject] stringValue];
        NSLog(@"name = %@,age = %@,sex = %@,address = %@",nameStr,ageStr,sexStr,addressStr);

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nameStr,@"name",ageStr,@"age",sexStr,@"sex",addressStr,@"address", nil];

        [_teachersArray addObject:dic];
    }
    return _teachersArray;
}

- (id)jsonWithParserString:(NSString *)jsonName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
   
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    return [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
}
#pragma mark  -实现NSXMLParserDelegate方法:太麻烦-
//找开始标签的方法
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    // 若遇到teacher开始标签，创建学生数组
    if ([elementName isEqualToString:@"Teachers"]) {
        _teachersArray = [[NSMutableArray alloc]init];
    }
    //若遇到teacher开始标签，创建学生字典
    if ([elementName isEqualToString:@"teacher"]) {
        _teacherDic = [[NSMutableDictionary alloc]init];
    }
    
}

//取值方法
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    self.contentString =string;
}

//结束标签的方法
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //    NSLog(@"woca");
    //   若遇到结束标签，就要添加到字典里
    if ([elementName isEqualToString:@"name"]) {
        [_teacherDic setValue:self.contentString forKey:@"name"];
    }
    if ([elementName isEqualToString:@"age"]) {
        [_teacherDic setValue:self.contentString forKey:@"age"];
    }
    if ([elementName isEqualToString:@"sex"]) {
        [_teacherDic setValue:self.contentString forKey:@"sex"];
    }
    if ([elementName isEqualToString:@"address"]) {
        [_teacherDic setValue:self.contentString forKey:@"address"];
    }
    //    遇到student结束标签，表示一个老师加入到数组。
    if ([elementName isEqualToString: @"teacher"]) {
        [_teachersArray addObject:_teacherDic];
    }
    
}

@end
