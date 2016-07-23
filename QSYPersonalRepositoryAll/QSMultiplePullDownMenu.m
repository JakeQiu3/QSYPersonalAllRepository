//  ViewController.h
//  PullDemo
//
//  Created by 邱少依 on 16/7/18.
//  Copyright © 2016年 QSY. All rights reserved.

#import "QSMultiplePullDownMenu.h"
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define bgViewOrTabsY (self.frame.origin.y + self.frame.size.height)
static const CGFloat pullDownMenuHeight = 45;
@interface QSMultiplePullDownMenu ()
{
    
    NSArray *dataArray;// 总的数据源
    NSMutableArray *currentTitlesArr;// 当前展示在menu中的titleStr数组
    NSMutableArray *currentTextLayerArr; // 当前展示在menu中的layerText的数组
    
    NSMutableArray *indicatorsPic; // 当前展示在menu中的layerIndicator图标的数组
    
    // 左侧和右侧的tab 以及对应的数组
    UITableView *leftTab;
    NSMutableArray *leftArr;// 3组数据的左侧Tab的总array
    
    UITableView *rightTab;
    
    // 决定仅仅创建1个tab的数组:存放着该menu的index
    NSMutableArray *confirmCreatSingleTabArr;
    
    NSInteger numsOfMenu;//menu中菜单栏的个数
    //  color
    UIColor *menuColor;// menu的title非选中时的颜色
    UIColor *selectMenuColor;// menu的title选中时的颜色
    
    UIView *backGroundView;//背景视图：默认是灰色半透明
    
    // 当前选择的menuIndex
    NSInteger _currentSelectedMenuIndex;
    // 是否只有单个Tab
    BOOL isSingleTab;
    UITapGestureRecognizer *backGroundGesture;// backGroundGesture的手势
    
    UITableViewCell *selectedLeftCell;//选择的左侧Tab的Cell
    UITableViewCell *selectedRightCell;//选择的右侧Tab的Cell
    
    //  选择的最终的左右2个数据或1个数据
    NSString *selectFirstTitle;
    NSString *selectSecondTitle;
    
}

// 2个tab时，点击左侧tab某row：得到右侧tab的arr
@property (nonatomic, strong)  NSMutableArray *rightArr;

@end

@implementation QSMultiplePullDownMenu

#warning 少 待修改的区域： 遍历总的数据源dataArr:获取哪个是单个tab的menu，并将该数组的index保存在 confirmCreatSingleTabArr。
- (void)confirmCreatSingleTabNum {
    NSMutableArray *tempArr = @[].mutableCopy;
    for (NSInteger i = 0; i<[dataArray count]; i++) {
        NSArray *itemArr = [dataArray objectAtIndex:i];
        for (NSDictionary *dic in itemArr) {
            NSArray *citysArr = [dic objectForKey:@"citys"];
            if (![citysArr count]) {//获取到城市的数组count
                [tempArr addObject:[NSNumber numberWithInteger:i]];
            }
        }
    }
    // 数组去重后添加
    for (NSNumber *num in tempArr) {
        if (![confirmCreatSingleTabArr containsObject:num]) {
            [confirmCreatSingleTabArr addObject:num];
        }
    }
}

#warning 少 待修改的区域： nums的====左侧的Tab的数组的大数组====
- (void)getLeftLabData {
    for (NSInteger i = 0; i<[dataArray count]; i++) {
        NSArray *itemArr = [dataArray objectAtIndex:i];
        NSMutableArray *tempArray = @[].mutableCopy;
        for (NSDictionary *dic in itemArr) {
            NSString *title = [dic objectForKey:@"provinceName"];
            [tempArray addObject:title];
        }
        [leftArr addObject:tempArray];
    }
    NSLog(@"左侧的3组数组的total数组: %@",leftArr);
}

- (QSMultiplePullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)selectedColor constantTitlesArr:(NSArray *)titlesArr {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREENW, pullDownMenuHeight);
        self.backgroundColor = [UIColor whiteColor];
        //       设置非选中文字和图标的颜色
        menuColor = [UIColor colorWithRed:164.0/255.0 green:166.0/255.0 blue:169.0/255.0 alpha:1.0];
        selectMenuColor = selectedColor;
        //   左侧设置默认可视化的tableView高度
        _tableVHeightNumMax = 6;
        dataArray = array;
        leftArr = @[].mutableCopy;
        self.rightArr = @[].mutableCopy;
        confirmCreatSingleTabArr = @[].mutableCopy;
        currentTextLayerArr = @[].mutableCopy;
        
        selectFirstTitle = @"";
        selectSecondTitle = @"";
        //  menu中显示items
        numsOfMenu = dataArray.count;
        [self confirmCreatSingleTabNum];
        // 获得menu的左侧tab的total数组
        [self getLeftLabData];
        
#warning 少 待修改的区域： menu中显示的title的字符串数组
        if ([titlesArr count]) {// menu显示的title数组不为空，是固定不变的
            currentTitlesArr = titlesArr.mutableCopy;
        } else {// 为空数组: 取每个数组中第0个数据
            currentTitlesArr = [[NSMutableArray alloc] initWithCapacity:numsOfMenu];
            for (NSInteger i = 0; i<[dataArray count]; i++) {
                NSDictionary *dic = dataArray[i][0];
                [currentTitlesArr addObject:[dic objectForKey:@"provinceName"]];
            }
        }
        
        indicatorsPic = [[NSMutableArray alloc] initWithCapacity:numsOfMenu];
        //  绘制menu上的 文字，图标，分割线
        [self drawTitleAndIndicatorPic];
        
    }
    return self;
}

- (void)drawTitleAndIndicatorPic {
    //  绘制文字和分割线的间距
    CGFloat textLayerInterval = self.frame.size.width / ( numsOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / numsOfMenu;
    for (NSInteger i = 0; i < numsOfMenu; i++) {
        //    绘制menu的文字
        CGPoint position = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        CATextLayer *layerTitle = [self creatTextLayerWithNSString:currentTitlesArr[i] withColor:menuColor andPosition:position];
        [self.layer addSublayer:layerTitle];
        [currentTextLayerArr addObject:layerTitle];
        
        //    绘制menu的箭头图标：并添加到indicatorsPic
        CAShapeLayer *indicator = [self creatIndicatorWithColor:!_indicatorColor? menuColor:_indicatorColor andPosition:CGPointMake(position.x + layerTitle.bounds.size.width / 2 + (!_titleAndPicMargin ? 10:_titleAndPicMargin), self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [indicatorsPic addObject:indicator];
        //    绘制竖向间隔线
        if (i != (numsOfMenu - 1)) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
            CAShapeLayer *separator = [self creatSeparatorLineWithColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0] andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
}

- (void)initSubviews {
    //   创建左侧的lab: 默认宽 120
    leftTab = [self creatTableViewAtPosition:CGPointMake(0,bgViewOrTabsY) labWidth:!_leftLabWidth ? 120:_leftLabWidth];
    leftTab.tintColor = selectMenuColor;
    leftTab.dataSource = self;
    leftTab.delegate = self;
    
    //    创建右侧的lab CGRectGetMaxX(leftTab.frame) SCREENW - leftTab.bounds.size.width
    rightTab = [self creatTableViewAtPosition:CGPointMake(CGRectGetMaxX(leftTab.frame), bgViewOrTabsY) labWidth:(SCREENW - CGRectGetMaxX(leftTab.frame))];
    rightTab.tintColor = selectMenuColor;
    rightTab.dataSource = self;
    rightTab.delegate = self;
    
    // 设置menu, 添加手势
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
    [self addGestureRecognizer:tapGesture];
    
    // 创建tab的父视图，并添加手势
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewOrTabsY,SCREENW, SCREENH-bgViewOrTabsY)];
    backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    backGroundView.opaque = NO;
    backGroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
    [backGroundView addGestureRecognizer:backGroundGesture];
    
    //  设置是哪个item
    _currentSelectedMenuIndex = -1;
    _isShowTab = NO;
    
}

//  添加子视图
- (void)showInSupView:(UIView *)superView {
    [self initSubviews];
    [superView addSubview:self];
}

// 消失子视图
- (void)dismissPullDownView {
    [self tapBackGround:backGroundGesture];
}
#warning 判断tab是单个还是多个，并设置frame -> 只有左侧tab：right宽为0,左侧tab宽为屏宽
- (void)configSingleOrTwoTabsFrame:(NSInteger )currentTapIndex {
    
    for (NSInteger i = 0; i<[confirmCreatSingleTabArr count]; i++) {
        if ([[confirmCreatSingleTabArr objectAtIndex:i] integerValue] == currentTapIndex) {
            isSingleTab = YES;
            leftTab.frame = CGRectMake(0,bgViewOrTabsY,SCREENW, 0);
            rightTab.frame = CGRectMake(0,bgViewOrTabsY,0, 0);
            
        } else {
            isSingleTab = NO;
            leftTab.frame = CGRectMake(0,bgViewOrTabsY,!_leftLabWidth?120:_leftLabWidth,0);
            rightTab.frame = CGRectMake(CGRectGetMaxX(leftTab.frame),bgViewOrTabsY,SCREENW - CGRectGetMaxX(leftTab.frame), 0);
            
        }
    }
}

#pragma mark - tapEvents menu gesture
- (void)tapMenu:(UITapGestureRecognizer *)menuGesture {
    CGPoint touchPoint = [menuGesture locationInView:self];
    // 得到tapIndex： 0表示点击了第1个item, 1表示点击第2个item，以此类推
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / numsOfMenu);
    //  确定当前点击的是1个还是2个tab：并用 isSingleTab 做记录
    [self configSingleOrTwoTabsFrame:tapIndex];
    //  tap 某item时，设置其他的tiems title和indicator
    for (NSInteger i = 0; i < numsOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:indicatorsPic[i] Forward:NO complete:^{
                [self animateTitle:currentTextLayerArr[i] show:NO complete:^{
                }];
            }];
        }
    }
    
    //  提前移除上一组数据
    if ([_rightArr count]) {
        [_rightArr removeAllObjects];
    }
    
    //  连续单击某个menu的item
    if (tapIndex == _currentSelectedMenuIndex && _isShowTab) {
        [self animateIdicator:indicatorsPic[tapIndex] background:backGroundView tableView:leftTab title:currentTextLayerArr[tapIndex] forward:NO complecte:^{
            _isShowTab = NO;
        }];
        
    } else {// 仅仅一次单击某个item时：首次点击
        _currentSelectedMenuIndex = tapIndex;
        // 刷新左侧和右侧tab
        [leftTab reloadData];
        [rightTab reloadData];
        [self animateIdicator:indicatorsPic[tapIndex] background:backGroundView tableView:leftTab title:currentTextLayerArr[tapIndex] forward:YES complecte:^{
            _isShowTab = YES;
        }];
        
    }
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                    //  判断是否是单个数组：单门考虑rightTab
                    if (!isSingleTab) {// 不是单个tab:显示右侧的tab
                        [self animateTableView:rightTab show:forward complete:^{
                        }];
                    }
                }];
            }];
        }];
    }];
    
    complete();
}


#pragma _mark 单击tabs的bgView手势
- (void)tapBackGround:(UITapGestureRecognizer *)paramSender {
    
    [self animateIdicator:indicatorsPic[_currentSelectedMenuIndex] background:backGroundView tableView:leftTab title:currentTextLayerArr[_currentSelectedMenuIndex] forward:NO complecte:^{
        _isShowTab = NO;
    }];
    
}

#pragma mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual: leftTab]) {
        return [[leftArr objectAtIndex:_currentSelectedMenuIndex] count];
    } else return self.rightArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *leftCellIdentifier = @"leftCellIdentifier";
    static NSString *rightCellIdentifier = @"leftCellIdentifier";
    UITableViewCell *cell;
    if ([tableView isEqual: leftTab]) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        }
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UIView *bacGroundView = [[UIView alloc]init];
        bacGroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = bacGroundView;
        if (isSingleTab) {//仅仅1个tab
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0f];
        }
        cell.textLabel.text = leftArr[_currentSelectedMenuIndex][indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if ([tableView isEqual: rightTab]){
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        }
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.text = _rightArr[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    //    //    若允许更新menu的title
    //    if (_isUpdataMenuTitle) {
    //        if (cell.textLabel.text == [(CATextLayer *)[currentTextLayerArr objectAtIndex:_currentSelectedMenuIndex] string]) {
    //            [cell setAccessoryType:UITableViewCellAccessoryNone];
    //            [cell.textLabel setTextColor:[tableView tintColor]];
    //        }
    //    }
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];//反选：点击背景色消失
    if (tableView == leftTab) {
        selectedLeftCell.textLabel.textColor = [UIColor blackColor];
        //      获取到左侧的tab cell
        UITableViewCell *leftCell;
        leftCell = [tableView cellForRowAtIndexPath:indexPath];
        leftCell.textLabel.textColor = selectMenuColor;
        selectedLeftCell = leftCell;
        selectFirstTitle = leftCell.textLabel.text;//获取省的名字
#warning 少  遍历获取得到右侧tab的array
        //        提前移除上一组数据
        if ([_rightArr count]) {
            [_rightArr removeAllObjects];
        }
        
        NSArray *citysArr = @[].copy;
        for (NSArray *array in dataArray) {
            for (NSDictionary *dic in array) {
                if ([[dic objectForKey:@"provinceName"] isEqualToString:selectFirstTitle]) {
                    citysArr = (NSArray *)[dic objectForKey:@"citys"];
                }
            }
        }
        [_rightArr addObjectsFromArray:citysArr];
        [rightTab reloadData];
    } else if ([tableView isEqual:rightTab]) {// 点击右侧的tabView
        selectedRightCell.textLabel.textColor = [UIColor blackColor];
        //      获取到左侧的tab cell
        UITableViewCell *rightCell;
        rightCell = [tableView cellForRowAtIndexPath:indexPath];
        rightCell.textLabel.textColor = selectMenuColor;
        selectedRightCell = rightCell;
        selectSecondTitle = rightCell.textLabel.text;//获取省的名字
    }
    
    if (!isSingleTab) {// 2个tab
        if ([selectFirstTitle length]>0 && [selectSecondTitle length]>0) {//2个都有值才执行代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(pullDownMenu:didSelectColumn:secondRow:)]) {
                __weak __typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    //  使该控件消失并传值
                    [strongSelf dismissPullDownView];
                });
                [self.delegate pullDownMenu:self didSelectColumn:selectFirstTitle secondRow:selectSecondTitle];
                //   是否更新menu的title
                if (_allowUpdataMenuTitle) {
                    [self confiMenuWithSelectTitle:selectSecondTitle];
                }
                selectFirstTitle = @"";
                selectSecondTitle = @"";
            }
        }
    } else {//单个tab
        if ([selectFirstTitle length] > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(pullDownMenu:didSelectColumn:secondRow:)]) {
                __weak __typeof(self)weakSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    //  使该控件消失并传值
                    [strongSelf dismissPullDownView];
                });
                [self.delegate pullDownMenu:self didSelectColumn:selectFirstTitle secondRow:selectSecondTitle];
                //      是否更新menu的title
                if (_allowUpdataMenuTitle) {
                    [self confiMenuWithSelectTitle:selectFirstTitle];
                }
                selectFirstTitle = @"";
                
            }
        }
    }
}

// 返回CATextLayer，绘制title到self.view
- (CATextLayer *)getDrawTextLayer {
    //  重新绘制menu的layer文字
    CGFloat textLayerInterval = self.frame.size.width / ( numsOfMenu * 2);
    CGPoint position = CGPointMake( (_currentSelectedMenuIndex * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
    CATextLayer *selectLayerTitle = [self creatTextLayerWithNSString:currentTitlesArr[_currentSelectedMenuIndex] withColor:menuColor andPosition:position];
    return selectLayerTitle;
}

// 配置是否动态更新选择的数据到menu的title
- (void)confiMenuWithSelectTitle:(NSString *)selectTitle {
    //   修改currentTitlesArr的数据
    [currentTitlesArr replaceObjectAtIndex:_currentSelectedMenuIndex withObject:selectTitle];
    //    获取到newTextLayer
    CATextLayer *newTextLayer = [self getDrawTextLayer];
    
    [self.layer replaceSublayer:[currentTextLayerArr objectAtIndex:_currentSelectedMenuIndex] with:newTextLayer];
    //  修改layerText数组
    [currentTextLayerArr replaceObjectAtIndex:_currentSelectedMenuIndex withObject:newTextLayer];
    
    [self animateIdicator:indicatorsPic[_currentSelectedMenuIndex] background:backGroundView tableView:leftTab title:currentTextLayerArr[_currentSelectedMenuIndex] forward:NO complecte:^{
        _isShowTab = NO;
        
    }];
    
    //    更正indicator的位置
    CAShapeLayer *indicator = (CAShapeLayer *)indicatorsPic[_currentSelectedMenuIndex];
    indicator.position = CGPointMake(newTextLayer.position.x + newTextLayer.frame.size.width / 2 + 8, indicator.position.y);
}

#pragma mark - animation

- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    //   设置其他指示图标的颜色：选择
    indicator.strokeColor = forward ? [UIColor colorWithRed:160/255.0 green:210/255.0 blue:120/255.0 alpha:1.0f].CGColor : menuColor.CGColor;//设置边框的颜色
#warning  同背景颜色
    indicator.fillColor = [UIColor whiteColor].CGColor;//设置内部填充的颜色:
    
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        title.foregroundColor = leftTab.tintColor.CGColor;
    } else {
        title.foregroundColor = menuColor.CGColor;
    }
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / numsOfMenu) - 25) ? size.width : self.frame.size.width / numsOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    complete();
}

// 添加该backGroundView到该menu的superView上，将menu添加到该superview上
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];// 将menu添加到该superview上
        //        backGroundView的背景颜色
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = (UIColor *)[UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {//若不显示该menu，移除该backGroundView
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
    
}
//点击时, tableView: leftTab 的展开和关闭的设置
- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    CGFloat leftTabWidth = 0.0f;
    if (!isSingleTab) {// 2个tab
        leftTabWidth = (!_leftLabWidth ? 120:_leftLabWidth);
    } else leftTabWidth = SCREENW;//单个tab
    
    if (show) {
        //      判断并设置左右侧tab的frame和显示高度
        CGFloat tableViewHeight = 0;
        if ([tableView isEqual:leftTab]) {//若是左侧Tab
            tableView.frame = CGRectMake(0, bgViewOrTabsY,leftTabWidth, 0);
            [self.superview addSubview:tableView];
            tableViewHeight = ([tableView numberOfRowsInSection:0] > _tableVHeightNumMax) ? (_tableVHeightNumMax * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
            
            [UIView animateWithDuration:0.2 animations:^{
                tableView.frame = CGRectMake(0, bgViewOrTabsY, leftTabWidth, tableViewHeight);
            }];
            
        } else if ([tableView isEqual:rightTab]){
            tableView.frame = CGRectMake( CGRectGetMaxX(leftTab.frame),bgViewOrTabsY, SCREENW - CGRectGetMaxX(leftTab.frame), SCREENH-bgViewOrTabsY);
            [self.superview addSubview:tableView];
            tableViewHeight = ([tableView numberOfRowsInSection:0] > _tableVHeightNumMax) ? (_tableVHeightNumMax * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
            
            [UIView animateWithDuration:0.2 animations:^{
                tableView.frame = CGRectMake( CGRectGetMaxX(leftTab.frame),bgViewOrTabsY, SCREENW - CGRectGetMaxX(leftTab.frame), SCREENH-bgViewOrTabsY);
            }];
        }
        
#warning 少 设置单个tableview可视化的高度
        
    } else {
        if ([tableView isEqual:leftTab]) {
            [UIView animateWithDuration:0.2 animations:^{
                tableView.frame = CGRectMake(0, bgViewOrTabsY, leftTabWidth, 0);
            } completion:^(BOOL finished) {
                [tableView removeFromSuperview];
            }];
            
        } else if ([tableView isEqual:rightTab]){
            [UIView animateWithDuration:0.2 animations:^{
                tableView.frame = CGRectMake( CGRectGetMaxX(leftTab.frame),bgViewOrTabsY, SCREENW - CGRectGetMaxX(leftTab.frame), SCREENH-bgViewOrTabsY);
            } completion:^(BOOL finished) {
                [tableView removeFromSuperview];
            }];
        }
    }
    
    complete();
    
}

#pragma mark - drawing

#pragma _mark  绘制Indicator的方法
- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path addLineToPoint:CGPointMake(8, 0)];
    
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.5;
    layer.strokeColor = [UIColor blackColor].CGColor;//设置边框的颜色
#warning  同背景颜色
    layer.fillColor = [UIColor whiteColor].CGColor;//设置内部填充的颜色:
    
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

#pragma _mark  绘制line的方法
- (CAShapeLayer *)creatSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = _lineWidth;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

#pragma _mark 绘制title的方法
- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / numsOfMenu) - 25) ? size.width : self.frame.size.width / numsOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = (!_titleFontSize?15:_titleFontSize);
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

#pragma _mark 创建tab的方法
- (UITableView *)creatTableViewAtPosition:(CGPoint)point labWidth:(CGFloat)labWidth {
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(point.x, point.y,labWidth, 0);
    tableView.rowHeight = 36;
    
    return tableView;
}

#pragma mark - otherMethods
// 根据字符串和长度计算
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = (!_titleFontSize?15:_titleFontSize);
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma _mark 右侧tab的arr setter
- (void)setRightArr:(NSMutableArray *)rightArr {
    _rightArr = rightArr;
}

@end

#pragma mark - CALayer Category

@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}


@end
