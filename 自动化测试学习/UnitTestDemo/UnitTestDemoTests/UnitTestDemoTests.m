//
//  UnitTestDemoTests.m
//  UnitTestDemoTests
//
//  Created by 韦荣炽 on 2018/1/3.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UnitTestDemoTests : XCTestCase

@end

@implementation UnitTestDemoTests

- (void)setUp {
    [super setUp];
    //每个test方法执行前调用，在这个测试用例里进行一些通用的初始化工作
}

- (void)tearDown {
    [super tearDown];
     //每个test方法执行后调用
}

- (void)testExample {
   //测试方法样例
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
    //这个方法主要是做性能测试的，所谓性能测试，主要就是评估一段代码的运行时间。该方法就是性能测试方法的样例。
}

@end









