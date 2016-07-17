//
//  RegisterAndLoginViewController.m
//  storyBoardEnough
//
//  Created by qsyMac on 16/7/8.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RegisterAndLoginViewController.h"
#import "LoginNextViewController.h"
@interface RegisterAndLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation RegisterAndLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//登陆: 并非直接segue跳转，先判断账号和密码都无误，才开始vc和vc 之间的segue

- (IBAction)login:(id)sender {
    if (![self.loginName.text length] || ![self.password.text length]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入账号或密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
// vc 和vc之间的跳转
    [self performSegueWithIdentifier:@"loginIdentifier" sender:sender];
}

//注册：在storyboard中segue 执行跳转
- (IBAction)register:(id)sender {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

//当前的视图控制器即将被另一个视图控制器所替代时，segue将处于激活状态，就执行该方法
// segue传递数据 或者跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {// 被触发事件的对象：可以为某个cell或button
    RegisterAndLoginViewController *source = [segue sourceViewController];
    LoginNextViewController *destination = (LoginNextViewController *)[segue destinationViewController];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.loginName.text,self.password.text] forKeys:@[@"loginName",@"password"]];
    if ([destination respondsToSelector:@selector(setLogNameAndPasswordDic:)]) {
        [destination setValue:dic forKey:@"logNameAndPasswordDic"];
    }
//    若是点击tableview的某行
//    if ([destination respondsToSelector:@selector(setSelection:)]) {
//        // prepare selection info
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        
//        id object = self.dataArray[indexPath.row];
//        NSDictionary *selection = @{@"indexPath" : indexPath,
//                                    @"object" : object};
//        [destination setValue:selection forKey:@"selection"];
//    }

}


@end
