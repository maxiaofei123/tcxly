//
//  userLogin.m
//  sq
//
//  Created by Li yi on 13-7-20.
//
//

#import "userLogin.h"
#import "ASIFormDataRequest.h"
#import "v_enter.h"
#import "registChooseSex.h"
#import "v_enter.h"
#import "reg_0.h"
#import "v_level.h"

@implementation userLogin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"login_bg.png"];
        
    }
    return self;
}


-(void)loadCurrentPage:(int)cmd
{
    
    UserName=[self addTextField:self
                          frame:CGRectMake(414, 319, 207, 35)
                           font:[UIFont systemFontOfSize:25]
                          color:[UIColor whiteColor]
                    placeholder:@"请输入用户昵称"
                            tag:1000];
    
    UserName.delegate = self;
    
    
    Password=[self addTextField:self
                          frame:CGRectMake(414, 370, 207, 35)
                           font:[UIFont systemFontOfSize:25]
                          color:[UIColor whiteColor]
                    placeholder:@"请输入密码"
                            tag:1000];
    
    
    Password.delegate= self;
    Password.secureTextEntry = YES;
    
    [self addButton:self
              image:@"login_dl.png"
           position:CGPointMake(394, 454)
                tag:2000
             target:self
             action:@selector(onLoginDown:)];
    
    [self addButton:self
              image:@"login_reg.png"
           position:CGPointMake(650, 307)
                tag:2001
             target:self
             action:@selector(onRegDown:)];
    
    [self addButton:self
              image:@"back.png"
           position:CGPointMake(30, 30)
                tag:1003
             target:self
             action:@selector(backClick:)
     ];
    
}


-(void)backClick:(id)sender
{
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:ve
                      duration:.5
     ];
    NSLog(@"userlogin backClick...");
}



-(void)onRegDown:(id*)sender
{
    NSLog(@"user onRegDown...");
    
    registChooseSex *ur = [[registChooseSex alloc]initWithFrame:self.frame];
    
    [ur loadCurrentPage:0];
    
    [self.superview fadeInView:self
                   withNewView:ur
                      duration:.5];
    
}


//footer -----------------------------------
-(void)onLoginDown:(id*)sender
{
    NSLog(@"登入...............");
    
    if (1) {
        v_enter *up = [[v_enter alloc]initWithFrame:self.frame];
        [self.superview fadeInView:self withNewView:up duration:.5];
        [up loadCurrentPage:0];
    }else{
    //开始提交
    NSString *msg=@"ok";
    
    if(UserName.text.length==0)
    {
        msg=@"请输入用户名";
    }
    
    else if(Password.text.length==0)
    {
        msg=@"请输入密码";
    }
    
    
    if ([msg isEqualToString:@"ok"])
    {
        
        HUD = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:HUD];
        
        HUD.labelText = @"正在提交，请稍等...";
        [HUD show:YES ];
        NSString *ss=[NSString stringWithFormat:@"http://gifted-center.com/users/sign_in.json?user[login]=%@&user[password]=%@",UserName.text,Password.text];
        
        NSLog(@"通过验证，可提交 url=%@",ss);
        NSURL *url = [NSURL URLWithString:[ss stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        
        
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    }
    
}
//请求回调 ---------------------------------------------------------------------------------------------------

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    //提取头像来源信息
    NSError *error;
    
    NSLog(@"userlogin requestFinished...%@",[request responseString]);
    
    NSData *jsonData = [request responseData];
    
    //解析JSon
    NSString * flag = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:flag
                                              forKey:@"flag"];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    
    BOOL success = [[jsonObject objectForKey:@"success"] boolValue];
    
    if (success){
        [[NSUserDefaults standardUserDefaults] setObject:[jsonObject objectForKey:@"auth_token"]
                                                  forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[jsonObject objectForKey:@"avatar_id"]
                                                  forKey:@"avatar"];
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"登入成功。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    else
    {
        //失败
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"用户名或密码错，请重试！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
    request=nil;
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [HUD hide:YES];
    NSError *error = [request error];
    NSLog(@"ruserlogin:%@",error);
    //失败
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接，请重试！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
    
    //停止查询
    [request clearDelegatesAndCancel];
    request=nil;
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    v_enter *up = [[v_enter alloc]initWithFrame:self.frame];
    [self.superview fadeInView:self withNewView:up duration:.5];
    [up loadCurrentPage:0];
}


@end
