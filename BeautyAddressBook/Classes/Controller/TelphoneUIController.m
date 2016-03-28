//
//  TelphoneUIController.m
//  YSzhuxuebao
//
//  Created by  吕海冬 on 16/2/22.
//  Copyright © 2016年 YS. All rights reserved.
//

#import "TelphoneUIController.h"

#import "PulsingHaloLayer.h"

#import "FGGReachability.h"

#import "MBProgressHUD+MJ.h"

#import "FYCall.h"

#import "define.h"

// 自适应屏
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height

@interface TelphoneUIController ()<FYCallDelegate>
{
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer *timer;
}

@property (nonatomic, strong) PulsingHaloLayer *halo;

@property (nonatomic, strong) UIButton         *hangUpBtn;

@property (nonatomic, strong) UIButton         *muteBtn;

@property (nonatomic, strong) UIButton         *loudSpeakBtn;

@property (nonatomic, strong) UIView           *pulseView;

@property (nonatomic, strong) Reachability     *reachability;

@property (nonatomic, strong) UILabel          *networkLable;

@property (strong, nonatomic) NSString         *callID;

@end

@implementation TelphoneUIController

- (void)settingsTopImage
{
    _pulseView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight * 0.3)];
    
    _halo = [[PulsingHaloLayer alloc] init];
    _halo.position = self.pulseView.center;
    [self.pulseView.layer addSublayer:_halo];
    
    self.halo.radius = self.pulseView.frame.size.height * 0.8;
    
    UIColor *color = [UIColor colorWithRed:0.7
                                     green:0.9
                                      blue:0.3
                                     alpha:1.0];
    
    self.halo.backgroundColor = color.CGColor;
    
    CGFloat X = self.pulseView.frame.size.width * 0.35;
    CGFloat Y = self.pulseView.frame.size.height * 0.2;
    CGFloat width = self.pulseView.frame.size.width - 2 * X;
    CGFloat height = width;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
    
    imgView.layer.cornerRadius = width * 0.48;
    
    imgView.layer.masksToBounds = YES;
    
    [imgView setBackgroundColor:[UIColor blueColor]];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(X * 0.2, imgView.frame.size.height * 0.3, imgView.frame.size.width - 2 * (X * 0.2), 40)];
    //[labelName setText:[UserDefault objectForKey:phoneContact]];
    labelName.textAlignment = NSTextAlignmentCenter;
    
    [imgView addSubview:labelName];
    
    
    CGFloat phoneNumX      = self.pulseView.frame.size.width * 0.1;
    CGFloat phoneNumY      = self.pulseView.frame.size.height * 0.9;
    CGFloat phoneNumWidth  = self.pulseView.frame.size.width - 2 * phoneNumX;
    CGFloat phoneNumHeight = 40;
    
    
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(phoneNumX, phoneNumY, phoneNumWidth, phoneNumHeight)];
    
    labelPhone.textAlignment = NSTextAlignmentCenter;

    [labelPhone setText: [[NSUserDefaults standardUserDefaults] objectForKey:ContactPhone]];
    
    [self.pulseView addSubview:labelPhone];
    
    [self.pulseView addSubview:imgView];
    
    [self.view addSubview:_pulseView];
}

- (void) settingsHangUpBtn
{
    _hangUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3, kScreenHeight * 0.7, kScreenWidth / 3, kScreenWidth / 3)];
    UILabel *hangUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.35, CGRectGetMaxY(_hangUpBtn.frame) - 10, kScreenWidth - 2 * (kScreenWidth * 0.35), 40)];
    [hangUpLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [hangUpLabel setText:@"挂断"];
    hangUpLabel.textAlignment = NSTextAlignmentCenter;
    [_hangUpBtn setImage:[UIImage imageNamed:@"guaduan_dianji_normal"] forState:UIControlStateNormal];
    [_hangUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_hangUpBtn];
    [self.view addSubview:hangUpLabel];
}

- (void) settingsMuteBtn
{
    _muteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.7, kScreenWidth / 3, kScreenWidth / 3)];
    
    UILabel *muteLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.01, CGRectGetMaxY(_hangUpBtn.frame) - 10, kScreenWidth - 2 * (kScreenWidth * 0.35), 40)];
    [muteLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [muteLabel setText:@"静音"];
    muteLabel.textAlignment = NSTextAlignmentCenter;
    
    [_muteBtn setImage:[UIImage imageNamed:@"jingyin_dianji_normal"] forState:UIControlStateNormal];

    [[FYCall instance] setMuteEnabled:NO];
    
    [_muteBtn addTarget:self action:@selector(muteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:muteLabel];
    
    [self.view addSubview:_muteBtn];
}

- (void) settingsLoudSpeak
{
    _loudSpeakBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * 2, kScreenHeight * 0.7, kScreenWidth / 3, kScreenWidth / 3)];
    
    UILabel *loudSepakLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.69, CGRectGetMaxY(_hangUpBtn.frame) - 10, kScreenWidth - 2 * (kScreenWidth * 0.35), 40)];
    [loudSepakLabel setFont:[UIFont systemFontOfSize:20.0f]];
    
    [loudSepakLabel setText:@"免提"];
    loudSepakLabel.textAlignment = NSTextAlignmentCenter;
    
    [_loudSpeakBtn setImage:[UIImage imageNamed:@"mianti_dianji_normal"] forState:UIControlStateNormal];
    
    
    [_loudSpeakBtn addTarget:self action:@selector(loudSpeakClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[FYCall instance] setSpeakerEnabled:NO];
    
    [self.view addSubview:loudSepakLabel];
    
    [self.view addSubview:_loudSpeakBtn];
}

- (void)muteClick
{
    if ([[FYCall instance] isMuted] == NO)
    {
        [_muteBtn setImage:[UIImage imageNamed:@"jingyin_dianji"] forState:UIControlStateNormal];
        [[FYCall instance] setMuteEnabled:YES];
    }else
    {
        [_muteBtn setImage:[UIImage imageNamed:@"jingyin_dianji_normal"] forState:UIControlStateNormal];
        [[FYCall instance] setMuteEnabled:NO];
    }
}

- (void)loudSpeakClick
{
    if ([[FYCall instance] isSpeakerEnabled] == NO)
    {
        [_loudSpeakBtn setImage:[UIImage imageNamed:@"mianti_dianji"] forState:UIControlStateNormal];
        [[FYCall instance] setSpeakerEnabled:YES];
    }else
    {
       [_loudSpeakBtn setImage:[UIImage imageNamed:@"mianti_dianji_normal"] forState:UIControlStateNormal];
        [[FYCall instance] setSpeakerEnabled:NO];
    }
}

- (void)backFronts
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hangup
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }

    [MBProgressHUD showText:@"结束通话"];
    [_hangUpBtn setImage:[UIImage imageNamed:@"guaduan_dianji"] forState:UIControlStateNormal];

    [NotificationCenter postNotificationName:@"endCall" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
    ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFronts) userInfo:nil repeats:NO];
}

- (void)setCheckReachability
{
    _networkLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_pulseView.frame) + 20, kScreenWidth - 2 * 10, 50)];
    
    _networkLable.textAlignment = NSTextAlignmentCenter;
    
    _networkLable.numberOfLines = 0;
    
    [_networkLable setFont:[UIFont systemFontOfSize:25.0f]];
    
    _reachability=[Reachability reachabilityForInternetConnection];
    
    //网络状态改变时调用estimateNetwork方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(estimateNetwork) name:kReachabilityChangedNotification object:nil];
    [_reachability startNotifier];
    
    //判断网络状态
    [self estimateNetwork];

    [self.view addSubview:_networkLable];
}
//判断网络状态
-(void)estimateNetwork
{
    FGGNetWorkStatus status=[FGGReachability networkStatus];
    
    switch (status)
    {
        case FGGNetWorkStatus2G:
        {
             [_networkLable setText:@"正在呼叫中,请稍等..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [_networkLable setText:@"当前网络状态:2G"];
            });
           
            break;
        }
        
        case FGGNetWorkStatus3G:
        {
            [_networkLable setText:@"正在呼叫中,请稍等..."];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [_networkLable setText:@"当前网络状态:3G"];
            });
            break;
        }
            
        case FGGNetWorkStatus4G:
        {
            [_networkLable setText:@"正在呼叫中,请稍等..."];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [_networkLable setText:@"当前网络状态:4G"];
            });
            
            break;
        }
            
        case FGGNetWorkStatusWifi:
        {
             [_networkLable setText:@"正在呼叫中,请稍等..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_networkLable setText:@"当前网络状态:WIFI"];
            });
            break;
        }
            
        case FGGNetWorkStatusNotReachable:
        {
             [_networkLable setText:@"正在呼叫中,请稍等..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [_networkLable setText:@"当前网络状态:不可用"];
            });
            break;
        }
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:kColor(0, 191, 255)];
    
    [self settingsTopImage];
    
    [self settingsHangUpBtn];
    
    [self settingsMuteBtn];
    
    [self settingsLoudSpeak];
    
    [self setCheckReachability];
    
    _muteBtn.enabled = NO;
    
     [[FYCall instance] addDelegate:self];
}

/**
 *  显示电话拨打分钟数
 */
- (void)updateRealtimeLabel
{
    ssInt +=1;
    if (ssInt >= 60)
    {
        mmInt += 1;
        ssInt -= 60;
        if (mmInt >=  60)
        {
            hhInt += 1;
            mmInt -= 60;
            if (hhInt >= 24)
            {
                hhInt = 0;
            }
        }
    }
    if (hhInt > 0)
    {
        self.networkLable.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt];
    } else {
        self.networkLable.text = [NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt];
    }
}

//呼叫失败
-(void)onFyCallFailed:(FYError *)error
{
    if (error.code == 202005 || error.code == 202010)
    {
        [self hangup];
    }
}

//有电话呼入
-(void)onFyIncomingCall:(NSString *)callerNumber
{
    NSLog(@"callerNumber1:%@", callerNumber);
}

//有电话呼出
-(void)onFyOutgoingCall:(NSString *)calleeNumber
{
    NSLog(@"calleeNumber1:%@", calleeNumber);
}

//通话中
-(void)onFyCallRunning:(NSString *)peerNumber
{
    NSLog(@"onFyCallRunning1通话中:%@", peerNumber);
    
    _muteBtn.enabled   = YES;
    _networkLable.text = @"00:00";
    
    if (![timer isValid])
    {
        timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }
}

//通话结束
-(void)onFyCallEnd
{
    NSLog(@"onFyCallEnd1通话结束");
    [self hangup];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(backFronts) userInfo:nil repeats:NO];
}

//对方正在振铃
-(void)onFyCallAlerting:(NSString *)calleeNumber
{
    NSLog(@"对方正在振铃1:%@", calleeNumber);
}

//回拨失败
-(void)onFyCallbackFailed:(FYError *)error
{
    NSLog(@"onFyCallbackFailed1回拨失败:%@", error.description);
}

//回拨成功
-(void)onFyCallbackSuccessful
{
    NSLog(@"onFyCallbackSuccessful1回拨成功");
}

//停止网络状态监听，移除通知
-(void)dealloc
{
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
