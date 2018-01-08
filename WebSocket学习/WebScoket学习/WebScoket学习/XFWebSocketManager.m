//
//  XFWebSocketManager.m
//  XFWebSocketDemo
//
//  Created by 韦荣炽 on 2018/1/5.
//  Copyright © 2018年 clarence. All rights reserved.
//

#import "XFWebSocketManager.h"
#import <SocketRocket/SocketRocket.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface XFWebSocketManager ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)XFWebSocketStatus xf_socketStatus;//星飞socket状态
@property (nonatomic,weak)NSTimer *reconnectTimer;//重连的定时器
@property (nonatomic,copy)NSString *urlString;
@property(nonatomic,strong)NSTimer * heartBeatTimer;//心跳定时器
@property(nonatomic,assign) NSInteger reconnectCounter;//重连时间
@end
@implementation XFWebSocketManager
#pragma mark - 单利创建
+ (instancetype)shareManager{
    static XFWebSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 5;
    });
    return instance;
}
#pragma mark - 连接socket
- (void)connectServerWithServerUrl:(NSString *)serverUrlStr connectSucess:(XFWebSocketDidConnectBlock)connect receiveMess:(XFWebSocketDidReceiveBlock)receive failure:(XFWebSocketDidFailBlock)failure
{
    [XFWebSocketManager shareManager].connect = connect;
    [XFWebSocketManager shareManager].receive = receive;
    [XFWebSocketManager shareManager].failure = failure;
    [self openSocket:serverUrlStr];
}
#pragma mark -  断开socket
- (void)disconnectSever:(XFWebSocketDidCloseBlock)disconnect{
    [XFWebSocketManager shareManager].close = disconnect;
    [self closeSocket];
}

// Send a UTF8 String or Data.
#pragma mark - 发送消息
- (void)sendMessageWithData:(id)data{
    switch ([XFWebSocketManager shareManager].xf_socketStatus) {
        case XFWebSocketStatusConnected:
        case XFWebSocketStatusReceived:{
            NSLog(@"发送中。。。");
            [self.webSocket send:data];
            break;
        }
        case XFWebSocketStatusFailed:
            NSLog(@"发送失败");
            break;
        case XFWebSocketStatusClosedByServer:
            NSLog(@"已经关闭");
            break;
        case XFWebSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            break;
    }
    
}

#pragma mark -- private method  实际上打开scoket的方法
- (void)openSocket:(id)params{
    //    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [XFWebSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}
#pragma mark - 关闭socket
- (void)closeSocket{
    
    [self.webSocket close];
    self.webSocket = nil;
    [self.reconnectTimer invalidate];
    self.reconnectTimer = nil;
}
#pragma mark - 重新连接socket
- (void)reconnectSocket{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(openSocket:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.reconnectTimer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.reconnectTimer) {
            [self.reconnectTimer invalidate];
            self.reconnectTimer = nil;
        }
        return;
    }
}
#pragma mark - 初始化心跳
-(void)initHearBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        
        __weak typeof (self) weakSelf=self;
        //心跳设置为3分钟，NAT超时一般为5分钟
        self.heartBeatTimer=[NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart");
            //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sendMessageWithData:@"heart"];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    })
}
#pragma mark -  取消心跳
-(void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (self.heartBeatTimer) {
            [self.heartBeatTimer invalidate];
            self.heartBeatTimer=nil;
        }
    });
}
#pragma mark -- SRWebSocketDelegate
/**
 连接成功回调
 
 @param webSocket socket对象
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [XFWebSocketManager shareManager].connect ? [XFWebSocketManager shareManager].connect() : nil;
    [XFWebSocketManager shareManager].xf_socketStatus = XFWebSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
    //初始化心跳
    [self initHearBeat];
}

/**
 连接失败回调
 
 @param webSocket socket对象
 @param error 失败描述
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    [XFWebSocketManager shareManager].xf_socketStatus = XFWebSocketStatusFailed;
    [XFWebSocketManager shareManager].failure ? [XFWebSocketManager shareManager].failure(error) : nil;
    // 重连
    [self reconnectSocket];
    
  
}

/**
 收到消息回调
 
 @param webSocket socket对象
 @param message 消息内容
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@":( Websocket Receive With message %@", message);
    [XFWebSocketManager shareManager].xf_socketStatus = XFWebSocketStatusReceived;
    [XFWebSocketManager shareManager].receive ? [XFWebSocketManager shareManager].receive(message,XFWebSocketReceiveTypeForMessage) : nil;
}

/**
网络连接中断被调用
 
 @param webSocket socket对象
 @param code 失败的code值
 @param reason 失败原因
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {//系统中断
        [XFWebSocketManager shareManager].xf_socketStatus = XFWebSocketStatusClosedByServer;
        // 重连
        [self reconnectSocket];
    }
    else{//用户自己关闭
        [XFWebSocketManager shareManager].xf_socketStatus = XFWebSocketStatusClosedByUser;
    }
    [XFWebSocketManager shareManager].close ? [XFWebSocketManager shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
    
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}

/**
 收到服务端回调的pong 数据

 @param webSocket socket对象
 @param pongPayload pong 数据
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [XFWebSocketManager shareManager].receive ? [XFWebSocketManager shareManager].receive(pongPayload,XFWebSocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    [self closeSocket];
}

@end
