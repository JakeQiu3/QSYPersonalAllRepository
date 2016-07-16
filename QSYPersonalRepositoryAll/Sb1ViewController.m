//
//  Sb1ViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/7/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "Sb1ViewController.h"
#import "Sb1TableViewCell.h"
#import "Sb1DetailViewController.h"
@interface Sb1ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sb1TableView;

@end

@implementation Sb1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//  获取到tableview，即可对其进行设置
    self.sb1TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Sb1TableViewCell *cell = [Sb1TableViewCell cellWithTalbeView:tableView];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    Sb1DetailViewController *detailVC = [segue destinationViewController];
    [self.navigationController pushViewController:detailVC animated:YES];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
