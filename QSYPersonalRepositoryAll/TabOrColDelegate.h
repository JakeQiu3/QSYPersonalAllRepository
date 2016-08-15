//
//  TabOrColDelegate.h
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/8/15.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabOrColDelegate <NSObject>
/**
 *  选择的文字和id
 */
- (void)selectedCategoryName:(NSString *)categoryName
                  categoryId:(NSString *)categoryId
                 objectValue:(NSString *)objectValue
                    objectId:(NSString *)objectId;
@end
