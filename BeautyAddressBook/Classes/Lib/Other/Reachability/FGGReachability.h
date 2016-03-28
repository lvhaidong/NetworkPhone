//
//  FGGReachability.h
//  FGGReachability
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//
/*
 ----------------------------------------------------
 FGGReachability用法简介：
 1.导入CoreTelephony.framework框架
 2.导入#import <CoreTelephony/CTTelephonyNetworkInfo.h>
 3.导入#import <CoreTelephony/CTCarrier.h>
 4.导入#import "FGGReachability.h"头文件
 5.获取当前网络状态：FGGNetWorkStatus status=[FGGReachability networkStatus];
 6.作出判断
 ==>若status==FGGNetWorkStatus2G，则当前网络状态为2G；
 ==>若status==FGGNetWorkStatusEdge，则当前网络状态为2.75G(Edge)；
 ==>若status==FGGNetWorkStatus3G，则当前网络状态为3G；
 ==>若status==FGGNetWorkStatus4G，则当前网络状态为4G；
 ==>若status==FGGNetWorkStatusWifi，则当前网络状态为wifi；
 ==>若status==FGGNetWorkStatusNotReachable，则当前网络状态为不可用；
 ==>若status!=FGGNetWorkStatusNotReachable,则当前网络状态可用(包含wifi和蜂窝移动网络)。
 ---------------------------------------------------
   Copyright (c) 2015年 夏桂峰. All rights reserved.
 ---------------------------------------------------
 */
#import <Foundation/Foundation.h>
#import "Reachability.h"

//警告视图在持续1.5秒后消失
#define FGGAlertViewDuration 1.5

//定义网络状态
typedef NS_ENUM(NSInteger, FGGNetWorkStatus){
    FGGNetWorkStatusNotReachable=0,
    FGGNetWorkStatus2G,
    FGGNetWorkStatusEdge,
    FGGNetWorkStatus3G,
    FGGNetWorkStatus4G,
    FGGNetWorkStatusWifi,
};

@interface FGGReachability : NSObject

@property(nonatomic,strong)Reachability *reachability;

/**判断网络是否可用*/
+(FGGNetWorkStatus)networkStatus;

@end
