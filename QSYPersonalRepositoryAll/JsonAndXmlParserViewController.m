//
//  JsonAndXmlParserViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by qsyMac on 16/5/5.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "JsonAndXmlParserViewController.h"
#import "XML&JsonParser.h"
@interface JsonAndXmlParserViewController ()

@end

@implementation JsonAndXmlParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  xml Sax解析和Dom解析数据
    XML_JsonParser *xmlSax = [[XML_JsonParser alloc]init];
    NSArray *saxArray = (NSArray *)[xmlSax xmlWithSaxParserString:@"Teacher"];
    
    
    NSArray *domArray = [xmlSax xmlWithDomParserString:@"Teacher"];
    
   //Json 数据解析
   NSArray *jsonArray = [xmlSax jsonWithParserString:@"movielist"];
   NSLog(@"saxArray:%@,domArray:%@,jsonArray文字数组:%@",saxArray,domArray,jsonArray);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
