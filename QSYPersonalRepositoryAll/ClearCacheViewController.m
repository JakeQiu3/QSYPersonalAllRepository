//
//  ClearCacheViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/30.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "ClearCacheViewController.h"
#import "ClearCacheTool.h"
@interface ClearCacheViewController ()
# define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@property (weak, nonatomic) IBOutlet UILabel *showCacheSizeLabel;

@end

@implementation ClearCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    self.showCacheSizeLabel.text = [ClearCacheTool getCacheSizeWithFilePath:filePath];
    self.showCacheSizeLabel.text = [ClearCacheTool folderSizeAtPath:filePath];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clearCache:(id)sender {
    BOOL isSuccessClearCache = [ClearCacheTool removeFloderOrFile:filePath];
    if (isSuccessClearCache ) {
         self.showCacheSizeLabel.text = [ClearCacheTool folderSizeAtPath:filePath];
    } else {
        NSLog(@"清理内存失败");
    }
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
