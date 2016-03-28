//
//  FYCall.h
//  FeiyuLib
//
//  Created by jinke on 2/28/15.
//  Copyright (c) 2015 feiyu. All rights reserved.

#import <Foundation/Foundation.h>
#import "FYError.h"

@protocol FYCallDelegate <NSObject>

/**
 * 呼叫失败代理
 * @param error  呼叫失败的原因
 * @return void
 */
- (void)onFyCallFailed:(FYError *)error;

/**
 * 接到呼叫代理
 * @param callerNumber  主叫来电号码
 * @return void
 */
- (void)onFyIncomingCall:(NSString *)callerNumber;

/**
 * 呼叫中代理
 * @param calleeNumber 被叫号码
 * @return void
 */
- (void)onFyOutgoingCall:(NSString *)calleeNumber;

/**
 * 接通中代理
 * @param peerNumber 对方号码
 * @return void
 */
- (void)onFyCallRunning:(NSString *)peerNumber;

/**
 * 呼叫结束代理
 * @return void
 */
- (void)onFyCallEnd;

/**
 * 对方正在振铃
 * @return void
 */
- (void)onFyCallAlerting:(NSString *)calleeNumber;

@optional
/**
 * 回拨失败代理
 * @param error  回拨失败的原因
 * @return void
 */
- (void)onFyCallbackFailed:(FYError *)error;

/**
 * 回拨成功代理
 * @return void
 */
- (void)onFyCallbackSuccessful;
@end

@interface FYCall : NSObject

/**
 * 获取实例
 * @return FeiyuCall 实例对象
 */
+ (FYCall *)instance;

/**
 * 增加代理
 * @param delegate  FeiyuCallDelegate 呼叫代理即呼叫成功或者
 *                 呼叫失败的回调函数实例对象
 * @return void
 */
- (void)addDelegate:(id<FYCallDelegate>)delegate;

/**
 * 移除代理
 * @param delegate  FeiyuCallDelegate 呼叫代理即呼叫成功或者
 *                 呼叫失败的回调函数实例对象
 * @return void
 */
- (void)removeDelegate:(id<FYCallDelegate>)delegate;

/**
 * 互联网语音
 * @param fyAccountId       被叫手机号码或Feiyu账号
 * @param showNumberType    外呼显号标示，类型为：0 根据后台账户配置；1 显号；2 不显号
 * @param extraData         自定义透传信息(能透传给AS服务器)
 * @param isRecord          BOOL值 YES：开启录音，NO：不开启录音
 * @return void
 */
- (void)networkCall:(NSString *)fyAccountId showNumberType:(NSInteger)showNumberType isRecord:(BOOL)isRecord extraData:(NSString *)extraData;

/**
 * 网络直拨
 * @param number            被叫的飞语云id（必须绑定过手机号码）或手机号码
 * @param showNumberType    外呼显号标示，类型为：0 根据后台账户配置；1 显号；2 不显号
 * @param extraData         自定义透传信息(能透传给AS服务器)
 * @param isRecord          BOOL值 YES：开启录音，NO：不开启录音
 * @return void
 */
- (void)directCall:(NSString *)number showNumberType:(NSInteger)showNumberType isRecord:(BOOL)isRecord extraData:(NSString *)extraData;

/**
 * 双向回拨
 * @param number            被叫的飞语云id（必须绑定过手机号码）或手机号码
 * @param showNumberType    外呼显号标示，类型为：0 根据后台账户配置；1 显号；2 不显号
 * @param extraData         自定义透传信息(能透传给AS服务器)
 * @param isRecord          BOOL值 YES：开启录音，NO：不开启录音
 * @return void
 */
- (void)callback:(NSString *)number showNumberType:(NSInteger)showNumberType isRecord:(BOOL)isRecord extraData:(NSString *)extraData;

/**
 * 最近一次呼叫的ID
 * @return void
 */
- (NSString *)callId;

/**
 * 结束通话
 * @return void
 */
- (void)endCall;

/**
 * 被叫接听
 * @return void
 */
- (void)answerCall;

/**
 * 被叫拒绝接听
 * @return void
 */
- (void)rejectCall;

/**
 * 设置静音
 * @param enable   YES：开启 ；NO：关闭
 * @return void
 */
- (void)setMuteEnabled:(BOOL)enable;

/**
 * 设置扬声器
 * @param enable  NO:关闭  YES:打开
 * @return void
 */
- (void)setSpeakerEnabled:(BOOL)enable;

/**
 * 发送DTMF
 * @param dtmf  DTMF值 Dtmf对应的字符为’0’,’1’,’2’,’3’,’4’,’5’,’6’,’7’,’8’,’9’,’#’,’*’
 * @return void
 */
- (void)sendDTMF:(char)dtmf;

/**
 * 获取静音状态
 * @param
 * @return BOOL  YES：开启 ；NO：关闭
 */
- (BOOL)isMuted;

/**
 * 获取扬声器状态
 * @return BOOL  YES：开启 ；NO：关闭
 */
- (BOOL)isSpeakerEnabled;

/**
 * 暂停来电响铃
 * @return void
 */
- (void)stopRing;
@end
