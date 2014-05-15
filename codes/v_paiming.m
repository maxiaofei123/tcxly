//
//  v_paiming.m
//  tcxly
//
//  Created by Li yi on 13-9-11.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_paiming.h"
#import "UIView+iTextManager.h"
#import "UIView+iAnimationManager.h"
#import "reg_0.h"
#import "MainViewController.h"
extern const NSString *avatarR;
@implementation v_paiming

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
     
        
        p0=  [self addImageView:self
                          image:@"pm_ui.png"
                       position:CGPointMake(60, 43)];//73
        
        
        
        p1= [self addImageView:p0
                         image:@"pm_di.png"
                      position:CGPointMake(70, 70)];
        
     
         p1.frame = CGRectMake(50, 140, 745, 510);
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:1003
                 target:self
                 action:@selector(backClick:)];
        

        
    }
    return self;
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    
    NSLog(@"paiming requst%@",[r responseString]);
    
    NSData *jsonData = [r responseData];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *items=(NSDictionary*)jsonObject;
    
    
    NSArray *rank=(NSArray*)[items objectForKey:@"user_rankings"];
    
    NSLog(@"rank count%d",[rank count]);
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 140, 745, 510)];
    [p1 addSubview:sv];
     MainViewController *mvc = (MainViewController*)[self getManager];
    rank = mvc.allArr;
    
    for (int i=0; i<10; i++) {
        
        id aid=[[rank objectAtIndex:i] objectForKey:@"avatar_id"];
        NSLog(@"paiming aid =%@",aid);
        UIImageView *im;
       
        UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0, 30 + i * 80 * 2, 745, 42)];
        txt.tag = 2000 + i;
        [sv addSubview:txt];
        [self addImageView:txt
                     image:@"qp_line.png"
                  position:CGPointMake(0, 110)
         ];
        [sv setContentSize:CGSizeMake(1024, (i + 1) * 80 * 2)];
        
        
        
        if(aid && ![aid isKindOfClass:[NSNull class]])
        {
            im=[self addImageView:p0
                            image:[NSString stringWithFormat:@"avatar_%@.jpg",aid]
                         position:CGPointMake(40, 83+i*122)];
        }
        else
        {
           /* im=[self addImageView:p0
                            image:@"avatar_1.jpg"
                         position:CGPointMake(40, 83+i*122)];*/
        }

        
        CGRect f=im.frame;
        f.size.width=f.size.height=110;
        im.frame=f;
        
        
        //名字
        UILabel *un=[self addLabel:p0
                             frame:CGRectMake(161, 115+i*120, 180, 50)
                              font:[UIFont boldSystemFontOfSize:20]
                              text:[[[rank objectAtIndex:i] objectForKey:@"user"] objectForKey:@"username"]
                             color:[UIColor blackColor]
                               tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        
        
        //成绩
        un=[self addLabel:p0
                    frame:CGRectMake(368, 115+i*120, 180, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text:[NSString stringWithFormat:@"%d",[[[rank objectAtIndex:i] objectForKey:@"total_point"] integerValue]]
                    color:[UIColor blackColor]
                      tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        
        
        
        //排名
        
        un = [self addLabel:txt
                       frame:CGRectMake(30, 0, 100, 24)
                        font:[UIFont fontWithName:@"Gretoon" size:24]
                        text:[NSString stringWithFormat:@"第%d名", i + 1]
                        color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                        tag:0];
        un.shadowOffset=CGSizeMake(0, 1);
        
        un.shadowColor=[UIColor whiteColor];
        
        /*un=[self addLabel:p0
                    frame:CGRectMake(572, 115+i*120, 121, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text:[NSString stringWithFormat:@"第%d名",i+1]
                    color:[UIColor blackColor]
                      tag:0];*/
        
        un.textAlignment=UITextAlignmentCenter;
        
    }
    
    
    
    NSDictionary *myself=[items objectForKey:@"current_user_ranking"];

    NSLog(@"myselfCount=%d",[myself count]);
    
    
    
    //第四名
    if([myself count]>0)
    {
        
        id aid=[[myself objectForKey:@"user"] objectForKey:@"avatar_id"];
        
        UIImageView *im;
        
        
        if(aid && ![aid isKindOfClass:[NSNull class]])
        {
            im=[self addImageView:p1
                            image:[NSString stringWithFormat:@"avatar_%@.jpg",aid]
                         position:CGPointMake(40, 83)];
        }
        else
        {
            im=[self addImageView:p1
                            image:@"avatar_1.jpg"
                         position:CGPointMake(40, 83)];
        }
        
        CGRect f=im.frame;
        f.size.width=f.size.height=110;
        im.frame=f;
        
        
        //名字
        UILabel *un=[self addLabel:p1
                             frame:CGRectMake(161, 115, 180, 50)
                              font:[UIFont boldSystemFontOfSize:20]
                              text:[[myself objectForKey:@"user"] objectForKey:@"username"]
                             color:[UIColor blackColor]
                               tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        

        //成绩
        un=[self addLabel:p1
                    frame:CGRectMake(368, 115, 180, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text:[NSString stringWithFormat:@"%d",[[myself objectForKey:@"total_point"] integerValue]]
                    color:[UIColor blackColor]
                      tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        

        //排名
        un=[self addLabel:p1
                    frame:CGRectMake(572, 115, 121, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text: [NSString stringWithFormat:@"第%d名",[[myself objectForKey:@"ranking_no"] integerValue]]
                    color:[UIColor blackColor]
                      tag:0];
        
        
        un.textAlignment=UITextAlignmentCenter;
        
        [self addLabel:p1
                 frame:CGRectMake(582, 20, 260, 50)
                  font:[UIFont boldSystemFontOfSize:20]
                  text:[NSString stringWithFormat:@"在线学员：%d",[[myself objectForKey:@"users_count"] integerValue]]
                 color:[UIColor whiteColor]
                   tag:0];


        [UIView animateWithDuration:1
                         animations:^{
                            p1.center=[self LeftPointToCenter:CGPointMake(70, 550) view:p1];
                         }];
    }
    
    
    
}



//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    NSLog(@"paiming:%@",error);
}


-(void)loadCurrentPage:(int)cmd
{

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *gid = [[NSUserDefaults standardUserDefaults] objectForKey:@"grade_id"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/ranks/ranking.json?auth_token=%@&grade_id=%@",token,gid]];
    
    NSLog(@"%@",url);
    
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
}

-(void)backClick:(UIButton*)sender
{
    [self fadeOutView:self
             duration:.5];
}


@end
