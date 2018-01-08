//
//  MyObjectStr.h
//  UnitTestDemo
//
//  Created by 韦荣炽 on 2018/1/3.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObjectStr : NSObject
/**
 *  判断字符串中是否有中文  YES 表示正确的
 */
+ (BOOL)isInclueChinese:(NSString *)string;
@end
