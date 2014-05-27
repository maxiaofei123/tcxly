//
//  reg_0.m
//  tcxly
//
//  Created by Li yi on 14-2-18.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "reg_0.h"
#import "reg_1.h"

#import "selectAvatar.h"
#import "UIView+iTextManager.h"
#import "ASIFormDataRequest.h"
#import "registChooseSex.h"
#import "userLogin.h"
#import "v_enter.h"
#import "SBJson.h"


extern UIImage *scaleImage;
@implementation reg_0
@synthesize image;


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addBackground:@"bg.png"];
        
    }
    return self;
}

-(void)loadCurrentPage:(int)cmd
{
    
    an= @"0";
    im = [self addImageView:self
                      image:@"reg_ui.png"
                   position:CGPointMake(182, 46)];
    
    im.userInteractionEnabled=YES;
    
    avatar= [self addButtonWithImageView:im
                                   image:@"avatar_null.jpg"
                               highlight:Nil
                                position:CGPointMake(237, 75)
                                       t:1000
                                  action:@selector(onSelect:)];
    
    
    [self addButton:im
              image:@"reg_qr.png"
           position:CGPointMake(224, 476)
                tag:1001
             target:self
             action:@selector(onDown:)
     ];
    
    [self addButton:self
              image:@"back.png"
           position:CGPointMake(30, 30)
                tag:1003
             target:self
             action:@selector(backClick:)
     ];
    
    UserName=[self addTextField:im
                          frame:CGRectMake(233, 315, 200, 30)
                           font:[UIFont systemFontOfSize:25]
                          color:[UIColor whiteColor]
                    placeholder:@"输入昵称"
                            tag:1100];
    
    UserName.delegate=self;
    
    
    Password=[self addTextField:im
                          frame:CGRectMake(233, 361, 200, 30)
                           font:[UIFont systemFontOfSize:25]
                          color:[UIColor whiteColor]
                    placeholder:@"输入6-10位密码"
                            tag:1101];
    Password.secureTextEntry = YES;
    Password.delegate=self;
    
    
    
    ConfirmPassword=[self addTextField:im
                                 frame:CGRectMake(233, 412, 200, 30)
                                  font:[UIFont systemFontOfSize:25]
                                 color:[UIColor whiteColor]
                           placeholder:@"确认密码"
                                   tag:1102];
    ConfirmPassword.secureTextEntry = YES;
    ConfirmPassword.delegate=self;
    
    
    NSLog(@"%f",im.center.y);
    
    UIKIT_EXTERN NSString *const UITextFieldTextDidBeginEditingNotification;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         im.center=CGPointMake(im.center.x, 100);
                     }];
    
}


- (void)keyboardWillHide:(NSNotification *)notif {
    
    [UIView animateWithDuration:.5
                     animations:^{
                         im.center=CGPointMake(im.center.x, 336);
                     }];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [UserName endEditing:YES];
    return YES;
}


- (void)requestFailed:(ASIHTTPRequest *)req
{ [HUD hide:YES];
    NSError *error = [req error];
    NSLog(@"login:%@",error);
    
    [self clearUnuseful];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接, 请检查网络并重试."
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
}


-(void)clearUnuseful {
    UIActivityIndicatorView *loginLoading = (UIActivityIndicatorView*)[self viewWithTag:9991];
    [loginLoading stopAnimating];
    [loginLoading removeFromSuperview];
    [[self viewWithTag:9992] removeFromSuperview];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"request = %@",[request responseString]);
    NSError *error;
    //提取头像来源信息
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary *user = [Dic objectForKey:@"user"];
    
    NSDictionary * url= [user objectForKey:@"avatar"];
    NSString * iurl = [url objectForKey:@"url"];
    NSString * aid_id =[[NSString alloc]initWithFormat:@"%@",[Dic objectForKey:@"avatar_id"]];
    
    
    switch (request.tag) {
            
            //注册功能回调
        case 8000:
        {
            
            // Use when fetching binary data
            NSData *jsonData = [request responseData];
            
            //解析JSon
            NSError *error = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            
            BOOL success = [[jsonObject objectForKey:@"success"] boolValue];
            
            if (success){
                
                //注册成功并保存token
                NSString *token=[jsonObject objectForKey:@"auth_token"];
                NSString *classNO = [user objectForKey:@"class_no"];
                
                [[NSUserDefaults standardUserDefaults] setObject:token
                                                          forKey:@"token"];
                
                [[NSUserDefaults standardUserDefaults] setObject:classNO
                                                          forKey:@"class_no"];
                
                //记录帐户信息
                
                id aa=[[NSUserDefaults standardUserDefaults] objectForKey:@"accountArray"];
                
                if(aa&& ![aa isKindOfClass:[NSNull class]])
                {
                    //已经存在帐户了
                    NSMutableArray *testArray=aa;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:nil
                                                              forKey:@"accountArray"];
                    
                    [testArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          an,@"avatar",
                                          UserName.text,@"name",
                                          token,@"token",nil]];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:testArray
                                                              forKey:@"accountArray"];
                    
                }
                else
                {
                    //不存在帐户
                    NSMutableArray *testArray=[NSMutableArray array];
                    [testArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          an,@"avatar",
                                          UserName.text,@"name",
                                          token,@"token",nil]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:testArray
                                                              forKey:@"accountArray"];
                }
                
                NSLog(@"items=%@",aa);
                
                
                [HUD hide:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"恭喜你注册成功了！"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                alertView.tag = 90;
                [alertView show];
            }
            else
            {
                [HUD hide:YES];
                //注册失败
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"注册失败 请重试！"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
        }
            break;
            
            request=nil;
    }
    
    
}


//生成唯一编码
- (NSString *) uniqueString
{
    CFUUIDRef unique = CFUUIDCreate(kCFAllocatorDefault);
    NSString *result =(NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, unique));
    CFRelease(unique);
    return result;
}

//footer -----------------------------------
-(void)reg
{
    
    //开始提交
    NSString *msg=@"ok";
    
    
    [UserName endEditing:YES];
    
    if(([an isEqualToString:@"0"]))
    {
        msg=@"请选择一个头像";
    }
    else if(UserName.text.length==0)
    {
        msg=@"请输入用户名";
    }    else if(Password.text.length==0)
    {
        msg=@"请输入密码";
    }
    else if([Password.text isEqualToString:ConfirmPassword.text]==NO)
    {
        msg=@"密码输入不一致";
    }
    else if(Password.text.length<6||Password.text.length>20)
    {
        msg=@"请输入6－10位密码";
    }
    if ([msg isEqualToString:@"ok"]) {
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        HUD.labelText = @"正在提交，请稍等...";
        [HUD show:YES];
        
        //开始注册
        
        NSMutableData *data = [[NSMutableData alloc]init];
        data = UIImagePNGRepresentation(scaleImage);
        
        NSString *sex=[[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        
        NSString *s=[NSString stringWithFormat:@"http://gifted-center.com/users.json?user[username]=%@&user[password]=%@&user[password_confirmation]=%@&user[email]=12311%d@kingaxis.com&user[gender]=%@&user[avatar_id]=%@",
                     UserName.text,
                     Password.text,
                     ConfirmPassword.text,
                     (1 + (arc4random() % (10000-1 + 1))),
                     sex,
                     [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]];
        
        NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"reg url =%@",url);
        regRequest = [ASIFormDataRequest requestWithURL:url];
        [regRequest  addData:data  withFileName:@"avatarImage.png" andContentType:@"image/png"  forKey:@"avatar"];
        regRequest.tag=8000;
        regRequest.timeOutSeconds=60;
        [regRequest setRequestMethod:@"POST"];
        [regRequest setDelegate:self];
        [regRequest startAsynchronous];
        
    }
    else
    {
        [HUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}


//选择头像
-(void)onSelect:(id)s
{
    [UserName endEditing:YES];
    
    selectAvatar *p=[[selectAvatar alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [p loadCurrentPage:[an integerValue]];
    [self fadeInView:p duration:.5];
}

-(void)updateAvatar:(UIImage * )image
{
    
    avatar.image= image;
    an =@"1";
    
}

-(void)updateAvatar
{
    an=  [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    
    if(!an||[an isKindOfClass:[NSNull class]])
    {
        an=@"0";
    }
    
    avatar.image=[UIImage imageNamed:[NSString stringWithFormat:@"avatar_%@.jpg",an]];
    
}


-(void)onDown:(UIButton*)sender
{
    [self reg];
}


-(void)backClick:(UIButton*)e
{
    registChooseSex *re = [[registChooseSex alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:re
                      duration:.5];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag ==90){
        
        [self showList];
        
    }
}

- (void)dealloc {//释放键盘监听方法
    
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
    
}

-(void)showList {
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:ve
                      duration:.5
     ];
    
}

@end
