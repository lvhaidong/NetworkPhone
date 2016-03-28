//
//  ViewController.m
//  BeautyAddressBook
//
//  Created by 余华俊 on 15/10/22.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import "ViewController.h"
#import "XHJAddressBook.h"
#import  "PersonModel.h"
#import "PersonCell.h"

#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"

#import "FYClient.h"
#import "FYCall.h"

#import "define.h"

#import "TelphoneUIController.h"

#define  mainWidth [UIScreen mainScreen].bounds.size.width
#define  mainHeigth  [UIScreen mainScreen].bounds.size.height

// 正式账号的appkey和token
#define FYAppkey       @"26170EB644C2879F786114B7202B9BC6"
#define FYAppToken     @"913F5B536F212903C41C81C26A90720D"

// 测试账号的appkey和token
#define TestFYAppkey   @"B9694560D119972DE20542847C987361"
#define TestFYAppToken @"77BA53CC8878DB109D87131972FF5B42"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, FYClientDelegate, FYCallDelegate>

@property(nonatomic,strong)   NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) PersonModel *people;

@end


@implementation ViewController
{
    UITableView    *_tableShow;
    XHJAddressBook *_addBook;
    UIWebView*      _phoneCallWebView;
}

- (void)showContactList
{
    _sectionTitles=[NSMutableArray new];
    
    _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
    
    [MBProgressHUD showMessage:@"联系人列表加载中,请稍等..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self setTitleList];
            [_tableShow reloadData];
        });
    });
}

- (void) addTableView
{
    _sectionTitles=[NSMutableArray new];
    _tableShow=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeigth)];
    _tableShow.delegate=self;
    _tableShow.dataSource=self;
    [self.view addSubview:_tableShow];
    _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"通讯录";
    
    [self showContactList];

    [self addTableView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
   _tableShow.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [NotificationCenter addObserver:self selector:@selector(releaseCall) name:@"endCall" object:nil];
}

- (void)loadNewData
{
   [MBProgressHUD showMessage:@"联系人列表加载中,请稍等..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       [_tableShow.mj_header endRefreshing];
                       [MBProgressHUD hideHUD1];
                       
                       _sectionTitles=[NSMutableArray new];
                       
                       _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
                       _tableShow.sectionIndexColor = [UIColor blackColor];
                       
                       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           [self initData];
                           
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               [self setTitleList];
                               [_tableShow reloadData];
                           });
                       });
                       
                   });
}

-(void)setTitleList
{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
    NSMutableArray * existTitles = [NSMutableArray array];
    for(int i=0;i<[_listContent count];i++)//过滤 就取存在的索引条标签
    {
        PersonModel *pm=_listContent[i][0];
        for(int j=0;j<_sectionTitles.count;j++)
        {
            if(pm.sectionNumber==j)
                [existTitles addObject:self.sectionTitles[j]];
        }
    }

    [self.sectionTitles removeAllObjects];
    self.sectionTitles = existTitles;
    
}

-(NSMutableArray*)listContent
{
    if(_listContent==nil)
    {
        _listContent=[NSMutableArray new];
    }
    return _listContent;
}

-(void)initData
{
    _addBook=[[XHJAddressBook alloc]init];
    self.listContent=[_addBook getAllPerson];
    if(_listContent==nil)
    {
        NSLog(@"数据为空或通讯录权限拒绝访问，请到系统开启");
        return;
    }
    
}

//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listContent count];
    
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_listContent objectAtIndex:(section)] count];
    
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//section的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(self.sectionTitles==nil||self.sectionTitles.count==0)
        return nil;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    NSString *sectionStr=[self.sectionTitles objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"addressCell";
    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(personcell==nil)
    {
        personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    _people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    [personcell setData:_people];
    
    return personcell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSString *key = [self.listContent objectAtIndex:indexPath.section];
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    self.people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_people.phonename
                                                    message:_people.tel
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"本地打电话",@"网络电话",  nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:_people.phonename forKey:ContactName];
     [[NSUserDefaults standardUserDefaults] setObject:_people.tel forKey:ContactPhone];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // UIApplication *app = [UIApplication sharedApplication];
    if (buttonIndex == 1)
    {
        // app 上线可能被拒
        //[app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
        
        [self requestCallPhone:alertView.message];
    }else if (buttonIndex == 2)
    {
        [self internetCallPhone];
        
        TelphoneUIController *telVC = [[TelphoneUIController alloc] init];
        
        [self presentViewController:telVC animated:YES completion:nil];
    }
}

- (void) requestCallPhone:(NSString *)phoneNumber
{
    NSURL* dialUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _people.tel]];
    
    if ([[UIApplication sharedApplication] canOpenURL:dialUrl])
    {
        if (_phoneCallWebView)
        {
            [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:dialUrl]];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:dialUrl];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设备不支持" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (void)internetCallPhone
{
    [[FYClient instance] addDelegate:self];
    
    [[FYClient instance] init:@"iOS" logSwitch:YES];
    
    [[FYClient instance] connect:TestFYAppkey appToken:TestFYAppToken fyAccountId:@"FYB96947EUGEC" fyAccountPwd:@"4PV2JN"];
}

//连接成功
-(void)onFyConnectionSuccessful
{
      NSLog(@"连接飞语平台成功");
     [[FYCall instance] addDelegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //网络直拨
        [[FYCall instance] directCall:_people.tel showNumberType:1 isRecord:NO extraData:@""];
        
        //互联网语音
        //[[FYCall instance] networkCall:fyAccountId showNumberType:showNumberType isRecord:isRecord extraData:extraData];
        
        //双向回拨
        //[[FYCall instance] callback:_people.tel showNumberType:1 isRecord:NO extraData:@""];
    });
}

//连接失败
-(void)onFyConnectionFailed:(FYError *)error
{
    NSLog(@"连接飞语平台失败:%@", error.description);
}

- (void)onUpLoadLogResult:(BOOL)result
{
    NSLog(@"result:%hhd", result);
}

- (void)onFyAccountOnlineFailed:(FYError *)error
{
    NSLog(@"error:%@", error.description);
}

- (void)onFyAccountOnlineInfo:(FYAccountNetState)state
{
    NSLog(@"state:%u", state);
}

//呼叫失败
-(void)onFyCallFailed:(FYError *)error
{
    NSLog(@"FYError:%@", error.description);
}

//有电话呼入
-(void)onFyIncomingCall:(NSString *)callerNumber
{
    NSLog(@"callerNumber:%@", callerNumber);
}

//有电话呼出
-(void)onFyOutgoingCall:(NSString *)calleeNumber
{
    NSLog(@"calleeNumber:%@", calleeNumber);
}

//通话中
-(void)onFyCallRunning:(NSString *)peerNumber
{
    NSLog(@"onFyCallRunning通话中:%@", peerNumber);
}

//通话结束
-(void)onFyCallEnd
{
    NSLog(@"onFyCallEnd通话结束");
}

//对方正在振铃
-(void)onFyCallAlerting:(NSString *)calleeNumber
{
    NSLog(@"对方正在振铃:%@", calleeNumber);
}

//回拨失败
-(void)onFyCallbackFailed:(FYError *)error
{
    NSLog(@"onFyCallbackFailed回拨失败:%@", error.description);
}

//回拨成功
-(void)onFyCallbackSuccessful
{
    NSLog(@"onFyCallbackSuccessful回拨成功");
}

- (void) releaseCall
{
    [[FYCall instance] endCall];
}

//开启右侧索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
