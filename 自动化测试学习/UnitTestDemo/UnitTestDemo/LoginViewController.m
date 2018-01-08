//
//  LoginViewController.m
//  UnitTestDemo
//
//  Created by 韦荣炽 on 2018/1/3.
//  Copyright © 2018年 XingFei_韦荣炽. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
 
    
    UITextField *acountTF=[[UITextField alloc]initWithFrame:CGRectMake(50, 150, self.view.frame.size.width-2*50, 40)];;
    acountTF.borderStyle=UITextBorderStyleLine;
    acountTF.placeholder=@"请输入账号";
    [self.view addSubview:acountTF];
    
    UITextField *pwdTF=[[UITextField alloc]initWithFrame:CGRectMake(50, acountTF.frame.origin.y+acountTF.frame.size.height+15, self.view.frame.size.width-2*50, 40)];;
    pwdTF.placeholder=@"请输入密码";
    pwdTF.borderStyle=UITextBorderStyleLine;
    [self.view addSubview:pwdTF];
    
    
    UIButton *loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, pwdTF.frame.origin.y+pwdTF.frame.size.height+50, pwdTF.frame.size.width, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor=[UIColor greenColor];
    [self.view addSubview:loginBtn];
    
    [loginBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)loginBtn
{
    UIAlertView *aler=[[UIAlertView alloc]initWithTitle:@"点击了登录" message:@"login btn click" delegate:self cancelButtonTitle:@"cacnle" otherButtonTitles:@"ok", nil];
    [aler show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
