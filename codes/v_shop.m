//
//  v_shop.m
//  tcxly
//
//  Created by Terry on 13-8-16.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_shop.h"
#import "v_pay.h"
#import "mpvc.h"
#import "v_unit.h"
#import "v_enter.h"
#import "UIView+iTextManager.h"
#import "MainViewController.h"
#import "UIImageView+WebCache.h"

@implementation v_shop

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
        
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:8888
                 target:self
                 action:@selector(backClick:)
         ];
        topView = [self addImageView:self image:@"shop_top.png" position:CGPointMake(300, 0)];
        
        
    }
    return self;
}

-(void)backClick:(UIButton*)e {
   
    [self fadeOutView:self duration:.5];
    
}

-(void)loadCurrentPage:(int)cmd {
    UIButton *buybtn = [self addButton:self
                                 image:@"shop_start.png"
                              position:CGPointMake(426, 620)
                                   tag:5000
                                target:self
                                action:@selector(buyClick:)
                        ];
    buybtn.alpha = cmd;
}

-(void)loadInfo:(NSArray *)arr vid:(int)v{
    varr = arr;
    _vid = v;
    NSString *n = [[NSUserDefaults standardUserDefaults] objectForKey:@"menuid"];
    int menuid = n.intValue;
    NSLog(@"menuid == %d", menuid);
    
    NSLog(@"%@++++++", [arr[v] objectForKey:@"name"]);
    
    UILabel *title = [self addLabel:topView
                              frame:CGRectMake(0,43, 395, 50)
                               font:[UIFont boldSystemFontOfSize:30]
                               text:[arr[v] objectForKey:@"name"]
                              color:[UIColor blackColor]
                                tag:1401
                      ];
    title.textAlignment = UITextAlignmentCenter;
    
    UILabel *content = [self addLabel:topView
                                frame:CGRectMake(0, 100, 395, 30)
                                 font:[UIFont systemFontOfSize:20]
                                 text:[arr[v] objectForKey:@"description"]
                                color:[UIColor blackColor]
                                  tag:1402
                        ];
    content.textAlignment = UITextAlignmentCenter;
    
    
    UIImageView *spbg = [self addImageView:self
                 image:@"shop_sp.png"
              position:CGPointMake(250, 190)
     ];
    
    //此处为视频讲解的图片。。。。
    
    UIImageView *bvv = [[UIImageView alloc] initWithFrame:CGRectMake(394, 320, 243, 205)];
    [self addSubview:bvv];
   // [[bvv layer] setCornerRadius:2.0];
    bvv.clipsToBounds = YES;
    [bvv setImageWithURL:[NSURL URLWithString:[arr[v] objectForKey:@"thumb_video_poster_url"]]
            placeholderImage:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {

                   }];
     
     
    
    UIButton *moviebtn = [self addButton:self
                                   image:@"sp_play.png"
                                position:CGPointMake(453, 400)
                                     tag:4500
                                  target:self
                                  action:@selector(playMovie:)
                          ];
    
    UILabel *ys = [self addLabel:self
                           frame:CGRectMake(389, 400, 275, 25)
                            font:[UIFont systemFontOfSize:15]
                            text:@"视频讲解演示"
                           color:[UIColor blackColor]
                             tag:1403
                   ];
    ys.textAlignment = UITextAlignmentCenter;
    
    NSString *video_url = [varr[_vid] objectForKey:@"video_url"];
    NSLog(@"videourl -> %@", video_url);
    if([video_url isKindOfClass:[NSNull class]] || video_url == nil) {
        moviebtn.alpha = spbg.alpha = ys.alpha = 0;
    }
}

-(void)buyClick:(UIButton*)e {
    
    MainViewController *mvc = (MainViewController*)[self getManager];
    int index=[[[NSUserDefaults standardUserDefaults]  objectForKey:@"menuid"] integerValue];
    NSArray *arr = mvc.unitArr;
    int cid = [[[arr[index] objectForKey:@"stages"][_vid] objectForKey:@"id"] integerValue];
    NSLog(@"buyid = %d", cid);
    NSString *token=[[NSUserDefaults standardUserDefaults]  objectForKey:@"token"];
    NSString *str = [NSString stringWithFormat:@"http://gifted-center.com/api/stages/%d/purchase.json?auth_token=%@", cid, token];
    NSLog(@"url = %@", str);
    NSURL *url = [NSURL URLWithString:str];
    request = [ASIHTTPRequest requestWithURL:url];
    request.tag = 60001;
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    UIActivityIndicatorView *loginLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [loginLoading setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)];
    loginLoading.tag = 9991;
    [self addSubview:loginLoading];
    [loginLoading startAnimating];
    
    UILabel *txt = [self addLabel:self
                            frame:CGRectMake(0, 0, 200, 100)
                             font:[UIFont systemFontOfSize:18]
                             text:@"请稍候..."
                            color:[UIColor whiteColor]
                              tag:9992
                    ];
    txt.shadowColor = [UIColor blackColor];
    txt.textAlignment = UITextAlignmentCenter;
    txt.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 + 50);
 //    v_pay *vp = [[v_pay alloc] initWithFrame:self.frame];
 //   [self.superview fadeInView:self withNewView:vp duration:.5];
 //   [vp loadCurrentPage:0];
 //   [vp saveInfo:varr vid:_vid];
}

#pragma mark –
#pragma mark 请求完成 requestFinished

- (void)requestFailed:(ASIHTTPRequest *)req
{
    NSError *error = [req error];
    NSLog(@"login:%@",error);
    
    [self clearUnuseful];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接, 请检查网络并重试."
                                                       delegate:self
                                              cancelButtonTitle:@"重试"
                                              otherButtonTitles:@"好", nil];
    [alertView show];
    
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    
    [self clearUnuseful];
    NSLog(@"%@",[r responseString]);
    
    if(r.tag == 60001) {
        NSString *res = [r responseString];
        if([res isEqualToString:@"success"]) {
             [self resetInfo];
             HUD = [[MBProgressHUD alloc] initWithView:self];
             [self addSubview:HUD];
             HUD.labelText = @"正在载入试卷，请稍候...";
            
             [HUD show:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"失败了，请检查网络."
                                                               delegate:nil
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }else {
            [HUD hide:YES];
            NSData *jsonData = [r responseData];
        
        //解析JSon
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
            NSLog(@"Successfully deserialized...");
        
        
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
        
            if(![deserializedDictionary isKindOfClass:[NSNull class]] )
            {
            
                NSArray *allArray = (NSArray*)deserializedDictionary;
                
               // NSLog(@"allArray = %@", allArray);
                
                MainViewController *mvc = (MainViewController*)[self getManager];
                mvc.unitArr = allArray;
            
                v_unit *vs = [[v_unit alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
                int index=[[[NSUserDefaults standardUserDefaults]  objectForKey:@"menuid"] integerValue];
            
                [vs loadInfo:mvc.unitArr idx:index];
                [self.superview.superview fadeInView:self.superview withNewView:vs duration:.5];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"载入失败, 请检查网络!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"好"
                                                          otherButtonTitles:nil];
                alertView.tag = 50001;
                [alertView show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 50001) {
        v_enter *ve = [[v_enter alloc] initWithFrame:self.frame];
        [self.superview.superview fadeInView:self.superview withNewView:ve duration:.5];
    }    
}

-(void)resetInfo {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/grades.json?auth_token=%@",token]];
    request = [ASIHTTPRequest requestWithURL:url];
    request.tag = 60002;
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
}

-(void)clearUnuseful {
    UIActivityIndicatorView *loginLoading = (UIActivityIndicatorView*)[self viewWithTag:9991];
    [loginLoading stopAnimating];
    [loginLoading removeFromSuperview];
    [[self viewWithTag:9992] removeFromSuperview];
}

-(void)playMovie:(UIButton*)e {
 
    MainViewController *m=(MainViewController*)[self getManager];
    mpvc *mv=[[mpvc alloc] init];
    NSString *video_url = [varr[_vid] objectForKey:@"video_url"];
    NSLog(@"videourl -> %@", video_url);
    if([video_url isKindOfClass:[NSNull class]] || video_url == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"抱歉, 暂无视频!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
    }else {
        [mv load:video_url Ex:nil];
        [m presentViewController:mv
                        animated:YES
                      completion:^{
                          
                      }];
    }
}

@end
