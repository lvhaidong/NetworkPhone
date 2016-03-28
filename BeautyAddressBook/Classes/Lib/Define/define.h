//
//  define.h
//  BeautyAddressBook
//
//  Created by  吕海冬 on 16/2/26.
//  Copyright © 2016年 hackxhj. All rights reserved.
//

#ifndef define_h
#define define_h

/***********************颜色色差值**************************/
#define kColor(r,g,b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

/***********************NSUserDefaults宏定义*******************/
#define UserDefault        [NSUserDefaults standardUserDefaults]

/***********************通知中心宏定义**************************/
#define NotificationCenter [NSNotificationCenter defaultCenter]

/***********************保存联系人列表**************************/
#define ContactName  @"ContactName"
#define ContactPhone @"ContactNumber"


#endif /* define_h */
