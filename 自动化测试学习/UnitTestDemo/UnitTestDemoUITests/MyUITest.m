//
//  MyUITest.m
//  UnitTestDemoTests
//
//  Created by 韦荣炽 on 2018/1/3.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import <XCTest/XCTest.h>


@interface MyUITest : XCTestCase

@end

@implementation MyUITest

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
    //每个test方法执行前调用，在这个测试用例里进行一些通用的初始化工作
}

- (void)tearDown {
    [super tearDown];
    //每个test方法执行后调用
}

- (void)testExample {
    //测试方法样例
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *textField = app.textFields[@"请输入账号"];
    [textField tap];
    [textField typeText:@"123231"];
    
    XCUIElement *textField2 = app.textFields[@"请输入密码"];
    [textField2 tap];
    [textField2 typeText:@"2333"];
    [app.buttons[@"登录"] tap];
    
    XCUIElement *button = app.buttons[@"登录"];
    [button tap];
    [app.alerts[@"点击了登录"].buttons[@"cacnle"] tap];
}


@end





/*
 
 */





