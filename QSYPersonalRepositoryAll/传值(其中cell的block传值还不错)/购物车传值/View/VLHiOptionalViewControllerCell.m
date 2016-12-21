//
//  VLHiOptionalViewControllerCell.m
//  VoiceLink
//
//  Created by fanyunyu on 16/1/13.
//  Copyright © 2016年 voilink. All rights reserved.
//

#import "VLHiOptionalViewControllerCell.h"
#import "VLHiOptionalViewController.h"

@interface VLHiOptionalViewControllerCell ()
    
@property (nonatomic, strong)  UIView *view ;
    

@end

@implementation VLHiOptionalViewControllerCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

-   (void)createUI{
    
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VLScreenW - 40, 40)];
    [self.contentView addSubview:_view];
    
    self.productNameLabel = [[UILabel alloc]init];
    _productNameLabel.frame = CGRectMake(0, 5, 70, 30);
    _productNameLabel.textColor = [UIColor grayColor];
    _productNameLabel.font = [UIFont systemFontOfSize:14];
    [_view addSubview:_productNameLabel];
    
    _bidPriceLabel = [ [UILabel alloc] init];
    _bidPriceLabel.size = CGSizeMake(50, 30);
    _bidPriceLabel.top = _productNameLabel.top;
    _bidPriceLabel.left = _productNameLabel.right;
    _bidPriceLabel.font = [UIFont systemFontOfSize:14];
    _bidPriceLabel.textAlignment = NSTextAlignmentCenter;
    [_view addSubview:_bidPriceLabel];
    
    UILabel *deleteLineLabel = [ [UILabel alloc] init];
    deleteLineLabel.size = CGSizeMake(_bidPriceLabel.width, 1);
    deleteLineLabel.top = _bidPriceLabel.top +_bidPriceLabel.height/2;
    deleteLineLabel.left = _bidPriceLabel.left;
    deleteLineLabel.backgroundColor = [UIColor blackColor];
    [_view addSubview:deleteLineLabel];
    
    _priceLabel = [ [UILabel alloc] init];
    _priceLabel.size = CGSizeMake(50, 30);
    _priceLabel.top = _productNameLabel.top;
    _priceLabel.left = _bidPriceLabel.right;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.font = [UIFont systemFontOfSize:14];
    [_view addSubview:_priceLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.size = CGSizeMake(30, 30);
    addBtn.top = _productNameLabel.top;
    addBtn.left = _priceLabel.right + 20;
    [addBtn setImage:[UIImage imageNamed:@"btn_jia@3x.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:addBtn];
    
    _timesLabel = [ [UILabel alloc]init];
    _timesLabel.size = CGSizeMake(30, 30);
    _timesLabel.top = _productNameLabel.top;
    _timesLabel.left = addBtn.right ;
    _timesLabel.text = @"0";
    _timesLabel.textAlignment = NSTextAlignmentCenter;
    _timesLabel.font = [UIFont systemFontOfSize:14];
    [_view addSubview:_timesLabel];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.size = CGSizeMake(30, 30);
    minusBtn.top = addBtn.top;
    minusBtn.left = _timesLabel.right;
    [minusBtn setImage:[UIImage imageNamed:@"btn_jian@3x.png"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:minusBtn];
    
    
}

-   (void)configCellWithModel:(VLHiOptionalModel *)model{
    
    _productNameLabel.text = model.productName;
    
    _bidPriceLabel.text = [NSString stringWithFormat:@"%@元/次",model.bidPrice] ;
    _priceLabel.text = [NSString stringWithFormat:@"%@元/次",model.price];
    _timesLabel.text = [NSString stringWithFormat:@"%@",model.times];
    
    
}

-   (void)addBtnClick{
    _timesLabel.text = [NSString stringWithFormat:@"%d",[_timesLabel.text intValue]+1];

//    NSLog(@"%d",self.indexPath.row);
     self.myBlock(_timesLabel.text ,self.indexPath);
    
}

-   (void)minusBtnClick{
    if ([_timesLabel.text intValue] <= 0) {
        _timesLabel.text = @"0";
    }else{
        _timesLabel.text = [NSString stringWithFormat:@"%d",[_timesLabel.text intValue] -1];
    }
    
    self.myBlock(_timesLabel.text ,self.indexPath);
}



@end
