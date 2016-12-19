//
//  LBMacroNet.h
//  
//
//  Created by qsy on 16/2/28.
//  Copyright © 2016年 qsy. All rights reserved.
//

/**
 *  类注释：网络请求宏
 */
#ifndef LBMacroNet_h
#define LBMacroNet_h


//实际环境
#define KHTTP @"http://219.139.130.109:8080/app_npc"
//测试环境
#define kHTTPTEST @"http://210.42.41.133:8080/app_npc"

#define HTTPCOM(api) [NSString stringWithFormat:@"%@%@",KHTTP,api]



//登录
#define API_login HTTPCOM(@"/login")



#endif /* LBMacroNet_h */
