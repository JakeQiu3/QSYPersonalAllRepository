//
//  FreezeViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/6/6.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FreezeViewController.h"
#import "DQKFreezeWindowView.h"

static NSString *const mainCellIdentifier = @"mainCell";
static NSString *const rowCellIdentifier = @"rowCell";
static NSString *const sectionCellIdentifier = @"sectionCell";

@interface FreezeViewController () <DQKFreezeWindowViewDataSource, DQKFreezeWindowViewDelegate>

@end

@implementation FreezeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    DQKFreezeWindowView *freezeWindowView = [[DQKFreezeWindowView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20) FreezePoint:CGPointMake(54, 64) cellViewSize:CGSizeMake(133, 44)];
    [self.view addSubview:freezeWindowView];
    freezeWindowView.dataSource = self;
    freezeWindowView.delegate = self;
    [freezeWindowView setSignViewWithContent:@"Test"];
    [freezeWindowView setSignViewBackgroundColor:[UIColor redColor]];
    
    [freezeWindowView setSectionViewBackgroundColor:[UIColor greenColor]];//hang
    [freezeWindowView setRowViewBackgroundColor:[UIColor cyanColor]];//lie
}

- (NSInteger)numberOfSectionsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 50;
}

- (NSInteger)numberOfRowsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 50;
}

- (DQKMainViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DQKMainViewCell *mainCell = [freezeWindowView dequeueReusableMainCellWithIdentifier:mainCellIdentifier forIndexPath:indexPath];
    NSString *mainCellContent = [NSString stringWithFormat:@"第%ld列 第%ld行",(long)indexPath.section,(long)indexPath.row];
    if (mainCell == nil) {
        mainCell = [[DQKMainViewCell alloc] initWithStyle:DQKMainViewCellStyleDefault reuseIdentifier:mainCellIdentifier];
        mainCell.title = mainCellContent;
    }
    return mainCell;
}

- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    
    DQKSectionViewCell *sectionCell = [freezeWindowView dequeueReusableSectionCellWithIdentifier:sectionCellIdentifier forSection:section];
    sectionCell.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
    NSString *sectionCellContent = [NSString stringWithFormat:@"%ld",(long)section];
    if (sectionCell == nil) {
        sectionCell = [[DQKSectionViewCell alloc] initWithStyle:DQKSectionViewCellStyleDefault reuseIdentifier:sectionCellIdentifier];
        sectionCell.title = sectionCellContent;
    }
    return sectionCell;
}

- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    
    DQKRowViewCell *rowCell = [freezeWindowView dequeueReusableRowCellWithIdentifier:rowCellIdentifier forRow:row];
    NSString *rowCellContent = [NSString stringWithFormat:@"%ld",(long)row];
    if (rowCell == nil) {
        rowCell = [[DQKRowViewCell alloc] initWithStyle:DQKRowViewCellStyleDefault reuseIdentifier:rowCellIdentifier];
        rowCell.title = rowCellContent;
    }
    return rowCell;
}

- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
//   获取到该cell
    DQKMainViewCell *cell;
    cell = [freezeWindowView dequeueReusableMainCellWithIdentifier:mainCellIdentifier forIndexPath:indexPath];
    NSString *message = [NSString stringWithFormat:@"Click at %@",cell.title];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You did a click!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
