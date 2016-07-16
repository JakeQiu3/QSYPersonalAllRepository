//
//  BtnNewAgainViewController.h
//  QSYPersonalRepositoryAll
/**

 *btn的地址是创建（alloc)控制器时系统分配的唯一一个。但该btn存储的内容（地址），是alloc出来的堆区内存的地址，注意：会创建多个。
// 未创建的btn为nil，nil对象可以发送任何消息，而不报错。
// 但NSNull对象的null若不是NSNull类的方法，会报错   像下面： btn =(UIButton *)[NSNull null]; [btn removeFromSuperview];
// 子视图的frame 大于父视图，多出部分无法响应交互。

 */
#pragma mark NSOperationQueue  n个操作队列，按顺序执行的代码段

//NSMutableArray *queueArray;//商品的运费和快递信息的操作队列
//NSMutableArray *salerIdArray;//卖家id数组
//- (void)getDeliveryType
//{
//    deliveryInfo = @{}.mutableCopy;
//    salerIdArray = @[].mutableCopy;
//    queueArray = @[].mutableCopy;
//    
//    // 邮局列表字段array型
//    NSArray *userAddressList = [self.postSettlementInfo[@"userAddressList"] copy];
//    NSArray *cartGoodsBoList = [self.postSettlementInfo[@"cartGoodsBoList"] copy];
//    
//    // 结束调用
//    if (userAddressList.count == 0) { // 无配送类型也要处理总金额
//        return;
//    }
//    NSDictionary *expressInfo = [userAddressList objectAtIndex:0];
//    
//    NSLog(@"%@",cartGoodsBoList);
//    [cartGoodsBoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        // 卖家信息
//        NSDictionary *saleInfo = [cartGoodsBoList objectAtIndex:idx];
//        [salerIdArray addObject:saleInfo[@"saleId"]];
//    }];
//    NSLog(@"%@",salerIdArray);
//    [self addPostMailData:expressInfo[@"expressId"]];
//}
//
//- (void)addPostMailData:(NSString *)expressIdStr {
//    for (int i = 0; i<salerIdArray.count; i++) {
//        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//            // 执行加载网络请求
//            [self executeNetRequestIndex:i saleId:salerIdArray[i] expressId:expressIdStr];
//            [NSThread sleepForTimeInterval:0.5];
//        }];
//        //  将操作加入数组
//        [queueArray addObject:operation];
//        if (i>=1) {
//            [operation addDependency:queueArray[i-1]];
//        }
//    }
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperations:queueArray waitUntilFinished:NO];
//}
//
//- (void)executeNetRequestIndex:(NSInteger)idx saleId:(NSString *)saleId expressId:(NSString *)expressIdStr{
//    //邮局ID：String postofficeGuid,
//    //卖家ID：String sellerId
//    NSDictionary *params = @{@"postofficeGuid" : expressIdStr,
//                             @"sellerId" : saleId};
//    
//    // 添加各个卖家的配送方式
//    [[SVHTTPClient sharedClient] POST:DeliveryURLPath parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        
//        NSDictionary *itemInfo = [UIUtils getResultFromResponseData:response];
//        
//        if ([itemInfo[@"status"] isEqualToNumber:@(200)]) {
//            [deliveryInfo setObject:itemInfo[@"result"] forKey:@(idx)];
//            
//            [_listView reloadData];
//            
//            // 处理总金额
//            [self dealWithTotalMoney];
//        }
//    }];
//}


#import <UIKit/UIKit.h>

@interface BtnNewAgainViewController : UIViewController


@end
