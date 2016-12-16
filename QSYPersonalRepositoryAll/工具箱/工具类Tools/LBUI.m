//
//  PandaUI.m
//  TaiHe
//
//  Created by qsy on 14-11-8.
//  Copyright (c) 2014年 qsy. All rights reserved.
//

#import "LBUI.h"

UIView * createView(UIView *superView){
    UIView *vi=[[UIView alloc] initWithFrame:CGRectZero];
    vi.backgroundColor=[UIColor clearColor];
    if (superView){
        [superView addSubview:vi];
    }
    return vi;
}

UIImageView *createImageView(UIView *superView){
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectZero];
    img.backgroundColor=[UIColor clearColor];
    if (superView) [superView addSubview:img];
    return img;
}

UIButton *createButton(UIView *superView){
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 4, 4);
    btn.backgroundColor=[UIColor clearColor];
    if (superView) [superView addSubview:btn];
    return btn;
}

UITableView *createTabel(UIView *superView){
    UITableView *table=[[UITableView alloc] initWithFrame:CGRectZero];
    table.backgroundColor=[UIColor clearColor];
    table.backgroundView=nil;
    table.separatorColor=[UIColor clearColor];
    if (superView) [superView addSubview:table];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    return table;
}

UILabel *createLabel(UIView *superView){
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectZero];
    la.backgroundColor=[UIColor clearColor];
    if (superView) [superView addSubview:la];
    return la;
}
