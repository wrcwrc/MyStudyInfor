//
//  MyObjectStr.m
//  UnitTestDemo
//
//  Created by 韦荣炽 on 2018/1/3.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import "MyObjectStr.h"

@implementation MyObjectStr
+ (BOOL)isInclueChinese:(NSString *)string
{
    if (string.length == 0) {
        return NO;
    }
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
@end
