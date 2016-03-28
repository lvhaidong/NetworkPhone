//
//  FYClient.h
//  FeiyuLib
//
//  Created by jinke on 2/28/15.
//  Copyright (c) 2015 feiyu. All rights reserved.
//
//  Version 1.2.5
//
#import <Foundation/Foundation.h>
#import "FYError.h"
typedef enum{
    FYOffline = 0,
    FYNetStateGood,
    FYNetStateBad
}FYAccountNetState;

@protocol FYClientDelegate <NSObject>
/**
 * 连接云平台成功代理
 * @return void
 */
- (void)onFyConnectionSuccessful;


/**
 * 连接云平台失败或连接断开
 * @param error 连接失败的原因
 * @return void
 */
- (void)onFyConnectionFailed:(FYError *)error;

/**
 * 获取飞语云账户网络状态回调代理
 * @param FYAccountNetState   1、网络良好，建议使用网络直拨。
 *                            2、网络不好，不建议使用网络直拨。
 *                            0、对方不在线，不能使用网络直拨。
 * @return void
 */
- (void)onFyAccountOnlineInfo:(FYAccountNetState)state;

/**
 * 获取飞语云账户是在线失败
 * @param error 失败原因
 * @return void
 */
- (void)onFyAccountOnlineFailed:(FYError *)error;

/**
 * 上传log信息回调
 * @param BOOL   YES:上传成功  NO:上传失败
 * @return
 */
- (void)onUpLoadLogResult:(BOOL)result;
@end

@interface FYClient : NSObject

/**
 * 获取实例
 * @return FeiyuClient 实例对象
 */
+ (FYClient *)instance;

/**
 * 初始化实例
 * @param channelId 渠道号
 * @param logSwitch 日志开关
 * @return void
 */
- (void)init:(NSString *)channelId logSwitch:(BOOL)logSwitch;



/**
 * 增加代理
 * @param delegate  FeiyuClientDelegate 回调代理即服务器连接成功或者服务器连
 *                 接失败的回调函数实例对象
 * @return void
 */
- (void)addDelegate:(id<FYClientDelegate>)delegate;

/**
 * 移除代理
 * @param delegate  FeiyuClientDelegate回调代理即服务器连接成功或者服务器连
 *                 接失败的回调函数实例对象
 * @return void
 */
- (void)removeDelegate:(id<FYClientDelegate>)delegate;

/**
 * @param
 * @return 应用id
 */
- (NSString *)appId;
/**
 * @param
 * @return 应用Token
 */
- (NSString *)appToken;
/**
 * @param
 * @return 飞语账号
 */
- (NSString *)fyAccountId;
/**
 * @param
 * @return 飞语账号密码
 */
- (NSString *)fyAccountPwd;
/**
 * @param
 * @return 渠道号
 */
- (NSString *)channelId;


/**
 * 连接云平台
 * @param appId 应用id
 * @param appToken 应用Token
 * @param fyAccountId 飞语账号
 * @param fyAccountPwd 飞语密码
 * @return void
 */
- (void)connect:(NSString*)appId appToken:(NSString*)appToken fyAccountId:(NSString*)fyAccountId fyAccountPwd:(NSString *)fyAccountPwd;

/**
 * 断开与云平台的连接
 * @param
 * @return void
 */
- (void)disconnect;

/**
 * 获取连接云平台状态
 * @param
 * @return BOOL  YES：在线 ；NO：不在线
 */
- (BOOL)isConnected;

/**
 * 获取SDK版本号
 * @return NSString
 */
+ (NSString *)version;

/**
 * 获取用户当前网络质量
 * @return FYAccountNetState  1、网络良好，建议使用网络直拨。
 *                            2、网络不好，不建议使用网络直拨。
 */
- (FYAccountNetState)getMyFyAccountNetState;

/**
 * 获取飞语云账户ID网络状态
 * @param fyAccountId 飞语云账户ID
 * @return void
 */
- (void)getFyAccountNetState:(NSString *)fyAccountId;

/**
 * 手动上传log信息
 * @return void
 */
- (void)uploadLog;

/**
 * 设置互联网语音来电铃声
 * @param path  铃音文件本地路径
 *              注：path为nil，则是静音状态；
 *                 如果path为非nil，如果所传路径没有铃音文件则为默认铃声。
 *                 铃声必须是wav格式，声音长度要小于 30 秒）
 * @return void
 */
- (void)setRing:(NSString *)path;

/**
 * 获取当前铃音文件存储路径
 * @return NSString 当前铃音文件存储路径
 */
- (NSString *)getRingPath;

@end
