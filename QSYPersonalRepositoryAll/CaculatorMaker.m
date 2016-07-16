//
//  CaculatorMake.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/7.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "CaculatorMaker.h"

@implementation CaculatorMaker

//加：CaculatorMaker *(^)(NSInteger) = ^CaculatorMaker *(NSInteger value){ #code 
//};
- (CaculatorMaker *(^)(NSInteger))add {
    return ^CaculatorMaker *(NSInteger value){
        _result +=value;
        return self;
    };
    
}
//减
- (CaculatorMaker *(^)(NSInteger))subtract {
    return ^CaculatorMaker *(NSInteger value){
        _result -=value;
        return self;
    };
}

//乘
- (CaculatorMaker *(^)(NSInteger))multiply {
    return ^CaculatorMaker *(NSInteger value){
        _result *=value;
        return self;
    };

}
//除
- (CaculatorMaker *(^)(NSInteger))divide {
    return ^CaculatorMaker *(NSInteger value){
        _result /=value;
        return self;
    };

}
@end
