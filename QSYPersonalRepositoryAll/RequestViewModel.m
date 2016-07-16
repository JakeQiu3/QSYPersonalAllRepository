//
//  RequestViewModel.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/13.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RequestViewModel.h"
static NSString *const cellIdentifier = @"cell";
@implementation RequestViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialBind];
    }
    return self;
}

- (void)initialBind {
    _reuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            parameters[@"q"] = @"基础";
            
            [[AFHTTPRequestOperationManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"打印返回的结果%@",responseObject);
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络加载出错" maskType:SVProgressHUDMaskTypeNone];
            }];
            return nil;
        }];
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(id value) {
            NSMutableArray *dicArray = value[@"books"];
            NSArray *modelArr = [[dicArray.rac_sequence  map:^id(id value) {
                return [Book bookWithDict:value];
            }] array];
            return modelArr;
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Book *book = self.modelsArray[indexPath.row];
    if (![book.subtitle length]) {
        book.subtitle = @"不要问我从哪里来,我就是占位文字...";
    }
    cell.detailTextLabel.text = book.subtitle;
    cell.textLabel.text = book.title;
    
    return cell;
}

@end
