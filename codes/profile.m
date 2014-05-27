//
//  profile.m
//  tcxly
//
//  Created by Li yi on 13-9-14.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "profile.h"
#import "UIView+iTextManager.h"
#import "UIView+iAnimationManager.h"
#import "selectAvatar1.h"
#import "v_paiming.h"
#import "wrongQuestion.h"

extern UIImage *scaleImage;
extern NSData *data;

@implementation profile

@synthesize image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
        
        pa = [self addImageView:self
                          image:@"profile_ui.png"
                       position:CGPointMake(195, 120)];
        
        pa.userInteractionEnabled=YES;
        
        
        //头像
        avatar=[self addButtonWithImageView:pa
                                      image:@"avatar_null.jpg"
                                  highlight:nil
                                   position:CGPointMake(20, 112)
                                          t:3000
                                     action:@selector(onADown:)];
        
        
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:1003
                 target:self
                 action:@selector(backClick:)];
        
        
        [self addButton:pa image:@"profile_kg.png"
               position:CGPointMake(386, 185) tag:10008 target:nil action:@selector(chooseBoy:)];
        [self addButton:pa image:@"profile_kg.png"
               position:CGPointMake(516, 185) tag:10009 target:nil action:@selector(chooseGirl:)];
        
        
        [self addButton:self
                  image:@"profile_xg.png"
               position:CGPointMake(440, 440)
                    tag:1000
                 target:self
                 action:@selector(onDown:)];
        [self addButton:self image:@"profile_cj.png" position:CGPointMake(800, 30) tag:nil target:self action:@selector(paiming:)];
        //[self addButton:self image:@"profile_bt3.png" position:CGPointMake(400,30) tag:nil target:self action:@selector(wrongQuestion:)];
        
        username = [self addTextField:pa
                                frame:CGRectMake(315, 125, 280, 30)
                                 font:[UIFont systemFontOfSize:25]
                                color:[UIColor blackColor]
                          placeholder:nil
                                  tag:1000];
        username.delegate = self;
        //年月日
        year= [self addTextField:pa
                           frame:CGRectMake(310, 265, 93, 30)
                            font:[UIFont systemFontOfSize:25]
                           color:[UIColor blackColor]
                     placeholder:nil
                             tag:1200];
        year.delegate=self;
        
        
        month=[self addTextField:pa
                           frame:CGRectMake(417, 265, 79, 30)
                            font:[UIFont systemFontOfSize:25]
                           color:[UIColor blackColor]
                     placeholder:nil
                             tag:1201];
        month.delegate=self;
        
        
        day=[self addTextField:pa
                         frame:CGRectMake(510, 265, 73, 30)
                          font:[UIFont systemFontOfSize:25]
                         color:[UIColor blackColor]
                   placeholder:nil
                           tag:1202];
        day.delegate=self;
        
        
        year.keyboardType=UIKeyboardTypeNumberPad;
        month.keyboardType=UIKeyboardTypeNumberPad;
        day.keyboardType=UIKeyboardTypeNumberPad;
        
        /*[UIView animateWithDuration:1
         animations:^{
         //106
         pa.center=[self LeftPointToCenter:CGPointMake(56, 50) view:pa];
         }];*/
        
        changed=NO;
        
    }
    return self;
}

-(void)chooseBoy:(UIButton*)sender{
    
    ChooseSex.frame = CGRectMake(387, 183, 50, 48);
    NSLog(@"man ");
    
    fm =@"f";
    
}
-(void)chooseGirl:(UIButton*)sender{
    NSLog(@"nv ");
    
    ChooseSex.frame = CGRectMake(517, 183, 50, 48);
    fm =@"m";
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [year endEditing:YES];
    [month endEditing:YES];
    [day endEditing:YES];
    
    return YES;
}


-(void)onADown:(id)sender
{
    selectAvatar1 *p=[[selectAvatar1 alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [p loadCurrentPage:0];
    [self fadeInView:p duration:.5];
}

-(void)paiming:(id)sender
{
    v_paiming *p=[[v_paiming alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [p loadCurrentPage:0];
    [self fadeInView:p duration:.5];
    
    
}

-(void)wrongQuestion:(id)sender
{
    
    
    wrongQuestion *p = [[wrongQuestion alloc] initWithFrame:self.frame];
    [p wrong_answers];
    [self fadeInView:p duration:.5];
    
}
-(void)loadP:(NSDictionary*)p
{
    
    username.text=[p objectForKey:@"username"];
    
    if([[p objectForKey:@"gender"] isEqualToString:@"f"])
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"f" forKey:@"sex"];
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"m" forKey:@"sex"];
    }
    id  s = [[NSUserDefaults standardUserDefaults]objectForKey:@"sex"];
    NSLog(@"profile sex=%@",s);
    if([s  isEqualToString:@"f"])
    {
        ChooseSex= [self addImageView:pa
                                image:@"profile_ch.png"
                             position:CGPointMake(387, 183)];
        fm =@"f";
    }
    else
    {
        ChooseSex=[self addImageView:pa
                               image:@"profile_ch.png"
                            position:CGPointMake(517, 183)];
        fm=@"m";
        
    }
    
    
    
    //头像
    
    NSString * avt_id= [[NSUserDefaults standardUserDefaults]objectForKey:@"avatar"];
    NSString * fl =[[NSUserDefaults standardUserDefaults]objectForKey:@"flag"];
    
    NSLog(@"flag avatar=%@",fl);
    if([fl isEqualToString:@"1"]){
        
        id imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL"];
        
        [avatar setImageWithURL:imageUrl ];
        
        
    }else{
        
        aid=[p objectForKey:@"avatar_id"];
        if(aid && ![aid isKindOfClass:[NSNull class]])
        {
            avatar.image=[UIImage imageNamed:[NSString stringWithFormat:@"avatar_%@.jpg",aid]];
        }
        else
        {
            aid=@"1";
            avatar.image=[UIImage imageNamed:[NSString stringWithFormat:@"avatar_%@.jpg",aid]];
        }
        
    }
    //生日
    id birthday=[p objectForKey:@"birthday"];
    
    if(birthday && ![birthday isKindOfClass:[NSNull class]])
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        
        NSDate *ld= [dateFormatter dateFromString:birthday];
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        comps = [calendar components:unitFlags fromDate:ld];
        
        
        int yy = [comps year];
        int mm = [comps month];
        int dd = [comps day];
        
        
        year.text=[NSString stringWithFormat:@"%d",yy];
        if(mm <10){
            month.text=[NSString stringWithFormat:@"0%d",mm];}
        else{month.text=[NSString stringWithFormat:@"%d",mm];}
        day.text=[NSString stringWithFormat:@"%d",dd];
        
    }
    
    
}


-(void)updateAvatar:(int)a
{
    avatar.image=[UIImage imageNamed:[NSString stringWithFormat:@"avatar_%d.jpg",a]];
    aid=[NSString stringWithFormat:@"%d",a];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"flag"];
    
}

-(void)avtatarImage:(UIImage * )image{
    avatar.image = image;
}

-(void)onDown:(UIButton*)sender
{
    
    NSString *msg=@"ok";
    
    
    if(username.text.length==0)
    {
        msg = @"请输入用户名";
    }
    
    else if(year.text.length==0)
    {
        msg =@"您还未填写年份";
    }
    else if(year.text.length !=4){
        
        msg=@"请正确填写(<2014)的年份";
    }
    
    else if(month.text.length==0)
    {
        msg =@"您还未填写月份";
    }
    
    else if([month.text intValue]>12 || [month.text intValue]<1){
        
        msg =@"请正确填写(1~12)的月份";
    }
    else if(day.text.length==0)
    {
        msg =@"您还未填写天";
    }
    else if([day.text intValue] >31 || [day.text intValue] <1){
        
        msg =@"请正确填写(1~31)天数";
    }
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    HUD.labelText = @"正在提交，请稍等...";
    [HUD show:YES];
    
    
    if ([msg isEqualToString:@"ok"]) {
        
        
        //如果选择自定义头像avatar_id =0;如果没有选择avatar_id等于上一次的id
        NSString * test=[[NSUserDefaults standardUserDefaults]objectForKey:@"flag"];
        NSLog(@"test =%@",test);
        if ([test isEqualToString:@"1"]) {
            //清楚之前的图片缓存
            NSString * key = [[NSUserDefaults standardUserDefaults]objectForKey:@"URL"];
            [[SDImageCache sharedImageCache] removeImageForKey:key];
            aid =@"0";
        }else if ([test isEqualToString:@"0"]){
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"URL"];
        }
        NSString * about = [[NSUserDefaults standardUserDefaults]objectForKey:@"about_me"];
        NSLog(@"about me %@",about);
        
        NSString *dateString =[NSString stringWithFormat:@"%@-%@-%@",year.text,month.text,day.text];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSString *sex = fm ;
        NSLog(@"url sex =%@",sex);
        NSMutableData *mData = [[NSMutableData alloc]init];
        mData = UIImagePNGRepresentation(scaleImage);
        
        NSString  * s =[NSString stringWithFormat:@"http://gifted-center.com/api/profiles/%@.json?auth_token=%@&user[avatar_id]=%@&user[birthday]=%@&user[username]=%@&user[gender]=%@",about,token,
                        aid,
                        dateString,
                        username.text,
                        sex];
        
        NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"profile_url =%@",url);
        request = [ASIFormDataRequest requestWithURL:url];
        
        [request  addData:mData  withFileName:@"avatarImage.png" andContentType:@"image/png"  forKey:@"avatar"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"PUT"];
        request.timeOutSeconds=60;
        request.tag=4000;
        [request startAsynchronous];
        
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



- (void)requestFailed:(ASIHTTPRequest *)r
{
    
    NSError *error = [r error];
    NSLog(@"profile_vatar:%@",error);
    
    [HUD hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络不给力，稍后在试用"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    changed=YES;
    return YES;
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    
    [HUD hide:YES];
    NSData *jsonData = [r responseData];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"requstFinished=%@",jsonObject);
    //判断下载头像
    NSDictionary * url = [jsonObject objectForKey:@"avatar"];
    NSString * iurl = [url objectForKey:@"url"];
    NSString * aid_id =[[NSString alloc]initWithFormat:@"%@",[jsonObject objectForKey:@"avatar_id"]];
    if([iurl isEqualToString:@"/images/fallback/default.png" ]){
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0"
                                                  forKey:@"flag"];
        
    }
    else{
        if([aid_id isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"1"
                                                      forKey:@"flag"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"0"
                                                      forKey:@"flag"];}
        //下载头像
        UIImageView * imageV;
        [imageV setImageWithURL:iurl];
        [[NSUserDefaults standardUserDefaults] setObject:iurl forKey:@"URL"];
        
        
    }
    
    switch (r.tag) {
        case 4000:
        {
            
            //已经存在帐户了
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            
            NSMutableArray *testArray=[[NSMutableArray alloc] init];
            [testArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"accountArray"]];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonObject objectForKey:@"avatar_id"]
                                                      forKey:@"avatar"];
            
            for (int i=0; i<[testArray count]; i++) {
                
                NSString *tk=  [[testArray objectAtIndex:i] objectForKey:@"token"];
                
                if([tk isEqualToString:token])
                {
                    //重要！！
                    /*
                     NSDictionary *item =[testArray objectAtIndex:i];
                     NSMutableDictionary *mutableItem = [NSMutableDictionary dictionaryWithDictionary:item];
                     [mutableItem setObject:aid forKey:@"avatar"];
                     [testArray setObject:mutableItem atIndexedSubscript:i];
                     */
                    break;
                }
            }
            
            
            changed=NO;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"修改成功！"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
            
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(pinchPiece:)];
            [self addGestureRecognizer:pinchGesture];
            
        }
            break;
            
        case 4001:{
            [[NSUserDefaults standardUserDefaults]setObject:[jsonObject objectForKey:@"id"] forKey:@"about_me"];
            NSLog(@"user_id =%@",[jsonObject objectForKey:@"id"]);
            items=(NSDictionary*)jsonObject;
            username.text=[items objectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setObject:aid_id forKey:@"avatar"];
            [self loadP:items];
            
        }
            break;
            
        default:
            break;
    }
    
    
}


//放大缩小
- (void)pinchPiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
		scalePos=gestureRecognizer.scale;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
	{
		if(scalePos>gestureRecognizer.scale)
        {
            
            
            if(changed)
            {
                
                //如果修改了没有保存的，提示一下
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"你还没有保存修改？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"保存",nil];
                [alertView show];
                
                return;
            }
            
            
            [self.superview fadeOutView:self duration:.5];
            
        }
	}
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            
            
        }
            break;
            
        default:
        {
            
            [self.superview fadeOutView:self duration:.5];        }
            break;
    }
}

-(void)backClick:(UIButton*)sender
{
    
    if(changed)
    {
        
        //如果修改了没有保存的，提示一下
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没有保存修改,是否继续退出？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认",nil];
        [alertView show];
        
        return;
    }
    
    
    [self.superview fadeOutView:self duration:.5];
    
}


-(void)loadCurrentPage:(int)cmd
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"token =%@",token);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/profiles/about_me.json?auth_token=%@",token]];
    NSLog(@"profile =%@",url);
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    request.tag=4001;
    
}

@end
