//
//  XFWebSocketManager.h
//  XFWebSocketDemo
//
//  Created by 韦荣炽 on 2018/1/5.
//  Copyright © 2018年 clarence. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  socket状态
 */
typedef NS_ENUM(NSInteger,XFWebSocketStatus){
    XFWebSocketStatusConnected,// 已连接
    XFWebSocketStatusFailed,// 失败
    XFWebSocketStatusClosedByServer,// 系统关闭
    XFWebSocketStatusClosedByUser,// 用户关闭
    XFWebSocketStatusReceived// 接收消息
};
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,XFWebSocketReceiveType){
    XFWebSocketReceiveTypeForMessage,
    XFWebSocketReceiveTypeForPong
};
/**
 *  连接成功回调
 */
typedef void(^XFWebSocketDidConnectBlock)(void);
/**
 *
 *  失败回调
 */
typedef void(^XFWebSocketDidFailBlock)(NSError *error);
/**
 *
 *  关闭回调
 */
typedef void(^XFWebSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
/**
 *  消息接收回调
 */
typedef void(^XFWebSocketDidReceiveBlock)(id message ,XFWebSocketReceiveType type);

@interface XFWebSocketManager : NSObject
/**
 *
 *  连接回调
 */
@property (nonatomic,copy)XFWebSocketDidConnectBlock connect;
/**
 *
 *  接收消息回调
 */
@property (nonatomic,copy)XFWebSocketDidReceiveBlock receive;
/**
 *
 *  失败回调
 */
@property (nonatomic,copy)XFWebSocketDidFailBlock failure;
/**
 *
 *  关闭回调
 */
@property (nonatomic,copy)XFWebSocketDidCloseBlock close;
/**
 *
 *  当前的socket状态
 */
@property (nonatomic,assign,readonly)XFWebSocketStatus xf_socketStatus;
/**
 *
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;
/**
 *
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
/** *
 *  单例调用
 */
+ (instancetype)shareManager;


/**
 开启socket并连接服务器

 @param serverUrlStr 服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)connectServerWithServerUrl:(NSString *)serverUrlStr connectSucess:(XFWebSocketDidConnectBlock)connect receiveMess:(XFWebSocketDidReceiveBlock)receive failure:(XFWebSocketDidFailBlock)failure;
/**
 *
 *  断开socket
 *
 *  @param disconnect 断开回调
 */
- (void)disconnectSever:(XFWebSocketDidCloseBlock)disconnect;

/**
 *
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
-(void)sendMessageWithData:(id)data;

@end








