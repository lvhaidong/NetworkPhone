//
//  FGGReachability.m
//  FGGReachability
//
//  Created by 夏桂峰 on 15/8/10.
//  Copyright (c) 2015年 夏桂峰. All rights reserved.
//

#import "FGGReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation FGGReachability

/**
 *  判断网络状态：包含2G,Edge,3G,4G可用和wifi可用和网络不可用
 *
 *  @return 网络状态
 */
+(FGGNetWorkStatus)networkStatus
{
    //wifi可用
    if([self isWifiEnable])
        return FGGNetWorkStatusWifi;
    //蜂窝移动网络可用,再具体细分(2G,3G,4G,2.75G(Edge))
    else if([self isCarrierConnectEnable])
        //运营商网络判断
        return [self carrierStatus];
    //网络不可用
    else
        return FGGNetWorkStatusNotReachable;
}
//wifi是否可用
+(BOOL)isWifiEnable
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]==ReachableViaWiFi);
}
//蜂窝移动网络是否可用
+(BOOL)isCarrierConnectEnable
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==ReachableViaWWAN);
}
/**
 *  运营商网络状态
 *
 *  @return 网络状态
 */
+(FGGNetWorkStatus)carrierStatus
{
    CTTelephonyNetworkInfo *info=[CTTelephonyNetworkInfo new];
    NSString *status=info.currentRadioAccessTechnology;
    
    if([status isEqualToString:CTRadioAccessTechnologyCDMA1x]||[status isEqualToString:CTRadioAccessTechnologyGPRS])
        return FGGNetWorkStatus2G;
    else if([status isEqualToString:CTRadioAccessTechnologyEdge])
        return FGGNetWorkStatusEdge;
    else if([status isEqualToString:CTRadioAccessTechnologyLTE])
        return FGGNetWorkStatus4G;
    else
        return FGGNetWorkStatus3G;
}
@end
