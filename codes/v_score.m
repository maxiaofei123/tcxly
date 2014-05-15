//
//  v_score.m
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_score.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "v_enter.h"
#import "v_unit.h"
#import "v_qna.h"
#import "UIView+iTextManager.h"
#import "MainViewController.h"
#import "v_answerCheck.h"
extern  int  allAnser;
@implementation v_score

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
        
        UIImageView *light = [self addImageView:self
                                          image:@"et_light.png"
                                       position:CGPointMake(286, 0)
                              ];
        ui = [self addImageView:self image:@"score_ui.png" position:CGPointMake(265, 150)];
        
        CAKeyframeAnimation *rock;
        rock = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        [rock setDuration:3];
        [rock setRepeatCount:HUGE_VALF];
        [rock setFillMode:kCAFillModeForwards];
        
        NSMutableArray *values = [NSMutableArray array];
        
        [values addObject:[NSNumber numberWithFloat:1.0]];
        [values addObject:[NSNumber numberWithFloat:1.5]];
        [values addObject:[NSNumber numberWithFloat:1.0]];
        
        [rock setValues:values];
        
        [[light layer] addAnimation:rock forKey:@"transform"];
        
        
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:2000
                 target:self
                 action:@selector(scClick:)
         ];
        
    }
    return self;
}

-(void)scClick:(UIButton*)e {
    v_unit *ve = [[v_unit alloc] initWithFrame:self.frame];
    [self.superview fadeInView:self withNewView:ve duration:.5];
    //[ve loadCurrentPage:1];
    MainViewController *mvc = (MainViewController*)[self getManager];
    [ve loadInfo:mvc.unitArr idx:[[[NSUserDefaults standardUserDefaults] objectForKey:@"menuid"] integerValue]];
}

-(void)loadCurrentPage:(int)cmd {
    
    [self setLoading];
    

     NSString *token=[[NSUserDefaults standardUserDefaults]  objectForKey:@"token"];
  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/exams/%d/finish_uploading.json?auth_token=%@", cmd,token]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.tag = 60001;
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark –
#pragma mark 请求完成 requestFinished

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSLog(@"failed");
    NSError *error = [request error];
    NSLog(@"login:%@",error);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    
    if(req.tag == 60001) {
        NSLog(@"successed");
     
        NSData *jsonData = [req responseData];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
        
         NSString *token=[[NSUserDefaults standardUserDefaults]  objectForKey:@"token"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/exams/%d.json?auth_token=%@", [[deserializedDictionary objectForKey:@"id"] integerValue ],token]];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request startAsynchronous];
    }else {
        
        [self clearUnuseful];
        
        NSLog(@"V-scaore=%@", [req responseString]);
        NSData *jsonData = [req responseData];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
        NSArray *arr = [deserializedDictionary objectForKey:@"answers"];
        NSLog(@"anser=%d",[arr count]);
        int anspoint = 0;
        for (int i = 0; i < [arr count]; i ++) {
            anspoint += [[arr[i] objectForKey:@"point"] integerValue];
        }
       //计分规则  分数＝ 100-（错题数＊5）
        int grade =100-((allAnser-anspoint) *5);
        if(grade<=0){grade =0; }
        

        
        UILabel *txt = [self addLabel:self
                                frame:CGRectMake(0, 0, 1024, 768)
                                 font:[UIFont fontWithName:@"Gretoon" size:150]
                                 text:@""
                                color:[UIColor colorWithRed:19.f/255.f green:226.f/255.f blue:243.f/255.f alpha:1]
                                  tag:5000
                        ];
        txt.text = [NSString stringWithFormat:@"%d",grade];//anspoint
        txt.shadowOffset=CGSizeMake(5, 5);
        txt.shadowColor=[UIColor colorWithWhite:-1 alpha:.5];
        txt.textAlignment = NSTextAlignmentCenter;
        txt.center = CGPointMake(512, 350);
        
        txt.transform = CGAffineTransformMakeScale(1.5, 1.5);
        txt.alpha = 0;
        
        [UIView animateWithDuration:.5
                         animations:^{
                             txt.transform = CGAffineTransformMakeScale(1, 1);
                             txt.alpha = 1;
                         }
         ];
        
        [self addButton:self
                  image:@"score_pd.png"
               position:CGPointMake(300, 500)
                    tag:8991
                 target:self
                 action:@selector(againClick:)
         ];
        [self addButton:self
                  image:@"score_re.png"
               position:CGPointMake(550, 500)
                    tag:8992
                 target:self
                 action:@selector(againClick:)
         ];
    }
    
}

-(void)againClick:(UIButton*)e {
    if(e.tag == 8991) {
        v_qna *vq = [[v_qna alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self.superview fadeInView:self
                       withNewView:vq
                          duration:.5
         ];
        NSString *n = [[NSUserDefaults standardUserDefaults] objectForKey:@"unitid"];
        int unitid = n.intValue;
        [vq loadCurrentPage:unitid];
    }else {
        v_answerCheck *vc = [[v_answerCheck alloc] initWithFrame:self.frame];
        [self fadeInView:vc duration:.5];
        [vc sendAnswer:answerArr];
    }
}

-(void)setLoading {
    UIView *ldv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    ldv.tag = 9997;
    ldv.backgroundColor = [UIColor blackColor];
    [self addSubview:ldv];
    ldv.alpha = .3;
    
    UIActivityIndicatorView *loginLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [loginLoading setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)];
    loginLoading.tag = 9991;
    [self addSubview:loginLoading];
    [loginLoading startAnimating];
    
    UILabel *txt = [self addLabel:self
                            frame:CGRectMake(0, 0, 200, 100)
                             font:[UIFont systemFontOfSize:18]
                             text:@"正在计算分数..."
                            color:[UIColor whiteColor]
                              tag:9992
                    ];
    txt.shadowColor = [UIColor blackColor];
    txt.textAlignment = UITextAlignmentCenter;
    txt.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 + 50);
}

-(void)clearUnuseful {
    UIActivityIndicatorView *loginLoading = (UIActivityIndicatorView*)[self viewWithTag:9991];
    [loginLoading stopAnimating];
    [loginLoading removeFromSuperview];
    [[self viewWithTag:9992] removeFromSuperview];
    [[self viewWithTag:9997] removeFromSuperview];
}


-(void)sendAnswer:(NSArray *)arr {
    answerArr = arr;
}

@end
