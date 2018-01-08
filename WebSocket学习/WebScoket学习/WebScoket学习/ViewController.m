//
//  ViewController.m
//  WebScoket学习
//
//  Created by 韦荣炽 on 2018/1/5.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket/SocketRocket.h>
@interface ViewController ()<SRWebSocketDelegate>
@property(nonatomic,strong)SRWebSocket *socket;//scoket对象
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化webScoket
    [self initWebScokect];
    
}
#pragma mark - 1.初始化webScoket
-(void)initWebScokect
{
    //初始化
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"serverUrl"]]];//这里填写你服务器的地址
    self.socket.delegate=self;//遵循SRWebSocketDelegate 协议
    [self.socket open];//开始连接
}

/**
 webScokect 收到消息回调

 @param webSocket scokect对象
 @param message 收到的消息
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    
}
/**
 webScokect 连接连接成功回调

 @param webSocket scokect对象
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
}

/**
  webScokect 连接失败回调

 @param webSocket cokect对象
 @param error 失败原因
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}

/**
webScokect 连接中断回调

 @param webSocket <#webSocket description#>
 @param code <#code description#>
 @param reason <#reason description#>
 @param wasClean <#wasClean description#>
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}

//返回YES，将以文本形式发送的消息转换为NSString。返回NO，以跳过NSData - >对文本消息的NSString转换。默认值为YES。
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
