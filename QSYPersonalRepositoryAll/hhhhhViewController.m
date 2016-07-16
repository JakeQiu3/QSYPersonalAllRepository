//
//  hhhhhViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/20.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "hhhhhViewController.h"

@interface hhhhhViewController ()

@end

@implementation hhhhhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"uuu" owner:self options:nil];
    UIView *newView = [array lastObject];
     ((UIScrollView *)self.view).contentSize =CGSizeMake(self.view.bounds.size.width, newView.bounds.size.height);
    
    // Do any additional setup after loading the view.
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
